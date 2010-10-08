(use gl.processing)

;;GL_TEXTURE_ENV
;; GL_MODULATE GL_REPLACE GL_DECAL GL_ADD
(define A #f)
(define B #f)
(define draw (draw-once$ 
              (^ () 
                 (with-matrix
                  (translate 50 50)
                  (draw-mixed-shape A B 200 200 
                                    :typeA GL_REPLACE :typeB GL_MODULATE)))
              :save "foo.png"))

(define main (setup$ (^ () (window 300 300 "foo")
                        (set! B (file->texture "lisp-redpill.jpg"))
                        (set! A (file->texture "lisp-glossy.jpg")))
                     :draw draw))

;; Texture Combiners - OpenGL.org
;; http://www.opengl.org/wiki/Texture_Combiners

(main '())

