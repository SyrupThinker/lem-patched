(defpackage :lem-notcurses/term
  (:use :cl)
  (:export :term-init
           :term-finalize
           :window-width
           :window-height))
(in-package :lem-notcurses/term)

(defun term-init ()
  (setf notcurses:*context* (notcurses:init))
  t)

(defun term-finalize ()
  (notcurses:stop notcurses:*context*)
  (setf notcurses:*context* nil))

(defun window-width ()
  (nth-value 1 (notcurses:plane-dimensions)))

(defun window-height ()
  (nth-value 0 (notcurses:plane-dimensions)))
