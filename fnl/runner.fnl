(local f vim.fn)
(local api vim.api)

(var runnerbufnr nil)
(var termjobnr nil)

(lambda restore-split [direction bufnr]
  "Opens bottom split terminal at 20% height."
  (print "Restored existing split.")
  (let [bufheight (f.floor (/ (f.winheight 0) 5))]
    (vim.cmd (.. direction " " bufheight "split"))
    (api.nvim_set_current_buf bufnr)))

(lambda open-split [direction]
  "Opens bottom split terminal at 20% height."
  (let [bufheight (f.floor (/ (f.winheight 0) 5))]
    (vim.cmd (.. direction " " bufheight "split"))
    (local bufnr (api.nvim_create_buf true false))
    (api.nvim_set_current_buf bufnr)
    bufnr))

; Reference: :help g@
(fn send-text [selection-type]
  (if (= selection-type nil)
    (do
      (set vim.o.opfunc "v:lua.require'runner'.send_text")
      "g@")
    (let [sel-save vim.o.selection
          reg-save (f.getreginfo "\"")
          cb-save vim.o.clipboard
          visual-marks-save [(f.getpos "'<") (f.getpos "'>")]
          commands {"line" "'[V']y"
                    "char" "`[v`]y"
                    "block" (api.nvim_replace_termcodes "`[<c-v>`]y" true true true)}]
      (set vim.o.clipboard "")
      (set vim.o.selection "inclusive")
      (vim.cmd (.. "noautocmd keepjumps normal! " (. commands selection-type)))
      (-> (f.getreg "\"" " " true)
          (vim.list_extend [""])
          (#(f.chansend termjobnr $1)))

      ; Restore original variables
      (f.setreg "\"" reg-save)
      (f.setpos "'<" (. visual-marks-save 1))
      (f.setpos "'>" (. visual-marks-save 2))
      (set vim.o.clipboard cb-save)
      (set vim.o.selection sel-save))))

(lambda run []
  (if (or (= runnerbufnr nil) (= (f.bufexists runnerbufnr) 0))
    (do
      (-?> (let [filetype (vim.api.nvim_buf_get_option 0 "filetype")
                 filename (vim.fn.expand "%")
                 filename-no-ext (vim.fn.expand "%<")] ; TODO: fix this in future when option works
             (->> (open-split "belowright")
                  (set runnerbufnr))
             (if
               (= filetype "c")
               (.. "gcc -o " filename-no-ext " " filename " && ./" filename-no-ext)
               (= filetype "perl")
               (.. "python3 " filename)
               (= filetype "java")
               (.. "java " filename-no-ext)
               (= filetype "sh")
               (.. "./ " filename)
               (= filetype "python")
               (.. "python3 " filename)
               (= filetype "html")
               (.. "!google-chrome-beta " filename " &")
               (= filetype "go")
               ":GoRun" ; TODO: Does this still work?
               (= filetype "haskell")
               (.. "runhaskell " filename)
               (= filetype "tex")
               (.. "zathura " filename-no-ext ".pdf")
               (= filetype "elixir")
               (.. "elixir " filename)
               (= filetype "r")
               (.. "Rscript " filename)
               (= filetype "lua")
               (.. "lua " filename)
               (= filetype "julia")
               (.. "julia " filename)
               "zsh")) ; Defaults to opening a terminal
           (f.termopen)
           (#(set termjobnr $1)))
      (api.nvim_command "startinsert"))
    (restore-split "belowright" runnerbufnr)))

(lambda interactive []
  (if (or (= runnerbufnr nil) (= (f.bufexists runnerbufnr) 0))
    (do
      (-?> (let [filetype (vim.api.nvim_buf_get_option 0 "filetype")
                 filename (vim.fn.expand "%")
                 filename-no-ext (vim.fn.expand "%<")] ; TODO: fix this in future when option works
             (->> (open-split "belowright")
                  (set runnerbufnr))
             (if (= filetype "python")
               (.. "python3 -i " filename)
               (= filetype "elixir")
               "iex"
               (= filetype "r")
               (.. "R --no-save")
               (= filetype "scheme")
               (.. "python3 scheme -i " filename)
               (= filetype "lua")
               (.. "lua -i " filename)
               (= filetype "julia")
               (.. "julia -i " filename)
               "zsh")) ; Defaults to opening a terminal
           (f.termopen)
           (#(set termjobnr $1)))
      (api.nvim_command "startinsert"))
    (restore-split "belowright" runnerbufnr)))

{:run run
 :interactive interactive
 :send_text send-text}
