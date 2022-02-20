(local f vim.fn)
(local api vim.api)

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

(lambda run []
  (if (or (= vim.g.runnerbufnr nil) (= (f.bufexists vim.g.runnerbufnr) "0"))
    (do
      (->> (open-split "belowright")
           (set vim.g.runnerbufnr))
      (-?> (let [filetype (vim.api.nvim_buf_get_option 0 "filetype")
                 filename (vim.fn.expand "%")
                 filename-no-ext (vim.fn.expand "%<")] ; TODO: fix this in future when option works
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
           (f.termopen))
      (api.nvim_command "startinsert"))
    (restore-split "belowright" vim.g.runnerbufnr)))

(lambda interactive []
  (if (or (= vim.g.runnerbufnr nil) (= (f.bufexists vim.g.runnerbufnr) "0"))
    (do
      (->> (open-split "belowright")
           (set vim.g.runnerbufnr))
      (-?> (let [filetype (vim.api.nvim_buf_get_option 0 "filetype")
                 filename (vim.fn.expand "%")
                 filename-no-ext (vim.fn.expand "%<")] ; TODO: fix this in future when option works
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
           (f.termopen))
      (api.nvim_command "startinsert"))
    (restore-split "belowright" vim.g.runnerbufnr)))

{:run run
 :interactive interactive}
