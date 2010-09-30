(define-module gl.processing.core
  (extend
   gl.processing.util
   gauche.experimental.lamb
   gauche.uvector
   gl
   gl.glut)
  (export-all))
(select-module gl.processing.core)

(define *buffer-mode* GLUT_SINGLE)

(define *fill-color* '#f32(1 1 1))

(define (fill . args)
  (set! *fill-color* (apply f32vector args)))

;; (define *no-stroke?* #f)

(define *stroke-color* '#f32(0 0 0))
(define (stroke . args)
  (set! *fill-color* (apply f32vector args)))

(define stroke-weight gl-line-width)  

(define background 
  (case-lambda
   [(r g b)
    (gl-clear-color r g b 0.0)
    (gl-clear GL_COLOR_BUFFER_BIT)]
   [(r g b a) (gl-clear-color r g b a)
    (gl-clear GL_COLOR_BUFFER_BIT)]))
