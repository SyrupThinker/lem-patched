(defsystem "lem-typst-mode"
  :depends-on ("lem/core")
  :serial t
  :components ((:file "typst-mode")
               (:file "lsp-config")))