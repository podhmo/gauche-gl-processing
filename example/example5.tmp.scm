;; draw pixels 
(add-load-path "../")
(use gl.processing)
(use graphics.imlib2)
(use util.match)

(define *image-file* "a.jpg")

(define (load)
  (let1 img (load-image *image-file*)
    (values (image-width img) 
            (image-height img)
            (image-data-gl-pixels img :alpha #t))))

(define (2d-reshape w h)
  (gl-viewport 0 0 w h)
  (gl-matrix-mode GL_PROJECTION)
  (gl-load-identity)
  (glu-ortho-2d 0 w 0 h)
  (gl-matrix-mode GL_MODELVIEW)
  (gl-load-identity))


(define main
  (receive (w h image) (load)
    (setup$
     (lambda ()
       (gl-pixel-store GL_UNPACK_ALIGNMENT 1)
       (window w h "example5" 100 100))
     :reshape 2d-reshape
     :draw (draw-once$
            (cut gl-draw-pixels w h GL_RGBA GL_UNSIGNED_BYTE image)))))
