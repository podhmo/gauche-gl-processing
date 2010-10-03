(use gauche.experimental.lamb)
(use srfi-1)
(use gauche.experimental.ref)
(add-load-path "..")
(extend gl.processing)
(use gauche.uvector)
(use graphics.imlib2)
(use gl.glc)


(define (fonts) '("Symbol"))
;; (define (fonts) '("Times New Roman"))

(define-class <font> ()
  [(id :init-keyword :id)
   (family :init-keyword :family)
   (color :init-value '#f32(1.0 0 0))
   (name :init-keyword :name)])

(define (draw-font color str x y)
  (gl-color color)
  (gl-raster-pos x y)
  (glc-render-string str))

(define *id* #f)
(define (make-font name :optional (scale 15))
  (let1 id (glc-gen-font-id)
    (push! *id* id)
    (cond ((glc-new-font-from-family id name)
           (print name)
           (glc-font id)
           (glc-scale scale scale)
           (glc-append-font id)
           (rlet1 font (make <font> :id id :name name :family (glc-get-fontc id GLC_FAMILY))
             (push! *font-list* font)))
          (else #f))))

(define draw
  (draw-once$
   (lambda ()
     (let ((red '#f32(1.0 0 0))
           (blue '#f32(0 0 1.0))
           (y 20))
       (draw-font red "これは良い本です。" 20 y) (inc! y 20)
           (draw-font blue "This is a good book."  20 y) (inc! y 20)
           (draw-font red  "この辞書は良い。" 20 y) (inc! y 20)
           (draw-font blue "This dictionary is good."  20 y) (inc! y 20)
           (draw-font red "あの本はおもしろいですか？<br>—　いいえ，おもしろくありません。"  20 y) (inc! y 20)
           (draw-font blue  "Is that an interesting book? <br>— Yes, it is." 20 y) (inc! y 20)
           (draw-font red "これは正しくない。"  20 y) (inc! y 20)
           (draw-font blue  "This is not right." 20 y) (inc! y 20)
           (draw-font red "あれは本物の花ではない。"  20 y) (inc! y 20)
           (draw-font blue  "That is not a real flower." 20 y) (inc! y 20)
           (draw-font red "このスープはあまり美味しくない。"  20 y) (inc! y 20)
           (draw-font blue "This soup is not very tasty." 20 y) (inc! y 20)
           (draw-font red "これは塩ですか，それとも砂糖ですか？<br>—　砂糖です。"  20 y) (inc! y 20)
           (draw-font blue "Is this salt or sugar? <br>— It is sugar." 20 y) (inc! y 20)
           (draw-font red  "彼女はフランス人ですか，それともイタリア人ですか？<br>—フランス人です。" 20 y) (inc! y 20)
           (draw-font blue "Is she French or Italian? <br>— She is French."  20 y) (inc! y 20)
           (draw-font red  "あの男性は日本人ですか，それとも中国人ですか？<br>—　日本人です。"  20 y) (inc! y 20)
           (draw-font blue "Is that man Japanese or Chinese? <br>— He is Japanese." 20 y) (inc! y 20)
           (let1 image (gl-pixels->image (load-pixels) *width* *height*)
             (save-image image "foo.png"))
           ))
   :bg (cut background 0 0 0)))

(define *ctx* #f)
(define *font-list* '())

(define main
  (setup$ (lambda ()
            (window 580 400 "glc Tutorial" 0 0)
            (set! *ctx* (glc-gen-context))
            (glc-context *ctx*)
            (glc-string-type GLC_UTF8_QSO)
            (glc-enable GLC_HINTING_QSO)
            (glc-append-catalog "/home/nao/.fonts/afm")
            (dolist (name (fonts))  (make-font name)))
          :draw draw))


(use gauche.process)
(define (font-candidate path)
  (when (file-exists? "/bin/grep")
    (let1 r (process-output->string-list
             `(grep --no-filename "^FamilyName" ,@(glob #`",|path|/*.afm")))
      (delete-duplicates
       (map (^x ((#/^FamilyName\s+(.+)$/ x) 1))
            r)))))

(define (fonts) (font-candidate "/home/nao/.fonts/afm"))
(main '())