;;
;; texture with gl-tex-coord
;;

(add-load-path "..")
(use gl.processing)
(use gauche.uvector)
(use graphics.imlib2)


(define *tex* #f)
(define *w* 0)
(define *h* 0)
(define *image-file* "a.jpg")

(define (load-image-file file)
  (let1 img (load-image file)
    (values (image-width img) 
            (image-height img)
            (image-data-gl img :type :texture))))

(define (draw-shape w h)
  (gl-begin* GL_QUADS
             (gl-tex-coord '#f32(1.0 0.0)) (gl-vertex (f32vector w 0.0))
             (gl-tex-coord '#f32(1.0 1.0)) (gl-vertex (f32vector w h))
             (gl-tex-coord '#f32(0.0 1.0)) (gl-vertex (f32vector 0.0 h))
             (gl-tex-coord '#f32(0.0 0.0)) (gl-vertex '#f32(0.0 0.0))))

(define disp
  (draw-once$
   (lambda ()
     (with-texture
      (gl-bind-texture GL_TEXTURE_2D *tex*)
      (draw-shape *w* *h*)
      (translate 300 400)
      (draw-shape 100 100)
      (translate -50 -50)
      (draw-shape 100 100)
      (translate -50 -50)
      (draw-shape 100 100)))))



(define main
  (receive (w h img) (load-image-file *image-file*)
    (set! *w* w) (set! *h* h) 
    (setup$ (lambda ()
              (window 500 500 "texture" 100 100)
              (gl-tex-env GL_TEXTURE_ENV GL_TEXTURE_ENV_MODE GL_REPLACE)
              (set! *tex* (image->texture img w h)))
            :draw disp)))

(main '())