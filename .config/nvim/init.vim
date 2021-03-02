call plug#begin('~/.config/nvim/addons')
" -------------------
" -- General Plugs
" -------------------

" autocomplete coc
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" molokai color theme
"Plug 'tomasr/molokai'

" nord color theme
Plug 'arcticicestudio/nord-vim'

" close parenthesis
"System Shortcuts:
"    <CR>  : Insert new indented line after return if cursor in blank brackets\ 
"    or quotes.
"    <BS>  : Delete brackets in pair
"    <M-p> : Toggle Autopairs (g:AutoPairsShortcutToggle)
"    <M-e> : Fast Wrap (g:AutoPairsShortcutFastWrap)
"    <M-n> : Jump to next closed pair (g:AutoPairsShortcutJump)
"    <M-b> : BackInsert (g:AutoPairsShortcutBackInsert)
"
"If <M-p> <M-e> or <M-n> conflict with another keys or want to bind to another\ 
"keys, add
"
"    let g:AutoPairsShortcutToggle = '<another key>'
"
"to .vimrc, if the key is empty string '', then the shortcut will be disabled.
Plug 'jiangmiao/auto-pairs'

" whitespace
Plug 'bronson/vim-trailing-whitespace' " :FixWhitespace

" Unite
"   depend on vimproc
"   ------------- VERY IMPORTANT ------------
"   you have to go to .vim/plugin/vimproc.vim and do a ./make
"   -----------------------------------------
" file management: Now type space twice. A list of files appears. Start to type\ 
" some letters of the file you are searching for. Select it, type return and \
" bingo the file opens in a new horizontal split.
Plug 'Shougo/vimproc.vim'
Plug 'Shougo/unite.vim'

" file search :Ack [options] {pattern} [{directories}]
Plug 'mileszs/ack.vim'

" Show which line changed since your last commit.
Plug 'airblade/vim-gitgutter'

" You can reset your changes from the latest git commit with :Gread. You can \ 
" stage your changes with :Gwrite
Plug 'tpope/vim-fugitive'

" Just select and type Return then space. Type Return many type to change the \
" alignments.If you want to align the second column, Return then 2 then space.
Plug 'junegunn/vim-easy-align'

" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" -------------------
" -- Haskell Plugs
" -------------------
" ---------- VERY IMPORTANT -----------
" Don't forget to install ghc-mod with:
" cabal install ghc-mod
" -------------------------------------

Plug 'scrooloose/syntastic'             " syntax checker
" --- Haskell
Plug 'yogsototh/haskell-vim'            " syntax indentation / highlight
Plug 'enomsg/vim-haskellConcealPlus'    " unicode for haskell operators
Plug 'eagletmt/ghcmod-vim'
Plug 'eagletmt/neco-ghc'
Plug 'Twinside/vim-hoogle'
Plug 'pbrisbin/html-template-syntax'    " Yesod templates


" -------------------
" -- Julia Plugs
" -------------------
Plug 'JuliaEditorSupport/julia-vim'
Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh'}

" -------------------
" -- Python Plugs
" -------------------

call plug#end()

" -------------------
" -- General Settings
" -------------------

set number
set spell spelllang=en_gb

" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

" COC autocomplete
source $HOME/.config/nvim/plug-config/coc.vim

" molokai color theme
"let g:molokai_original = 0
"colorscheme molokai

" nord color theme
colorscheme nord

" close parenthesis
let g:AutoPairsFlyMode = 0
let g:AutoPairsShortcutBackInsert = '<M-b>'
let g:AutoPairsMapBS = 0

" shows 80 char column
if (exists('+colorcolumn'))
    set colorcolumn=80
    highlight ColorColumn ctermbg=9
endif

" file management
let g:unite_source_history_yank_enable = 1
try
  let g:unite_source_rec_async_command='ag --nocolor --nogroup -g ""'
  call unite#filters#matcher_default#use(['matcher_fuzzy'])
catch
endtry
" search a file in the filetree
nnoremap <space><space> :split<cr> :<C-u>Unite -start-insert file_rec/async<cr>
" reset not it is <C-l> normally
:nnoremap <space>r <Plug>(unite_restart)

" Easy align interactive
vnoremap <silent> <Enter> :EasyAlign<cr>

" Ack search
cnoreabbrev Ack Ack!
nnoremap <Leader>a :Ack!<Space>

" airline
let g:airline_theme='papercolor'

" -------------------
" -- Haskell Settings
" -------------------

let mapleader="-"
let g:mapleader="-"
set tm=2000
nmap <silent> <leader>ht :GhcModType<CR>
nmap <silent> <leader>hh :GhcModTypeClear<CR>
nmap <silent> <leader>hT :GhcModTypeInsert<CR>
nmap <silent> <leader>hc :SyntasticCheck ghc_mod<CR>:lopen<CR>
let g:syntastic_mode_map={'mode': 'active', 'passive_filetypes': ['haskell']}
let g:syntastic_always_populate_loc_list = 1
nmap <silent> <leader>hl :SyntasticCheck hlint<CR>:lopen<CR>

" Auto-checking on writing
autocmd BufWritePost *.hs,*.lhs GhcModCheckAndLintAsync

"  neocomplcache (advanced completion)
autocmd BufEnter *.hs,*.lhs let g:neocomplcache_enable_at_startup = 1
function! SetToCabalBuild()
    if glob("*.cabal") != ''
        set makeprg=cabal\ build
    endif
endfunction
autocmd BufEnter *.hs,*.lhs :call SetToCabalBuild()

" -- neco-ghc
let $PATH=$PATH.':'.expand("~/.cabal/bin")

" -------------------
" -- Julia Settings
" -------------------
" julia
let g:default_julia_version = '1.0'

" language server
let g:LanguageClient_autoStart = 1
let g:LanguageClient_serverCommands = {
\   'julia': ['/home/sys-adm-eddie/.julia-1.5.3/bin/julia', '--startup-file=no', '--history-file=no', '-e', '
\       using LanguageServer;
\       using Pkg;
\       import StaticLint;
\       import SymbolServer;
\       env_path = dirname(Pkg.Types.Context().env.project_file);
\ 
\       server = LanguageServer.LanguageServerInstance(stdin, stdout, env_path, "");
\       server.runlinter = true;
\       run(server);
\   ']
\ }

nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>

" -------------------
" -- Python Settings
" -------------------
"set pyx=3
let g:loaded_python_provider = 0
let g:python3_host_prog = '~/.pyenv/shims/python'
