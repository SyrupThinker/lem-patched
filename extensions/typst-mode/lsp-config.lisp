(defpackage :lem-typst-mode/lsp-config
  (:use :cl))
(in-package :lem-typst-mode/lsp-config)

(lem-lsp-mode:define-language-spec (typst-spec lem-typst-mode:typst-mode)
  :language-id "typst"
  :command '("tinymist")
  :install-command "cargo install tinymist --locked"
  :readme-url "https://github.com/Myriad-Dreamin/tinymist"
  :connection-mode :stdio)