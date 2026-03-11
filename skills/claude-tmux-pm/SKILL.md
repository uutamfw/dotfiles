---
name: claude-tmux-pm
description: tmux 上の Claude Code セッションを見つける、必要なら起動する、GitHub の sub-issue を順番に割り当てるためのスキル。親 Issue 配下の sub-issue を番号順に見て、最初の未対応タスクが `S` ラベルなら `feat/{issue_number}` ブランチで Claude Code エージェントに依頼する。最初の未対応タスクが `M` または `L` の場合は割り当てず、先に対応方針をユーザーと相談する。「Claude Code に割り当てて」「tmux の Claude に投げて」「agent に issue を振って」などで使用。
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
- agent は `git commit` と PR 作成まで行ってよい

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

### 3. Claude Code pane を探す

```bash
tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index}  #{pane_current_command}  #{pane_title}'
```

優先順位:

1. `claude` を実行中で、まだ issue が予約されていない pane
2. `claude` を起動できる空き pane / window
3. なければ新規 window or session を作る

### 4. 必要なら Claude Code を起動する

Claude Code の起動コマンドが `claude` で通る前提なら、必ず `--dangerously-skip-permissions` を付けて起動する。例えば次を使う。

```bash
tmux new-window -n claude-<issue_number> -c <repo_path>
tmux send-keys -t <target> 'claude --dangerously-skip-permissions' C-m
```

起動コマンドが不明、または `claude` が見つからない場合は、ここで止めてユーザーに確認する。勝手に別コマンドを推測しない。

起動後は `tmux capture-pane -p -t <target> -S -80` を数回取り、出力が安定して操作待ちになったことを確認する。

### 5. pane を issue に予約する

同じ issue を二重で振らないため、pane title か window 名に issue を入れる。

例:

```bash
tmux select-pane -t <target> -T 'claude issue-<issue_number>'
```

または:

```bash
tmux rename-window -t <target_window> 'claude-<issue_number>'
```

### 6. Claude Code に送る

複数行 prompt として送る。最低限、次の情報を含める:

- repo path
- issue number / title / URL
- ブランチ名 `feat/{issue_number}`
- `AGENTS.md` を守ること
- この issue 以外に着手しないこと
- 完了時は commit と PR 作成まで進めてよいこと
- ブロック時は停止して状況を要約すること

推奨テンプレート:

```text
You are working in <repo_path>.

Take GitHub issue #<issue_number> in <owner>/<repo>.
Issue URL: <issue_url>
Branch: feat/<issue_number>

Rules:
- Follow AGENTS.md in the repo.
- Work only on this issue.
- Inspect the relevant files before editing.
- Run relevant tests or verification.
- You may commit your changes and create a pull request.
- If blocked, stop and summarize the blocker clearly.

Suggested start:
cd <repo_path>
git fetch origin
git switch -c feat/<issue_number> || git switch feat/<issue_number>
gh issue view <issue_number> --repo <owner>/<repo>
```

送信時は `tmux-sender` と同じルールを使う。

- 単一行なら `tmux send-keys`
- 複数行なら `load-buffer` -> `paste-buffer` -> `C-m`

### 7. 割り当て結果を返す

ユーザーには少なくとも次を返す:

- 割り当てた issue 番号とタイトル
- size label
- 割り当て先 pane
- ブランチ名 `feat/{issue_number}`

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
