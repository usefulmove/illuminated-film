(define (script-fu-add-grain-fp4plus image drawable)
  (let* ((width (car (gimp-image-get-width image)))
         (height (car (gimp-image-get-height image)))
         (current-layer drawable)
         (copy-layer (car (gimp-layer-copy current-layer TRUE)))
         (noise-layer (car (gimp-layer-new image
                                           "Grain (FP4+)"
                                           width
                                           height
                                           RGB-IMAGE 
                                           72.0
                                           LAYER-MODE-GRAIN-MERGE))))
    ;; start an undo group
    (gimp-image-undo-group-start image)

    ;; copy layer and desaturate
    (gimp-image-insert-layer image copy-layer 0 -1)
    (gimp-item-set-name copy-layer "Desaturate")
    (gimp-drawable-desaturate copy-layer DESATURATE-LUMINANCE)

    ;; add grain layer
    (gimp-image-insert-layer image noise-layer 0 -1)
    (gimp-context-set-foreground '(128 128 128))
    (gimp-drawable-fill noise-layer FILL-FOREGROUND)

    ;; end undo group
    (gimp-image-undo-group-end image)

    ;; update all open displays to show changes
    (gimp-displays-flush)))

(script-fu-register
 "script-fu-add-grain-fp4plus"                  ; Procedure name
 "Add Grain (FP4+)"                             ; Menu label
 "Adds a FP4+ 125 film grain emulation layer"   ; Description
 "Duane Edmonds"                                ; Author
 "Duane Edmonds"                                ; Copyright
 "2025"                                         ; Date
 "*"                                            ; Image types (all)
 SF-IMAGE    "Image"    0
 SF-DRAWABLE "Drawable" 0
 )

(script-fu-menu-register "script-fu-add-grain-fp4plus"
                         "<Image>/Filters/Illuminated Film/Film Grain")
