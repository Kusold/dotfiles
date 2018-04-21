" Refactored vimrc start

"│-v-1 │ to-do's
"└─────┴─────────
  " TODO Move all settings into folds
  " TODO Convert most plugins to lazy load
  " TODO evaluate if all plugins are necessary
  " TODO expand on plugin descriptions
  " TODO investigate https://github.com/reedes/vim-thematic
  " TODO https://github.com/mbbill/undotree
  " TODO https://github.com/godlygeek/tabular

"│-v-1 │ initiliaze
"└─┬───┴─┬────────────────
  "│-v-2 │ compatibility settings
  "└─────┴─────────
    " Disable vi compatibility settings
    set nocompatible

    "For that which __requires_utf_8:
    set encoding=utf8

  "│-v-2 │ filetype settings
  "└─────┴─────────
    " Enable filetype detection
    " Enable loading of filetype plugins
    " Enable loading of filetype indents
    filetype plugin indent on

  "│-v-2 │ leader key settings
  "└─────┴─────────
    " Set the leader key to \
    let mapleader = "\<Space>"

"│-v-1 │ plugin settings
"└─┬───┴─┬────────────────
  "│-v-2 │ vim-plug                    - junegunn/vim-plug (init vim-plug)
  "└─────┴─────────
    " Load vim-plug
    call plug#begin('~/.vim/plugged')

  "│-v-2 │ ack                         - mileszs/ack.vim (faster grep)
  "└─────┴─────────
    "Faster grep for code
    Plug 'mileszs/ack.vim', {'on': 'Ack!'}

    " if silver surfer is installed, use that instead
    if executable('ag')
        let g:ackprg = 'ag --vimgrep'
    endif

    " Don't automatically jump to the first result
    cnoreabbrev Ack Ack!
    nnoremap <Leader>a :Ack!<Space>

  "│-v-2 │ airline                     - vim-airline/vim-airline (fancy status line)
  "└─────┴─────────
    " Style the status/tabline
    Plug 'vim-airline/vim-airline'
    set laststatus=2
    set timeoutlen=1000
    set ttimeoutlen=50
    let g:airline_powerline_fonts = 1
    let g:airline#extensions#tabline#enabled = 1 " Enable the list of buffers
    let g:airline#extensions#tabline#fnamemod = ':t' " Show just the filename

  "│-v-2 │ airline-themes              - vim-airline/vim-airline-themes (themes for airline)
  "└─────┴─────────
    " themes for airline, includes base16 themes
    Plug 'vim-airline/vim-airline-themes'

  "│-v-2 │ ale                         - w0rp/ale (display errors while typing)
  "└─────┴─────────
    "Display where errors and warnings occur
    Plug 'w0rp/ale'
    " :ALEFix
    let g:ale_fixers = {
                \  'javascript': ['eslint'],
                \}

    let g:ale_sign_error = '✘'
    let g:ale_sign_warning = '▲'

    " Configure for airline
    let g:airline#extensions#ale#enabled = 1

    " Open location or quick fix list when there are errors
    let g:ale_open_list = 1

    let g:ale_list_window_size = 5
    let g:syntastic_loc_list_height=5

  "│-v-2 │ base16                      - chriskempson/base16-vim (base16 color scheme)
  "└─────┴─────────
    " Base16 Themes
    Plug 'chriskempson/base16-vim'
    let base16colorspace=256 " Access colors present in 256 colorspace

  "│-v-2 │ css-color                   - ag/vim-css-color (shows roughly what the color code is)
  "└─────┴─────────
  " Shows a rough representation of color codes
  Plug 'ap/vim-css-color', {'for': ['css', 'scss', 'sass']}
  "│-v-2 │ delimitMate                 - Raimondi/delimitMate (autoclose quotes and groupings)
  "└─────┴─────────
    " Autoclose quotes and groupings ()
    Plug 'Raimondi/delimitMate'

    let delimitMate_expand_cr = 1
    augroup mydelimitMate
        au!
        au FileType markdown let b:delimitMate_nesting_quotes = ["`"]
        au FileType tex let b:delimitMate_quotes = ""
        au FileType tex let b:delimitMate_matchpairs = "(:),[:],{:},`:'"
        au FileType python let b:delimitMate_nesting_quotes = ['"', "'"]
    augroup END

  "│-v-2 │ devicons                    - ryanoasis/vim-devicons (filetype icons for nerdtree)
  "└─────┴─────────
    " Adds filetype glyphs (icons) to NerdTree and other plugins
    " Requires special fonts
    Plug 'ryanoasis/vim-devicons'

  "│-v-2 │ dispatch                    - tpope/vim-dispatch (async command running)
  "└─────┴─────────
    "Asynchronous command running. Useful for builds/tests
    Plug 'tpope/vim-dispatch'

  "│-v-2 │ dracula                     - dracula/vim (dracula color scheme)
  "└─────┴─────────
    " Dracula color scheme
    Plug 'dracula/vim', { 'as': 'dracula' }
    let g:dracula_italic = 0 " Disable italics https://github.com/dracula/vim/issues/65
    augroup dracula_customization
        au!
        autocmd ColorScheme dracula hi DraculaComment ctermfg=63
    augroup END
    "color dracula "Set the color scheme

  "│-v-2 │ fastfold                    - Konfekt/FastFold (faster folding without redraws)
  "└─────┴─────────
    "Allow syntax folding without constant recalculation
    Plug 'Konfekt/FastFold'

  "│-v-2 │ fugitive                    - tpope/fugitive (git in vim)
  "└─────┴─────────
    "Git in vim
    Plug 'tpope/vim-fugitive'

  "│-v-2 │ fzf                         - junegunn/fzf.vim (fuzzy searching)
  "└─────┴─────────
    " Install fzf for fuzzy searching
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'

    " Files command with preview window
     command! -bang -nargs=? -complete=dir Files
       \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

     " mappings
     nnoremap <silent> <leader><space> :Files<CR>
     nnoremap <silent> <leader>c :Commands<CR>

     " use ripgrep if installed
      if executable('rg')
        command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!{.git,node_modules}/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)

        set grepprg=rg\ --vimgrep
      endif

  "│-v-2 │ go                          - fatih/vim-go (golang ide)
  "└─────┴─────────
    "Run :GoInstallBinaries to pull down dependencies.
    "Requires modifying gitconfig https rewrite.
    Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries', 'for': 'go' }

    "let g:go_highlight_functions = 1
    "let g:go_highlight_methods = 1
    "let g:go_highlight_structs = 1
    "let g:go_highlight_interfaces = 1
    "let g:go_highlight_operators = 1
    "let g:go_highlight_build_constraints = 1
    let g:go_fmt_command = "goimports" "Use goimports instead of gofmt to insert imports
    let g:go_list_type = "quickfix"
    "\s to list interfaces implemented by the type
    au FileType go nmap <Leader>s <Plug>(go-implements)
    "\i to show type info
    au FileType go nmap <Leader>i <Plug>(go-info)

  "│-v-2 │ jade                        - digitaltoad/vim-jade (jade syntax highlighting)
  "└─────┴─────────
   " Jade language syntax highlighting
   Plug 'digitaltoad/vim-jade', {'for': 'jade'}

  "│-v-2 │ javascript                  - pangloss/vim-javascript (better javascript syntax)
  "└─────┴─────────
   "Better Javascript syntax highlighting (Required by react)
   Plug 'pangloss/vim-javascript', {'for': ['javascript', 'jsx']}

   let g:javascript_conceal_function       = "ƒ"
   let g:javascript_conceal_null           = "ø"
   let g:javascript_conceal_this           = "@"
   let g:javascript_conceal_return         = "⇚"
   let g:javascript_conceal_undefined      = "¿"
   let g:javascript_conceal_NaN            = "ℕ"
   let g:javascript_conceal_prototype      = "¶"
   let g:javascript_conceal_static         = "•"
   let g:javascript_conceal_super          = "Ω"
   let g:javascript_conceal_arrow_function = "⇒"

  "│-v-2 │ jsx                         - mxw/vim-jsx (jsx support)
  "└─────┴─────────
    "JSX support (React)
    Plug 'mxw/vim-jsx', {'for': 'jsx'}
    let g:jsx_ext_required = 0

  "│-v-2 │ nerdtree                    - scrooloose/nerdtree (file browser)
  "└─────┴─────────
    " File Browser
    Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeTabsToggle' }
    " Open/close NERDTree Tabs (explorer tree) with \e
    nmap <silent> <leader>e :NERDTreeTabsToggle<CR>

    " Open NERDTree at current file
    nmap <silent> <leader>E :NERDTreeFind<CR>

    " To have NERDTree always open on startup. 0 = disabled
    let g:nerdtree_tabs_open_on_console_startup = 0

    " Disable cursor line highlight in order to speed up
    " nerdtree-syntax-highlight
    let g:NERDTreeHighlightCursorline = 0

    " Show hidden files and folders
    let NERDTreeShowHidden = 1

  "│-v-2 │ nerdtree-tabs               - justr/vim-nerdtree-tabs (consistent nerdtree)
  "└─────┴─────────
    "Same nerdtree in every file
    Plug 'jistr/vim-nerdtree-tabs', { 'on': 'NERDTreeTabsToggle' }

  "│-v-2 │ nerdtree-syntax-highlight   - tiagofumo/vim-nerdtree-syntax-highlight
  "└─────┴─────────
    "Highlight devicons in nerdtree
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight', { 'on': 'NERDTreeTabsToggle' }

    " Disable all extensions to prevent lag
    let g:NERDTreeSyntaxDisableDefaultExtensions = 1
    let g:NERDTreeDisableExactMatchHighlight = 1
    let g:NERDTreeDisablePatternMatchHighlight = 1

    " Only change the color for extensions I commonly use
    let g:NERDTreeSyntaxEnabledExtensions = ['css', 'go', 'html', 'js', 'json', 'jsx', 'markdown', 'md', 'sh', 'vim', 'zsh']

  "│-v-2 │ repeat                      - tpope/vim-repeat (enable plugin bindings to repeat)
  "└─────┴─────────
    "Enable plugin bindings (such as vim-surround) to be repeated with `.`
    Plug 'tpope/vim-repeat'

  "│-v-2 │ signify                     - mhinz/signify (gutter git status)
  "└─────┴─────────
    "Display which lines have changed for git
    Plug 'mhinz/vim-signify'
    let g:signify_vcs_list = ['git'] " Limit support to git for speed. Why would I use anything else?
    let g:signify_mapping_next_hunk = '<leader>gj' " Go to next hunk
    let g:signify_mapping_prev_hunk = '<leader>gk' " Go to previous hunk

  "│-v-2 │ sleuth                      - tpope/vim-sleuth (match indentation style)
  "└─────┴─────────
    "Match indentation style
    Plug 'tpope/vim-sleuth'

  "│-v-2 │ startify                    - mhinz/vim-startify (start page)
  "└─────┴─────────
    "Disaply fancy start screen on start
    Plug 'mhinz/vim-startify'
    function! s:list_commits() abort
      let git = 'git'
      let commits = systemlist(git .' log --oneline | head -n5')
      let git = 'G'. git[1:]
      return map(commits, '{"line": matchstr(v:val, "\\s\\zs.*"), "cmd": "'. git .' show ". matchstr(v:val, "^\\x\\+") }')
    endfunction

    " Let us assume you have vim-devicons installed. That plugin has a function
    " `WebDevIconsGetFileTypeSymbol()` which returns an icon depending on the given
    " file. Prepend the logo to each Startify entry by putting this in your vimrc:
    function! StartifyEntryFormat() abort
      return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
    endfunction

    " Define what get's shown on open
    let g:startify_lists = [
      \ { 'type': 'files',     'header': [   'Most Recently Used']            },
      \ { 'type': 'dir',       'header': [   'Most Recently Used - '. getcwd()] },
      \ { 'type': 'sessions',  'header': [   'Sessions']       },
      \ { 'type': 'bookmarks', 'header': [   'Bookmarks']      },
      \ { 'type': 'commands',  'header': [   'Commands']       },
      \ { 'type': function('s:list_commits'), 'header': [ 'Commits in '. getcwd()] },
      \ ]
    " When opening a file or bookmark, seek and change to the root directory
    " of the VCS (if there is one).
    let g:startify_change_to_vcs_root = 1

  "│-v-2 │ surround                    - tpope/vim-surround (keybindings for surrounding things)
  "└─────┴─────────
    "Easy keybindings for surrounding things in pairs
    Plug 'tpope/vim-surround'

  "│-v-2 │ tagbar                      - majutsushi/tagbar (tagbar)
  "└─────┴─────────
    "Display ctags in a tagbar
    Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
    " Open tagbar with F8
    nmap <F8> :TagbarToggle<CR>
    let g:tagbar_autofocus = 1 "Automatically focus the tagbar when it is opened

  "│-v-2 │ test                        - janko-m/vim-test (test running)
  "└─────┴─────────
    "Execute tests from inside vim
    Plug 'janko-m/vim-test'
    nmap <silent> <leader>t :TestNearest<CR>
    nmap <silent> <leader>T :TestFile<CR>
    nmap <silent> <leader>a :TestSuite<CR>
    nmap <silent> <leader>l :TestLast<CR>
    nmap <silent> <leader>g :TestVisit<CR>
    " make test commands execute using dispatch.vim
    let test#strategy = "dispatch"

    " Set the NODE_ENV correctly for tests
    "let test#javascript#mocha#executable = 'NODE_ENV=test ' . test#javascript#mocha#executable()

  "│-v-2 │ tmux-navigator              - christoomey/vim-tmux-navigator (vim/tmux navigation)
  "└─────┴─────────
    " Seamless vim/tmux navigation by using C+J/K/H/L
    Plug 'christoomey/vim-tmux-navigator'

  "│-v-2 │ tmux-focus-events           - tmux-plugins/vim-tmux-focus-events (tmux focus fix)
  "└─────┴─────────
    "makes tmux + vim work with focus events
    Plug 'tmux-plugins/vim-tmux-focus-events'

  "│-v-2 │ unimpaired                  - tpope/vim-unimpaird (bracket maps)
  "└─────┴─────────
    "provides several pairs of bracket maps.
    Plug 'tpope/vim-unimpaired'

  "│-v-2 │ wakatime                    - wakatime/vim-wakatime (productivity stats)
  "└─────┴─────────
    "Collects stats on programming
    Plug 'wakatime/vim-wakatime'
  "│-v-2 │ xterm-color-table           - guns/xterm-color-table.vim
  "└─────┴─────────
    " display a 256 color table
    Plug 'guns/xterm-color-table.vim'

  "│-v-2 │ youcompleteme               - Valloric/YouCompleteMe (autocomplete)
  "└─────┴─────────
    Plug 'Valloric/YouCompleteMe', { 'do': './install.py  --go-completer --js-completer' }

  "│-v-2 │ vim-plug                    - junegunn/vim-plug (load plugins)
  "└─────┴─────────
    call plug#end()



"│-v-1 │ functions
"└─────┴─────────
  " Useful for setting the upperchase char to the same as the  lowercase char
  function! SetupCommandAlias(from, to) abort
    exec 'cnoreabbrev <expr> '.a:from
    \ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")'
    \ .'? ("'.a:to.'") : ("'.a:from.'"))'
  endfunction

"│-v-1 │ settings
"└─┬───┴─┬────────────────
  "│-v-2 │ appearance
  "└─┬───┴─┬────────────────
    "│-v-3 │ syntax
    "└─────┴─────────
      " enable syntax highlighting
      syntax on
    "│-v-3 │ display
    "└─────┴─────────
      " Display characters to symbolize whitespace
      "set list
      set listchars=tab:▸\ ,eol:¬
      set number " Line numbering on
      set ruler " Display location in file
      set showmatch " Show matching brackets/paranthesis
      set showcmd "Show command in the last line of the screen

      " ----- background highlight the character if line length goes over 120 -----
      highlight OverLengthIndiator ctermbg=darkyellow
      call matchadd('OverLengthIndiator', '\%121v', 100)

      " redraw only when we need to."
      set lazyredraw

    "│-v-3 │ color scheme
    "└─────┴─────────
      set background=dark " Dark background friendly

      " vim-shell automatically write the color theme to ~/.vimrc_background
      " this allows the terminal and vim to change themes together
      if filereadable(expand("~/.vimrc_background"))
          source ~/.vimrc_background
      endif

  "│-v-2 │ commands
  "└─┬───┴─┬────────────────
    "│-v-3 │ wildmenu
    "└─────┴─────────
      set wildmenu
      set wildmode=longest:list,full

  "│-v-2 │ editor
  "└─────┴─────────
    set tabstop=4 "Tabs take up 4 spaces
    "set shiftwidth=2
    "set softtabstop=2

    " Open new splits on the right, or bottom
    set splitbelow
    set splitright

  "│-v-2 │ spelling
  "└─────┴─────────
    set spelllang=en_us
  "│-v-2 │ search
  "└─────┴─────────
    set incsearch "Search as you type. Return to original location if canceled.
    set ignorecase "case insensitive searching
    set smartcase "if search isn't all lowercase, casesensitive search

  "│-v-2 │ mouse
  "└─────┴─────────
    "set mouse=a "Enable the mouse use in all modes
    set mouse-=a "Disable the mouse use in all modes

  "│-v-2 │ files
  "└─────┴─────────
    " Triger `autoread` when files changes on disk
    " https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
    " https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
    autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
    " Notification after file change
    " https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
    autocmd FileChangedShellPost *
      \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

"│-v-1 │ mappings
"└─┬───┴─┬────────────────
  "│-v-2 │ keys
  "└─────┴─────────
    set backspace=indent,eol,start "make backspace behave like normal
    call SetupCommandAlias("Q", "q")
    call SetupCommandAlias("W", "w")

  "│-v-2 │ layout
  "└─────┴─────────
    nnoremap <silent> <leader>> :vertical resize 123<CR> "Automatically resize split to fit 120 chars

    command! BufOnly silent! execute "%bd|e#" "Delete all buffers except the current

  "│-v-2 │ file shortcuts
  "└─────┴─────────
    " Quick settings access
    nnoremap <silent> <F2> :tabedit $MYVIMRC<cr>
    augroup myvimrc
      au!
      au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
    augroup END

"│-v-1 │ filetype
"└─┬───┴─┬────────────────
  "│-v-2 │ .md - markdown
  "└─────┴─────────
    autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown " .md == markdown. .md != modula-2

  "│-v-2 │ .ejs - embeddedjs)
  "└─────┴─────────
    autocmd BufNewFile,BufRead *.ejs set filetype=html
"│-v-1 │ footer
"└─────┴─────────
" vim: set fmr=-v-,-^- fdm=marker cms="%s et ts=2 sw=0 sts=0 :
