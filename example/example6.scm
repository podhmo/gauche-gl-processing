;; texture with gl-tex-coord

(add-load-path "..")
(use gauche.uvector)
(use graphics.imlib2)
(use gl.processing)

(define *tex* #f)
(define *w* 0)
(define *h* 0)
(define *image-file* "a.jpg")

(define (load-image-file file)
  (let1 img (load-image file)
    (values (image-width img) 
            (image-height img)
            (image->gl img :type :texture))))

(define disp
  (draw-once$
   (lambda ()
     (with-texture
      (draw-shape *tex* *w* *h*)
      (translate 300 400)
      (draw-shape *tex* 100 100)
      (translate -50 -50)
      (draw-shape *tex* 100 100)
      (translate -50 -50)
      (draw-shape *tex* 100 100)))))

(define main
  (receive (w h img) (load-image-file *image-file*)
    (set! *w* w) (set! *h* h) 
    (setup$ (lambda ()
              (window 500 500 "texture" 100 100)
              (set! *tex* (image->texture img w h))
              (image->texture img w h))
            :draw disp
            :reshape (2d-elastic-reshape$ 500 500))))
    

(main '())