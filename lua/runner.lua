local f = vim.fn
local api = vim.api
local function restore_split(direction, bufnr)
  _G.assert((nil ~= bufnr), "Missing argument bufnr on fnl/runner.fnl:4")
  _G.assert((nil ~= direction), "Missing argument direction on fnl/runner.fnl:4")
  print("Restored existing split.")
  local bufheight = f.floor((f.winheight(0) / 5))
  vim.cmd((direction .. " " .. bufheight .. "split"))
  return api.nvim_set_current_buf(bufnr)
end
local function open_split(direction)
  _G.assert((nil ~= direction), "Missing argument direction on fnl/runner.fnl:11")
  local bufheight = f.floor((f.winheight(0) / 5))
  vim.cmd((direction .. " " .. bufheight .. "split"))
  local bufnr = api.nvim_create_buf(true, false)
  api.nvim_set_current_buf(bufnr)
  return bufnr
end
local function test(selection_type)
  if (selection_type == nil) then
    vim.o.opfunc = "v:lua.require'acmetag'.test"
    return "g@"
  else
    local sel_save = vim.o.selection
    local reg_save = f.getreginfo("\"")
    local cb_save = vim.o.clipboard
    local visual_marks_save = {f.getpos("'<"), f.getpos("'>")}
    local commands = {line = "'[V']y", char = "`[v`]y", block = "`[\\<c-v>`]y"}
    vim.o.clipboard = ""
    vim.o.selection = "inclusive"
    vim.cmd(("noautocmd keepjumps normal! " .. commands[selection_type]))
    print(f.getreg("\"", " "))
    f.setreg("\"", reg_save)
    f.setpos("'<", visual_marks_save[1])
    f.setpos("'>", visual_marks_save[2])
    vim.o.clipboard = cb_save
    vim.o.selection = sel_save
    return nil
  end
end
local function run()
  if ((vim.g.runnerbufnr == nil) or (f.bufexists(vim.g.runnerbufnr) == "0")) then
    vim.g.runnerbufnr = open_split("belowright")
    do
      local _2_
      do
        local filetype = vim.api.nvim_buf_get_option(0, "filetype")
        local filename = vim.fn.expand("%")
        local filename_no_ext = vim.fn.expand("%<")
        if (filetype == "c") then
          _2_ = ("gcc -o " .. filename_no_ext .. " " .. filename .. " && ./" .. filename_no_ext)
        elseif (filetype == "perl") then
          _2_ = ("python3 " .. filename)
        elseif (filetype == "java") then
          _2_ = ("java " .. filename_no_ext)
        elseif (filetype == "sh") then
          _2_ = ("./ " .. filename)
        elseif (filetype == "python") then
          _2_ = ("python3 " .. filename)
        elseif (filetype == "html") then
          _2_ = ("!google-chrome-beta " .. filename .. " &")
        elseif (filetype == "go") then
          _2_ = ":GoRun"
        elseif (filetype == "haskell") then
          _2_ = ("runhaskell " .. filename)
        elseif (filetype == "tex") then
          _2_ = ("zathura " .. filename_no_ext .. ".pdf")
        elseif (filetype == "elixir") then
          _2_ = ("elixir " .. filename)
        elseif (filetype == "r") then
          _2_ = ("Rscript " .. filename)
        elseif (filetype == "lua") then
          _2_ = ("lua " .. filename)
        elseif (filetype == "julia") then
          _2_ = ("julia " .. filename)
        else
          _2_ = "zsh"
        end
      end
      if (nil ~= _2_) then
        f.termopen(_2_)
      else
      end
    end
    return api.nvim_command("startinsert")
  else
    return restore_split("belowright", vim.g.runnerbufnr)
  end
end
local function interactive()
  if ((vim.g.runnerbufnr == nil) or (f.bufexists(vim.g.runnerbufnr) == "0")) then
    vim.g.runnerbufnr = open_split("belowright")
    do
      local _6_
      do
        local filetype = vim.api.nvim_buf_get_option(0, "filetype")
        local filename = vim.fn.expand("%")
        local filename_no_ext = vim.fn.expand("%<")
        if (filetype == "python") then
          _6_ = ("python3 -i " .. filename)
        elseif (filetype == "elixir") then
          _6_ = "iex"
        elseif (filetype == "r") then
          _6_ = "R --no-save"
        elseif (filetype == "scheme") then
          _6_ = ("python3 scheme -i " .. filename)
        elseif (filetype == "lua") then
          _6_ = ("lua -i " .. filename)
        elseif (filetype == "julia") then
          _6_ = ("julia -i " .. filename)
        else
          _6_ = "zsh"
        end
      end
      if (nil ~= _6_) then
        f.termopen(_6_)
      else
      end
    end
    return api.nvim_command("startinsert")
  else
    return restore_split("belowright", vim.g.runnerbufnr)
  end
end
return {run = run, interactive = interactive, test = test}
