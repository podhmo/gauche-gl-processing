(define-module gl.processing.transform
  (use gl.processing.core)
  (export-all))
(select-module gl.processing.transform)

(define pop-matrix gl-pop-matrix)
(define push-matrix gl-push-matrix)
(define reset-matrix gl-load-identity)

(define-syntax with-matrix
  (syntax-rules ()
    [(_ ac ...)
     (begin (push-matrix)
            ac ...
            (pop-matrix))]))

(define *matrix-mode-table*
  (let1 alist `((GL_MODELVIEW_MATRIX ,GL_MODELVIEW_MATRIX)
                (GL_PROJECTION_MATRIX ,GL_PROJECTION_MATRIX)
                (GL_TEXTURE_MATRIX ,GL_TEXTURE_MATRIX)
                (modelview ,GL_MODELVIEW_MATRIX)
                (projection ,GL_PROJECTION_MATRIX)
                (texture ,GL_TEXTURE_MATRIX))
    (rlet1 ht (make-hash-table)
      (for-each (^e (apply hash-table-put! ht e)) 
                alist))))

(define print-matrix
  (case-lambda 
   [() (print-matrix 'modelview)]
   [(mode) (let1 v (gl-get-double (hash-table-get *matrix-mode-table* mode))
             (let1 ep (current-error-port)
               (display mode ep) (newline ep)
               (dotimes (i 4)
                 (dotimes (j 4)
                   (display (f64vector-ref v (+ (* 4 i) j)) ep)
                   (display (if (= j 3) "\n" ", ") ep)))))]))

(define (skew-x angle)
  (gl-mult-matrix 
   (f32vector 1 0 0 0
              (tan angle) 1 0 0
              0 0 1 0
              0 0 0 1)))

(define (skew-y angle)
  (gl-mult-matrix 
   (f32vector 1 (tan angle) 0 0
              0 1 0 0
              0 0 1 0
              0 0 0 1)))

(define translate 
  (case-lambda 
   [(x y) (gl-translate x y 0.0)]
   [(x y z) (gl-translate x y z)]))

(define rotate
  (case-lambda
   [(angle) (gl-rotate angle 0.0 0.0 1.0)]
   [(angle x y z) (gl-rotate angle x y z)]))
(define (rotate-x angle)
  (gl-rotate angle 1.0 0.0 0.0))
(define (rotate-y angle)
  (gl-rotate angle 0.0 1.0 0.0))
(define (rotate-z rotate)
  (gl-rotate angle 0.0 0.0 1.0))
