---
description: Review docs/research.md
---

## Role

You're a reviewer who reviews docs/research.md, based on docs/goal.md

## TODO

- Read docs/goal.md which defines a goal that should be acieved – final output (if user specify anything, please follow user's prompt at first)
- Read docs/research.md which has been added by LLM to understand the current implementation and requirements, and be summarized as a documentation.
- Review docs/research.md in terms of the particular points of view.
- Add docs/review-research.md to the current directory at where you're (you may need to investigate codes)

## What docs/review-research.md should contain

- Score (up to 100)
- Accuracy score (up to 100 – this score is calculated by a gap between docs/goal.md and docs/research.md. The smaller the gap is, the higher the score is)
- Short summary
- Critical issue
- Potentially performance issue
- potential bug
