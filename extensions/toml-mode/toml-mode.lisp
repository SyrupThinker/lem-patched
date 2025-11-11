(defpackage :lem-toml-mode
  (:use :cl :lem :lem/language-mode :lem/language-mode-tools)
  (:export :*toml-mode-hook*
           :toml-mode))
(in-package :lem-toml-mode)

(defun make-tm-patterns-toml ()
  (make-tm-patterns
   (make-tm-line-comment-region "#")
   (make-tm-string-region "\"")
   (make-tm-string-region "'")))

(defun make-tmlanguage-toml ()
  (make-tmlanguage :patterns (make-tm-patterns-toml)))

(defun make-syntax-table-toml ()
  (let ((table (make-syntax-table
                :space-chars '(#\space #\tab #\newline)
                :paren-pairs '((#\[ . #\]) (#\{ . #\}))
                :string-quote-chars '(#\" #\')
                :line-comment-string "#"))
        (tmlanguage (make-tmlanguage-toml)))
    (set-syntax-parser table tmlanguage)
    table))

(defvar *toml-syntax-table* (make-syntax-table-toml))

(define-major-mode toml-mode language-mode
    (:name "TOML"
     :keymap *toml-mode-keymap*
     :syntax-table *toml-syntax-table*
     :mode-hook *toml-mode-hook*)
  (setf (variable-value 'enable-syntax-highlight) t))

(define-file-type ("toml") toml-mode)