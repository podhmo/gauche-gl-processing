(use gl.processing)
;; animation

(define a 0)
(define draw
  (draw$ (lambda ()
           (translate 150 150)
           (rotate a 0 0 1)
           (rect 0 0 40 40))))

(define (timer _)
  (inc! a)
  (draw)
  (glut-timer-func 1 timer 0))

(define main
  (setup$ (lambda ()
            (window 300 300 "sample" 100 100)
            (rect-mode! 'center)
            (glut-timer-func 1 timer 0))
          :draw draw))

(main '())

