;; old

(define-module gl.processing.text
  (use gl.processing.core)
  (export text))
(select-module gl.processing.text)

(define *space*
  '#u8(#x00 #x00 #x00 #x00 #x00 #x00 #x00 #x00 #x00 #x00 #x00 #x00 #x00))

(define *letters*
  '#(#u8(#x00 #x00 #xc3 #xc3 #xc3 #xc3 #xff #xc3 #xc3 #xc3 #x66 #x3c #x18)
        #u8(#x00 #x00 #xfe #xc7 #xc3 #xc3 #xc7 #xfe #xc7 #xc3 #xc3 #xc7 #xfe)
        #u8(#x00 #x00 #x7e #xe7 #xc0 #xc0 #xc0 #xc0 #xc0 #xc0 #xc0 #xe7 #x7e)
        #u8(#x00 #x00 #xfc #xce #xc7 #xc3 #xc3 #xc3 #xc3 #xc3 #xc7 #xce #xfc)
        #u8(#x00 #x00 #xff #xc0 #xc0 #xc0 #xc0 #xfc #xc0 #xc0 #xc0 #xc0 #xff)
        #u8(#x00 #x00 #xc0 #xc0 #xc0 #xc0 #xc0 #xc0 #xfc #xc0 #xc0 #xc0 #xff)
        #u8(#x00 #x00 #x7e #xe7 #xc3 #xc3 #xcf #xc0 #xc0 #xc0 #xc0 #xe7 #x7e)
        #u8(#x00 #x00 #xc3 #xc3 #xc3 #xc3 #xc3 #xff #xc3 #xc3 #xc3 #xc3 #xc3)
        #u8(#x00 #x00 #x7e #x18 #x18 #x18 #x18 #x18 #x18 #x18 #x18 #x18 #x7e)
        #u8(#x00 #x00 #x7c #xee #xc6 #x06 #x06 #x06 #x06 #x06 #x06 #x06 #x06)
        #u8(#x00 #x00 #xc3 #xc6 #xcc #xd8 #xf0 #xe0 #xf0 #xd8 #xcc #xc6 #xc3)
        #u8(#x00 #x00 #xff #xc0 #xc0 #xc0 #xc0 #xc0 #xc0 #xc0 #xc0 #xc0 #xc0)
        #u8(#x00 #x00 #xc3 #xc3 #xc3 #xc3 #xc3 #xc3 #xdb #xff #xff #xe7 #xc3)
        #u8(#x00 #x00 #xc7 #xc7 #xcf #xcf #xdf #xdb #xfb #xf3 #xf3 #xe3 #xe3)
        #u8(#x00 #x00 #x7e #xe7 #xc3 #xc3 #xc3 #xc3 #xc3 #xc3 #xc3 #xe7 #x7e)
        #u8(#x00 #x00 #xc0 #xc0 #xc0 #xc0 #xc0 #xfe #xc7 #xc3 #xc3 #xc7 #xfe)
        #u8(#x00 #x00 #x3f #x6e #xdf #xdb #xc3 #xc3 #xc3 #xc3 #xc3 #x66 #x3c)
        #u8(#x00 #x00 #xc3 #xc6 #xcc #xd8 #xf0 #xfe #xc7 #xc3 #xc3 #xc7 #xfe)
        #u8(#x00 #x00 #x7e #xe7 #x03 #x03 #x07 #x7e #xe0 #xc0 #xc0 #xe7 #x7e)
        #u8(#x00 #x00 #x18 #x18 #x18 #x18 #x18 #x18 #x18 #x18 #x18 #x18 #xff)
        #u8(#x00 #x00 #x7e #xe7 #xc3 #xc3 #xc3 #xc3 #xc3 #xc3 #xc3 #xc3 #xc3)
        #u8(#x00 #x00 #x18 #x3c #x3c #x66 #x66 #xc3 #xc3 #xc3 #xc3 #xc3 #xc3)
        #u8(#x00 #x00 #xc3 #xe7 #xff #xff #xdb #xdb #xc3 #xc3 #xc3 #xc3 #xc3)
        #u8(#x00 #x00 #xc3 #x66 #x66 #x3c #x3c #x18 #x3c #x3c #x66 #x66 #xc3)
        #u8(#x00 #x00 #x18 #x18 #x18 #x18 #x18 #x18 #x3c #x3c #x66 #x66 #xc3)
        #u8(#x00 #x00 #xff #xc0 #xc0 #x60 #x30 #x7e #x0c #x06 #x03 #x03 #xff)
        ))

(define *font-offset* 0)

(define (make-raster-font)
  (gl-pixel-store GL_UNPACK_ALIGNMENT 1)
  (set! *font-offset* (gl-gen-lists 128))
  (dotimes (i 26)
    (gl-new-list (+ *font-offset* i (char->integer #\A)) GL_COMPILE)
    (gl-bitmap 8 13 0.0 2.0 10.0 0.0 (ref *letters* i))
    (gl-end-list))
  (gl-new-list (+ *font-offset* (char->integer #\space)) GL_COMPILE)
  (gl-bitmap 8 13 0.0 2.0 10.0 0.0 *space*)
  (gl-end-list))

(define (print-string s)
  (gl-push-attrib GL_LIST_BIT)
  (gl-list-base *font-offset*)
  (gl-call-lists s)
  (gl-pop-attrib))

;; (define* (foo) :main (print ":foo") :initialize (print "init"))
(macroexpand
'(define* (text str x y)
  :initialize (make-raster-font)
  :main (begin
          (gl-color *fill-color*)
          (gl-raster-pos x y)
          (print-string str)))
)
