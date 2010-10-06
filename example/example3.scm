;;transform
(use math.const)
(add-load-path "..")
(use gl.processing)

                         
(define draw
  (draw-once$
   (lambda ()
     (fill 255 255 255)
     (translate 25 25)
     (skew-y (/. pi 4))
     (print-matrix)
     (rect 0 0 30 30)
     (print "[ESC]:TO EXIT"))))

(define main 
  (setup$ (lambda ()
             (window 100 100 "Gauche-GL" 100 100))
          :draw draw))

(main '())