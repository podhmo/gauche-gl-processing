(use gl.processing)

(define myarray '#(#(236 189 189   0)
                   #(236  80 189 189)
                   #(236   0 189  80)
                   #(236 189 189  80)))


(define draw 
  (draw-once$
   (^ () (let* ((margin 50)
                (board (2dvector->board myarray :each-size margin)))
           (board-for-each* (^ (x y color x* y*)
                              (fill color)
                              (rect x* y* margin margin))
                          board)))
                    :save "eg1.png"))

(define main (setup$ (^ () (window 200 200 "eg1" 100 100))
                     :draw draw))

(main '())