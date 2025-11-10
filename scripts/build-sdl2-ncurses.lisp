(require 'asdf)
(asdf:load-system :lem-sdl2)
(asdf:load-system :lem-ncurses)

(lem:init-at-build-time)

(sb-ext:save-lisp-and-die "lem"
                          :toplevel #'lem:main
                          :executable t)
