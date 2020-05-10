;;;; volt.asd

(asdf:defsystem #:volt
  :description "Updating Common Lisp"
  :author "Anish Moorthy <anlsh@protonmail.com>"
  :license  "Public Domain"
  :version "0.0.1"
  :serial t
  :depends-on
  (
   :alexandria
   :generic-cl
   :named-readtables
   )
  :components ((:file "package")
               (:file "utils" :depends-on ("package"))
               (:file "macros" :depends-on ("package"))
               (:file "reader-macros" :depends-on ("package"))))
