(add-load-path "..")
(use gl.processing)

                         
(define draw
  (draw-once$
   (lambda ()
     (print-matrix)
     (fill 0 0 1)
     (rect 0 20 20 10)
     (fill 0.5 0.5 0.5)
     (rect 150 150 100 100)
     (fill 1 1 1)
     (ellipse 150 150 30 60)

     (no-fill!)
     (rect 20 280 20 20)
     (fill 1 1 1)
     (rect 50 280 20 20)
     (no-stroke!)
     (rect 80 280 20 20)
     (stroke 0 1 0)
     (rect 110 280 20 20)
     (stroke-weight 3)
     (rect 140 280 20 20)
     (print "[ESC]:TO EXIT"))))

(define main 
  (setup$ (lambda ()
             (window 300 300 "draw rect" 100 100)
             (rect-mode! 'center))
          :reshape (2d-elastic-reshape$ 300 300)
          :draw draw))

(main '())