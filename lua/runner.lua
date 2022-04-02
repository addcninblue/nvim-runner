local f = vim.fn
local api = vim.api
local runnerbufnr = nil
local termjobnr = nil
local function restore_split(direction, bufnr)
  _G.assert((nil ~= bufnr), "Missing argument bufnr on fnl/runner.fnl:7")
  _G.assert((nil ~= direction), "Missing argument direction on fnl/runner.fnl:7")
  print("Restored existing split.")
  local bufheight = f.floor((f.winheight(0) / 5))
  vim.cmd((direction .. " " .. bufheight .. "split"))
  return api.nvim_set_current_buf(bufnr)
end
local function open_split(direction)
  _G.assert((nil ~= direction), "Missing argument direction on fnl/runner.fnl:14")
  local bufheight = f.floor((f.winheight(0) / 5))
  vim.cmd((direction .. " " .. bufheight .. "split"))
  local bufnr = api.nvim_create_buf(true, false)
  api.nvim_set_current_buf(bufnr)
  return bufnr
end
local function send_text(selection_type)
  if (selection_type == nil) then
    vim.o.opfunc = "v:lua.require'runner'.send_text"
    return "g@"
  else
    local sel_save = vim.o.selection
    local reg_save = f.getreginfo("\"")
    local cb_save = vim.o.clipboard
    local visual_marks_save = {f.getpos("'<"), f.getpos("'>")}
    local commands = {line = "'[V']y", char = "`[v`]y", block = api.nvim_replace_termcodes("`[<c-v>`]y", true, true, true)}
    vim.o.clipboard = ""
    vim.o.selection = "inclusive"
    vim.cmd(("noautocmd keepjumps normal! " .. commands[selection_type]))
    local function _1_(_241)
      return f.chansend(termjobnr, _241)
    end
    _1_(vim.list_extend(f.getreg("\"", " ", true), {""}))
    f.setreg("\"", reg_save)
    f.setpos("'<", visual_marks_save[1])
    f.setpos("'>", visual_marks_save[2])
    vim.o.clipboard = cb_save
    vim.o.selection = sel_save
    return nil
  end
end
local function run()
  if ((runnerbufnr == nil) or (f.bufexists(runnerbufnr) == 0)) then
    do
      local _3_
      do
        local filetype = vim.api.nvim_buf_get_option(0, "filetype")
        local filename = vim.fn.expand("%")
        local filename_no_ext = vim.fn.expand("%<")
        runnerbufnr = open_split("belowright")
        if (filetype == "c") then
          _3_ = ("gcc -o " .. filename_no_ext .. " " .. filename .. " && ./" .. filename_no_ext)
        elseif (filetype == "perl") then
          _3_ = ("python3 " .. filename)
        elseif (filetype == "java") then
          _3_ = ("java " .. filename_no_ext)
        elseif (filetype == "sh") then
          _3_ = ("./ " .. filename)
        elseif (filetype == "python") then
          _3_ = ("python3 " .. filename)
        elseif (filetype == "html") then
          _3_ = ("!google-chrome-beta " .. filename .. " &")
        elseif (filetype == "go") then
          _3_ = ":GoRun"
        elseif (filetype == "haskell") then
          _3_ = ("runhaskell " .. filename)
        elseif (filetype == "tex") then
          _3_ = ("zathura " .. filename_no_ext .. ".pdf")
        elseif (filetype == "elixir") then
          _3_ = ("elixir " .. filename)
        elseif (filetype == "r") then
          _3_ = ("Rscript " .. filename)
        elseif (filetype == "lua") then
          _3_ = ("lua " .. filename)
        elseif (filetype == "julia") then
          _3_ = ("julia " .. filename)
        else
          _3_ = "zsh"
        end
      end
      if (nil ~= _3_) then
        local _5_ = f.termopen(_3_)
        if (nil ~= _5_) then
          local function _6_(_241)
            termjobnr = _241
            return nil
          end
          _6_(_5_)
        else
        end
      else
      end
    end
    return api.nvim_command("startinsert")
  else
    return restore_split("belowright", runnerbufnr)
  end
end
local function interactive()
  if ((runnerbufnr == nil) or (f.bufexists(runnerbufnr) == 0)) then
    do
      local _10_
      do
        local filetype = vim.api.nvim_buf_get_option(0, "filetype")
        local filename = vim.fn.expand("%")
        local filename_no_ext = vim.fn.expand("%<")
        runnerbufnr = open_split("belowright")
        if (filetype == "python") then
          _10_ = ("python3 -i " .. filename)
        elseif (filetype == "elixir") then
          _10_ = "iex"
        elseif (filetype == "r") then
          _10_ = "R --no-save"
        elseif (filetype == "scheme") then
          _10_ = ("scheme -i " .. filename)
        elseif (filetype == "lua") then
          _10_ = ("lua -i " .. filename)
        elseif (filetype == "julia") then
          _10_ = ("julia -i " .. filename)
        else
          _10_ = "zsh"
        end
      end
      if (nil ~= _10_) then
        local _12_ = f.termopen(_10_)
        if (nil ~= _12_) then
          local function _13_(_241)
            termjobnr = _241
            return nil
          end
          _13_(_12_)
        else
        end
      else
      end
    end
    return api.nvim_command("startinsert")
  else
    return restore_split("belowright", runnerbufnr)
  end
end
return {run = run, interactive = interactive, send_text = send_text}
