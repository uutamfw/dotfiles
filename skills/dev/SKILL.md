---
name: dev
description: Orchestrate TDD-based development workflow – plan with test-first approach, save to Obsidian vault, split into trackable steps, and execute sequentially with status tracking. Acts as project manager, delegating tasks to specialized agents.
---

# Dev orchestrater

要件と簡単な仕様を元にTDDベースの計画を作成し、各stepに分割する。stepごとに実行し、完全な実装を目指す。

## Requirements

- Follow user's instructions ($ARGUMENTS)
- Your main role is the project manager so assign tasks to other agents as far as possible

## Procedure

- Receive user's request and make a plan (this is the general feature in Claude Code)
  - The implementation plan should be made with TDD discipline, see [tdd-plan.md](steps/tdd-plan.md)
- If user agrees with your plan, add your plan into the local file, [plan-on-md.md](steps/plan-on-md.md)
  - **Do not forget**
- Split steps into each markdown, see [plan-steps-split.md](steps/plan-steps-split.md) 
- Proceed steps along with statuses in step markdowns, see [proceed-by-step.md](steps/proceed-by-step.md)

