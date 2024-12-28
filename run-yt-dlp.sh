#!/bin/bash

# 現在の日付をYYYYMMDD形式で取得
current_date=$(date +"%Y%m%d")

# ダウンロード先のパスを作成
download_path="$HOME/Dropbox/$current_date/"

# 引数としてURLを受け取る
url="$1"

# yt-dlpコマンドを実行
yt-dlp -f "136/137/mp4/bestvideo,140/m4a/bestaudio" -P "$download_path" "$url" -o '%(id)s.%(ext)s'

