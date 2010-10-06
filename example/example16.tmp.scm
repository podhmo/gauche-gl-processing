(use gl.processing)

(define draw
  (draw-once$ (lambda ()
                (text "word" 15 30)
                (fill 0 102 153)
                (text "word" 15 60)
                (fill 0 102 153 51)
                (text "word" 15 90))))

(define main
  (setup$ (lambda ()
            (window 100 100 "glc Tutorial" 0 0)
            (font-scale! 30)
            (text-font! (load-font "Utopia")))
          :draw draw))

(main '())
