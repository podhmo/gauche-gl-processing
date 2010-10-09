(define-module gl.processing
  (extend gl.processing.core gl.processing.window  gl.processing.transform
          gl.processing.text gl.processing.2d gl.processing.math)
  (export-all))
(select-module gl.processing)


;;; experimental
(define (image->texture img w h :key (alpha #f))
  (let ((rgb-or-rgba (if alpha GL_RGBA GL_RGB))
        (id (u32vector-ref (gl-gen-textures 1) 0)))
    (gl-bind-texture GL_TEXTURE_2D id)
    (gl-tex-image-2d GL_TEXTURE_2D 0 rgb-or-rgba w h 0 rgb-or-rgba GL_UNSIGNED_BYTE img)
    (gl-tex-parameter GL_TEXTURE_2D GL_TEXTURE_WRAP_S GL_REPEAT)
    (gl-tex-parameter GL_TEXTURE_2D GL_TEXTURE_WRAP_T GL_REPEAT)
    (gl-tex-parameter GL_TEXTURE_2D GL_TEXTURE_MAG_FILTER GL_NEAREST)
    (gl-tex-parameter GL_TEXTURE_2D GL_TEXTURE_MIN_FILTER GL_NEAREST)
    id))

(define-syntax with-texture
  (syntax-rules ()
    ([_ action ...]
     (begin
       (gl-enable GL_TEXTURE_2D)
       action ...
       (gl-disable GL_TEXTURE_2D)))))

(define draw-shape 
  (let1 %texture-id +inf.0
    (lambda (id w h)
      (unless (= %texture-id id)
        (set! %texture-id id)
        (gl-bind-texture GL_TEXTURE_2D id))
      (gl-begin* GL_QUADS
                 (gl-tex-coord '#f32(0.0 0.0)) (gl-vertex '#f32(0.0 0.0))
                 (gl-tex-coord '#f32(0.0 1.0)) (gl-vertex (f32vector 0.0 h))
                 (gl-tex-coord '#f32(1.0 1.0)) (gl-vertex (f32vector w h))
                 (gl-tex-coord '#f32(1.0 0.0)) (gl-vertex (f32vector w 0.0))
                 ))))

(define (draw-mixed-shape A B w h :key (typeA GL_REPLACE) (typeB GL_MODULATE))
  (with-texture
   (gl-active-texture-arb GL_TEXTURE0_ARB)
   (gl-bind-texture GL_TEXTURE_2D A) ;;
   (gl-tex-env GL_TEXTURE_ENV GL_TEXTURE_ENV_MODE typeA)
   (gl-enable GL_TEXTURE_2D)

   (gl-active-texture-arb GL_TEXTURE1_ARB)
   (gl-bind-texture GL_TEXTURE_2D B) ;;
   (gl-tex-env GL_TEXTURE_ENV GL_TEXTURE_ENV_MODE typeB)
   (gl-enable GL_TEXTURE_2D)

   (gl-begin* GL_QUADS
              (gl-multi-tex-coord-arb GL_TEXTURE0_ARB 0 0)
              (gl-multi-tex-coord-arb GL_TEXTURE1_ARB 0 0)
              (gl-vertex 0 0)
              (gl-multi-tex-coord-arb GL_TEXTURE0_ARB 0 1)
              (gl-multi-tex-coord-arb GL_TEXTURE1_ARB 0 1)
              (gl-vertex 0 h)
              (gl-multi-tex-coord-arb GL_TEXTURE0_ARB 1 1)
              (gl-multi-tex-coord-arb GL_TEXTURE1_ARB 1 1)
              (gl-vertex w h)
              (gl-multi-tex-coord-arb GL_TEXTURE0_ARB 1 0)
              (gl-multi-tex-coord-arb GL_TEXTURE1_ARB 1 0)
              (gl-vertex w 0))))

(define-syntax with-simple-draw
  (syntax-rules ()
    [(_ (w h) action ...)
     (with-simple-draw (w h "sample" 100 100) action ...)]
    [(_ (w h title) actioin ...)
     (with-simple-draw (w h title 100 100) actioin ...)]
    [(_ (w h title x y)
        action ...)
     (define main (setup$ (lambda () (window w h title x y))
                          :draw (draw-once$ (lambda () action ...))))]))
;; (put 'with-simple-draw 'scheme-indent-function 1)

(define (flip-texture!)
  (gl-matrix-mode GL_TEXTURE)
  (gl-load-identity)
  (gl-scale 1.0 -1.0 1.0))

(define (load-image-file file)
  (let1 img (load-image file)
    (values (image-width img) 
            (image-height img)
            (image->gl img :alpha #t))))


(define (file->texture file)
  (receive (w h img) (load-image-file file)
    (image->texture img w h :alpha #t)))

(define (blend-info)
  (print "
GL_ZERO	(0,0,0,0)
GL_ONE	(1,1,1,1)
GL_SRC_COLOR	(Rs/kR ,Gs/kG,Bs/kB,As/kA)
GL_ONE_MINUS_SRC_COLOR	(1,1,1,1)-(Rs/kR,Gs/kG,Bs/kB,As/kA)
GL_DST_COLOR	(Rd/kR,Gd/kG,Bd/kB,Ad/kA)
GL_ONE_MINUS_DST_COLOR	(1,1,1,1)-(Rd/kR,Gd/kG,Bd/kB,Ad/kA)
GL_SRC_ALPHA	(As/kA,As/kA,As/kA,As/kA)
GL_ONE_MINUS_SRC_ALPHA	(1,1,1,1)-(As/kA,As/kA,As/kA,As/kA)
GL_DST_ALPHA	(Ad/kA,Ad/kA,Ad/kA,Ad/kA)
GL_ONE_MINUS_DST_ALPHA	(1,1,1,1)-(Ad/kA,Ad/kA,Ad/kA,Ad/kA)
GL_SRC_ALPHA_SATURATE	(i,i,i,1)

//アルファ合成
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
//加算合成
    glBlendFunc(GL_SRC_ALPHA, GL_ONE);
//乗算合成
    glBlendFunc(GL_ZERO, GL_SRC_COLOR);
//反転合成
    glBlendFunc(GL_ONE_MINUS_DST_COLOR, GL_ZERO);
//スクリーン合成
    glBlendFunc(GL_ONE_MINUS_DST_COLOR, GL_ONE);
//排他的論理和合成
    glBlendFunc(GL_ONE_MINUS_DST_COLOR, GL_ONE_MINUS_SRC_COLOR);
"))