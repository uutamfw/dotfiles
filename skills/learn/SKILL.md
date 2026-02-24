---
name: learn
description: AI-Driven Learning Assistant. Structured learning based on Plan → Learn → Practice → Track methodology. Stores curricula and lessons in ~/uuta/Learning/{topic}/.
user_invocable: true
---
# AI-Driven Learning Assistant

## Overview

A structured learning skill based on the 4-step methodology: **Plan → Learn → Practice → Track**. Use AI as a *learning designer* — to create curricula, produce hands-on teaching materials, do peer-style review, and maintain progress visibility.

All learning files are saved to the Obsidian vault at `~/uuta/Learning/{topic}/`.

## Usage

```
/learn plan <topic>    # Create a new learning curriculum
/learn <topic>         # Start or continue learning a topic
/learn lesson          # Generate the next lesson for the current topic
/learn review          # Peer-review your submitted practice work
/learn track           # Show TODO progress checklist
/learn まとめ           # Session summary
```

---

## Storage Layout

```
~/uuta/Learning/
  {topic}/
    curriculum.md      # Structured learning plan with TODO checklist
    lesson-01.md       # Lesson 1 content + exercises
    lesson-02.md       # Lesson 2 content + exercises
    ...
```

Use the Write tool or Bash to create and update files in `~/uuta/Learning/`.

---

## Behavior by Mode

### `/learn plan <topic>`

**Goal**: Create a structured curriculum and generate all lesson files at once.

Steps:
1. Research the topic: identify official documentation, key concepts, and common learning pitfalls.
2. Divide the curriculum into **5–8 numbered modules**. Each module must include:
   - **Objective**: What the learner will be able to do after completing this module
   - **Key Concepts**: 3–5 core ideas to understand
   - **Exercises**: 2–3 concrete, output-verifiable tasks
   - **Estimated Time**: Realistic time estimate
3. Format the curriculum as a markdown TODO checklist (each module is a `- [ ]` item).
4. Save to `~/uuta/Learning/{topic}/curriculum.md`.
5. Generate all lesson files in parallel using a Team:
   a. Call TeamCreate to create a team (e.g., team name: "lesson-gen-{topic}").
   b. For each module in the curriculum, spawn one Task agent (subagent_type: general-purpose)
      with a prompt that includes:
        - The topic name and lesson number (N)
        - The module's title, objective, key concepts, exercises, and estimated time
        - The full lesson-XX.md format template (from this file)
        - The exact save path: ~/uuta/Learning/{topic}/lesson-{N:02d}.md
        - Instruction: generate the lesson content and save it using the Write tool
      Launch all agents in a single message (parallel tool calls).
   c. Wait for all agents to complete (they will send messages back when done).
   d. Call TeamDelete to clean up the team.
   e. Print a summary listing all lesson files created.
6. Print a summary: curriculum overview + list of all lesson files created.

**curriculum.md format**:
```markdown
# {Topic} Learning Curriculum

## Overview
Brief description of what you will learn and why it matters.

## Curriculum

- [ ] **Module 1: {Title}**
  - Objective: ...
  - Key Concepts: concept1, concept2, concept3
  - Exercises: Exercise description
  - Estimated Time: X hours

- [ ] **Module 2: {Title}**
  ...

## References
- [Official Docs](url)
- [Key Resource](url)
```

---

### `/learn <topic>` (Start or Continue)

**Goal**: Resume a learning session for a topic, or start one if no curriculum exists.

Steps:
1. Check if `~/uuta/Learning/{topic}/curriculum.md` exists.
   - If **not**, run the `plan` flow automatically first.
2. Read `curriculum.md` to identify the next incomplete lesson (`- [ ]`).
3. Run the `lesson` flow for that module.

---

### `/learn lesson`

**Goal**: Generate (or regenerate) a lesson file for a specific module. Use this when a lesson file is missing or needs to be refreshed — `/learn plan` normally creates all lessons upfront.

Steps:
1. Read `~/uuta/Learning/{topic}/curriculum.md` to find the **first unchecked module** (`- [ ]`) without an existing lesson file, or the module the user specifies.
2. Determine the lesson number `N` (count existing `lesson-XX.md` files + 1).
3. Generate a detailed lesson file with:
   - **Concept explanation** with clear, beginner-friendly prose
   - **Concrete code examples** or worked examples (where applicable)
   - **Common mistakes** to avoid
   - **Practice exercises**: 2–3 hands-on tasks with clear success criteria (include `**Hint**:` and `**My Answer**: <!-- Write your answer here -->` for each)
4. Generate 3–5 quiz questions (following the Quiz Generation Rules) and embed a `## Self-Check Quiz` section directly into the lesson file.
5. Save to `~/uuta/Learning/{topic}/lesson-{N:02d}.md`.
6. Display the lesson content in the terminal.

**lesson-XX.md format**:
```markdown
# Lesson {N}: {Module Title}

**Module**: {Module title from curriculum}
**Status**: In Progress

---

## Concepts

### {Concept 1}
Explanation...

```code
example
```

### {Concept 2}
...

## Common Mistakes
- Mistake 1: why it happens and how to avoid it
- Mistake 2: ...

## Practice Exercises

### Exercise 1: {Title}
**Task**: Description of what to do
**Hint**: Optional hint to help you get started
**Success Criteria**: How to verify you got it right

**My Answer**:
<!-- Write your answer here -->

### Exercise 2: {Title}
**Task**: ...
**Hint**: ...
**Success Criteria**: ...

**My Answer**:
<!-- Write your answer here -->

---

## Self-Check Quiz
<!-- Complete these before running /learn review -->

### Q1 — Multiple Choice
**Question**: ...
A) ...  B) ...  C) ...  D) ...

**My Answer**: <!-- A / B / C / D -->

### Q2 — Fill in the Blank
**Question**: `____` is used when ...

**My Answer**: <!-- Write your answer here -->

### Q3 — Explain in Your Own Words
**Question**: In your own words, explain why ...

**My Answer**:
<!-- Write your answer here (2–3 sentences) -->

---

## Review
<!-- This section will be filled in by /learn review -->
```

---

### `/learn review`

**Goal**: Peer-review the user's submitted practice work, run a quiz gate, and mark the lesson complete only after demonstrated understanding.

Steps:
1. Instruct the user to fill in their answers directly in the lesson file — in the `## Practice Exercises → **My Answer**` blocks and the `## Self-Check Quiz → **My Answer**` fields — then run `/learn review` again if they haven't done so yet.
2. Read the current lesson file (`lesson-{N}.md`) — focus on **Key Concepts**, **Common Mistakes**, **Practice Exercises**, and **Self-Check Quiz**.
3. Review the submitted work like a knowledgeable peer:
   - **Correctness**: Are the answers correct? Point out errors with explanations.
   - **Best Practices**: Highlight idiomatic or better approaches.
   - **Improvements**: Suggest what could be done more cleanly or efficiently.
   - **Praise**: Acknowledge what was done well.
4. **Evaluate the Self-Check Quiz**:
   - Read the `## Self-Check Quiz` section from the lesson file.
   - If all `**My Answer**` fields are still blank placeholders (`<!-- ... -->`), prompt the user to fill them in before continuing.
   - If answers are present, evaluate them holistically. Skip generating new quiz questions — the pre-generated quiz in the file is authoritative.
5. **Evaluate answers**:
   - **Pass** (≥ 60% understanding, judged holistically): append review + quiz results to the lesson file, mark `- [x]` in curriculum.md.
   - **Gaps found**: give targeted feedback on missed concepts. Ask the user: "Would you like to retry with new questions, or move on anyway?" If they retry, generate a new set of questions (one retry maximum). Save results either way.
6. Print a motivating summary of the review and quiz outcome.

---

**Review section format** (appended to lesson file):
```markdown
## Review

**Reviewed**: {date}

### Feedback
{Peer-style review of the submitted work}

### Corrections
{Specific corrections if any}

### What You Did Well
{Positive reinforcement}

### Next Steps
{What to focus on in the next lesson}

## Quiz Results

**Date**: YYYY-MM-DD
**Score**: X/Y
**Pass**: Yes / No (retried: Yes/No)

### Q1 — Multiple Choice
Question: ...
Options: A) ... B) ... C) ... D) ...
Your answer: ...
Correct: ...
Result: ✓ / ✗

### Q2 — Fill in the Blank
Question: ...
Your answer: ...
Correct: ...
Result: ✓ / ✗

### Q3 — Explain in Your Own Words
Question: ...
Your answer: ...
Evaluation: ...
Result: ✓ / ✗

### Summary
{Brief note on strengths and any concepts to revisit}
```

---

### Quiz Generation Rules

- Draw questions directly from the lesson's **Key Concepts** and **Common Mistakes** sections.
- Each quiz must include all 3 formats: multiple choice, fill in the blank, and explain in your own words.
- Multiple choice distractors should test common misconceptions, not random wrong answers.
- Fill-in-the-blank blanks should target critical syntax, keywords, or terminology.
- The "explain" question should require the learner to articulate the *why*, not just the *what*.

### Pass Threshold

- ≥ 60% of questions demonstrate understanding.
- The AI makes a holistic judgment — partial credit is fine, especially for the "explain" question.
- If gaps are found: offer one retry with new questions, or let the user opt to move on. Save quiz results regardless.

---

### `/learn track`

**Goal**: Show current learning progress.

Steps:
1. Ask the user which topic to track (or infer from context).
2. Read `~/uuta/Learning/{topic}/curriculum.md`.
3. Parse the TODO checklist and display:
   - Completed modules (`- [x]`) with a checkmark
   - Current module (first `- [ ]`) highlighted
   - Remaining count
4. Print a motivational summary: "You've completed X of Y modules. Keep going!"

---

### `/learn まとめ`

**Goal**: Summarize everything covered in the current session.

Steps:
1. Review all lessons generated and reviewed in this session.
2. Produce a concise summary:
   - Topics covered
   - Key concepts learned
   - Exercises completed
   - Insights from review feedback
3. Optionally offer to save the summary as a note in `~/uuta/Learning/{topic}/session-summary.md`.

---

## Important Notes

- Always confirm the topic before operating on files.
- When saving files, use the Write tool with the full absolute path (e.g., `/Users/yutaaoki/uuta/Learning/Swift/curriculum.md`).
- If `~/uuta/Learning/` does not exist, create it with `mkdir -p ~/uuta/Learning/{topic}`.
- Lesson numbers are zero-padded to two digits: `lesson-01.md`, `lesson-02.md`, etc.
- Prefer official documentation as the primary learning reference.
