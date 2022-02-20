local f = vim.fn
local api = vim.api
local function open_split(direction)
  _G.assert((nil ~= direction), "Missing argument direction on fnl/runner.fnl:4")
  local bufheight = f.floor((f.winheight(0) / 5))
  vim.cmd((direction .. " " .. bufheight .. "split"))
  local bufnr = api.nvim_create_buf(false, false)
  api.nvim_set_current_buf(bufnr)
  return bufnr
end
local function run()
  open_split("belowright")
  do
    local _1_
    do
      local filetype = vim.api.nvim_buf_get_option(0, "filetype")
      local filename = vim.fn.expand("%")
      local filename_no_ext = vim.fn.expand("%<")
      if (filetype == "c") then
        _1_ = ("gcc -o " .. filename_no_ext .. " " .. filename .. " && ./" .. filename_no_ext)
      elseif (filetype == "perl") then
        _1_ = ("python3 " .. filename)
      elseif (filetype == "java") then
        _1_ = ("java " .. filename_no_ext)
      elseif (filetype == "sh") then
        _1_ = ("./ " .. filename)
      elseif (filetype == "python") then
        _1_ = ("python3 " .. filename)
      elseif (filetype == "html") then
        _1_ = ("!google-chrome-beta " .. filename .. " &")
      elseif (filetype == "go") then
        _1_ = ":GoRun"
      elseif (filetype == "haskell") then
        _1_ = ("runhaskell " .. filename)
      elseif (filetype == "tex") then
        _1_ = ("zathura " .. filename_no_ext .. ".pdf")
      elseif (filetype == "elixir") then
        _1_ = ("elixir " .. filename)
      elseif (filetype == "r") then
        _1_ = ("Rscript " .. filename)
      elseif (filetype == "lua") then
        _1_ = ("lua " .. filename)
      elseif (filetype == "julia") then
        _1_ = ("julia " .. filename)
      else
        _1_ = "zsh"
      end
    end
    if (nil ~= _1_) then
      f.termopen(_1_)
    else
    end
  end
  return api.nvim_command("startinsert")
end
local function interactive()
  open_split("belowright")
  do
    local _4_
    do
      local filetype = vim.api.nvim_buf_get_option(0, "filetype")
      local filename = vim.fn.expand("%")
      local filename_no_ext = vim.fn.expand("%<")
      if (filetype == "python") then
        _4_ = ("python3 -i " .. filename)
      elseif (filetype == "elixir") then
        _4_ = "iex"
      elseif (filetype == "r") then
        _4_ = "R --no-save"
      elseif (filetype == "scheme") then
        _4_ = ("python3 scheme -i " .. filename)
      elseif (filetype == "lua") then
        _4_ = ("lua -i " .. filename)
      elseif (filetype == "julia") then
        _4_ = ("julia -i " .. filename)
      else
        _4_ = "zsh"
      end
    end
    if (nil ~= _4_) then
      f.termopen(_4_)
    else
    end
  end
  return api.nvim_command("startinsert")
end
return {interactive = interactive, test = test}
