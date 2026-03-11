---
name: claude-tmux-pm
description: tmux 上の Claude Code セッションに GitHub の sub-issue を順番に割り当てるスキル。親 Issue 配下の sub-issue を番号順に見て、最初の未対応タスクが `S` ラベルなら `feat/{issue_number}` ブランチの専用 worktree で Claude Code に実装させる。Claude は実装と検証まで行い、Codex が diff review してから commit / push / PR を行う。最初の未対応タスクが `M` または `L` の場合は割り当てず、先に対応方針をユーザーと相談する。「Claude Code に割り当てて」「tmux の Claude に投げて」「agent に issue を振って」などで使用。
allowed-tools: Bash(tmux:*), Bash(gh:*), Bash(git:*)
---

# Claude Code tmux PM Skill

## Guardrails

- `S` ラベルの task だけを Claude Code に割り当てる
- sub-issue は必ず番号の小さい順に扱う
- 先頭の未対応 task が `M` または `L` なら、後ろの `S` を飛ばして割り当ててはいけない
- ブランチ名は必ず `feat/{issue_number}` を使う
- 1 agent につき 1 task だけを担当させる
- Claude Code は必ず `--dangerously-skip-permissions` を付けて起動する
- issue ごとに専用 worktree を使う。既存のユーザー作業中 checkout は使わない
- Claude Code は実装と検証まで行い、commit / push / PR は Codex が review 後に行うのを原則とする
- Claude が「完了」と言っても、そのまま成功扱いにしない。必ず diff review を挟む

## Procedure

### 1. 親 Issue と sub-issue を確認する

```bash
gh issue view <parent_issue> --repo <owner>/<repo>
gh sub-issue list <parent_issue>
```

sub-issue を番号順に見て、最初の未対応 issue を決める。

未対応かどうかは次で判定する:

- Issue が open のまま
- まだ tmux 上の agent に予約されていない
- まだ PR 完了扱いになっていない

### 2. サイズラベルを確認する

対象 issue の size label を確認する。

- `S`: 割り当て可
- `M` / `L`: 割り当て禁止。ここで止めてユーザーに相談する

このルールは厳守する。先頭 issue が `M` / `L` のとき、後続の `S` に進めてはいけない。

### 3. 専用 worktree を用意する

既存の checkout を Claude に触らせない。issue ごとに専用 worktree を作る。

例:

```bash
git fetch origin
git worktree add -b feat/<issue_number> <repo_parent>/agent-<issue_number> origin/main
```

- すでに `feat/<issue_number>` の worktree があるならそれを再利用してよい
- 既存 branch / remote branch がある場合は、その branch を正しく checkout した worktree を使う

### 4. Claude Code pane を探す

```bash
tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index}  #{pane_current_command}  #{pane_title}'
```

優先順位:

1. すでに `issue-<issue_number>` に予約されている pane
2. なければ対象 worktree 用の新規 window

原則として、別 issue の会話が残っている既存 pane は再利用しない。

### 5. 必要なら Claude Code を起動する

Claude Code の起動コマンドが `claude` で通る前提なら、必ず `--dangerously-skip-permissions` を付けて起動する。例えば次を使う。

```bash
tmux new-window -n claude-<issue_number> -c <worktree_path> 'claude --dangerously-skip-permissions'
```

起動コマンドが不明、または `claude` が見つからない場合は、ここで止めてユーザーに確認する。勝手に別コマンドを推測しない。

起動後は `tmux capture-pane -p -t <target> -S -80` を数回取り、出力が安定して操作待ちになったことを確認する。

workspace trust prompt が出る場合は、安全な自分の repo/worktree であることを確認した上で通す。

### 6. pane を issue に予約する

同じ issue を二重で振らないため、pane title か window 名に issue を入れる。

例:

```bash
tmux select-pane -t <target> -T 'claude issue-<issue_number>'
```

または:

```bash
tmux rename-window -t <target_window> 'claude-<issue_number>'
```

### 7. Claude Code に送る

複数行 prompt として送る。最低限、次の情報を含める:

- worktree path
- issue number / title / URL
- ブランチ名 `feat/{issue_number}`
- 親 Issue の番号 / title / URL
- `AGENTS.md` を守ること
- この issue 以外に着手しないこと
- 実装後は commit / push / PR をせず停止し、diff と検証結果を要約すること
- ブロック時は停止して状況を要約すること

推奨テンプレート:

```text
You are working in <worktree_path>.

Take GitHub issue #<issue_number> in <owner>/<repo>.
Issue URL: <issue_url>
Branch: feat/<issue_number>
Parent issue: #<parent_issue_number>
Parent issue title: <parent_issue_title>
Parent issue URL: <parent_issue_url>

Rules:
- Follow AGENTS.md in the repo.
- Read the parent issue for context before making changes.
- Work only on this issue. Do not take on other sub-issues from the parent.
- Inspect the relevant files before editing.
- Run relevant tests or verification.
- Do not commit, push, or create a pull request yet.
- When implementation is ready, stop and summarize:
  - changed files
  - verification commands run
  - any blockers or remaining uncertainty
- If blocked, stop and summarize the blocker clearly.

Suggested start:
cd <worktree_path>
git fetch origin
git switch -c feat/<issue_number> || git switch feat/<issue_number>
gh issue view <parent_issue_number> --repo <owner>/<repo>
gh issue view <issue_number> --repo <owner>/<repo>
```

送信時は `tmux-sender` と同じルールを使う。

- 単一行なら `tmux send-keys`
- 複数行なら `load-buffer` -> `paste-buffer` -> `C-m`

### 8. Claude の実装後に diff review する

Claude が実装完了を報告したら、ここで初めて Codex が review を行う。

最低限:

```bash
git -C <worktree_path> status --short --branch
git -C <worktree_path> diff --stat origin/main...HEAD
git -C <worktree_path> diff --unified=80 origin/main...HEAD
```

- `review-diffs` スキルが使えるなら使う
- findings があれば、その内容を同じ Claude pane に返して修正させる
- 修正後に再 review する
- findings がなくなるまで loop する

### 9. review が clean なら Codex が commit / push / PR を行う

review が clean で、かつ push 権限がある場合は Codex が worktree で次を行ってよい。

```bash
git -C <worktree_path> add <files>
git -C <worktree_path> commit -m "<message>"
git -C <worktree_path> push -u origin feat/<issue_number>
```

必要なら、その後に GitHub PR を作成する。

Claude に commit / push / PR をさせるのは、明示的にその運用を選ぶ場合だけにする。

### 10. 割り当て結果を返す

ユーザーには少なくとも次を返す:

- 割り当てた issue 番号とタイトル
- size label
- 割り当て先 pane
- ブランチ名 `feat/{issue_number}`
- worktree path

## If The Next Issue Is M Or L

割り当てず、次のように返す:

- 次に処理すべき issue 番号
- issue title
- size label (`M` or `L`)
- `S` ではないので Claude Code へはまだ渡さないこと

その上で、分割するか、別の進め方にするかをユーザーと相談する。

## Notes

- branch 名に `#` は使わない。必ず `feat/{issue_number}` にする
- size label は 1 issue につき 1 つを前提にする
- pane の予約ルールを守り、同じ issue の二重アサインを避ける
- Claude Code を新規起動する場合は、毎回 `claude --dangerously-skip-permissions` を使う
- reuse より isolation を優先する。worktree と tmux window は issue ごとに分ける
- 「Claude が実装した」ことと「review 済みで merge 可能」なことは別物として扱う
