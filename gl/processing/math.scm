(define-module gl.processing.math
  (use gl.processing.core)
  (use srfi-27))
(select-module gl.processing.math)

(define random
  (case-lambda 
   [(n) (cond [(fixnum? n) (random-integer n)]
              [else (* n (random-real))])]
   [(low high)
    (cond [(fixnum? low) (+ low (random-integer (- high low)))]
          [else (+ low (* (- high low) (random-real)))])]))

;; (use gauche.experimental.lamb)
;; (use srfi-1)
;; (list-tabulate 10 (^_ (random 10)))
;; (list-tabulate 10 (^_ (random 3.2)))
;; (list-tabulate 10 (^_ (random 1 5)))
;; (list-tabulate 10 (^_ (random 1.5 5.0)))

(define (constrain val minv maxv)
  (cond ((< val minv) minv)
        ((> val maxv) maxv)
        (else val)))

(define dist
  (case-lambda
   [(x1 y1 x2 y2)
    (sqrt (+ (sq (- y2 y1)) (sq (- x2 x1))))]
   [(x1 y1 z1 x2 y2 z2)
    (sqrt (+ (sq (- z2 z1)) (sq (- y2 y1)) (sq (- x2 x1))))]))

(define (norm value low high)
  (/. (- value low)
      (- high low)))

(define (lerp v1 v2 amt)
  (+ v1 (* amt (- v2 v1))))

(define (nummap val low1 high1 low2 high2) ;;processing's map
  (let1 amt (/. (- val low1) (- high1 low1))
    (+ low2 (* amt (- high2 low2)))))

(define (sq x) (* x x))

(define (mag . args)
  (sqrt
   (fold (lambda (x n) (+ n (* x x))) 0 args)))

