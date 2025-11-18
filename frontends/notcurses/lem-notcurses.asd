(defsystem "lem-notcurses"
  :depends-on ("cl-notcurses"
               "lem/core"
               "trivial-signal")
  :serial t
  :components ((:file "term")
               (:file "input")
               (:file "view")
               (:file "render")
               (:file "mainloop")
               (:file "notcurses")))