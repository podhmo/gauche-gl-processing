(use gl.processing)

(define draw
  (draw-once$ (^ ()
                 (text "VAV" 100 200)
                 (fill 255 0 0)
                 (rect 100 20 10 10)
                 (text "abc" 100 20))))

(define main 
  (setup$ (lambda ()
            (window 200 200 "foo" 100 100)
            (font-mode! 'texture)
            ;; (font-mode! 'bitmap)
            (load-font "Utopia" 20))
          :draw draw))
(main '())
