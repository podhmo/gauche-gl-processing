(define-module gl.processing
  (use math.const)
  (extend gl.processing.core gl.processing.window  gl.processing.transform
          gl.processing.text gl.processing.2d)
  (export-all))
(select-module gl.processing)


;;; experimental
(define (image->texture img w h)
  (let1 %texture-id (u32vector-ref (gl-gen-textures 1) 0)
    (gl-tex-parameter GL_TEXTURE_2D GL_TEXTURE_WRAP_S GL_REPEAT)
    (gl-tex-parameter GL_TEXTURE_2D GL_TEXTURE_WRAP_T GL_REPEAT)
    (gl-tex-parameter GL_TEXTURE_2D GL_TEXTURE_MAG_FILTER GL_NEAREST)
    (gl-tex-parameter GL_TEXTURE_2D GL_TEXTURE_MIN_FILTER GL_NEAREST)

    (gl-bind-texture GL_TEXTURE_2D %texture-id)
    (gl-tex-image-2d GL_TEXTURE_2D 0 GL_RGB w h 0 GL_RGB GL_UNSIGNED_BYTE img)
    %texture-id))

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


(define (load-pixels)
  (gl-read-pixels 0 0 *width* *height* GL_RGB GL_UNSIGNED_INT_8_8_8_8))
