;;------------------------------------
;; LTM Model 2
;;------------------------------------
;;

;; This model relies only on storage and retrieval of memory of past experience
;; with stimuli and associated response.
;; It relies on three parameters: memory decay(BLL), activation noise(ANS) and
;; and base level activation (bll)
;; Important features: Stiumulus, associate-key and feedback

;;------------------------------------
;; Change log
;;------------------------------------
;; 03/30/20TMH updated commit-to-memory production to match integrated-model.lisp
;;            - Added parse-feedback-yes and parse-feedback-no productions
;;            - Enabled subsymbolic computations
;;            - Minor modifications to encode-feedback and commit-to-memory productions
;;            - Added parse-feedback-test productions
;;
;;------------------------------------




(clear-all)

(define-model LTM_model_wpt

(sgp ;;:bll 0.
     ;;:ans nil
     ;; :rt  0.5  ;; Not needed
     :er  t
     :v nil
     :esc t
     :mas 8.0
     ;:visual-activation 5.0
     )

;;---------------------------------------
;; Chunk types
;;---------------------------------------

(chunk-type goal
            responded ;; Whether a response was chosen or not
            fproc)    ;; fproc= feedback processed

(chunk-type stimulus
            card1
            card2
            card3
            associated-key
            outcome
            )

(chunk-type feedback
            feedback)

;;---------------------------------------
;; Chunks
;;---------------------------------------

;;(add-dm (yes isa chunk)
 ;;       (no  isa chunk)
   ;;     (make-response isa       goal
     ;;                  responded no
       ;;                fproc     yes)
        ;)


;;----------------------------------------
;; productions
;;----------------------------------------
   ;; Check memory: picture cur_pic, current picture presented is a variable.
   ;; This is a general purpose production that just takes in whatever presented stimulus
   ;; and checks against declarative memory in the retrieval buffer

;;  card1 =cur_pic1
    ;; card2 =cur_pic2
     ;; card3 =cur_pic3

(p check-memory-s1
   =visual>
     card1 =cur_pic1
     card2 nil
     card3 nil

   ?visual>
     state free

   ?imaginal>
     state free
     buffer empty

   =goal>
     fproc yes

   ?retrieval>
     state free
   - buffer full
  ==>

   +retrieval>
      card1 =cur_pic1

      outcome yes

   +imaginal>
       card1 =cur_pic1


   =visual>
)


(p check-memory-s2
   =visual>
     card1 =cur_pic1
     card2 =cur_pic2
     card3 nil


   ?visual>
     state free

   ?imaginal>
     state free
     buffer empty

   =goal>
     fproc yes

   ?retrieval>
     state free
   - buffer full
  ==>

   +retrieval>
      card1 =cur_pic1

      outcome yes

   +imaginal>
       card1 =cur_pic1
       card2 =cur_pic2


   =visual>
)


(p check-memory-s3
   =visual>
     card1 =cur_pic1
     card2 =cur_pic2
     card3 =cur_pic3

   ?visual>
     state free

   ?imaginal>
     state free
     buffer empty

   =goal>
     fproc yes

   ?retrieval>
     state free
   - buffer full
  ==>

   +retrieval>
      card1 =cur_pic1
      card2 =cur_pic2
      card3 =cur_pic3

      outcome yes

   +imaginal>
       card1 =cur_pic1


   =visual>
)
;;-------------------------------------
;; Depending on outcome: yes or no (retrieval error):

   ;;outcome is no (retrieval error): make random response (3 possible)
;;-------------------------------------

    ;; modified =visual> -*check that buffer isn't empty* I hope this allows matching when atleast one of the slots is filled?
(p response-monkey-sun
  ?retrieval>
    state error

  ?imaginal>
    state free

  =imaginal>
    associated-key nil

  =goal>
    fproc yes

  =visual>
  - buffer empty

  ?manual>
    preparation free
    processor free
    execution free
==>
  +manual>
    cmd press-key
       key "s"

  =imaginal>
    associated-key s

  *goal>
    fproc no

  =visual>
  )

(p response-monkey-rain
  ?retrieval>
    state error

  =goal>
    fproc yes

  =visual>

  - buffer empty


  ?imaginal>
    state free

  =imaginal>
    associated-key nil

  ?manual>
    preparation free
    processor free
    execution free
==>
  +manual>
     cmd press-key
       key "r"

  =imaginal>
    associated-key r

  *goal>
    fproc no

  =visual>
  )




;;-------------------------------------
;;outcome is yes: make response based on memory
;;-------------------------------------

(p outcome-yes
  =retrieval>
    outcome yes
    associated-key =k

  =goal>
    fproc yes

  ?imaginal>
    state free

  =imaginal>
    associated-key nil

  ?manual>
    preparation free
    processor free
    execution free

==>

  +manual>
    cmd press-key
    key =k

  *imaginal>
    associated-key =k

  *goal>
    fproc no
)


;;Encode response after feedback

(p parse-feedback-yes
   =visual>
     feedback yes

   ?visual>
     state free

   =goal>
    fproc no
==>
   =visual>

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
   =visual>

   *goal>
     fproc yes
)

(p encode-feedback
   "Encodes the visual response"
  =visual>
    feedback =f

  ?imaginal>
    state free

  =goal>
    fproc yes

  =imaginal>
    outcome nil

==>
  *imaginal>
    outcome =f

  ;*goal>
   ; fproc yes

  =visual>
  )


(p commit-to-memory
   "Creates an episodic traces of the previous decision"
  =visual>
    feedback =f

  =goal>
    fproc  yes

  =imaginal>

  - outcome nil

==>

  -visual>
  -imaginal>
)



;;(p outcome-no-commit-to-memory

  ;;)

;;(goal-focus make-response)



;;(set-buffer-chunk 'visual 'cup-stimulus)

)
