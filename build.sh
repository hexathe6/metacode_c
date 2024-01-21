#! /bin/bash

sbcl --non-interactive --eval '(progn (require :cl-ppcre) (sb-ext:save-lisp-and-die "./cl-ppcre.core"))'
