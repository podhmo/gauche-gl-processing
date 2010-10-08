(define-module gl.processing.2d
  (use gl.processing.core)
  (use math.const)
  (export-all))
(select-module gl.processing.2d)


;;; 2d 
;;corners,radious is not implemented
(define-mode rect :default 'corner :candidates '(center corner))

(define-mode ellipse :default 'center :candidates '(center))

;;; draw-function

(define (line x1 y1 x2 y2)
  (gl-begin* GL_LINE 
             (gl-color *stroke-color*)
             (gl-vertex x1 y1 0)
             (gl-vertex x2 y2 0)))

(define-syntax with-fill
  (syntax-rules ()
    [(_ action ...)
     (unless *no-fill?*
       (gl-color *fill-color*)
       action ...)]))

(define-syntax with-stroke
  (syntax-rules ()
    [(_ action ...)
     (unless *no-stroke?*
       (gl-color *stroke-color*)
       action ...)]))

(define (ellipse x y width height)
  (let ((d (/. (* 2 pi) 120)) ;;120 is adhoc value
        (mw (/. width 2))
        (mh (/. height 2)))
    (define (loop i ratio)
      (when (< i 120)
        (let ((x* (+ x (* mw (cos ratio))))
              (y* (+ y (* mh (sin ratio)))))
          (gl-vertex x* y* 0)
          (loop (+ i 1) (+ ratio d)))))
    (with-fill
     (gl-begin* GL_POLYGON
                (gl-color *fill-color*)
                (loop 0 0)))
    (with-stroke
     (gl-begin* GL_LINE_LOOP
                (gl-color *stroke-color*)
                (loop 0 0)))))

(define (rect x y width height)
  (case *rect-mode*
    [(corner)
     (with-fill
      (gl-rect (f32vector x y) (f32vector (+ x width) (+ y height))))
     (with-stroke
      (gl-begin* GL_LINE_LOOP
                 (gl-color *stroke-color*)
                 (gl-vertex x y 0.0)
                 (gl-vertex x (+ y height) 0.0)
                 (gl-vertex (+ x width) (+ y height) 0.0)
                 (gl-vertex (+ x width) y 0.0)))]
    [(center)
     (let ((mw (/. width 2)) (mh (/. height 2)))
       (with-fill
        (gl-rect (f32vector (- x mw) (- y mh)) 
                 (f32vector (+ x mw) (+ y mh))))
       (with-stroke
        (gl-begin* GL_LINE_LOOP
                   (gl-color *stroke-color*)
                   (gl-vertex (- x mw) (- y mh) 0.0)
                   (gl-vertex (+ x mw) (- y mh) 0.0)
                   (gl-vertex (+ x mw) (+ y mh) 0.0)
                   (gl-vertex (- x mw) (+ y mh) 0.0))))]))

(define (triangle x1 y1 x2 y2 x3 y3)
  (define (%tri)
    (gl-vertex x1 y1)
    (gl-vertex x2 y2)
    (gl-vertex x3 y3))
  (with-fill (gl-begin* GL_TRIANGLES (%tri)))
  (with-stroke (gl-begin* GL_LINE_LOOP (%tri))))
