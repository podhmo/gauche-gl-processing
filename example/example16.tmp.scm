(use gl.processing)

(define draw
  (draw-once$ (^ ()
                 (fill 255 255 255)                 
                 (let1 s "The quick brown 狐 jumped over the lazy 犬."
                   (text s 15 20 70 70))
                 (let1 s "こんにちは。こんにちは。日本語でも適切に折り返してくれますか？"
                   (text s 15 120 70 70)))
              :save "foo.png"))

(define main
  (setup$ (lambda ()
            (window 200 200 "glc Tutorial" 0 0)
            (text-font! (load-font "Utopia" 12)))
          :draw draw))

(main '())
