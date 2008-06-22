#|

Author: Gary King

Code originally forked from Kevin Rosenberg's KMRCL and borrowed from
Alexander Repenning's Apple event code. It was then subjected to bursts
of gamma radiation and repeated does of the sonic screwdriver.
|#

(defpackage :trivial-shell-system (:use #:cl #:asdf))
(in-package :trivial-shell-system)

(defsystem trivial-shell
  :version "0.1.7"
  :author "Gary Warren King <gwking@metabang.com>"
  :maintainer "Gary Warren King <gwking@metabang.com>"
  :licence "MIT Style License"
  :description "OS and Implementation independent access to the shell"
  :components ((:module 
		"notes"
		:pathname "dev/"
		:components 
		((:static-file "notes.text")))
	       (:module 
		"timeout"
		:pathname "dev/"
		:components 
		((:file "with-timeout")))
	       (:module 
		"setup"
		:pathname "dev/"
		:depends-on ("timeout")
		:components 
		((:file "package")))
	       (:module 
		"dev"
		:depends-on ("setup")
		:components 
		((:file "definitions")
		 (:file "macros")
		 (:file "shell"
			:depends-on ("definitions" "macros" #+digitool "mcl"))))
	       (:module
		"port"
		:pathname "dev/"
		:depends-on ("dev")
		:components
		(
		 #+allegro
		 (:file "allegro")
		 #+clisp
		 (:file "clisp")
		 #+cmu
		 (:file "cmucl")
		 #+digitool
		 (:file "digitool")
		 #+lispworks
		 (:file "lispworks")
		 #+openmcl
		 (:file "openmcl")
		 #+sbcl
		 (:file "sbcl")

		 #-(or allegro clisp cmu digitool lispworks openmcl sbcl)
		 (:file "unsupported")                                     
		 #+digitool
		 (:module "mcl"
			  :components ((:file "eval-apple-script")))))
               (:module 
		"website"
		:components
		((:module "source"
			  :components ((:static-file "index.md"))))))
  :in-order-to ((test-op (load-op trivial-shell-test)))
  :perform (test-op :after (op c)
		    (funcall
		      (intern (symbol-name '#:run-tests) :lift)
		      :config :generic))
  :depends-on ())

(defmethod operation-done-p 
           ((o test-op)
            (c (eql (find-system 'trivial-shell))))
  (values nil))


