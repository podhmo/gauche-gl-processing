(define-module gl.processing.core
  (extend
   gl.processing.util
   gauche.experimental.lamb
   gauche.uvector
   gl
   gl.glut)
  (export-all))
(select-module gl.processing.core)

;; window size
(define *width* 0)
(define *height* 0)

(define *buffer-mode* GLUT_SINGLE)

(define *fill-color* '#f32(1 1 1))

(define (fill . args)
  (set! *no-fill?* #f)
  (set! *fill-color* (apply f32vector args)))

(define *no-stroke?* #f)
(define *no-fill?* #f)
(define (no-stroke!) (set! *no-stroke?* #t))
(define (no-fill!) (set! *no-fill?* #t))

(define *stroke-color* '#f32(0 0 0))
(define (stroke . args)
  (set! *no-stroke?* #f)
  (set! *stroke-color* (apply f32vector args)))

(define stroke-weight gl-line-width)  

(define background 
  (case-lambda
   [(r g b)
    (gl-clear-color r g b 0.0)
    (gl-clear GL_COLOR_BUFFER_BIT)]
   [(r g b a) (gl-clear-color r g b a)
    (gl-clear GL_COLOR_BUFFER_BIT)]))
