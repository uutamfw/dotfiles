# Neovim Configuration

個人用のNeovim設定ファイル集です。プラグイン管理に[lazy.nvim](https://github.com/folke/lazy.nvim)を使用し、LSP、補完、シンタックスハイライト、Git統合など多数の機能を備えています。

## 特徴

- `;` をリーダーキーとして使用
- [lazy.nvim](https://github.com/folke/lazy.nvim)によるプラグイン管理
- LSPサポート（[lspsaga](https://github.com/nvimdev/lspsaga.nvim)など）
- [Telescope](https://github.com/nvim-telescope/telescope.nvim)によるファジーファインダー
- [Treesitter](https://github.com/nvim-treesitter/nvim-treesitter)によるシンタックスハイライト
- [BufferLine](https://github.com/akinsho/bufferline.nvim)によるタブ管理
- Git統合（[gitsigns](https://github.com/lewis6991/gitsigns.nvim)、[git-blame](https://github.com/f-person/git-blame.nvim)など）
- Go言語サポート
- カラースキーム設定
- その他多数のQOL改善

## キーマップ

主要なキーマップは以下の通りです：

### 基本操作
- `;d` - HopWord（単語間ジャンプ）
- `;q` - 終了
- `;Q` - 強制終了
- `;w` - 保存
- `;wq` - 保存して終了

### バッファ操作
- `;ls` - バッファ一覧
- `;bd` - バッファ削除
- `<C-l>` - 次のバッファへ
- `<C-h>` - 前のバッファへ
- `;1-9` - 特定のバッファへ移動

### ファイル操作
- `;p` - ファイル検索（Telescope）
- `;ff` - テキスト検索（Telescope）
- `;F` - ファイルエクスプローラー（NvimTree）

### LSP
- `;s` - コードフォーマット
- `;kk` - ホバードキュメント
- `;kf` - 定義へ移動
- `;kt` - 型定義へ移動
- `;ka` - コードアクション
- `;kr` - リネーム

### Git
- `gf` - ファイルURLを開く
- `gc` - コミットURLを開く
- `gh` - 前のハンクへ
- `gl` - 次のハンクへ
- `gd` - diff表示
- `co` - コンフリクト解決（自分の変更を選択）
- `ct` - コンフリクト解決（相手の変更を選択）

### その他
- `;L` - Lazy（プラグイン管理）
- `;M` - Mason（LSPマネージャー）
- `;n` - Trouble（問題一覧）

## インストール方法

1. このリポジトリをクローン：
   ```
   git clone https://github.com/yourusername/dotfiles.git ~/.config/nvim
   ```

2. Neovimを起動すると、lazy.nvimが自動的にインストールされ、設定されたプラグインがダウンロードされます。

## 必要条件

- Neovim 0.9.0以上
- Git
- [ripgrep](https://github.com/BurntSushi/ripgrep)（Telescopeの全文検索用）
- 各言語のLSP（自動的にインストールされます）

## カスタマイズ

- `lua/core/keymaps.lua` - キーマップの設定
- `lua/core/options.lua` - Neovimの基本設定
- `lua/plugins/` - 各プラグインの設定
- `lua/core/colorscheme.lua` - カラースキームの設定

## ライセンス

MIT


