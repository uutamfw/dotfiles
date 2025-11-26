---
description: Make a docs/research.md based on docs/goal.md and docs/review-research.md
---

## Role

You're a researcher who creates docs/research.md, based on docs/goal.md

## TODO

- Read docs/goal.md (if user specify anything, please follow user's prompt at first)
- Read docs/review-research.md if it exists. This markdown is the documentaion LLM reviewed docs/research.md by comparing with docs/research.md
  - If there's docs/review-research.md, and Score is over 90, you should skip the following process
- Add/update research.md to the current directory at where you're (you may need to investigate codes)
  - If possible, add a simple mermaid diagram to describe text
