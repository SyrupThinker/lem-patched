(defsystem "lem-toml-mode"
  :depends-on ("lem/core")
  :serial t
  :components ((:file "toml-mode")
               (:file "lsp-config")))
