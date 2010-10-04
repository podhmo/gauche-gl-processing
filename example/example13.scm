(use gl.processing)

(define draw
  (draw$ (^ ()
            (fill 0 0 0)
            (ellipse 5 5 5 5)
            (line 5 5 *width* 5)
            (line 5 5 5 *width*))
         :save "c3.png"))

(define main
  (setup$ (^ ()
             (window 200 200 "coordinate" 100 100)
             (ellipse-mode! 'center)
             (stroke-weight 3))
          ;; :reshape (2d-reshape$ 100 100 :style :math)
          :draw draw))
