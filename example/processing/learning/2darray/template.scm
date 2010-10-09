(use gl.processing)

(define draw (draw-once$ (^ ()
                       )
                    :save ".png"))
(define main (setup$ (^ () 
                        )
                     :draw draw))

(main '())