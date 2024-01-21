#! /bin/bash

cwd=`dirname \`realpath "$0"\``

sbcl --core $cwd/cl-ppcre.core --script $cwd/metacode.lisp $@ 3>&1 1>&2 2>&3 | sed -z "s/Backtrace.*/ /g"
