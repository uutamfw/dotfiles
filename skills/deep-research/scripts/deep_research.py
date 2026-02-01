#!/usr/bin/env python3
"""Deep research script using OpenAI's o4-mini-deep-research model.

Sends a query to the OpenAI Responses API with background mode,
polls until completion, and prints the research report with sources.
"""

import os
import sys
import time

try:
    from openai import OpenAI
except ImportError:
    print("Error: openai package not installed. Run: pip install openai", file=sys.stderr)
    sys.exit(1)


def main():
    if len(sys.argv) < 2:
        print("Usage: deep_research.py <query>", file=sys.stderr)
        sys.exit(1)

    query = sys.argv[1]
    api_key = os.environ.get("OPENAI_API_KEY")
    if not api_key:
        print("Error: OPENAI_API_KEY environment variable is not set.", file=sys.stderr)
        sys.exit(1)

    client = OpenAI(api_key=api_key)

    print(f"Starting deep research for: {query}", file=sys.stderr)
    print("This may take several minutes...", file=sys.stderr)

    response = client.responses.create(
        model="o4-mini-deep-research",
        input=query,
        tools=[{"type": "web_search_preview"}],
        background=True,
    )

    while response.status in ("queued", "in_progress", "searching"):
        time.sleep(5)
        response = client.responses.retrieve(response.id)
        print(f"  Status: {response.status}", file=sys.stderr)

    if response.status != "completed":
        print(f"Error: Research ended with status '{response.status}'", file=sys.stderr)
        if hasattr(response, "error") and response.error:
            print(f"Details: {response.error}", file=sys.stderr)
        sys.exit(1)

    # Extract the text output
    text = ""
    sources = []
    for item in response.output:
        if item.type == "message":
            for content in item.content:
                if content.type == "output_text":
                    text = content.text
                    # Collect annotation URLs
                    if hasattr(content, "annotations") and content.annotations:
                        for ann in content.annotations:
                            if hasattr(ann, "url") and ann.url:
                                title = getattr(ann, "title", ann.url)
                                sources.append({"url": ann.url, "title": title})

    if not text:
        print("Error: No text output received from the model.", file=sys.stderr)
        sys.exit(1)

    # Print the research report
    print(text)

    # Append deduplicated sources
    if sources:
        seen = set()
        unique_sources = []
        for s in sources:
            if s["url"] not in seen:
                seen.add(s["url"])
                unique_sources.append(s)
        print("\n---\n## Sources\n")
        for s in unique_sources:
            print(f"- [{s['title']}]({s['url']})")


if __name__ == "__main__":
    main()
