(defpackage :lem-typst-mode
  (:use :cl
        :lem
        :lem/language-mode
        :lem/language-mode-tools)
  (:import-from :lem/tmlanguage
                :load-tmlanguage)
  (:export :*typst-mode-hook*
           :typst-mode))
(in-package :lem-typst-mode)

(defun make-tmlanguage-typst ()
  (load-tmlanguage
   (merge-pathnames "typst.tmLanguage.json"
                    (asdf:system-source-directory :lem-typst-mode))))

(defvar *syntax-table*
  (let ((table (make-syntax-table
                :space-chars '(#\space #\tab #\newline)
                :paren-pairs '((#\( . #\))
                               (#\{ . #\})
                               (#\[ . #\]))
                :string-quote-chars '(#\" #\')
                :block-string-pairs '()
                :line-comment-string "//"
                :block-comment-pairs '(("/*" . "*/")))))
    ;(set-syntax-parser table (make-tmlanguage-typst)) ;; TODO(st): Too expensive, hangs
    table))

(define-major-mode typst-mode language-mode
    (:name "Typst"
     :keymap *typst-mode-keymap*
     :syntax-table *syntax-table*
     :mode-hook *typst-mode-hook*)
  (setf (variable-value 'enable-syntax-highlight) t
        (variable-value 'line-comment) "//"
        (variable-value 'insertion-line-comment) "// "))

(define-file-type ("typ") typst-mode)
