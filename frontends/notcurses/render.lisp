(defpackage :lem-notcurses/render
  (:use :cl
        :lem-core/display)
  (:export :clear-to-end-of-window
           :render-line))
(in-package :lem-notcurses/render)

(defgeneric draw-object (object x y view plane))

(defmethod draw-object ((object void-object) x y view plane)
  0)

(defun attribute-to-style-list (attribute)
  (let ((styles '()))
    (when (lem:attribute-bold attribute)
      (push :bold styles))
    (when (lem:attribute-underline attribute)
      (push :underline styles))
    styles))

(defun get-color-rgb (color)
  (let ((c (if (stringp color)
               (lem:parse-color color)
               color)))
    (when c
      (logior (ash (lem:color-red c) 16)
              (ash (lem:color-green c) 8)
              (lem:color-blue c)))))

(defun set-attribute (plane attribute)
  (when attribute
    (let ((fg (lem:attribute-foreground attribute))
          (bg (lem:attribute-background attribute)))
      (when fg
        (let ((rgb (get-color-rgb fg)))
          (when rgb
            (notcurses:plane-set-channels plane
                                          (notcurses:channels-set-fg-rgb (notcurses:plane-channels plane) rgb)))))
      (when bg
        (let ((rgb (get-color-rgb bg)))
          (when rgb
            (notcurses:plane-set-channels plane
                                          (notcurses:channels-set-bg-rgb (notcurses:plane-channels plane) rgb)))))
      (notcurses:plane-set-style plane (attribute-to-style-list attribute)))))

(defmethod draw-object ((object text-object) x y view plane)
  (let ((string (text-object-string object))
        (attribute (text-object-attribute object)))
    (set-attribute plane attribute)
    (let ((cols (notcurses:putstr string :plane plane :x x :y y)))
      (notcurses:plane-set-style plane '())
      cols)))

(defmethod draw-object ((object eol-cursor-object) x y view plane)
  0)

(defmethod draw-object ((object extend-to-eol-object) x y view plane)
  0)

(defmethod draw-object ((object line-end-object) x y view plane)
  0)

(defmethod draw-object ((object image-object) x y view plane)
  0)

(defun clear-to-end-of-window (view y)
  (notcurses:plane-erase-region (lem-notcurses/view:view-plane view)
                                :start-y y :start-x 0
                                :length-y 999999 :length-x 0))

(defun %render-line (view x y objects plane)
  (loop :for object :in objects
        :do (incf x (draw-object object x y view plane))))

(defun render-line (view x y objects)
  (notcurses:plane-erase-region (lem-notcurses/view:view-plane view)
                                :start-y y :start-x x
                                :length-y 1 :length-x 999999)
  (%render-line view x y objects (lem-notcurses/view:view-plane view)))
