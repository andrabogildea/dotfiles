" mkdir -p .config/nvim/init.vim
" cp init.vim ~/.config/nvim/init.vim
"
" brew install neovim ripgrep fzf
" curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"
" python3 -m venv ~/.pylanguageserver
" ~/.pylanguageserver/bin/pip install 'python-language-server[all]'
"
" nvim +:PlugInstall +:qa

call plug#begin('~/.local/share/nvim/plugged')

" color schemes
Plug 'mhartington/oceanic-next'
Plug 'joshdick/onedark.vim'

Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf'

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

call plug#end()

" color scheme settings
" set termguicolors
let g:oceanic_next_terminal_bold = 1
let g:oceanic_next_terminal_italic = 1
let g:onedark_terminal_italics = 1

" set the default color scheme
colorscheme onedark
let g:airline_theme='onedark'

let mapleader = " "

" insert norecursive map jk to <esc>
inoremap jk <esc>

"set the timeout to wait for k after pressing j
set timeoutlen=500 

" include highlight clear in redraw
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

set splitright            "open vertical splits on the right
set splitbelow            "open horizontal splits below
set hidden                "don't warn if a buffer has changes before becomming hidden
set cursorline            "highlight current line
set ignorecase            "ignore case in search (used w/ smartcase)
set smartcase             "case sensitive search when uppercase chars are used
set nowrap                "don't wrap lines
set clipboard=unnamedplus "copy to CLIPBOARD
set mouse=a               "enable mouse in all modes
set colorcolumn=80        "show 80 columns limit

let g:netrw_liststyle=3 "list tree style
let g:netrw_banner=0    "disable top banner

" make * and # work in visual mode
function! s:VSetSearch(cmdtype)
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
  let @s = temp
endfunction
xnoremap * :<C-u>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>

if executable("rg")
  set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
endif

inoremap <TAB> <C-X><C-O>

" FZF bindigs
nnoremap <silent> <leader>f :GFiles<CR>
nnoremap <silent> <leader>F :Files<CR>
nnoremap <silent> <leader>l :BLines<CR>
nnoremap <silent> <leader>L :execute 'BLines ' . expand('<cword>')<CR>
nnoremap <silent> <leader>c :Commits<CR>
nnoremap <silent> <leader>C :BCommits<CR>

nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>h :Helptags<CR>
nnoremap <silent> <leader>H :Commands<CR>

nnoremap <silent> <leader>* :execute 'Rg ' . expand('<cword>')<CR>
nnoremap <silent> <leader>/ :execute 'Rg ' . input('Rg/')<CR>


" show fullscreen preview for files
command! -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), 1)
"
" show fullscreen preview for git files
command! -nargs=? -complete=dir GFiles
  \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(), 1)

let g:LanguageClient_serverCommands = {
    \ 'python': ['~/.pylanguageserver/bin/pyls'],
    \ }

augroup LanguageClient_config
  autocmd!
    autocmd User LanguageClientStarted setlocal signcolumn=yes
    autocmd User LanguageClientStarted setlocal formatexpr=LanguageClient#textDocument_rangeFormatting()
    autocmd User LanguageClientStarted setlocal completeopt-=preview
    autocmd User LanguageClientStopped setlocal signcolumn=auto
    autocmd User LanguageClientStopped setlocal formatexpr=""
    autocmd User LanguageClientStopped setlocal completeopt+=preview
augroup END
let g:LanguageClient_useVirtualText = "All"
let g:LanguageClient_completionPreferTextEdit = 1
let g:LanguageClient_hoverPreview = "Always"
nnoremap K :call LanguageClient_contextMenu()<CR>
