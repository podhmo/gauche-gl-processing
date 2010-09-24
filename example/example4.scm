;;transform
(use srfi-27)
(use math.const)
(add-load-path "..")
(use gl.processing)

(define draw
  (draw-once$
   (lambda ()
     (dotimes (i 300)
       (fill (random-real) (random-real) (random-real))
       (rect (random-integer 300) (random-integer 300)
             10 10))
     (print "[ESC]:TO EXIT"))))

(define main 
  (setup$ (lambda ()
             (window 300 300 "Gauche-GL" 100 100))
;             (rect-mode! 'center))
          :draw draw))

(main '())