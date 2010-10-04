(use gl.processing)

;; animation

(define *angle* 0)
(define draw
  (draw$ (lambda ()
           (translate 150 150)
           (rotate *angle* 0 0 1)
           (rect 0 0 40 40)
           (inc! *angle* 10))))

(define main
  (setup$ (lambda ()
            (window 300 300 "sample" 100 100)
            (frame-rate! 100)
            (rect-mode! 'center))
          :draw draw))

(main '())