vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.mouse = "a"
opt.completeopt = "menuone,noinsert,noselect" -- Autocomplete options
opt.laststatus = 3 -- Set global statusline

opt.relativenumber = true
opt.number = true
opt.cursorline = true

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

opt.linebreak = true -- Wrap on word boundary
opt.wrap = false

opt.synmaxcol = 240 -- Max column for syntax highlight
opt.showmatch = true -- Highlight matching parenthesis
opt.foldmethod = "marker" -- Enable folding (default 'foldmarker')

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- turn on termguicolors for tokyonight colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.lazyredraw = true -- Faster scrolling
opt.colorcolumn = "100" -- Line lenght marker at N columns
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.hidden = true -- Enable background buffers
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard = "unnamedplus" -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

-- Disable nvim intro
opt.shortmess:append("sI")
