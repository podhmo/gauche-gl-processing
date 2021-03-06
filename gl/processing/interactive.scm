(define-module gl.processing.interactive
  (use gauche.threads)
  (use gl.processing.window)
  (extend gl.processing.core)
  (export-all))

(select-module user)

(define draw-update? #f)
(define draw #f)

(define update-timer 
  (timer$ (^v (when draw-update?
                (format (current-error-port) "draw is update")
                (set! draw-update? #f))
              (draw))))

(define-macro (redraw . actions)
  `(begin
     (set! draw
           (draw-once$ (^ () ,@actions)))
     (set! draw-update? #t)))

(define setup-with-other-thread
  (let1 done? #f
    (lambda (thunk 
             :key (reshape 2d-reshape) 
             (draw %default-draw-function) 
             (keyboard keyboard-esc-or-q-end) 
             (mouse #f))
      (unless done? (set! done? #t)
              (with-module user
                (use gauche.threads)
                (let1 %main (setup$ thunk
                                    :reshape reshape 
                                    :draw draw
                                    :keyboard keyboard
                                    :mouse mouse)
                  (thread-start! (make-thread (cut %main '())))))))))

