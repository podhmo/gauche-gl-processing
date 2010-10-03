(use gauche.threads)
(use gl.processing)


(define draw
  (draw$ (lambda ()
           (translate 150 150)
           (rotate a 0 0 1)
           (rect 0 0 40 40))))

(define (timer _)
  (inc! a)
  (draw)
  (glut-timer-func 100 timer 0))

(define main
  (setup$ (lambda ()
            (window 300 300 "sample" 100 100)
            (rect-mode! 'center)
            (glut-timer-func 100 timer 0))
          :draw draw))

(thread-start! (make-thread (cut main '())))

