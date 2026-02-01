#!/usr/bin/env python3
"""Deep research script using Google's Gemini Deep Research API.

Sends a query to the Gemini Interactions API with background mode,
polls until completion, and prints the research report.
"""

import os
import sys
import time

try:
    from google import genai
except ImportError:
    genai = None


def parse_args(argv=None):
    """Parse CLI arguments and return the query string."""
    if argv is None:
        argv = sys.argv
    if len(argv) < 2:
        print("Usage: gemini_deep_research.py <query>", file=sys.stderr)
        sys.exit(1)
    return argv[1]


def validate_environment():
    """Validate required environment variables. Returns the API key."""
    api_key = os.environ.get("GEMINI_API_KEY")
    if not api_key:
        print("Error: GEMINI_API_KEY environment variable is not set.", file=sys.stderr)
        sys.exit(1)
    return api_key


def start_research(client, query):
    """Start a background deep research interaction."""
    print(f"Starting deep research for: {query}", file=sys.stderr)
    print("This may take several minutes...", file=sys.stderr)

    interaction = client.interactions.create(
        input=query,
        agent="deep-research-pro-preview-12-2025",
        background=True,
    )
    return interaction


def poll_until_complete(client, interaction, poll_interval=10, max_wait=3600):
    """Poll the interaction until it completes, fails, or times out."""
    elapsed = 0
    while True:
        result = client.interactions.get(interaction.id)
        status = result.status.lower() if isinstance(result.status, str) else str(result.status).lower()
        if status == "completed":
            return result
        if status == "failed":
            error_msg = getattr(result, "error", "Unknown error")
            print(f"Error: Research failed: {error_msg}", file=sys.stderr)
            sys.exit(1)
        if elapsed >= max_wait:
            print("Error: Research timed out.", file=sys.stderr)
            sys.exit(1)
        print(f"  Status: {status}", file=sys.stderr)
        time.sleep(poll_interval)
        elapsed += poll_interval


def extract_output(interaction):
    """Extract the text output from a completed interaction."""
    if not interaction.outputs:
        print("Error: No output received from the model.", file=sys.stderr)
        sys.exit(1)
    return interaction.outputs[-1].text


def main():
    """Orchestrate the deep research flow."""
    if genai is None:
        print("Error: google-genai package not installed. Run: pip install google-genai", file=sys.stderr)
        sys.exit(1)

    query = parse_args()
    api_key = validate_environment()

    client = genai.Client(api_key=api_key)

    interaction = start_research(client, query)
    interaction = poll_until_complete(client, interaction)
    report = extract_output(interaction)

    print(report)


if __name__ == "__main__":
    main()
