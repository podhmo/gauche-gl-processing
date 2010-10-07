(extend gl.processing)
(use gl.glc)
(define id 0)
(define ctx #f)
(define myfont #f)
(define draw
  (draw-once$ (lambda ()
;           glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
           (gl-load-identity)
           (gl-scale 100 100 1)
           (gl-translate 0.5 0.5 1)
           (gl-color 1 0 0 1)
           (glc-render-string "ABCDE")

           (gl-load-identity)
           (gl-scale 100 100 1)
           (gl-translate 0.5 1.5 1)
           (glc-render-string " ABCDE "))))
(define main
  (setup$ (^ ()
             (window 640 300 "" 100 100)
             (gl-enable GL_TEXTURE_2D)
             (set! ctx (glc-gen-context))
             (glc-context ctx)
             (set! myfont (glc-gen-font-id))
;;             (glc-new-font-from-family myfont "Palatino") ;;Linotype
               (glc-new-font-from-family myfont "Utopia") ;;Linotype
             (glc-font-face myfont "Bold")
             (glc-font myfont)
             (glc-render-style GLC_TEXTURE))
          :draw draw
          :reshape (2d-reshape$ :style :gl)))
(main '())