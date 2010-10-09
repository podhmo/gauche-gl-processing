
(define-module gl.processing.2d
  (use gl.processing.core)
  (use math.const)
  (use util.match)
  (use srfi-43)
  (use srfi-1)
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

;; point
(define (point x y)
  (gl-begin* GL_POINTS (gl-vertex x y)))

;;; board
(define-class <board> ()
  [(each-size :init-keyword :each-size)
   (xn :init-keyword :xn)
   (yn :init-keyword :yn)
   (data :init-keyword :data)])

(define (make-board xn yn :key (each-size 10))
  (let1 data
      (list->vector (list-tabulate yn (^_ (list->vector (list-tabulate xn (^_ 0))))))
    (make <board> :xn xn :yn yn :each-size each-size :data data)))

(define (2dvector->board 2dv :key (each-size 10))
  (let ((yn (vector-length 2dv))
        (xn (vector-length (vector-ref 2dv 0))))
    (make <board> :xn xn :yn yn :each-size each-size :data 2dv)))

(define (board-for-each fn board)
  (match-let1 ($ <board> _ xn yn data) board
    (vector-for-each 
     (^ (y v)
        (vector-for-each
         (^ (x e) (fn x y e)) v))
     data)))

(define (board-for-each* fn board)
  (match-let1 ($ <board> each-size xn yn data) board
    (vector-for-each 
     (^ (y v)
        (vector-for-each
         (^ (x e) (fn x y e (* x each-size) (* y each-size))) v))
     data)))

