(require :asdf)
(load "~/quicklisp/setup.lisp")
;;(ql:quickload :cl-ppcre) ;; run this if the REQUIRE fails
(require :cl-ppcre)

(defmacro defvars (&rest body) `(progn ,@(mapcar (lambda (x) `(defvar ,(nth 0 x) ,(nth 1 x))) body)))

(defvar *cli-args* (subseq (or #+CLISP *args*
                               #+SBCL *posix-argv*
                               #+CMU extensions:*command-line-words*)
                           1))

(format t "~a~%" *cli-args*)

(defun print-help ()
  (format t "~
metacode (c edition)
usage:
  metacode -i input -o output

arguments:
  -i path
    input file location (mandatory)
  -o path
    output file location (mandatory)
"))

(defvars (*file-contents* nil) (*snippets* nil) (*snippets-pos* nil) (*match-regex* "/\\*lisp\\*.*?\\*lisp\\*/") (*output-path* nil))

(let ((input-path nil))
  ;; parse args
  (macrolet ((multiarg (flag num &rest body)
               `(when (and (equal (nth i *cli-args*) ,flag) (>= (length *cli-args*) (+ i ,num))) ,@body)))
    (do ((i 0 (+ i 1)))
        ((= i (length *cli-args*)) nil)
      (multiarg "-i" 1 (setq input-path (nth (+ i 1) *cli-args*)))
      (multiarg "-o" 1 (setq *output-path* (nth (+ i 1) *cli-args*)))))
  
  (unless (and input-path *output-path*) ;; nothing else matters if there's no input/output file
    (print-help)
    (quit))
  
  (let ((input-file (open input-path)))
    (setq *file-contents* (let ((l nil) (end nil))
                            (do nil (end (reverse l))
                              (setq l (cons (read-line input-file nil) l))
                              (when (null (car l)) (setq l (cdr l)) (setq end t)))))))

(setq *file-contents* (format nil "~{~a<->~}" *file-contents*))

(defun replace-subseq (type orig-seq replace-seq start end)
  (concatenate type (subseq orig-seq 0 start) replace-seq (subseq orig-seq end (length orig-seq))))

(do () (nil nil)
  (setq *snippets-pos* (ppcre:all-matches *match-regex* *file-contents*))
  (setq *snippets* (substitute-if "" #'symbolp
                                  (mapcar (lambda (x) (eval (read-from-string x)))
                                          (mapcar (lambda (z) (let ((y (ppcre:regex-replace-all "<->" z (format nil "~%")))) (subseq y 7 (- (length y) 7))))
                                                  (ppcre:all-matches-as-strings *match-regex* *file-contents*)))))
  (if (and *snippets* *snippets-pos*)
      (setq *file-contents* (replace-subseq 'string *file-contents* (nth 0 *snippets*) (nth 0 *snippets-pos*) (nth 1  *snippets-pos*)))
      (return)))

(setq *file-contents* (ppcre:regex-replace-all "<->" *file-contents* (format nil "~%")))

(with-open-file (output-file *output-path*
                             :direction :output
                             :if-exists :supersede
                             :if-does-not-exist :create)
  (format output-file "~a" *file-contents*))
