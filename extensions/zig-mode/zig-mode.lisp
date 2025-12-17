(defpackage :lem-zig-mode
  (:use :cl :lem :lem/language-mode)
  (:import-from :lem/tmlanguage
                :load-tmlanguage)
  (:export :*zig-mode-hook*
           :zig-mode
           :zig-format-buffer))
(in-package :lem-zig-mode)

(defvar *zig-format-buffer* "zig")

(defun zig-format-buffer (buffer)
  (declare (ignore buffer))
  (when (zerop (nth-value 2
                          (uiop:run-program (format nil "~A version" *zig-format-buffer*)
                                            :ignore-error-status t)))
    (filter-buffer (format nil "~a fmt --stdin" *zig-format-buffer*))
    (message "Formatted buffer with `zig fmt`.")))

(defvar *zig-syntax-table*
  (let ((table (make-syntax-table
                :space-chars '(#\space #\tab #\newline)
                :paren-pairs '((#\( . #\))
                               (#\{ . #\})
                               (#\[ . #\]))
                :string-quote-chars '(#\" #\')
                :block-string-pairs '()
                :line-comment-string "//")))
    table))

(define-major-mode zig-mode language-mode
    (:name "Zig"
     :keymap *zig-mode-keymap*
     :syntax-table *zig-syntax-table*
     :mode-hook *zig-mode-hook*
     :formatter 'zig-format-buffer)
  (setf (variable-value 'enable-syntax-highlight) t
        (variable-value 'indent-tabs-mode) nil
        (variable-value 'line-comment) "//"
        (variable-value 'insertion-line-comment) "// "
        (variable-value 'tab-width :buffer) 4))

(define-file-type ("zig") zig-mode)
