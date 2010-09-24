(add-load-path ".")
(use gl.processing)

                         
(define draw
  (draw-once$
   (lambda ()
     (print-matrix)
     (fill 0 0 0)
     (rect 250 250 30 30)
     (fill 1 1 1)
     (ellipse 250 250 30 60)
     (line 10 10 100 10)
     (stroke-weight 3.0)
     (line 10 30 100 30) 
     (stroke-weight 1.0)
     (print "[ESC]:TO EXIT"))))

(define main 
  (setup$ (lambda ()
             (window 500 500 "Gauche-GL" 100 100)
             (rect-mode! 'center))
          :reshape (2d-elastic-reshape$ 500 500)
          :draw draw))

(main '())