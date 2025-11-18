(defpackage :lem-notcurses/view
  (:use :cl
        :lem)
  (:export :make-view
           :delete-view
           :view-height
           :view-plane
           :view-update
           :view-width))
(in-package :lem-notcurses/view)

(defclass view ()
  ((plane :initarg :plane
          :type notcurses:plane
          :reader view-plane)))

(defun make-view (window x y width height use-modeline) ; TODO: Modeline
  (declare (ignore window use-modeline))
  (let ((v (make-instance 'view :plane (notcurses:make-plane :y y :x x :rows height :cols width))))
    (log:info "created ~Ax~A view ~A at ~A,~A" width height v x y)
    v))

(defun delete-view (view)
  (log:info "requesting destruction of view ~A" view)
  (notcurses:destroy-plane (view-plane view)))

(defun view-update (view)
  (notcurses:pile-render (view-plane view))
  (notcurses:pile-rasterize (view-plane view)))

(defun view-height (view)
  (nth-value 0 (notcurses:plane-dimensions (view-plane view))))

(defun view-width (view)
  (nth-value 1 (notcurses:plane-dimensions (view-plane view))))
