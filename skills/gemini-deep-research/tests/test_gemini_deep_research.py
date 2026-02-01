"""Tests for Gemini Deep Research script."""

import sys
import types
from unittest.mock import MagicMock, patch

import pytest

from gemini_deep_research import (
    extract_output,
    main,
    parse_args,
    poll_until_complete,
    start_research,
    validate_environment,
)


class TestParseArgs:
    def test_returns_query_string(self):
        result = parse_args(["script_name", "What is quantum computing?"])
        assert result == "What is quantum computing?"

    def test_missing_arg_exits(self):
        with pytest.raises(SystemExit) as exc_info:
            parse_args(["script_name"])
        assert exc_info.value.code == 1


class TestValidateEnvironment:
    def test_returns_api_key_when_set(self, monkeypatch):
        monkeypatch.setenv("GEMINI_API_KEY", "test-key-123")
        assert validate_environment() == "test-key-123"

    def test_exits_when_key_missing(self, monkeypatch):
        monkeypatch.delenv("GEMINI_API_KEY", raising=False)
        with pytest.raises(SystemExit) as exc_info:
            validate_environment()
        assert exc_info.value.code == 1


class TestStartResearch:
    def test_calls_interactions_create(self):
        mock_client = MagicMock()
        mock_interaction = MagicMock()
        mock_client.aio = MagicMock()
        mock_client.interactions.create.return_value = mock_interaction

        result = start_research(mock_client, "test query")

        mock_client.interactions.create.assert_called_once()
        assert result == mock_interaction

    def test_uses_correct_agent_and_background(self):
        mock_client = MagicMock()
        mock_client.interactions.create.return_value = MagicMock()

        start_research(mock_client, "test query")

        call_kwargs = mock_client.interactions.create.call_args
        assert call_kwargs.kwargs["config"]["agent"] == "deep-research-pro-preview-12-2025"
        assert call_kwargs.kwargs["config"]["background"] is True


class TestPollUntilComplete:
    def test_returns_completed_interaction(self):
        mock_client = MagicMock()
        interaction = MagicMock()
        interaction.name = "interactions/123"

        completed = MagicMock()
        completed.status = "COMPLETED"
        mock_client.interactions.get.return_value = completed

        result = poll_until_complete(mock_client, interaction, poll_interval=0)
        assert result.status == "COMPLETED"

    def test_exits_on_failed_status(self):
        mock_client = MagicMock()
        interaction = MagicMock()
        interaction.name = "interactions/123"

        failed = MagicMock()
        failed.status = "FAILED"
        mock_client.interactions.get.return_value = failed

        with pytest.raises(SystemExit) as exc_info:
            poll_until_complete(mock_client, interaction, poll_interval=0)
        assert exc_info.value.code == 1

    def test_exits_on_timeout(self):
        mock_client = MagicMock()
        interaction = MagicMock()
        interaction.name = "interactions/123"

        pending = MagicMock()
        pending.status = "RUNNING"
        mock_client.interactions.get.return_value = pending

        with pytest.raises(SystemExit) as exc_info:
            poll_until_complete(mock_client, interaction, poll_interval=0, max_wait=0)
        assert exc_info.value.code == 1

    def test_polls_at_interval(self):
        mock_client = MagicMock()
        interaction = MagicMock()
        interaction.name = "interactions/123"

        running = MagicMock()
        running.status = "RUNNING"
        completed = MagicMock()
        completed.status = "COMPLETED"
        mock_client.interactions.get.side_effect = [running, completed]

        with patch("gemini_deep_research.time.sleep") as mock_sleep:
            result = poll_until_complete(mock_client, interaction, poll_interval=10)
            mock_sleep.assert_called_with(10)
        assert result.status == "COMPLETED"


class TestExtractOutput:
    def test_extracts_last_output_text(self):
        interaction = MagicMock()
        output = MagicMock()
        output.text = "# Research Report\n\nHere are the findings..."
        interaction.outputs = [output]

        result = extract_output(interaction)
        assert result == "# Research Report\n\nHere are the findings..."

    def test_exits_on_empty_outputs(self):
        interaction = MagicMock()
        interaction.outputs = []

        with pytest.raises(SystemExit) as exc_info:
            extract_output(interaction)
        assert exc_info.value.code == 1


class TestMain:
    @patch("gemini_deep_research.extract_output")
    @patch("gemini_deep_research.poll_until_complete")
    @patch("gemini_deep_research.start_research")
    @patch("gemini_deep_research.validate_environment")
    @patch("gemini_deep_research.parse_args")
    def test_full_flow(
        self,
        mock_parse,
        mock_validate,
        mock_start,
        mock_poll,
        mock_extract,
        capsys,
    ):
        mock_parse.return_value = "test query"
        mock_validate.return_value = "fake-key"
        mock_interaction = MagicMock()
        mock_start.return_value = mock_interaction
        mock_poll.return_value = mock_interaction
        mock_extract.return_value = "# Report\nFindings here."

        with patch("gemini_deep_research.genai") as mock_genai:
            mock_client = MagicMock()
            mock_genai.Client.return_value = mock_client
            main()

        mock_parse.assert_called_once()
        mock_validate.assert_called_once()
        mock_start.assert_called_once_with(mock_client, "test query")
        mock_poll.assert_called_once_with(mock_client, mock_interaction)
        mock_extract.assert_called_once_with(mock_interaction)

        captured = capsys.readouterr()
        assert "# Report" in captured.out
