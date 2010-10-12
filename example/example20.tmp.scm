(extend gl.processing)
(use ext.perlinnoise)
(define t #f)
(define draw (draw$ (^ ()
                       (with-texture
                        (draw-shape t 200 200)))
                       ))

(define main (setup$ (^ ()
                        (window 200 200 "f00" 100 100)
                        (set! t (image->texture pixels 200 200)))
                     :draw draw
                     :reshape (2d-elastic-reshape$ 200 200)))

(define pixels
  (pixels-generator 200 200
                    (^ (x y)
                       (let* ((n (* 255 (perlinnoise-2d (quotient  x 8) (quotient y 8) 1 8)))
                              (c (logand (floor->exact n) #xff)))
                         (values c c c)))))
(main '())