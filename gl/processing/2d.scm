(define-module gl.processing.2d
  (use gl)
  (use gl.glut)
  (use math.const)
  (use gauche.uvector)
  (use gauche.experimental.lamb)
  (export-all))
(select-module gl.processing.2d)


(define *fill-color* '#f32(1 1 1))

(define (fill . args)
  (set! *fill-color* (apply f32vector args)))

(define *stroke-color* '#f32(0 0 0))
(define (stroke . args)
  (set! *fill-color* (apply f32vector args)))

;;; 2d 

(define (symbol-transform fn sym)
  ((compose string->symbol fn symbol->string) sym))
(define-macro (define-mode name :key (default #f) (candidates '()))
  (let ((val (symbol-transform (^s #`"*,|s|-mode*") name))
        (cands (symbol-transform (^s #`"*,|s|-mode-candidates*") name))
        (setter (symbol-transform (^s #`",|s|-mode!") name))
        (mode (gensym)))
    `(begin (define ,val ,default)
            (define ,cands ,candidates)
            (define (,setter ,mode)
              (if (memq ,mode ,cands)
                  (set! ,val ,mode)
                  (errorf "RECT-MODE: `~a' is not implemented yet" ,mode)))
            (values ',val ',cands ',setter))))

;;corners,radious is not implemented
(define-mode rect :default 'corner :candidates '(center corner))

(define-mode ellipse :default 'center :candidates '(center))

;;; draw-function

(define (line x1 y1 x2 y2)
  (gl-begin* GL_LINE 
             (gl-color *stroke-color*)
             (gl-vertex x1 y1 0)
             (gl-vertex x2 y2 0)))

(define (ellipse x y width height)
  (let1 d (/. (* 2 pi) 120) ;;120 is adhoc value
    (define (loop i ratio)
      (when (< i 120)
        (let ((x* (+ x (* width (cos ratio))))
              (y* (+ y (* height (sin ratio)))))
          (gl-vertex x* y* 0)
          (loop (+ i 1) (+ ratio d)))))
    (gl-begin* GL_POLYGON
               (gl-color *fill-color*)
               (loop 0 0))
    (gl-begin* GL_LINE_LOOP
               (gl-color *stroke-color*)
               (loop 0 0))))

(define (rect x y width height)
  (case *rect-mode*
    [(corner)
     (gl-color *fill-color*)
     (gl-rect (f32vector x y) (f32vector (+ x width) (+ y height)))
     (gl-begin* GL_LINE_LOOP
                (gl-color *stroke-color*)
                (gl-vertex x y 0.0)
                (gl-vertex x (- y height) 0.0)
                (gl-vertex (+ x width) (- y height) 0.0)
                (gl-vertex (+ x width) y 0.0))]
    [(center)
     (let ((mw (/. width 2)) (mh (/. height 2)))
       (gl-color *fill-color*)
       (gl-rect (f32vector (- x mw) (- y mh)) 
                (f32vector (+ x mw) (+ y mh)))
       (gl-begin* GL_LINE_LOOP
                  (gl-color *stroke-color*)
                  (gl-vertex (- x mw) (- y mh) 0.0)
                  (gl-vertex (+ x mw) (- y mh) 0.0)
                  (gl-vertex (+ x mw) (+ y mh) 0.0)
                  (gl-vertex (- x mw) (+ y mh) 0.0)))]))
