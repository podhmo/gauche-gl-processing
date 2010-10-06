(use gl.processing)

(define draw
  (draw-once$ (lambda () 
                (translate 100 100)
                (dotimes (i 5)
                  (fill (* 10 i) (* 10 i) (* 20 i))
                  (rect (* i 20) (* i 20) 50 50)))
              :save "foo.png"))

(define main
  (setup$ (lambda ()
            (window 300 300 "foo" 100 100)
            (rect-mode! 'center))
          :draw draw))


