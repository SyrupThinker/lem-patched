(uiop:define-package :lem-notcurses
  (:use :cl))
(in-package :lem-notcurses)

(pushnew :lem-notcurses *features*)

(defclass notcurses (lem:implementation)
  ()
  (:default-initargs
   :name :notcurses))

(defmethod lem-if:invoke ((implementation notcurses) function)
  (lem-notcurses/mainloop:invoke function))

(defmethod lem-if:get-background-color ((implementation notcurses))
  (lem:make-color 0 0 0))

(defmethod lem-if:update-background ((implementation notcurses) color-name))

(defmethod lem-if:update-foreground ((implementation notcurses) color-name))

(defmethod lem-if:update-cursor-shape ((implementation notcurses) cursor-type)
  (if (eq cursor-type :none)
      (notcurses:cursor-set-visibility nil)
      (notcurses:cursor-set-visibility t)))

(defmethod lem-if:update-background ((implementation notcurses) color-name))

(defmethod lem-if:display-width ((implementation notcurses))
  (lem-notcurses/term:window-width))

(defmethod lem-if:display-height ((implementation notcurses))
  (lem-notcurses/term:window-height))

(defmethod lem-if:make-view ((implementation notcurses) window x y width height use-modeline)
  (lem-notcurses/view:make-view window x y width height use-modeline))

(defmethod lem-if:delete-view ((implementation notcurses) view)
  (lem-notcurses/view:delete-view view))

(defmethod lem-if:clear ((implementation notcurses) view)
  (notcurses:plane-erase (lem-notcurses/view:view-plane view)))

(defmethod lem-if:set-view-size ((implementation notcurses) view width height)
  (notcurses:plane-resize (lem-notcurses/view:view-plane view) 0 0 0 0 0 0 height width))

(defmethod lem-if:set-view-pos ((implementation notcurses) view x y)
  (notcurses:plane-move (lem-notcurses/view:view-plane view) y x))

(defmethod lem-if:redraw-view-after ((implementation notcurses) view))

(defmethod lem-if:update-display ((implementation notcurses))
  (lem-notcurses/view:view-update (lem:window-view (lem:current-window))))

(defmethod lem-if:clipboard-paste ((implementation notcurses)))

(defmethod lem-if:clipboard-copy ((implementation notcurses) text))

(defmethod lem-if:view-width ((implementation notcurses) view)
  (lem-notcurses/view:view-width view))

(defmethod lem-if:view-height ((implementation notcurses) view)
  (lem-notcurses/view:view-height view))

(defmethod lem-if:render-line ((implementation notcurses)
                               view x y objects height)
  (lem-notcurses/render:render-line view x y objects))

(defmethod lem-if:render-line-on-modeline ((implementation notcurses)
                                           view
                                           left-objects
                                           right-objects
                                           default-attribute
                                           height))

(defmethod lem-if:object-width ((implementation notcurses) drawing-object)
  1)

(defmethod lem-if:object-height ((implementation notcurses) drawing-object)
  1)

(defmethod lem-if:clear-to-end-of-window ((implementation notcurses) view y)
  (lem-notcurses/render:clear-to-end-of-window view y))

(defmethod lem-if:get-char-width ((implementation notcurses))
  1)
