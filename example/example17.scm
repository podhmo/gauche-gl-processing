(use gauche.uvector)
(use gl.glc)
(use gl.processing)

(define draw
  (draw-once$
   (lambda ()
         (gl-clear-color 0 0 0 0)
         (gl-clear (logior GL_COLOR_BUFFER_BIT GL_DEPTH_BUFFER_BIT))
         (gl-matrix-mode GL_TEXTURE)
         (gl-load-identity)
         (glc-scale 1.0 -1.0 1.0)
         (gl-matrix-mode GL_MODELVIEW)
         (gl-load-identity)
         (rect 10 10 10 10)
         (gl-color 1 0 0)
         (gl-scale 20 20 1)
         (translate 5 5)
         (glc-render-string "abc")
)))

(define main 
  (setup$ (lambda ()
            (window 200 200 "foo" 100 100)
            (gl-enable GL_TEXTURE_2D)
            (glc-render-style GLC_TEXTURE)
            (load-font "Utopia" 20))
          :draw draw))
(main '())
