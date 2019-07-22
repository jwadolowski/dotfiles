" -----------------------------------------------------------------------------
" Plugins
" -----------------------------------------------------------------------------
call plug#begin('~/.local/share/nvim/plugged')
" Look & feel
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'morhetz/gruvbox'

" Git
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'
Plug 'junegunn/gv.vim'

" FZF
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

" Ruby
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rake'

" Snippets
Plug 'SirVer/ultisnips'   " Track the engine
Plug 'honza/vim-snippets' " Snippets are separated from the engine

" Markdown
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'

" Utils
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-projectionist' " adds TAB completion to :Rake function
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'       " Reconfig built-in directory browser

" VCL
Plug 'fgsch/vim-varnish'

" Search
Plug 'haya14busa/incsearch.vim'

" Auto-close bracket/quotes/tags
Plug 'jiangmiao/auto-pairs'

" Syntax checks
Plug 'w0rp/ale'

" Jenkinsfile support
Plug 'martinda/Jenkinsfile-vim-syntax'

" Log highlighting
Plug 'mtdl9/vim-log-highlighting'

" Terraform
Plug 'hashivim/vim-terraform'

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {{

" TODO review
" Plug 'tpope/vim-eunuch'
" Plug 'junegunn/vim-slash'

" TODO HashiCorp tools
" Plug 'hashivim/vim-consul'
" Plug 'hashivim/vim-nomadproject'
" Plug 'hashivim/vim-packer'
" Plug 'hashivim/vim-vagrant'
" Plug 'hashivim/vim-vaultproject'

" TODO Autocompletion
" Plug 'ervandew/supertab'
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'neoclide/coc.nvim', {'branch': 'release'}

" TODO Go
" Plug 'fatih/vim-go'

" TODO compare against ultisnips
" Plug 'Shougo/neosnippet.vim'
" Plug 'Shougo/neosnippet-snippets'

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ }}

call plug#end()

" -----------------------------------------------------------------------------
" Look & feel
" -----------------------------------------------------------------------------
set number          " display line numbers on the left
set colorcolumn=80  " highlight column #80
set cursorline      " Highlight current line
set noshowmode      " don't display current mode (Insert, Visual, Replace) in
                    " the status line. This information is already shown in the
                    " Airline status bar
set termguicolors   " enable true colors support

" order matters
"
" https://github.com/morhetz/gruvbox/issues/258#issuecomment-457215075
let g:gruvbox_contrast_dark='hard'
colorscheme gruvbox

set showbreak=↪\    " string displayed at the start of wrapped lines
set listchars=tab:»\ ,eol:$,trail:_,space:_,extends:>,precedes:<,nbsp:+
nmap <leader>l :set list!<CR>

" -----------------------------------------------------------------------------
" Search
" -----------------------------------------------------------------------------
set ignorecase      " ignore case when using a search pattern
set smartcase       " override 'ignorecase' if pattern has upper case characters

" -----------------------------------------------------------------------------
" Indentation & moving things around
" -----------------------------------------------------------------------------

set tabstop=4       " tab = N spaces
set softtabstop=4   " remove N spaces when removing indentation
set shiftwidth=4    " autoindent indents N spaces
set shiftround      " round to 'shiftwidth' for "<<" and ">>"
set expandtab       " always use spaces instead of tab characters
set nostartofline   " keep cursor in same column for long-range motion cmds
set scrolloff=3     " number of screen lines to show around the cursor
set sidescrolloff=2 " min # of columns to keep left/right of cursor

" Make code indendation easier
vnoremap < <gv
vnoremap > >gv

" -----------------------------------------------------------------------------
" General
" -----------------------------------------------------------------------------
set showmatch    " highlight matching bracket for short period of time
set nojoinspaces " Prevents inserting two spaces after punctuation on a join (J)
set autochdir    " automatically change window's cwd to file's dir

" -----------------------------------------------------------------------------
" Splits
" -----------------------------------------------------------------------------
set splitbelow " Horizontal split below current.
set splitright " Vertical split to right of current.

map <Leader>h :sp<CR>
map <Leader>v :vsp<CR>

map <c-h> <c-w>h
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l

" show vim help in vertical split on the right
"
" https://stackoverflow.com/a/21843502
autocmd FileType help wincmd L

set diffopt+=vertical " start diff mode with vertical splits by default

" -----------------------------------------------------------------------------
" Folding
" -----------------------------------------------------------------------------
" https://forum.upcase.com/t/code-folding-for-ruby/5644
"
" Space to toggle folds.
nnoremap <Space> za
vnoremap <Space> za

" -----------------------------------------------------------------------------
" FZF
" -----------------------------------------------------------------------------
" Detect Git repo root for Rg
"
" https://github.com/junegunn/fzf.vim/issues/27#issuecomment-185757840
function! s:with_git_root()
  let root = systemlist('git rev-parse --show-toplevel')[0]
  return v:shell_error ? {} : {'dir': root}
endfunction

" A few modifications to make grepping more sensible:
" * ignore filenames when searching with ripgrep
" * always assume Git repo's top level dir as a starting point
" * display preview window on the right hand side
"
" Further reading:
" * https://github.com/junegunn/fzf.vim/issues/346#issuecomment-288483704
" * https://github.com/junegunn/fzf.vim/issues/346#issuecomment-412558898
" * https://github.com/junegunn/fzf.vim/issues/714#issuecomment-428802659
command! -bang -nargs=* Rg
      \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>),
      \                   1,
      \                   fzf#vim#with_preview(extend({'options': '--delimiter : --nth 4..'}, s:with_git_root())),
      \                   <bang>0)

" Add preview to :GFiles
command! -bang -nargs=? GFiles
      \ call fzf#vim#gitfiles(<q-args>,
      \                       fzf#vim#with_preview(),
      \                       <bang>0)

" Add preview to :Files
command! -bang -nargs=? -complete=dir Files
      \ call fzf#vim#files(<q-args>,
      \                    fzf#vim#with_preview(),
      \                    <bang>0)

" Rg current word
nnoremap <silent> <Leader>rg :Rg <C-R><C-W><CR>

" Include all $HOME files
nnoremap <C-o> :Files ~<Cr>
nnoremap <C-p> :GFiles<Cr>
nnoremap <C-g> :Rg<Cr>
nnoremap <C-f> :BLines<Cr>
nnoremap <C-q> :Helptags<Cr>

" -----------------------------------------------------------------------------
" Airline
" -----------------------------------------------------------------------------
let g:airline_powerline_fonts = 1

" -----------------------------------------------------------------------------
" Ruby
" -----------------------------------------------------------------------------
" syntax highlighting
let ruby_operators = 1
let ruby_pseudo_operators = 1

" whitespace errors
let ruby_space_errors = 1

" syntax errors
let ruby_line_continuation_error = 1
let ruby_global_variable_error   = 1

" folding
" let g:ruby_foldable_groups = 'def #'
let g:ruby_foldable_groups = 'if def class module do begin case for { [ #'
let ruby_fold = 1

set foldlevel=99

" nnoremap <leader>f :call FoldRubyToggle()<cr>

" function! FoldRubyToggle()
"   if !exists("g:ruby_fold")
"     let g:ruby_fold = 1
"   else
"     unlet g:ruby_fold
"   endif
" endfunction

" -----------------------------------------------------------------------------
" Terraform
" -----------------------------------------------------------------------------
let g:terraform_fmt_on_save = 0 " ALE takes care of that
let g:terraform_align = 1       " Auto-align code as I type
let g:terraform_fold_sections=1 " Allow folding

autocmd BufNewFile,BufRead *.hcl set filetype=terraform

" -----------------------------------------------------------------------------
" Chef
" -----------------------------------------------------------------------------
autocmd BufNewFile,BufRead */cookbooks/*/\(attributes\|definitions\|libraries\|providers\|recipes\|resources\)/*.rb set filetype=ruby.chef
" autocmd BufNewFile,BufRead */cookbooks/*/templates/*/*.erb set filetype=chef syntax=eruby.chef
autocmd BufNewFile,BufRead */cookbooks/*/metadata.rb set filetype=ruby.chef

" -----------------------------------------------------------------------------
" Deoplete (autocompletion)
" -----------------------------------------------------------------------------
" let g:python2_host_prog = '/usr/local/bin/python2'
" let g:python3_host_prog = '/usr/local/bin/python3'
" let g:deoplete#enable_at_startup = 1

" -----------------------------------------------------------------------------
" UltiSnips
" -----------------------------------------------------------------------------
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" https://github.com/SirVer/ultisnips/issues/1052#issuecomment-504719268
" let g:UltiSnipsExpandTrigger = "<nop>"

" use <tab> for trigger completion and navigate to the next complete item
" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~ '\s'
" endfunction

" inoremap <silent><expr> <Tab>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<Tab>" :
"       \ coc#refresh()

" -----------------------------------------------------------------------------
" ALE (linters)
" -----------------------------------------------------------------------------
let g:ale_linters = {
\   'chef': ['cookstyle', 'foodcritic'],
\   'dockerfile': ['hadolint'],
\   'json': ['jsonlint'],
\   'markdown': ['alex', 'mdl', 'vale'],
\   'sh': ['shellcheck'],
\   'terraform': ['terraform', 'tflint'],
\   'yaml': ['yamllint'],
\   'xml': ['xmllint'],
\}

let g:ale_linters_explicit = 1

" https://github.com/markdownlint/markdownlint/blob/master/docs/RULES.md
let g:ale_markdown_mdl_options = '-r "~MD013,~MD024,~MD025"'

" https://github.com/w0rp/ale#5ix-how-can-i-navigate-between-errors-quickly
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" -----------------------------------------------------------------------------
" ALE (fixers)
" -----------------------------------------------------------------------------
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'json': ['jq'],
\   'terraform': ['terraform'],
\   'yaml': ['prettier'],
\}

" FIXME does it make sense to enforce Prettier-style for all *.md files?
" \   'markdown': ['prettier'],

" Adjust jq settings to match 'python -mjson.tool' output
let g:ale_json_jq_options = '--sort-keys --indent 4'

" Set this variable to 1 to fix files when you save them.
let g:ale_fix_on_save = 1

" -----------------------------------------------------------------------------
" Markdown
" -----------------------------------------------------------------------------
autocmd FileType markdown setlocal
  \ textwidth=120
  \ colorcolumn=+1
  \ spell spelllang=en_us

let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_follow_anchor = 1
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0

" Resize Goyo window to 120 characters
let g:goyo_width = 120

" Turn on Limelight automatically
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

" -----------------------------------------------------------------------------
" JSON
" -----------------------------------------------------------------------------
" enable folding for JSON files
autocmd FileType json setlocal foldmethod=syntax

" -----------------------------------------------------------------------------
" YAML
" -----------------------------------------------------------------------------
" https://lornajane.net/posts/2018/vim-settings-for-working-with-yaml
au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml foldmethod=indent
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" -----------------------------------------------------------------------------
" Incsearch
" -----------------------------------------------------------------------------
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

let g:incsearch#do_not_save_error_message_history = 1

let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

" https://github.com/haya14busa/incsearch.vim/issues/80
" augroup NoHlOnInsert
"   au!

"   " Exit hlsearch when entering insert as well
"   autocmd InsertEnter * :set nohlsearch

"   " Reenable it so that future searchs do hlsearch
"   autocmd InsertLeave * :set hlsearch
" augroup  END

" -----------------------------------------------------------------------------
" Utils
" -----------------------------------------------------------------------------

" Highlight all tabs and trailing whitespace characters
highlight ExtraWhitespace guibg=darkred
match ExtraWhitespace /\s\+$\|\t/

" https://stackoverflow.com/a/16114535/6802186
set nofixendofline

" sudo write
cmap w!! w !sudo tee > /dev/null %
