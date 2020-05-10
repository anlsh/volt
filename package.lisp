;;;; package.lisp

(defpackage #:volt
  (:use #:generic-cl)
  (:local-nicknames (#:alx #:alexandria) (#:nrt #:named-readtables) (#:gcl #:generic-cl) )
  (:export
   readtable
   sethash
   transpose
   put-if-absent
   set-contains
   set-add
   list-to-set))

(in-package :volt)
(nrt:defreadtable readtable (:merge :standard))
