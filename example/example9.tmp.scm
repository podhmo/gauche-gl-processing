(use srfi-1)
(use gauche.experimental.ref)
(add-load-path "..")
(extend gl.processing)
(use gauche.uvector)
(use graphics.imlib2)
(use gl.glc)


(define (fonts) '("Symbol"))
;; (define (fonts) '("Bitstream"  "Century"  "Computer"  "Courier"  "Dingbats"  "Euler"  "FreeEuro"  "Helvetica"  "ITC"  "LMMathExtension10"  "LMMathItalic10"  "LMMathItalic12"  "LMMathItalic5"  "LMMathItalic6"  "LMMathItalic7"  "LMMathItalic8"  "LMMathItalic9"  "LMMathSymbols10"  "LMMathSymbols5"  "LMMathSymbols6"  "LMMathSymbols7"  "LMMathSymbols8"  "LMMathSymbols9"  "LMMono10"  "LMMono12"  "LMMono8"  "LMMono9"  "LMMonoCaps10"  "LMMonoLt10"  "LMMonoLtCond10"  "LMMonoProp10"  "LMMonoPropLt10"  "LMMonoSlant10"  "LMRoman10"  "LMRoman12"  "LMRoman17"  "LMRoman5"  "LMRoman6"  "LMRoman7"  "LMRoman8"  "LMRoman9"  "LMRomanCaps10"  "LMRomanDemi10"  "LMRomanDunh10"  "LMRomanSlant10"  "LMRomanSlant12"  "LMRomanSlant17"  "LMRomanSlant8"  "LMRomanSlant9"  "LMRomanUnsl10"  "LMSans10"  "LMSans12"  "LMSans17"  "LMSans8"  "LMSans9"  "LMSansDemiCond10"  "LMSansQuot8"  "LOGO10"  "LOGO8"  "LOGO9"  "LOGOBF10"  "LOGOD10"  "LOGOSL10"  "LOGOSL8"  "LOGOSL9"  "LaTeX"  "Martin"  "New"  "Nimbus"  "Palatino"  "PazoMath"  "PazoMathBlackboardBold"  "Pxbex"  "Pxbexa"  "Pxbmia"  "Pxbsy"  "Pxbsya"  "Pxbsyb"  "Pxbsyc"  "Pxex"  "Pxexa"  "Pxmia"  "Pxsy"  "Pxsya"  "Pxsyb"  "Pxsyc"  "Rpcxb"  "Rpcxbi"  "Rpcxi"  "Rpcxr"  "Rpxb"  "Rpxbi"  "Rpxbmi"  "Rpxbsc"  "Rpxi"  "Rpxmi"  "Rpxr"  "Rpxsc"  "Standard"  "Symbol"  "TeX"  "Times"  "URW"  "Utopia"  "ZapfDingbats"  "rsfs10"  "rsfs5"  "rsfs7"  "rtcxb"  "rtcxbi"  "rtcxbss"  "rtcxi"  "rtcxr"  "rtcxss"  "rtxb"  "rtxbi"  "rtxbmi"  "rtxbsc"  "rtxbss"  "rtxbsssc"  "rtxi"  "rtxmi"  "rtxr"  "rtxsc"  "rtxss"  "rtxsssc"  "stmary10"  "stmary5"  "stmary6"  "stmary7"  "stmary8"  "stmary9"  "t1xbtt"  "t1xbttsc"  "t1xtt"  "t1xttsc"  "tcxbtt"  "tcxtt"  "txbex"  "txbexa"  "txbmia"  "txbsy"  "txbsya"  "txbsyb"  "txbsyc"  "txbtt"  "txbttsc"  "txex"  "txexa"  "txmia"  "txsy"  "txsya"  "txsyb"  "txsyc"  "txtt"  "txttsc"  "wasy10"  "wasy5"  "wasy6"  "wasy7"  "wasy8"  "wasy9"  "wasyb10"))

(define-class <font> ()
  [(id :init-keyword :id)
   (family :init-keyword :family)
   (color :init-value '#f32(1.0 0 0))
   (name :init-keyword :name)])

(define (draw-font font x y)
  (gl-color (~ font 'color))
  (gl-raster-pos x y)
  (glc-render-string "fooo"))
;  (glc-render-string (format #f "Hello World! (~a)" (~ font 'family))))

(define *id* #f)
(define (make-font name :optional (scale 5))
  (let1 id (glc-gen-font-id)
    (push! *id* id)
    (cond ((glc-new-font-from-family id name)
           (glc-font id)
           (glc-scale scale scale)
           (rlet1 font (make <font> :id id :name name :family (glc-get-fontc id GLC_FAMILY))
             (push! *font-list* font)))
          (else #f))))

(define draw
  (draw-once$
   (lambda ()
     (glc-render-style GLC_BITMAP)
     (let1 y (- *height* 10)
       (dolist (font *font-list*)
         (draw-font font 20 y)
         (dec! y 20)))
     #?=(glc-get-error)
     (fill 1 1 1)
     (rect 20 50 (/. *width* 2) 30))))
;   :bg (cut background 0 0 0)))

(define *ctx* #f)
(define *font-list* '())

(define main
  (setup$ (lambda ()
            (window 800 800 "glc Tutorial"
            (set! *ctx* (glc-gen-context))
            (glc-context *ctx*)
            (glc-string-type GLC_UTF8_QSO)
            (glc-enable GLC_HINTING_QSO)
            (dolist (name (fonts))  (make-font name)))
          :draw draw))

(main '())