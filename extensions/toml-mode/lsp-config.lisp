(uiop:define-package #:lem-toml-mode/lsp-config
  (:use #:cl)
  (:export))
(in-package :lem-js-mode/lsp-config)

(lem-lsp-mode:define-language-spec (toml-spec lem-toml-mode:toml-mode)
  :language-id "toml"
  :command '("taplo" "lsp" "stdio")
  :install-command "cargo install taplo-cli --locked"
  :readme-url "https://github.com/tamasfe/taplo"
  :connection-mode :stdio)
