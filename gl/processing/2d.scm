(define-module gl.processing.2d
  (use gl)
  (use gl.glut)
  (use math.const)
  (use gauche.experimental.lamb)
  (export-all))
(select-module gl.processing.2d)

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

;; (define-macro (with-mode mode

(define (ellipse x y width height)
  (let1 d (/. (* 2 pi) 120) ;;120 is adhoc value
    (gl-begin* GL_POLYGON
               (let loop ((i 0) (ratio 0))
                 (when (< i 120)
                   (let ((x* (+ x (* width (cos ratio))))
                         (y* (+ y (* height (sin ratio)))))
                     (gl-vertex x* y* 0)
                     (loop (+ i 1) (+ ratio d))))))))

(define (rect x y width height)
  (case *rect-mode*
    [(corner)
     (gl-begin* GL_POLYGON
                (gl-vertex x y 0.0)
                (gl-vertex x (- y height) 0.0)
                (gl-vertex (+ x width) (- y height) 0.0)
                (gl-vertex (+ x width) y 0.0))]
    [(center)
     (let ((mw (/. width 2)) (mh (/. height 2)))
       (gl-begin* GL_POLYGON
                  (gl-vertex (- x mw) (- y mh) 0.0)
                  (gl-vertex (+ x mw) (- y mh) 0.0)
                  (gl-vertex (+ x mw) (+ y mh) 0.0)
                  (gl-vertex (- x mw) (+ y mh) 0.0)))]))
