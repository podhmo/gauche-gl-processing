;;; animation
(use gauche.threads)
(use gauche.experimental.lamb)
(use gl.processing)

;;; util
(define gen-timer-id
  (let1 i 0
    (lambda () (inc! i) i)))


(define (timer$ function)
  (lambda (delay-time)
    (let1 id (gen-timer-id)
      (define (function* v)
        (function v)
        (glut-timer-func delay-time function* v))
      (glut-timer-func delay-time function* id))))

;;;;
(define x 0) (define y 0)
(define draw-update? #t)
(define-macro (define-draw . actions)
  `(begin
     (set! draw
       (draw$ (lambda () ,@actions)))
     (set! draw-update? #t)))

(define update-timer
  (timer$ (^v (when draw-update?
                (print "watch")
                (set! draw-update? #f)
                (draw)))))


(define draw (draw$ (cut rect x y 30 20)))
(define-draw 
  (background 0 0 0)
  (print "update!")
  (rect 100 100 30 30))


(define main
  (setup$ (lambda ()
            (window 200 200 "animatin" 100 100)
            (update-timer 100))
          :draw draw))

(define th (make-thread (cut main '())))
(thread-start! th)
