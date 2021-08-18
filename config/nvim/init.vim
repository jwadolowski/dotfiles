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

" Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

" web-devicons
Plug 'kyazdani42/nvim-web-devicons'

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

" Caddyfile
Plug 'isobit/vim-caddyfile'

" Kotlin
Plug 'udalov/kotlin-vim'

" Rust
Plug 'rust-lang/rust.vim'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Plug 'windwp/nvim-autopairs'

" Ansible
Plug 'pearofducks/ansible-vim'

" Utils
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-projectionist' " adds TAB completion to :Rake function
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'       " Reconfig built-in directory browser
Plug 'tpope/vim-endwise'
Plug 'junegunn/vim-easy-align'
" Plug 'andymass/vim-matchup'

" Startup time
Plug 'dstein64/vim-startuptime'

" VCL
Plug 'fgsch/vim-varnish'

" TOML
Plug 'cespare/vim-toml'

" Search
Plug 'haya14busa/is.vim'

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

" Plug 'codota/tabnine-vim'
Plug 'chrisbra/Colorizer'

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
Plug 'neoclide/coc.nvim', {'branch': 'release'}

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
set number         " display line numbers on the left
set colorcolumn=80 " highlight column #80
set cursorline     " Highlight current line
set noshowmode     " don't display current mode (Insert, Visual, Replace) in
                   " the status line. This information is already shown in the
                   " Airline status bar
set termguicolors  " enable true colors support

set updatetime=100

" order matters
"
" https://github.com/morhetz/gruvbox/issues/258#issuecomment-457215075
let g:gruvbox_contrast_dark='hard'
colorscheme gruvbox

set showbreak=↪\    " string displayed at the start of wrapped lines
set listchars=tab:»\ ,eol:$,trail:_,space:_,extends:>,precedes:<,nbsp:+
nmap <leader>l :set list!<CR>

lua <<EOF
require'nvim-treesitter.configs'.setup {
ensure_installed = "maintained",
highlight = {
enable = true,
},
  incremental_selection = {
  enable = true,
  },
  indent = {
  enable = true,
  },
}
EOF

" -----------------------------------------------------------------------------
" Search
" -----------------------------------------------------------------------------
set ignorecase " ignore case when using a search pattern
set smartcase  " override 'ignorecase' if pattern has upper case characters

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
set showmatch         " highlight matching bracket for short period of time
set nojoinspaces      " Prevents inserting two spaces after punctuation on a
" join (J)
set clipboard=unnamed " macOS clipboard sharing
set nofixendofline    " https://stackoverflow.com/a/16114535/6802186

" https://vi.stackexchange.com/a/1985/18655
"
" Disable comment continuation:
" * do not continue comment on ENTER in insert mode
" * do not continue comment after hiting 'o' or 'O' in normal mode
au FileType * setlocal formatoptions-=r formatoptions-=o

" Change to file directory
nnoremap <leader>cd :cd %:p:h<CR>

" Disable unused providers to fix ":checkhealth provider"
"
" https://neovim.io/doc/user/provider.html
let g:loaded_python_provider = 0
let g:loaded_ruby_provider = 0
let g:loaded_node_provider = 0
let g:loaded_perl_provider = 0

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
nnoremap <Space> za
vnoremap <Space> za

set foldlevelstart=99 " Start with all folds opened

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

" I experienced quite a few odd issues that I can't explain easily. Let's try
" ag for a while and then decide what to do next:
" * Error detected while processing function 276[30]..<SNR>27_callback:
" * ... (didn't write it down anywhere)
"
command! -bang -nargs=* Ag
            \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>),
            \                   1,
            \                   fzf#vim#with_preview(extend({'options': '--delimiter : --nth 4..'}, s:with_git_root())),
            \                   <bang>0)

command! -bang -nargs=* Ag
            \ call fzf#vim#ag(<q-args>,
            \                 fzf#vim#with_preview(extend({'options': '--delimiter : --nth 4..'}, s:with_git_root())),
            \                 <bang>0)

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

" Grep current word
nnoremap <silent> <Leader>rg :Rg <C-R><C-W><CR>
nnoremap <silent> <Leader>ag :Ag <C-R><C-W><CR>
nnoremap <silent> <Leader>g :Ag <C-R><C-W><CR>

" Include all $HOME files
nnoremap <C-o> :Files ~<Cr>

nnoremap <C-p> :GFiles<Cr>
nnoremap <C-g> :Ag<Cr>
nnoremap <C-f> :BLines<Cr>
nnoremap <C-q> :Helptags<Cr>

" -----------------------------------------------------------------------------
" Easy align
" -----------------------------------------------------------------------------
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

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
let g:ruby_foldable_groups = 'if def class module do begin case for { [ #'
let ruby_fold = 1

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
" let g:UltiSnipsExpandTrigger="<tab>"
" let g:UltiSnipsJumpForwardTrigger="<tab>"
" let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" https://github.com/SirVer/ultisnips/issues/1052#issuecomment-504719268
let g:UltiSnipsExpandTrigger = "<nop>"

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
" \   'chef': ['cookstyle', 'foodcritic'],
let g:ale_linters = {
            \   'dockerfile': ['hadolint'],
            \   'json': ['jsonlint'],
            \   'markdown': ['alex', 'mdl', 'vale'],
            \   'sh': ['shellcheck'],
            \   'terraform': ['terraform'],
            \   'yaml': ['yamllint'],
            \   'xml': ['xmllint'],
            \}

let g:ale_linters_explicit = 1

" https://github.com/markdownlint/markdownlint/blob/master/docs/RULES.md
let g:ale_markdown_mdl_options = '-r "~MD013,~MD024,~MD025"'

" Let's be a bit more verbose during linting
"
" https://github.com/w0rp/ale#5vii-how-can-i-change-the-format-for-echo-messages
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] [%severity%] %s'

" Populate localion list with linter messages
let g:ale_set_loclist = 1

" Open location list with <Leader>m
"
" Location list == per window quickfix
nmap <Leader>m :lopen<CR>

" -----------------------------------------------------------------------------
" ALE (fixers)
" -----------------------------------------------------------------------------
let g:ale_fixers = {
            \   '*': ['remove_trailing_lines', 'trim_whitespace'],
            \   'json': ['jq'],
            \   'markdown': ['prettier'],
            \   'terraform': ['terraform'],
            \   'yaml': ['prettier'],
            \   'sh': ['shfmt'],
            \}

" Adjust jq settings to match 'python -mjson.tool' output
let g:ale_json_jq_options = '--sort-keys --indent 4'

" Prefer 4 space indentation in bash scripts
let g:ale_sh_shftm_options = '-i 4'

" Set this variable to 1 to fix files when you save them.
let g:ale_fix_on_save = 1

" -----------------------------------------------------------------------------
" Markdown
" -----------------------------------------------------------------------------

" https://github.com/plasticboy/vim-markdown/issues/126#issuecomment-485579068
autocmd FileType markdown setlocal
            \   textwidth=0
            \   colorcolumn=
            \   indentexpr=
            \   ts=2
            \   sts=2
            \   sw=2
            \   expandtab
            \   spell spelllang=en_us

" Do not fix Markdown syntax on save
autocmd FileType markdown let b:ale_fix_on_save=0

" ge command doesn't make sense for [Section](#section)
let g:vim_markdown_follow_anchor = 1

" Resize Goyo window to 121 characters (120 for markdown + sign column)
let g:goyo_width = 121

" Turn on Limelight automatically
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

" Shortcut to fix syntax on demand
nmap <Leader>f <Plug>(ale_fix)

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
" Utils
" -----------------------------------------------------------------------------

" Highlight all tabs and trailing whitespace characters
highlight ExtraWhitespace guibg=darkred
match ExtraWhitespace /\s\+$\|\t/

" https://stackoverflow.com/a/16114535/6802186
set nofixendofline

" sudo write
cmap w!! w !sudo tee > /dev/null %

" clever substitute
"
" https://vim.fandom.com/wiki/Search_and_replace_the_word_under_the_cursor
:nnoremap <Leader>s :%s/\<<C-r><C-w>\>/

" disable paste mode when leaving Insert Mode
autocmd InsertLeave * set nopaste

" -----------------------------------------------------------------------------
" coc
" -----------------------------------------------------------------------------
inoremap <silent><expr> <TAB>
            \ pumvisible() ? coc#_select_confirm() :
            \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ coc#refresh()

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

let g:coc_global_extensions = ['coc-solargraph', 'coc-yaml']

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
    " Recently vim can merge signcolumn and number column into one
    set signcolumn=number
else
    set signcolumn=yes
endif

" Use <c-space> to trigger completion.
if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
else
    inoremap <silent><expr> <c-@> coc#refresh()
endif

let g:coc_filetype_map = {
            \ 'yaml.ansible': 'yaml',
            \ }

" -----------------------------------------------------------------------------
" Telescope
" -----------------------------------------------------------------------------
lua << EOF
require('telescope').setup {
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
            }
        }
    }
require('telescope').load_extension('fzy_native')
EOF

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>gf <cmd>Telescope git_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
