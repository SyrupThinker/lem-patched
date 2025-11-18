(defpackage :lem-notcurses/input
  (:use :cl
        :lem)
  (:export :get-event))
(in-package :lem-notcurses/input)

(defparameter *character-name-table*
  '((#x09 . "Tab")
    (#x1b . "Escape")))

(defparameter *special-name-table*
  '((:backspace . "Backspace")
    (:enter . "Return")
    (:del . "Delete")
    (:left . "Left")
    (:right . "Right")
    (:up . "Up")
    (:down . "Down")))

(defun make-character-key (event)
  (log:info "input: cp:~A mods:~A"
            (notcurses:character-input-codepoint event)
            (notcurses:input-modifiers event))
  (let* ((codepoint (notcurses:character-input-codepoint event))
         (named (assoc codepoint *character-name-table*))
         (is-shifted (notcurses:input-shift-p event))
         (char (if is-shifted
                   (char-upcase (code-char codepoint))
                   (char-downcase (code-char codepoint)))))
    (lem:make-key :sym (or (cdr named) (string char))
                  :ctrl (notcurses:input-ctrl-p event)
                  :meta (or (notcurses:input-alt-p event) (notcurses:input-meta-p event))
                  :hyper (notcurses:input-hyper-p event)
                  :shift (and named is-shifted)
                  :super (notcurses:input-super-p event))))

(defun make-special-key (event)
  (log:info "special: value:~A mods:~A"
            (notcurses:special-input-value event)
            (notcurses:input-modifiers event))
  (let ((sym (assoc (notcurses:special-input-value event) *special-name-table*)))
    (when sym
      (lem:make-key :sym (cdr sym)
                    :ctrl (notcurses:input-ctrl-p event)
                    :meta (or (notcurses:input-alt-p event) (notcurses:input-meta-p event))
                    :hyper (notcurses:input-hyper-p event)
                    :shift (notcurses:input-shift-p event)
                    :super (notcurses:input-super-p event)))))

(defun make-mouse-event (event))

(defun get-event ()
  (tagbody :start
    (return-from get-event
      (let ((event (notcurses:input-get)))
        (typecase event
          (notcurses:character-input (if (eq (notcurses:input-type event) :press)
                                         (make-character-key event)
                                         (go :start)))
          (notcurses:special-input (if (eq (notcurses:input-type event) :press)
                                       (make-special-key event)
                                       (go :start)))
          (t (go :start)))))))
