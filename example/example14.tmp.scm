(use gl.processing)

;;; utlity
;; these function are not implemented yet.
;;mouse-clicked <fun>
;;mouse-dragged <fun>
;;mouse-moved <fun>
;;mouse-pressed <fun>
;;mouse-release <fun>

(define draw (draw$ (lambda ()
                      (when (eq? 'right *mouse-button*)
                        (background 0.7 0.7 0.7))
                      (if *mouse-pressed?* (fill 0 0 0) (fill 1 1 1))
                      (ellipse *mouse-x* *mouse-y* 80 80))
                    :clean #f))

(define main
  (setup$ (lambda ()
            (window 480 120 "mouse example" 100 100)
            (frame-rate! 100))
          :draw draw))

(main '())
