;;;; volt.asd

(asdf:defsystem #:volt
  :description "Describe volt here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :components ((:file "package")
               (:file "utils" :depends-on ("package"))
               (:file "macros" :depends-on ("package"))
               (:file "reader-macros" :depends-on ("package"))))
