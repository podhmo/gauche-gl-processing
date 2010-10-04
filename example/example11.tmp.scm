(use gl.processing)
(use gl.processing.interactive)

;; animation

(define *angle* 0)
(define draw
  (draw$ (lambda ()
           (translate 150 150)
           (rotate *angle* 0 0 1)
           (rect 0 0 40 40))))

(define timer  
  (timer$ (^ (_) (inc! *angle*) (redisplay))))
;; redisplay=glut-post-redisplay, drawを実行しても良い

(define main
  (setup$ (lambda ()
            (window 300 300 "sample" 100 100)
            (rect-mode! 'center)
            (timer 1))
          :draw draw))

