(add-load-path "..")
(use gl.processing)

                         
(define draw
  (draw-once$
   (lambda ()
     (print-matrix)
     (fill 0.5 0.5 0.5)
     (rect 150 150 100 100)
     (fill 1 1 1)
     (ellipse 150 150 30 60)
     (print "[ESC]:TO EXIT"))))

(define main 
  (setup$ (lambda ()
             (window 300 300 "draw rect" 100 100)
             (rect-mode! 'center))
          :reshape (2d-elastic-reshape$ 300 300)
          :draw draw))

(main '())