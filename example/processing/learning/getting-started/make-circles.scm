(use gl.processing)

(define draw (draw$ (^ ()
                       (fill (if *mouse-pressed?* 0 255))
                       (ellipse *mouse-x* *mouse-y* 80 80))
                    :clean #f))

(define main (setup$ (^ ()
                        (window 480 120 "make circles" 100 100)
;                        (frame-rate! 100))
                        )
                     :draw draw))
