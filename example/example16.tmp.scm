(use gl.processing)

(font-scale! 12)
(text-font! (load-font "Utopia" 12))
(with-simple-draw (100 100)
  (fill 255 255 255)
  (let1 s "The quick brown fox jumped over the lazy dog.";
    (text s 15 20 80 70)
    (no-fill!)))


(main '())
