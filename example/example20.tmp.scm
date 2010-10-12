(use gauche.uvector)
(use gauche.experimental.lamb)
(use srfi-42)
(use srfi-1)
(extend gl.processing)
(use ext.perlinnoise)

(define draw (draw$ (^ ()
                       (with-texture
                        (draw-shape t 200 200)))
                       ))
(define t #f)
(define main (setup$ (^ ()
                        (window 200 200 "f00" 100 100)
                        (set! t (image->texture pixels 200 200)))
                     :draw draw
                     :reshape (2d-elastic-reshape$ 200 200)))

(define pixels
  (list->u8vector
   (fold-ec '() (: i 200) (: j 200)
            i (^ (i acc)
                 (let* ((n (* 255 (perlinnoise-2d i j 0.5 8.0)))
                        (x (logand (floor->exact n) #xff)))
                   (cons* x x x acc))))))
(main '())