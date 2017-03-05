"#####dein.vimの設定#####
if &compatible
  set nocompatible
endif

" プラグインが実際にインストールされるディレクトリ
let s:dein_dir = expand('~/git/dotfiles/')
" dein.vim 本体
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" dein.vim がなければ github から落としてくる
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)

    " プラグインリストを収めたTOMLファイル
    let g:dein_dir = expand('~/git/dotfiles/.vim/dein')
    let s:toml = g:dein_dir . '/dein.toml'
    let s:lazy_toml = g:dein_dir . '/dein_lazy.toml'

    " TOMLファイルにpluginを記述
    call dein#load_toml(s:toml, {'lazy': 0})
    call dein#load_toml(s:lazy_toml, {'lazy': 1})

    call dein#end()
    call dein#save_state()
endif

" 未インストールを確認
if dein#check_install()
    call dein#install()
endif

filetype plugin indent on

" -------------------
" View
" -------------------
syntax on " 強調表示(色付け)のON/OFF設定
syntax enable " 構文ハイライトが有効になる
set background=dark
"set background=light
"let g:solarized_termcolors=256
let g:solarized_termtrans =   1
colorscheme solarized
"colorscheme molokai
"colorscheme Tomorrow-Night-Bright
set t_Co=256
set cursorline
" アンダーラインを引く(color terminal)
"highlight CursorLine term=underline termfg=underline termbg=underline
highlight CursorLine term=reverse cterm=none ctermbg=242
" " アンダーラインを引く(gui)
highlight CursorLine gui=underline guifg=NONE guibg=NONE

highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
match ZenkakuSpace /　/

" 輝度を高くする
let g:solarized_visibility = "high"
" コントラストを高くする
"let g:solarized_contrast = "high"

set modeline
set modelines=1  "モードラインを1行読み込む
set number       "行番号表示
set ruler        "ルーラー表示
set title        "ウィンドウタイトルを変更
set visualbell   "visual bellの使用
set scrolloff=5
set textwidth=0  "一行に長い文章を書いていても自動折り返ししない

set laststatus=2
set showtabline=2 " 常にタブラインを表示
let g:airline_powerline_fonts = 1
let g:airline_theme = 'powerlineish'
"let g:airline_theme = 'molokai'
"let g:airline_theme = 'solarized'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

" vimを立ち上げたときに、自動的にvim-indent-guidesをオンにする
let g:indent_guides_enable_on_vim_startup = 1

" カーソルキーでbuffer移動
nnoremap <Left> :bp<CR>
nnoremap <Right> :bn<CR>

" -------------------
" Language
" -------------------
set encoding=utf-8
" set encoding=euc-jp
" set termencoding=utf-8
" set termencoding=eud-jp
set fileencoding=utf-8
" set fileencodings=utf-8,euc-jp,iso-2022-jp,cp932
" set fileformat=unix
" set fileformats=unix,dos,mac

" 文字コードの自動認識
if &encoding !=# 'utf-8'
      set encoding=japan
      set fileencoding=japan
endif
if has('iconv')
    let s:enc_euc = 'euc-jp'
    let s:enc_jis = 'iso-2022-jp'
    " iconvがeucJP-msに対応しているかをチェック
    if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
        let s:enc_euc = 'eucjp-ms'
        let s:enc_jis = 'iso-2022-jp-3'
    " iconvがJISX0213に対応しているかをチェック
    elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
        let s:enc_euc = 'euc-jisx0213'
        let s:enc_jis = 'iso-2022-jp-3'
    endif
    " fileencodingsを構築
    if &encoding ==# 'utf-8'
        let s:fileencodings_default = &fileencodings
        let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
        let &fileencodings = &fileencodings .','. s:fileencodings_default
        unlet s:fileencodings_default
    else
        let &fileencodings = &fileencodings .','. s:enc_jis
        set fileencodings+=utf-8,ucs-2le,ucs-2
        if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
            set fileencodings+=cp932
            set fileencodings-=euc-jp
            set fileencodings-=euc-jisx0213
            set fileencodings-=eucjp-ms
            let &encoding = s:enc_euc
            let &fileencoding = s:enc_euc
        else
            let &fileencodings = &fileencodings .','. s:enc_euc
        endif
    endif
    " 定数を処分
    unlet s:enc_euc
    unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
    function! AU_ReCheck_FENC()
        if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
            let &fileencoding=&encoding
        endif
    endfunction
    autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
    set ambiwidth=double
endif
set fileformat=unix
set fileformats=unix,dos,mac

if exists('&ambiwidth')
    if has('kaoriya')
        set ambiwidth=auto
    else
        set ambiwidth=double
    endif
endif

" iconvが使用可能の場合、カーソル上の文字コードをエンコードに応じた表示にする GetB(を使用)
if has('iconv')
    set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %F%=[%{GetB()}]\ %l,%c%V%8P
else
    set statusline=%<%f\ %m\ %r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=\ (%v,%l)/%L%8P
endif

function! GetB() " {{{
    let c = matchstr(getline('.'), '.', col('.') - 1)
    let c = iconv(c, &enc, &fenc)
    return s:String2Hex(c)
endfunction
" :help eval-examples
" The function Nr2Hex() returns the Hex string of a number.
function! s:Nr2Hex(nr)
    let n = a:nr
    let r = ''
    while n
        let r = '0123456789ABCDEF'[n % 16] . r
        let n = n / 16
    endwhile
    return r
endfunction

" -------------------
" evernote
" -------------------

let g:evervim_devtoken='S=s12:U=1549e6:E=161e0dfccc0:C=15a892e9d90:P=1cd:A=en-devtoken:V=2:H=7c569135ed53328c22aac2a0bf4899dd'
let g:vim_markdown_folding_disabled=1

" -------------------
"  tab
" -------------------

"ファイル内の <Tab> が対応する空白の数
set tabstop=4
"自動インデントの各段階に使われる空白の数
set shiftwidth=4
"<Tab>を押した時に挿入される空白の量(0:ts'で指定した量
set softtabstop=0
"タブをスペースに置き換える
set expandtab
"インデントを'shiftwidth' の値の倍数に丸める
set shiftround


" -------------------
" Search
" -------------------
set incsearch  "インクリメンタルサーチ
set ignorecase "大文字小文字無視
set smartcase  "大文字で開始したら大文字小文字区別
set wrapscan   "最後まで検索したら最初に戻る
set hlsearch   "検索結果をハイライト
set smartcase  "大文字で始めたら大文字小文字を区別する
"Escの2回押しでハイライト消去
nmap <ESC><ESC> :nohlsearch<CR><ESC>

" -------------------
" Special `Key

" -------------------
set list
set listchars=tab:>-,trail:-,extends:<,precedes:<
set display=uhex      " 印字不可能文字を16進数で表示
highlight SpecialKey ctermfg=darkgray
augroup highlightIdegraphicSpace
        autocmd!
        autocmd ColorScheme * highlight IdeographicSpace term=underline ctermbg=DarkGreen guibg=DarkGreen
        autocmd VimEnter,WinEnter * match IdeographicSpace /　/
augroup END

" -------------------
" Input
" -------------------
set nocompatible " Vi互換を無くす設定
set backspace=indent,eol,start "BSで何でも消せるようにする
"set formatoptions+=mM          "整形オプションにマルチバイト追加
set formatoptions=lmoq
set autoindent
set smartindent
set vb t_vb=    "ビープをならさない
set whichwrap=b,s,h,l,<,>,[,]    " カーソルを行頭、行末で止まらないようにする

" ------------------
" mouse
" ------------------
"set mouse=a

" Changing Leader Key
let mapleader = ","

" -------------------
" Command
" -------------------
set infercase
set wildmenu
set wildchar=<tab>         " コマンド補完を開始するキー
set wildmode=list:full     " リスト表示，最長マッチ
"set wildmode=list:longest,full
"set completeopt=menu,preview,menuone
set complete+=k            " 補完に辞書ファイル追加
set omnifunc=syntaxcomplete#Complete

" -------------------
" Programming
" -------------------
set showmatch "対応する括弧を強調表示
set cindent   "Cのインデント
set foldmethod=syntax
set grepprg=internal "内蔵grep
augroup grepopen
        autocmd!
        autocmd QuickfixCmdPost vimgrep cw
augroup END

"---------------------------------------------------------------------------
" フォント設定:
"---------------------------------------------------------------------------
"
if has('win32')
  " Windows用
  set guifont=MS_Gothic:h12:cSHIFTJIS
  "set guifont=MS_Mincho:h12:cSHIFTJIS
  " 行間隔の設定
  set linespace=1
  " 一部のUCS文字の幅を自動計測して決める
  if has('kaoriya')
    set ambiwidth=auto
  endif
elseif has('gui_macvim')
  set guifont=RictyDiscordForPowerline-Regular:h14
"elseif has('mac')
"  set guifont=Osaka－等幅:h14
elseif has('xfontset')
  " UNIX用 (xfontsetを使用)
  set guifontset=a14,r14,k14
endif

" -------------------
" Backup
" -------------------
"set autowrite " ファイル切替時に自動保存
set hidden " 保存しないで他のファイルを表示
"set backup "バックアップ
set nobackup
"set backupdir=$HOME/.backup/ "バックアップディレクトリ
"set swapfile
set noswapfile
"set directory=$HOME/.backup/
"set directory=$HOME/.vimtmp
"set history=10000  "ヒストリ件数
"set updatetime=500
"set viminfo="" ".viminfoファイルの設定
set viminfo='50,<1000,s100,\"50  " viminfoファイルの設定
"let g:svbfre = '.\+'
"augroup CursorHold
"    autocmd!
"    autocmd CursorHold * call NewUpdate()
"augroup END

" -------------------
" Status Line
" -------------------
set showcmd      "ステータスラインにコマンドを表示
set showmode     "現在のモードを表示
set laststatus=2 "ステータスラインを常に表示
set statusline=[%L]\ %t\ %y%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%r%m%=%c:%l/%L
" 入力時、ステータスラインのカラーを変更
"augroup InsertHook
"	autocmd!
"	autocmd InsertEnter * highlight StatusLine ctermfg=black ctermbg=white guifg=#2E4340 guibg=#ccdc90
"	autocmd InsertLeave * highlight StatusLine ctermfg=black ctermbg=lightgray guifg=black guibg=#c2bfa5
"augroup END

" -------------------
" Window
" -------------------
set splitright "Window Split時に新Windowを右に表示
set splitbelow "Window Split時に新Window下をに表示

" -------------------
" Spell Check
" -------------------
"set spell
"set spelllang=en
"set spellsuggest=en

" -------------------
" Dictionary
" -------------------
set dictionary=/usr/share/dict/words

" 日本語ヘルプを使う
set helplang=ja

" -------------------
" File Type
" -------------------
syntax on "シンタックスハイライト
augroup syntax
        autocmd!
"    autocmd FileType perl call PerlType()
augroup END
filetype indent on "ファイルタイプによるインデントを行う
filetype plugin on "ファイルタイプによるプラグインを使う
augroup bufcmd
        autocmd!
        autocmd BufNewFile * silent! 0r $VIMHOME/templates/%:e.tpl
        autocmd BufEnter * execute ":lcd " . expand("%:p:h")
augroup END

" screen
if &term =~ "screen"
    autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | silent!  exe '!echo -n "^[kv:%^[\\    "' | endif
    autocmd VimLeave * silent!  exe '!echo -n "^[k[`basename $PWD`]^[\\"'
endif

" 前回終了したカーソル行に移動
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

" -------------------
" キーバインド
" -------------------
" vimrc をリローダブルにする
noremap <C-c><C-c> <C-c>
noremap <C-c>ev :edit $HOME/.vimrc<CR>
noremap <C-c>sv :source $HOME/.vimrc<CR>
noremap <C-c>ez :edit $HOME/.zshrc<CR>
noremap <C-c>sz :source $HOME/.zshrc<CR>
noremap <C-c>ee :edit $HOME/.zshenv<CR>
noremap <C-c>se :source $HOME/.zshenv<CR>

" 表示単位で移動
noremap j gj
noremap k gk
vnoremap j gj
vnoremap k gk
noremap <C-h> <C-w>gh
noremap <C-j> <C-w>gj
noremap <C-k> <C-w>gk
noremap <C-l> <C-w>gl

" 検索箇所を真ん中に
noremap n nzz
noremap N Nzz
noremap * *zz
noremap # #zz
noremap g* g*zz
noremap g# g#zz

noremap <Space>  /
noremap s :%s/
noremap ; :
noremap <C-n> :nohl<CR>

noremap <Silent> <C-c>wo :set wrap<CR>
noremap <Silent> <C-c>wn :set nowrap<CR>

noremap <Silent> <C-c>ro :set expandtab<CR>:retab<CR>
noremap <Silent> <C-c>rn :set noexpandtab<CR>:retab<CR>
noremap <Silent> <C-c>eo :set expandtab<CR>:retab!<CR>
noremap <Silent> <C-c>en :set noexpandtab<CR>:retab!<CR>

noremap <Silent> <C-c>po :set paste<CR>:set nonumber<CR>:set nolist<CR>
noremap <Silent> <C-c>pn :set nopaste<CR>:set number<CR>:set list<CR>

noremap <Silent> gh :nohlsearch<CR>
noremap ,<Space> :vimgrep<Space>
noremap <Silent> <S->> <C-w>>
noremap <Silent> <S-<> <C-w><
noremap <Silent> <C-[> <C-t>
noremap <Silent> <C-]> <C-]>
noremap ,a :abbreviate<Space>

noremap <C-c>pp :set paste<CR>:set nonumber<CR>:set nolist<CR>
noremap <C-c>pn :set nopaste<CR>:set number<CR>:set list<CR>

" buffer
noremap ee :e .
noremap bb :ls<CR>:buf<Space>
noremap bd :buffdo
noremap bh :set :hidden<CR>
noremap bf :edit <Cfile><CR>
"noremap <C-b><C-b> <C-b>
noremap <silent> ] :bp<CR>
noremap <silent> [ :bn<CR>
noremap <silent> bp :bp<CR>
noremap <silent> bn :bn<CR>
noremap <silent> bd :bd<CR>
noremap <silent> <C-Left> :bp<CR>
noremap <silent> <C-Right> :bn<CR>
noremap <silent> <F2> :bq<CR>
noremap <silent> <F3> :bn<CR>
noremap <silent> <F4> :bw<CR>
noremap <silent> bq :Kwbd<CR>

" tab
noremap tt :tabnew .
noremap <silent> tn :tabn<CR>
noremap <silent> tp :tabp<CR>
noremap <C-t>t :tabdo<Space>

" window
noremap <C-w><C-w> <C-w>
noremap <Silent> <C-w>n :new<CR>
noremap <Silent> <C-w>v :vnew<CR>
noremap <Silent> <C-w>q :quit<CR>
noremap <silent> <C-w>- <C-w>-
noremap <Silent> <C-w>= <C-w>+
noremap <Silent> <C-w>, <C-w><
noremap <Silent> <C-w>. <C-w>>

" help
noremap ,h :<C-u>help<CR>
noremap ,u :<C-u>help<Space><C-r><C-w><CR>
noremap ,g :<C-u>helpgrep<Space>
noremap ,ms :marks<CR>
noremap ,md :delmarks!<CR>

" foldmethod
"noremap <silent> <C-f><C-f> zA
"noremap <silent> <C-f><C-o> zO
"noremap <silent> <C-f><C-c> zC

" tags
noremap <C-]><C-]> <C-]>
noremap <C-[><C-[> <C-t>
noremap <C-]><C-w> <C-w>}
noremap <C-[><C-w> <C-w><C-x>

" undo
noremap gl :undolist<CR>
noremap ge :undo NODE_NUMBER<CR>

" Command
inoremap <expr> <C-d>f strftime('%Y-%m-%dT%H:%M:%S')
inoremap <expr> <C-d>d strftime('%Y-%m-%d')
inoremap <expr> <C-d>t strftime('%H:%M:%S')
inoremap <silent> <expr> ,t (exists('#AutoComplPopGlobalAutoCommand#InsertEnter')) ? "\<C-o>:AutoComplPopDisable\<CR>" : "\<C-o>:AutoComplPopEnable\<CR>"

" 補完コマンド Ctrl + x + o
autocmd BufNewFile,BufRead COMMIT_EDITMSG set filetype=git
autocmd FileType git :set fileencoding=utf-8
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete
autocmd FileType ruby setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
