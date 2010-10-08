(use gauche.uvector)
(use gl.glc)
(use gl.processing)

;;GLC_STATE_ERROR
(define draw
  (draw-once$
   (lambda ()
         ;; (gl-matrix-mode GL_TEXTURE)
         ;; (gl-load-identity)
         ;; (gl-scale 1.0 -1.0 1.0)
         ;; (gl-matrix-mode GL_MODELVIEW)
         (gl-load-identity)
         (rect 10 10 10 10)
         (gl-color 1 0 0)
         (translate 5 5)
         (gl-scale 20 20 1)
         (glc-render-string "abc")
         #?=(glc-get-error)
)))

(define main 
  (setup$ (lambda ()
            (window 200 200 "foo" 100 100)
            (gl-enable GL_TEXTURE_2D)
            (glc-render-style GLC_TEXTURE)
            (load-font "Utopia" 100))
          :draw draw))
(main '())
