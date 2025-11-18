(defpackage :lem-notcurses/mainloop
  (:use :cl
        :lem
        :trivial-signal)
  (:export :invoke))
(in-package :lem-notcurses/mainloop)

(defun ignore-signal (signo)
  (declare (ignore signo)))

(define-condition exit (editor-condition)
  ((value
    :initarg :value
    :reader exit-editor-value
    :initform nil)))

(defun input-loop (editor-thread)
  (handler-case
      (loop
        (unless (bt2:thread-alive-p editor-thread) (return))
        (let ((event (lem-notcurses/input:get-event)))
          (case event
            (:abort (send-abort-event editor-thread nil))
            ((nil) nil)
            (t (send-event event)))))
    (exit (c) (return-from input-loop c))))

(defun invoke (function)
  (let ((result nil)
        (input-thread (bt2:current-thread)))
    (log:info "starting notcurses")
    (unwind-protect
         (signal-handler-bind ((:sigint #'ignore-signal)
                               (:sigtstp #'ignore-signal)
                               (:sigwinch (lambda (c)
                                            (declare (ignore c))
                                            (log:info "sigwinch")
                                            (notcurses:refresh))))
                              (when (lem-notcurses/term:term-init)
                                (let ((*standard-output* (make-broadcast-stream))
                                      (*error-output* (make-broadcast-stream))
                                      (*terminal-io* (make-broadcast-stream)))
                                  (let ((editor-thread
                                          (funcall function
                                                   nil
                                                   (lambda (report)
                                                     (bt2:interrupt-thread
                                                      input-thread
                                                      (lambda () (error 'exit :value report)))))))
                                    (setf result (input-loop editor-thread))))))
      (log:info "stopping notcurses")
      (lem-notcurses/term:term-finalize))
    (when (and (typep result 'exit)
               (exit-editor-value result))
      (format t "~&~A~%" (exit-editor-value result)))))
