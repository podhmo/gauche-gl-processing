;; /** \file
;;  * Regression test for bug #1987563 (reported by GenPFault) :
;;  *
;;  * glcEnable(GLC_KERNING_QSO) does not enable kerning.
;;  * Microsoft Word 2003 and the official Freetype tutorial kerning algorithm
;;  * both produced the correct kerning which is different from the kerning
;;  * obtained with QuesoGLC.
;;  * Actually, the combination of GLC_GL_OBJECTS and KERNING induces the bug.
;;  */

(use gauche.experimental.ref)
(add-load-path "..")
(extend gl.processing)
(use gauche.uvector)
(use graphics.imlib2)
(use gl.glc)
(use gauche.uvector)

(define *id* 0)

(define (bbox-rect bbox)
  (gl-begin* GL_LINE_LOOP
             (gl-vertex (~ bbox 0) (~ bbox 1))
             (gl-vertex (~ bbox 2) (~ bbox 3))
             (gl-vertex (~ bbox 4) (~ bbox 5))
             (gl-vertex (~ bbox 6) (~ bbox 7))))


(define (bbox-caption-box-below bbox :key (size 40) (margin 10))
  (gl-begin* GL_LINE
             (gl-vertex (~ bbox 0) (~ bbox 1))
             (gl-vertex (~ bbox 0) (- (~ bbox 1) size))
             (gl-vertex (~ bbox 2) (~ bbox 3))
             (gl-vertex (~ bbox 2) (- (~ bbox 3) size))
             (gl-vertex (~ bbox 0) (- (~ bbox 1) (- size margin)))
             (gl-vertex (~ bbox 2) (- (~ bbox 3) (- size margin))))

  ;; draw allow
  (let ((half (/. margin 2)) (h (- size margin))) ;;left
    (let ((x (~ bbox 0)) (y (~ bbox 1)))
      (gl-begin* GL_LINE_LOOP
                 (gl-vertex (+ x half) (- y (- h half)))
                 (gl-vertex x (- y h))
                 (gl-vertex (+ x half) (- y (+ h half)))))
    (let ((x (~ bbox 2)) (y (~ bbox 1))) ;;right
      (gl-begin* GL_LINE_LOOP 
                 (gl-vertex (- x half) (- y (- h half)))
                 (gl-vertex x (- y h))
                 (gl-vertex (- x half) (- y (+ h half)))))))

(define (bbox-caption-box-above bbox :key (size 40) (margin 10))
  (gl-begin* GL_LINE
             (gl-vertex (~ bbox 4) (~ bbox 5))
             (gl-vertex (~ bbox 4) (+ (~ bbox 5) size))
             (gl-vertex (~ bbox 6) (~ bbox 7))
             (gl-vertex (~ bbox 6) (+ (~ bbox 7) size))
             (gl-vertex (~ bbox 4) (+ (~ bbox 5) (- size margin)))
             (gl-vertex (~ bbox 6) (+ (~ bbox 7) (- size margin))))
  (let ((half (/. margin 2)) (h (- size margin))) ;;left
    (gl-begin* GL_LINE_LOOP
               (let ((x (~ bbox 4)) (y (~ bbox 5)))
                 (gl-vertex (- x half) (+ y (- h half)))
                 (gl-vertex x (+ y h))
                 (gl-vertex (- x half) (+ y (+ h half)))))
    (gl-begin* GL_LINE_LOOP
               (let ((x (~ bbox 6)) (y (~ bbox 7)))
                 (gl-vertex (+ x half) (+ y (- h half)))
                 (gl-vertex x (+ y h))
                 (gl-vertex (+ x half) (+ y (+ h half)))))))

(define draw
  (draw-once$
   (lambda ()
     (let ((bbox (make-f32vector 8 0))
           (bbox2 (make-f32vector 8 0)))
       (gl-clear (logior GL_COLOR_BUFFER_BIT GL_DEPTH_BUFFER_BIT))
       (gl-load-identity)
       (gl-color 1.0 0 0)
       (let ((object-x 50) (object-y 50))
         (gl-raster-pos object-x object-y)
         (glc-disable GLC_KERNING_QSO)
         (glc-render-style GLC_BITMAP)
         (glc-load-identity)
         (glc-scale 100 100)

         (glc-render-string "VAV")
         (glc-measure-string GL_FALSE "VAV")
         (glc-get-string-metric! GLC_BOUNDS bbox) ;;
         (gl-color 0 1 1)
         (gl-translate 50 50 0)
         (bbox-rect bbox)

         (gl-color 1 1 1)
         (let ((size 40) (margin 10))
           (bbox-caption-box-below bbox :size size :margin margin)
           
           ;;draw caption
           (let1 string (format #f "~a" (- (~ bbox 2) (~ bbox 0)))
             (glc-enable GLC_HINTING_QSO)
             (glc-scale 0.15 0.15)
             (glc-measure-string GL_FALSE string)
             (glc-get-string-metric! GLC_BOUNDS bbox2)
             (gl-load-identity)
             (gl-raster-pos  (+ (* 0.5 (- (~ bbox 2) (~ bbox 0) (- (~ bbox2 2) (~ bbox2 0))))
                                object-x)
                             (+ (~ bbox 1) (- object-y (- size margin)) 3))
             (glc-render-string string)
             (glc-disable GLC_HINTING_QSO)))



         ;; Render GLC_TEXTURE without kerning
         (gl-load-identity)
         (glc-render-style GLC_TEXTURE)
         (gl-color 1 0 0)
         (gl-scale 100 100 1)
         (gl-translate 3 0.5 0)
         (gl-push-matrix)
         ;; In order to reproduce the conditions of bug #1987563(quesoglc) GLC_GL_OBJECTS must
         ;; be disabled when rendering GLC_TEXTURE w/o kerning.
         (glc-render-string "VAV")
         (gl-pop-matrix)
         (glc-measure-string GL_TRUE "VAV")
         (glc-get-string-char-metric! 1 GLC_BOUNDS bbox)
         (gl-color 0 1 0)

         (bbox-rect bbox)

         (glc-get-string-metric! GLC_BOUNDS bbox)
         (gl-color 0 1 1)
         (bbox-rect bbox)

         (let1 string (format #f "~a" (* 100 (- (~ bbox 2) (~ bbox 0))))
           (glc-enable GLC_HINTING_QSO)
           (glc-measure-string GL_FALSE string)
           (glc-get-string-metric! GLC_BOUNDS bbox2)
           (gl-color 1 1 1)
           (let ((size 0.4) (margin 0.1))
             (bbox-caption-box-below bbox :size size :margin margin)
             (gl-translate  (abs (* 0.5 0.35 (- (~ bbox 2) (~ bbox 0) (- (~ bbox2 2) (~ bbox2 0)))))
                            (- (~ bbox 1) 0.27)
                            0)
             (gl-scale 0.15 0.15 1)
             (glc-render-string string)))
         (glc-disable GLC_HINTING_QSO)

         ;;   When hinting is enabled, characters must be rendered at integer positions
         ;;   otherwise hinting is compromised and characters look fuzzy.

         

         ;;; render GLC_BITMAP with kerning
         (gl-color 1 0 0)
         (glc-enable GLC_KERNING_QSO)
         (glc-render-style GLC_BITMAP)
         (glc-load-identity)
         (glc-scale 100 100)
         (gl-load-identity)
         (gl-raster-pos 50 150)
         (glc-render-string "VAV")
         (glc-measure-string GL_FALSE "VAV")
         (glc-get-string-metric! GLC_BOUNDS bbox) ;;
         (gl-color 0 1 1)
         (gl-translate 50 150 0) ;;kk
         (bbox-rect bbox)
         (let1 string (number->string (- (~ bbox 4 ) (~ bbox 6)))
           (glc-enable GLC_HINTING_QSO)
           (glc-scale 0.15 0.15)
           (glc-measure-string GL_FALSE string)
           (glc-get-string-metric! GLC_BOUNDS bbox2)
           (gl-color 1 1 1)
           (bbox-caption-box-above bbox :size 40 :margin 10)
           (gl-load-identity)
           (gl-raster-pos (+ (* 0.5 (- (~ bbox 4) (~ bbox 6) (- (~ bbox2 4) (~ bbox2 6))))
                             object-x)
                          (+ (~ bbox 7) 183))
           (glc-render-string string))

         (glc-scale 2 2)
         (glc-measure-string GL_FALSE "GL_BITMAP")
         (glc-get-string-metric! GLC_BOUNDS bbox2)
         (gl-raster-pos  (+ (* 0.5 (- (~ bbox 2) (~ bbox 0) (- (~ bbox2 2) (~ bbox2 0))))
                            object-x)
                         300)
         (glc-render-string "GL_BITMAP")
         (glc-disable GLC_HINTING_QSO)

       ;;;; Render GLC_TEXTURE with kerning

         (gl-load-identity)
         (glc-render-style GLC_TEXTURE)
         (gl-color 1 0 0)
         (gl-scale 100 100 1)
         (gl-translate 3 1.5 0)
         (gl-push-matrix)
         (glc-render-string "VAV")
         (gl-pop-matrix)
         (glc-measure-string GL_TRUE "VAV")
         (glc-get-string-char-metric! 1 GLC_BOUNDS bbox)
         (gl-color 0 1 0)
         (bbox-rect bbox)
         (glc-get-string-metric! GLC_BOUNDS bbox)
         (gl-color 0 1 1)
         (bbox-rect bbox)
         (let1 string (number->string (* 100 (- (~ bbox 4) (~ bbox 6))))
           (glc-enable GLC_HINTING_QSO)
           (glc-measure-string GL_FALSE string)
           (glc-get-string-metric! GLC_BOUNDS bbox2)
           (gl-color 1 1 1)
           (bbox-caption-box-above bbox :size 0.4 :margin 0.1)
           (gl-push-matrix)
           (gl-translate (* 0.5 (- (~ bbox 4) (~ bbox 6) (* 0.15(- (~ bbox2 4) (~ bbox2 6)))))
                         (+ (~ bbox 5) 0.33)
                         0)
           (gl-scale 0.15 0.15 1)
           (glc-render-string string))
         (gl-pop-matrix)
         (glc-measure-string GL_FALSE "GL_TEXTURE")
         (glc-get-string-metric! GLC_BOUNDS bbox2)
         (gl-translate (* 0.5 (- (~ bbox 2) (~ bbox 0) (* 0.3 (- (~ bbox2 2) (~ bbox2 0)))))
                       1.5 0)
         (gl-scale 0.3 0.3 1)
         (glc-render-string "GLC_TEXTURE")))
     (let1 image (gl-pixels->image (load-pixels) *width* *height*)
       (save-image image "foo.png")))
   :bg (cut background 0 0 0)))

(define main
  (setup$ (lambda ()
            (window 640 400 "quesoglc Test12" 100 100)
            (gl-enable GL_TEXTURE_2D)
            (let1 ctx (glc-gen-context)
              (glc-context ctx)
              (glc-disable GLC_GL_OBJECTS)
              (let1 myfont (glc-gen-font-id)
                ;;(glc-new-font-from-family myfont "Utopia")
                (glc-new-font-from-family myfont "Symbol")
                (glc-font myfont)
                (glc-render-style GLC_BITMAP))))
          :draw draw
          :reshape (2d-reshape$ :style :gl)))

(main '())