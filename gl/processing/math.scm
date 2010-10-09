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

(define (norm value low high)
  (/. (- value low)
      (- high low)))

(define (sq x) (* x x))

(define (mag . args)
  (sqrt
   (fold (lambda (x n) (+ n (* x x))) 0 args)))

(define 