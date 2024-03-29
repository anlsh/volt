(in-package :volt)

(defmacro sethash ((key val) table)
  `(setf (gethash ,key ,table) ,val))

(defmacro put-if-absent (key val table)
  (alx:once-only (key table)
    `(unless (second (multiple-value-list (gethash ,key ,table)))
       (sethash (,key ,val) ,table))))


(defmacro imp (imports &rest body)
  ;; Imports has form
  ;;     (package-name (symbol-to-import | symbol-to-import nickname)*)*
  ;;
  ;; Wilcard imports are bad and I'm not going to support them.
  ;; TODO Local package nicknames though, would be *incredibly* nice

  (labels ((validate-pkgimport (pkg-import)
             (unless (listp pkg-import) (error "Each pkg-import spec must be a list"))
             (unless (listp (cdr pkg-import)) (error "The cdr must also be a list"))
             (unless (symbolp (car pkg-import))
               (error (format nil "The car of ~a must be a symbol giving a package name"
                              pkg-import)))
             (mapcar #'validate-symspecs (cdr pkg-import)))
           (validate-symspecs (symspec)
             (or (symbolp symspec)
                 (and (listp symspec) (equalp (length symspec) 2)
                      (symbolp (car symspec)) (symbolp (cadr symspec)))
                 (error (format nil "Malformed symbol spec ~a" symspec)))))
    (mapcar #'validate-pkgimport imports))

  ;; TODO This logic does not let you import the "*" symbol nicely
  (let ((replacement-map (fset:empty-map)))
    (arrow-macros:-<> imports
      (mapcar (lambda (pkg-spec)
                (let ((pkg-name (car pkg-spec)))
                  (mapcar (lambda (sym-spec)
                            (if (symbolp sym-spec)
                                (list sym-spec
                                      (find-symbol (symbol-name sym-spec)
                                                   pkg-name))
                                (list (cadr sym-spec)
                                      (find-symbol (symbol-name (car sym-spec))
                                                   pkg-name))))
                          (cdr pkg-spec))))
              arrow-macros:<>)
      (apply #'append arrow-macros:<>)
      (mapcar (lambda (x) (fset:adjoinf replacement-map (car x) (cadr x)))
              arrow-macros:<>))
    (labels ((replace-symbols (x)
               (cond ((listp x) (mapcar #'replace-symbols x))
                     ((symbolp x) (multiple-value-bind (new-sym in?) (fset:@ replacement-map x)
                                    (if in? new-sym x)))
                     (t x))))
      `(progn ,@(replace-symbols body)))))
