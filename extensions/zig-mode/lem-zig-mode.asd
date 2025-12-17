(defsystem "lem-zig-mode"
  :depends-on ("lem/core" "lem-lisp-mode")
  :serial t
  :components ((:file "zig-mode")
               (:file "lsp-config")))
