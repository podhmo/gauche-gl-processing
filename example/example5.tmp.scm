;; draw pixels 
(add-load-path "../")
(use graphics.imlib2)
(use util.match)
(use gl.processing)

(define *image-file* "lisp-glossy.jpg")

(define (load)
  (let1 img (load-image *image-file*)
    (values (image-width img) 
            (image-height img)
            (image->gl-pixels img :alpha #t))))

(define main
  (receive (w h image) (load)
    (setup$
     (lambda ()
       (gl-pixel-store GL_UNPACK_ALIGNMENT 1)
       (window w h "example5" 100 100))
     :reshape (2d-elastic-reshape$ 100 100)
     :draw (draw-once$
            (cut gl-draw-pixels w h GL_RGBA GL_UNSIGNED_BYTE image)))))

(main '())