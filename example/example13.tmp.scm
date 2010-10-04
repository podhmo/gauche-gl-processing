;;; Drawing \ Processing.org http://processing.org/learning/drawing/
;;; http://processing.org/learning/drawing/imgs/1.11.jpg

(use gl.processing)

(define draw
  (draw$ (^ ()
            (rect 100 100 20 100)
            (ellipse 100 70 60 60)
            (ellipse 81 70 16 32)
            (ellipse 119 70 16 32)
            (line 90 150 80 160)
            (line 110 150 120 160))))

(define main
  (setup$ (^ ()
             (window 200 200 "coordinate" 100 100)
             (no-fill!)
             (rect-mode! 'center)
             (ellipse-mode! 'center))
          :draw draw))

