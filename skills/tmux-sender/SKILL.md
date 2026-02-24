---
name: tmux-sender
description: tmux の別ペインにコマンドを送信する。「ペインで実行して」「tmuxで送信」などのリクエストで使用。
allowed-tools: Bash(tmux:*)
---

# tmux コマンド送信スキル

## 使い方

tmux のペインにコマンドを送信して実行する場合、コマンドが単一行か複数行かで方法を切り替える。

### 単一行コマンド

```bash
tmux send-keys -t <ペイン番号> '<コマンド>' C-m
```

### 複数行コマンド（改行を含む場合）

```bash
# 1. 一時ファイルに書き出す
printf '%s' "$command" > /tmp/tmux_send.txt
# 2. tmux バッファに読み込む
tmux load-buffer /tmp/tmux_send.txt
# 3. ペインにペーストする（改行を保ったまま送信）
tmux paste-buffer -t <ペイン番号>
# 4. 実行する
tmux send-keys -t <ペイン番号> C-m
```

## 手順

1. `tmux list-panes` でペイン一覧を確認
2. コマンドに改行が含まれるか判定する
3. 単一行なら `tmux send-keys -t <ペイン番号> '<コマンド>' C-m` で送信・実行
4. 複数行なら `load-buffer` → `paste-buffer` → `C-m` の順で送信・実行
