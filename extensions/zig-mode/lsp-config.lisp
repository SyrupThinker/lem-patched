(uiop:define-package #:lem-zig-mode/lsp-config
  (:use #:cl)
  (:export))
(in-package :lem-js-mode/lsp-config)

(lem-lsp-mode:define-language-spec (zig-spec lem-zig-mode:zig-mode)
  :language-id "zig"
  :command '("zls")
  :readme-url "https://github.com/zigtools/zls"
  :connection-mode :stdio)
