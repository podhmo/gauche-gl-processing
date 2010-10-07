(use gl.processing)

(define draw
  (draw-once$ (^ ()
                 (fill 255 255 255)
                 ;; (let1 s "The quick brown fox jumped over the lazy dog.";
                 (let1 s "foo baaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
                   (text s 15 20 80 70)))
              :save "foo2.png"))

(define main
  (setup$ (lambda ()
            (window 100 100 "glc Tutorial" 0 0)
            (text-font! (load-font "Utopia" 12)))
          :draw draw))

(main '())
