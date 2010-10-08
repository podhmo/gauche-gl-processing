;; ;; blending
;; GL_ZERO	(0,0,0,0)
;; GL_ONE	(1,1,1,1)
;; GL_SRC_COLOR	(Rs/kR ,Gs/kG,Bs/kB,As/kA)
;; GL_ONE_MINUS_SRC_COLOR	(1,1,1,1)-(Rs/kR,Gs/kG,Bs/kB,As/kA)
;; GL_DST_COLOR	(Rd/kR,Gd/kG,Bd/kB,Ad/kA)
;; GL_ONE_MINUS_DST_COLOR	(1,1,1,1)-(Rd/kR,Gd/kG,Bd/kB,Ad/kA)
;; GL_SRC_ALPHA	(As/kA,As/kA,As/kA,As/kA)
;; GL_ONE_MINUS_SRC_ALPHA	(1,1,1,1)-(As/kA,As/kA,As/kA,As/kA)
;; GL_DST_ALPHA	(Ad/kA,Ad/kA,Ad/kA,Ad/kA)
;; GL_ONE_MINUS_DST_ALPHA	(1,1,1,1)-(Ad/kA,Ad/kA,Ad/kA,Ad/kA)
;; GL_SRC_ALPHA_SATURATE	(i,i,i,1)

(use gl.processing)

(define (tri) ;; draw triangle
  (gl-begin* GL_TRIANGLES
             (gl-vertex 120 120)
             (gl-vertex 0 120)
             (gl-vertex 60 60)))

(define (blend-sample caption x y)
  (with-matrix
   (translate x y 0)
   (gl-color 1 0 0 0.7)
   (tri)
   (with-matrix
    (gl-color 0.4 0.8 0.6 0.5)
    (translate 50 0 0)
    (tri))
   (with-matrix
    (fill 255 255 255)
    (text caption 10 140))))

(define draw
  (draw-once$ (^ ()
                 (translate 20 20)
                 (text "left triangle is GL_SRC_ALPHA L:(1 0 0 0.7) R:(0.4 0.8 0.6 0.5)" 0 0)

                 (gl-blend-func GL_SRC_ALPHA GL_ONE)
                 (blend-sample "GL_ONE" 0 0)
                 (gl-blend-func GL_SRC_ALPHA GL_ZERO)
                 (blend-sample "GL_ZERO" 200 0)
                 (gl-blend-func GL_SRC_ALPHA GL_SRC_COLOR)
                 (blend-sample "GL_SRC_COLOR" 400 0)
                 (gl-blend-func GL_SRC_ALPHA GL_ONE_MINUS_SRC_COLOR)
                 (blend-sample "GL_ONE_MINUS_SRC_COLOR" 600 0)
                 (with-matrix
                  (translate 0 100)
                  (gl-blend-func GL_SRC_ALPHA GL_DST_COLOR)
                  (blend-sample "GL_DST_COLOR" 0 0)
                  (gl-blend-func GL_SRC_ALPHA GL_SRC_ALPHA)
                  (blend-sample "GL_SRC_ALPHA" 200 0)
                  (gl-blend-func GL_SRC_ALPHA GL_ONE_MINUS_DST_ALPHA)
                  (blend-sample "GL_ONE_MINUS_DST_ALPHA" 400 0)
                  (gl-blend-func GL_SRC_ALPHA GL_SRC_ALPHA_SATURATE)
                  (blend-sample "GL_SRC_ALPHA_SATURATE" 600 0))
                 )
              :save "foo.png"
              :bg (cut background 0 0 0)))

(define main 
  (setup$ (^ ()
             (window 900 300 "" 100 100)
             (font-mode! 'bitmap)
             (load-font "Utopia" 12)
             (gl-disable GL_DEPTH_TEST)
             (gl-enable GL_BLEND))
          :draw draw))
(main '())