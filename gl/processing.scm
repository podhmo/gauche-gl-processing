(define-module gl.processing
  (extend gl.processing.core gl.processing.window  gl.processing.transform
          gl.processing.text gl.processing.2d)
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
