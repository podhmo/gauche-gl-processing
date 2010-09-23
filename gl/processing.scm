(define-module gl.processing
  (extend gl gl.glut 
          gl.processing.window gl.processing.2d)
  (export-all))
(select-module gl.processing)
;; color
(define fill gl-color)

;; background(value1, value2, value3)
;; background(value1, value2, value3, alpha)

(define background 
  (case-lambda
   [(r g b)
    (gl-clear-color r g b 0.0)
    (gl-clear GL_COLOR_BUFFER_BIT)]
   [(r g b a) (gl-clear-color r g b a)
    (gl-clear GL_COLOR_BUFFER_BIT)]))

(define (draw$ action :key (bg (cut background 0.5 0.5 0.5)))
  (lambda ()
    (bg)
    (action)
    (gl-flush)))


