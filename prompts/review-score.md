---
description: Score code review comments
---

## Objective

- Read review comments on GitHub and give scores for each comment

## Todo

- Read comments with `gh` commands
- Review those comments
- Create/update docs/review-score.md in the current directory that you're working on

## useful commands

```
cd {project directory} && gh pr view 8 --comments
cd {project directory} && gh pr view $1 --comments
cd {project directory} && gh pr view $1 --json reviews
cd {project directory} && gh api repos/{xxx}/{project}/pulls/$1/reviews
```

## docs/review-score.md should be considered in the following perspectives

- Overall score (up to 100)
- The reason why you gave the above score
- Review each comment
  - Score
  - What you agree
     - Does the suggestion work well?
     - Is the comment critical?
  - What you disagree
     - Does this comment generate critical bugs?
     - Does this comment cause potential bugs?


## Format

```
## Overall score (up to 100)

- 

## The reason why you gave the above score

- 

## 1. {title of review comments 1}

### 1-1. Score (up to 100)

### 1-2. What you agree

### 1-3. What you disagree

## 2. {title of review comments 2}

...
```
