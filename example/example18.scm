;; flip texture
(use gl.processing)

(define texture #f)
(define draw (draw-once$ (^ ()
                            (with-texture
                             (draw-shape texture 100 100)))
                         :save "foo3.png"))

(define main (setup$ (^ () (window 150 150 "foo")
                        (flip-texture!)
                        (set! texture (file->texture "lisp-glossy.jpg")))
                     :draw draw
                     :reshape (2d-reshape$ :style :gl)))
(main '())

