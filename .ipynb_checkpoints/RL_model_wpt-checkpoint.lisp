;;------------------------------------
;; WPT Model 1
;;------------------------------------
;;
;; This is a 'pure' reinforcement learning model of the Weather Prediction task (Knowlton();Li et al ().
;; The stimuli and response probabilities were adopted from Li et al().
;;
;;
;; This model has only two parameters: alpha(learningrate) and temperature(softmax function).
;;
;; The model has a few simple assumptions:
;; - cards that appear together are learned together - they are processed at the same time.
;; - cards are presented in different slots of the same chunk when pushed to the visual buffer.
;; - card order doesn't matter. I.e., a trial with "Triangle Square" is treated the same as "Square Triangle".
;;   This might matter for a human learner. For instance, a human might try to take order as a feature to predict outcome.


;; Stimulus is displayed --> processed --> disapears --> a response is selected --> feedback is given --> feedback is processed
;; For ease of computation/set-up stimuli are ordered alphabetically and placed into slots in that order; productions
;; similarly expect an alphabetic order when matching.
(clear-all)

(define-model RL_wpt_model

;; parameters - learning rate and temperature (expected gain s: amount of noise added to *utility*/selection), enable randomness (er)
    ;; ul: utility learning, *bll for the memory model*

(sgp :alpha 0.2
     :egs 0
     :er t
     :ul t
     :esc t
     :v nil
     )
;;--------------------------------------------------------
;;----------------Chunk types-----------------------------
(chunk-type goal
            fproc) ;; fproc= feedback processed

(chunk-type stimulus
            card1
            card2
            card3)

(chunk-type feedback
            feedback)

;;---------------------------------------
;; Chunks
;;---------------------------------------

    ;; Stimulus chunks

;; **add chunks for all images? These are added in the python interface**
;;(add-dm (cup-stimulus
     ;;   isa stimulus
      ;; picture cup)
       ;; )

;;(add-dm (bowl-stimulus
  ;;      isa stimulus
    ;;    picture bowl)
      ;;  )


    ;; Goal chunk
(add-dm (make-response
        isa goal
        fproc yes)
        )



;;-------------------------------------------------
;; Productions: 1 for each image : 2 conditions (ns 6 & ns 3) * 3 response keys
;;-------------------------------------------------


;;- visual, encode stimulus, check visual to see if its free,  make response (j, k or l)based on Q value, updates goal?.
;;  If never encountered, select arbitrarily


;;-------------------------------------------------
;;-------------cards: singles----------------------
;;-------------------------------------------------


;;-------------- Circle--------------
(p circle-sun
   =visual>
       card1 circle
       card2 nil
       card3 nil

   ?visual>
       state free
    =goal>
   fproc yes

   ?manual>
   preparation free
     processor free
     execution free
   ==>
   +manual>

       cmd press-key
       key "s"

   *goal>
       fproc no
   )


(p circle-rain
   =visual>
       card1 circle
       card2 nil
       card3 nil
   ?visual>
       state free
    =goal>
   fproc yes

   ?manual>
   preparation free
     processor free
     execution free
   ==>

   +manual>
       cmd press-key
       key "r"

   *goal>
       fproc no
   )

;;-------------- Diamond --------------
(p diamond-sun
   =visual>
       card1 diamond
       card2 nil
       card3 nil

   ?visual>
       state free
    =goal>
   fproc yes

   ?manual>
   preparation free
     processor free
     execution free
   ==>
   +manual>

       cmd press-key
       key "s"

   *goal>
       fproc no
   )


(p diamond-rain
   =visual>
       card1 diamond
       card2 nil
       card3 nil
   ?visual>
       state free
    =goal>
   fproc yes

   ?manual>
   preparation free
     processor free
     execution free
   ==>

   +manual>
       cmd press-key
       key "r"

   *goal>
       fproc no
   )

;;-------------- Square --------------

(p square-sun
   =visual>
       card1 square
       card2 nil
       card3 nil

   ?visual>
       state free
    =goal>
   fproc yes

   ?manual>
   preparation free
     processor free
     execution free
   ==>
   +manual>

       cmd press-key
       key "s"

   *goal>
       fproc no
   )


(p square-rain
   =visual>
       card1 square
       card2 nil
       card3 nil
   ?visual>
       state free
    =goal>
   fproc yes

   ?manual>
   preparation free
     processor free
     execution free
   ==>

   +manual>
       cmd press-key
       key "r"

   *goal>
       fproc no
   )

;;-------------- Triangle --------------
(p triangle-sun
   =visual>
       card1 triangle
       card2 nil
       card3 nil

   ?visual>
       state free
    =goal>
   fproc yes

   ?manual>
   preparation free
     processor free
     execution free
   ==>
   +manual>

       cmd press-key
       key "s"

   *goal>
       fproc no
   )


(p triangle-rain
   =visual>
       card1 triangle
       card2 nil
       card3 nil
   ?visual>
       state free
    =goal>
   fproc yes

   ?manual>
   preparation free
     processor free
     execution free
   ==>

   +manual>
       cmd press-key
       key "r"

   *goal>
       fproc no
   )


;;-------------------------------------------------
;;-------------cards: doubles----------------------
;;-------------------------------------------------

;;-------------- circle - diamond --------------
     (p circle-diamond-sun
   =visual>
       card1 circle
       card2 diamond
       card3 nil
   ?visual>
       state free
    =goal>
   fproc yes

   ?manual>
   preparation free
     processor free
     execution free
   ==>
   +manual>
       cmd press-key
       key "s"

   *goal>
       fproc no
   )


(p circle-diamond-rain
   =visual>
       card1 circle
       card2 diamond
       card3 nil
   ?visual>
       state free
    =goal>
   fproc yes

   ?manual>
   preparation free
     processor free
     execution free
   ==>
   +manual>
       cmd press-key
       key "r"

   *goal>
       fproc no
   )

;;-------------- circle - square --------------
     (p circle-square-sun
   =visual>
       card1 circle
       card2 square
       card3 nil
   ?visual>
       state free
    =goal>
   fproc yes

   ?manual>
   preparation free
     processor free
     execution free
   ==>
   +manual>
       cmd press-key
       key "s"

   *goal>
       fproc no
   )


(p circle-square-rain
   =visual>
       card1 circle
       card2 square
       card3 nil
   ?visual>
       state free
    =goal>
   fproc yes

   ?manual>
   preparation free
     processor free
     execution free
   ==>
   +manual>
       cmd press-key
       key "r"

   *goal>
       fproc no
   )

;;-------------- circle - triangle --------------
     (p circle-triangle-sun
   =visual>
       card1 circle
       card2 triangle
       card3 nil
   ?visual>
       state free
    =goal>
   fproc yes

   ?manual>
   preparation free
     processor free
     execution free
   ==>
   +manual>
       cmd press-key
       key "s"

   *goal>
       fproc no
   )


(p circle-triangle-rain
   =visual>
       card1 circle
       card2 triangle
       card3 nil
   ?visual>
       state free
    =goal>
   fproc yes

   ?manual>
   preparation free
     processor free
     execution free
   ==>
   +manual>
       cmd press-key
       key "r"

   *goal>
       fproc no
   )

;;-------------- diamond - square --------------
     (p diamond-square-sun
   =visual>
       card1 diamond
       card2 square
       card3 nil
   ?visual>
       state free
    =goal>
   fproc yes

   ?manual>
   preparation free
     processor free
     execution free
   ==>
   +manual>
       cmd press-key
       key "s"

   *goal>
       fproc no
   )


(p diamond-square-rain
   =visual>
       card1 diamond
       card2 square
       card3 nil
   ?visual>
       state free
    =goal>
   fproc yes

   ?manual>
   preparation free
     processor free
     execution free
   ==>
   +manual>
       cmd press-key
       key "r"

   *goal>
       fproc no
   )

;;-------------- diamond - triangle --------------
     (p diamond-triangle-sun
   =visual>
       card1 diamond
       card2 triangle
       card3 nil
   ?visual>
       state free
    =goal>
   fproc yes

   ?manual>
   preparation free
     processor free
     execution free
   ==>
   +manual>
       cmd press-key
       key "s"

   *goal>
       fproc no
   )


(p diamond-triangle-rain
   =visual>
       card1 diamond
       card2 triangle
       card3 nil
   ?visual>
       state free
    =goal>
   fproc yes

   ?manual>
   preparation free
     processor free
     execution free
   ==>
   +manual>
       cmd press-key
       key "r"

   *goal>
       fproc no
   )

;;-------------- square - triangle --------------
     (p square-triangle-sun
   =visual>
       card1 square
       card2 triangle
       card3 nil
   ?visual>
       state free
    =goal>
   fproc yes

   ?manual>
   preparation free
     processor free
     execution free
   ==>
   +manual>
       cmd press-key
       key "s"

   *goal>
       fproc no
   )


(p square-triangle-rain
   =visual>
       card1 square
       card2 triangle
       card3 nil
   ?visual>
       state free
    =goal>
   fproc yes

   ?manual>
   preparation free
     processor free
     execution free
   ==>
   +manual>
       cmd press-key
       key "r"

   *goal>
       fproc no
   )

;;-------------------------------------------------
;;-------------cards: triples ---------------------
;;-------------------------------------------------

;;-------------- circle - diamond  - square -------
     (p circle-diamond-square-sun
   =visual>
       card1 circle
       card2 diamond
       card3 square
   ?visual>
       state free
    =goal>
   fproc yes

   ?manual>
   preparation free
     processor free
     execution free
   ==>
   +manual>
       cmd press-key
       key "s"

   *goal>
       fproc no
   )


(p circle-diamond-square-rain
   =visual>
       card1 circle
       card2 diamond
       card3 square
   ?visual>
       state free
    =goal>
   fproc yes

   ?manual>
   preparation free
     processor free
     execution free
   ==>
   +manual>
       cmd press-key
       key "r"

   *goal>
       fproc no
   )


;;-------------- circle - diamond  - triangle -------
     (p circle-diamond-triangle-sun
   =visual>
       card1 circle
       card2 diamond
       card3 triangle
   ?visual>
       state free
    =goal>
   fproc yes

   ?manual>
   preparation free
     processor free
     execution free
   ==>
   +manual>
       cmd press-key
       key "s"

   *goal>
       fproc no
   )


(p circle-diamond-triangle-rain
   =visual>
       card1 circle
       card2 diamond
       card3 triangle
   ?visual>
       state free
    =goal>
   fproc yes

   ?manual>
   preparation free
     processor free
     execution free
   ==>
   +manual>
       cmd press-key
       key "r"

   *goal>
       fproc no
   )

;;-------------- diamond - square  - triangle -------
     (p diamond-square-triangle-sun
   =visual>
       card1 diamond
       card2 square
       card3 triangle
   ?visual>
       state free
    =goal>
   fproc yes

   ?manual>
   preparation free
     processor free
     execution free
   ==>
   +manual>
       cmd press-key
       key "s"

   *goal>
       fproc no
   )


(p diamond-square-triangle-rain
   =visual>
       card1 diamond
       card2 square
       card3 triangle
   ?visual>
       state free
    =goal>
   fproc yes

   ?manual>
   preparation free
     processor free
     execution free
   ==>
   +manual>
       cmd press-key
       key "r"

   *goal>
       fproc no
   )

;;-------------- circle - square  - triangle -------
     (p circle-square-triangle-sun
   =visual>
       card1 circle
       card2 square
       card3 triangle
   ?visual>
       state free
    =goal>
   fproc yes

   ?manual>
   preparation free
     processor free
     execution free
   ==>
   +manual>
       cmd press-key
       key "s"

   *goal>
       fproc no
   )


(p circle-square-triangle-rain
   =visual>
       card1 circle
       card2 square
       card3 triangle
   ?visual>
       state free
    =goal>
   fproc yes

   ?manual>
   preparation free
     processor free
     execution free
   ==>
   +manual>
       cmd press-key
       key "r"

   *goal>
       fproc no
   )




;;--------------------------------------------------------
;; Productions: processing feedback
;;--------------------------------------------------------

(p parse-feedback-yes
   =visual>
       feedback yes
   ?visual>
       state free
   =goal>
       fproc no
   ==>
   *goal>
       fproc yes
   )

 (p parse-feedback-no
   =visual>
       feedback no
   ?visual>
       state free
   =goal>
       fproc no
   ==>
   *goal>
       fproc yes
   )

(goal-focus
 make-response)

 (spp parse-feedback-yes :reward +1)
 (spp parse-feedback-no :reward -1)
;;(set-buffer-chunk 'visual 'cup-stimulus)


    )
