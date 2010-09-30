;;
;; texture mapping gl-tex-gen
;;
(use gauche.uvector)
(add-load-path "..")
(use gl.processing)


(define *size*  256)
(define *image* (make-u8vector (* *size* *size* 3) 0))
(define *tex* #f)


(define *speed-phi* 0)
(define *xrot* 0)
(define *yrot* 0)

(define (fill-image)
  (dotimes (y *size*)
    (dotimes (x *size*)
      (let ((i (* (+ (* y *size*) x) 3))
            (z (make-rectangular (- (* 3 (/ x *size*)) 2)
                                 (- (* 3 (/ y *size*)) 1.5))))
        (letrec ((rank (lambda (zn n)
                         (cond ((>= n 16) 0)
                               ((>= (magnitude zn) 2) n)
                               (else (rank (+ (* zn zn) z) (+ n 1)))))))
          (let ((r (rank z 0)))
            (u8vector-set! *image* i       (ash (logand r #xc) 4))
            (u8vector-set! *image* (+ i 1) (ash (logand r #x2) 6))
            (u8vector-set! *image* (+ i 2) (ash (logand r #x1) 7))
            ))))))

(define draw
  (draw-once$
   (lambda ()
     (gl-enable GL_TEXTURE_2D)
     (gl-tex-env GL_TEXTURE_ENV GL_TEXTURE_ENV_MODE GL_REPLACE)
     (gl-bind-texture GL_TEXTURE_2D *tex*)
;     (rect 0 0 *size* *size*)
     (gl-begin GL_QUADS)
     (gl-tex-coord 0 0 0.0)
     (gl-vertex 0 0 0.0)
     (gl-tex-coord 0 (+ 0 *size*) 0.0)
     (gl-vertex 0 (+ 0 *size*) 0.0)
     (gl-tex-coord (+ 0 *size*) (+ 0 *size*) 0.0)
     (gl-vertex (+ 0 *size*) (+ 0 *size*) 0.0)
     (gl-tex-coord (+ 0 *size*) 0 0.0)  
     (gl-vertex (+ 0 *size*) 0 0.0)
     (gl-end)

     (gl-disable GL_TEXTURE_2D)
     (print "[ESC]:TO EXIT"))))

(define main 
  (setup$ (lambda ()
            (window 500 500 "Gauche-GL" 100 100)

            (fill-image)
            (set! *tex* (u32vector-ref (gl-gen-textures 1) 0))
            (gl-bind-texture GL_TEXTURE_2D *tex*)
            (gl-tex-parameter GL_TEXTURE_2D GL_TEXTURE_WRAP_S GL_REPEAT)
            (gl-tex-parameter GL_TEXTURE_2D GL_TEXTURE_WRAP_T GL_REPEAT)
            (gl-tex-parameter GL_TEXTURE_2D GL_TEXTURE_MAG_FILTER GL_NEAREST)
            (gl-tex-parameter GL_TEXTURE_2D GL_TEXTURE_MIN_FILTER GL_NEAREST)
            (gl-tex-image-2d GL_TEXTURE_2D 0 GL_RGB *size* *size* 0 GL_RGB GL_UNSIGNED_BYTE *image*)
            
            (gl-enable GL_TEXTURE_GEN_S)
            (gl-enable GL_TEXTURE_GEN_T)
            (gl-tex-gen GL_S GL_TEXTURE_GEN_MODE GL_OBJECT_LINEAR) ;;GL_OBJECT_*
            (gl-tex-gen GL_T GL_TEXTURE_GEN_MODE GL_OBJECT_LINEAR) ;;GL_OBJECT_*
            (rect-mode! 'center))
          :draw draw))

(main '())
;; (main '())