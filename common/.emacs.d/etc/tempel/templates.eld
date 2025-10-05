;; Several of these templates are taken from tempel-collection:
;; https://github.com/Crandel/tempel-collection

fundamental-mode

(t (p (if (featurep 'hl-todo)
          (split-string (key-description nil hl-todo-keyword-faces))
        '("TODO" "FIXME" "NOTE" "REVIEW"))
      possible-todo-keywords noinsert)
   (completing-read "Keyword: " possible-todo-keywords) (just-one-space))
(d (format-time-string "%F"))
(td (p (if (equal major-mode 'emacs-lisp-mode) ";;" comment-start) comment-delimiter noinsert)
    (when (and comment-delimiter (not (nth 4 (syntax-ppss))))
      (concat (string-trim-right comment-delimiter)))
    (just-one-space) (include t) (include d) ":" (just-one-space))

emacs-lisp-mode

(al & ";;;###autoload")
(adv "(defun " (p "adv" name) " (&rest app)" n> p n> "(apply app))" n>
     "(advice-add #'" (p "fun") " " (p ":around") " #'" (s name) ")")
(prv "(provide '" (file-name-base (or (buffer-file-name) (buffer-name))) ")" n
     ";;;" (file-name-nondirectory (or (buffer-file-name) (buffer-name))) " ends here" n)
(lg "(message \"LOG %s " (s sexp) ": %S"
    "\" (format-time-string \"%X\") " sexp ")")
(dv "(defvar " p "\n  \"" p "\")")
(dc "(defcustom " p "\n  \"" p "\"" n> ":type '" p ")")
(df "(defface " p " '((t :inherit " p "))\n  \"" p "\")")
(dg "(defgroup " p " nil\n  \"" p "\"" n> ":group '" p n> ":prefix \"" p "-\")")
(dm "(defmacro " p " (" p ")\n  \"" p "\"" n> r> ")")
(da "(defalias '" p " '" p ")")
(dfn "(defun " p " (" p ")\n  \"" p "\"" n> r> ")")
(package-header ";;;" (p (file-name-base (or (buffer-file-name) (buffer-name))) file) ".el --- " (p "summary" summary) " -*- lexical-binding: t -*-" n n

                ";; Author:" (p (user-full-name)) n
                ";; Version:" (p "version") n
                ";; Package-Requires:" (p "dependencies") n
                ";; Homepage:" (p "homepage") n
                ";; Keywords:" (p "keywords") n n

                ";; This file is not part of GNU Emacs" n n

                (p (concat
                    ";; This program is free software: you can redistribute it and/or modify\n"
                    ";; it under the terms of the GNU General Public License as published by\n"
                    ";; the Free Software Foundation, either version 3 of the License, or\n"
                    ";; (at your option) any later version.\n\n"

                    ";; This program is distributed in the hope that it will be useful,\n"
                    ";; but WITHOUT ANY WARRANTY; without even the implied warranty of\n"
                    ";; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n"
                    ";; GNU General Public License for more details.\n\n"

                    ";; You should have received a copy of the GNU General Public License\n"
                    ";; along with this program.  If not, see <https://www.gnu.org/licenses/>."))

                n n

                ";;; Commentary:" n n

                ";;" (p "commentary") n n

                ";;; Code:" n n

                (p "(message \"Hello, World\")") n n

                "(provide '" (s file) ")" n
                ";;;" (s file) ".el ends here")


(s "(setq " p ")")
(sl "(setq-local " p ")")
(l "(let ((" p "))" n> q ")")
(it "(lambda (" (p "it") ")" n> q ")")

(i "(if " q ")")
(w "(when " q ")")
(u "(unless " q ")")
(wh "(while " p n> q ")")
(c "(cond" n> "(" q ")" n> ")")
(wl "(when-let* ((" p "))" n> q ")")
(il "(if-let* ((" p "))" n> q ")")
(cc "(condition-case err" n> p n> "(err " q "))")

(p "(progn" n> q ")")
(p1 "(prog1 " p n> q ")")
(ie "(ignore-errors" n> q ")")

(dl "(dolist (" p ")" n> q ")")

(pc "(pcase " q n> ")")
(pce "(pcase-exhaustive " q n> ")")
(pdl "(pcase-dolist (" p ")" n> q ")")
(pl "(pcase-let (" p ")" n> q ")")
(pla "(pcase-lambda (" p ")" n> q ")")

(v "(defvar " (p "NAME") " " (p "VALUE") ")")
(dc "(defconst " (p "NAME") " " (p "VALUE") ")")
(d "(defun " (p "NAME") " (" p ")" n> q ")")
(dm "(defmacro " (p "NAME") " (" p ")" n> q ")")
(da "(define-advice " (p "TARGET-FN") " (:" (p "WHERE" where) " ("
    ;; Generate arg-list based on advice type.
    (pcase where
      ("around"
       "fn &rest args")
      ("filter-return"
       "result")
      (_ "&rest args"))

    ") " (p "NAME") ")" n> q ")")
(ert "(ert-deftest " (p "NAME") " (" p ")" n> q ")")

(atl "(add-to-list '" q ")")
(as "(cl-assert " p " t " "\"" p "\")")

(a "(with-eval-after-load '" (p "FEATURE") n> q ")")
(se "(save-excursion" n> q ")")
(ewc "(eval-when-compile" n> q ")")
(eac "(eval-and-compile" n> q ")")
(r "(require '" q ")")
(al "(autoload '" (p "IDENT" sym) " "
    "\""
    (if-let* ((file (symbol-file (if (stringp sym) (intern sym) sym))))
        (file-name-sans-extension (file-name-nondirectory file))
      "FEAT")
    "\")")

(lbp "(line-beginning-position)")
(lep "(line-end-position)")
(pt "(point)")
(pm "(point-min)")
(pM "(point-max)")
(wcb "(with-current-buffer " p n> q ")")
(bs "(buffer-substring " q ")")
(bsl "(buffer-substring (line-beginning-position) (line-end-position))")

(m "(message \"" p "\" " q ")")

(up "(use-package " q ")")
(in "(interactive)")
(gc "(goto-char " q ")")
(ah "(add-hook '" (p "HOOK") " " (p "FN") q ")")

fundamental-mode ;; Available everywhere

(today (format-time-string "%Y-%m-%d")
       :ann "Today's date"
       :doc "Insert today's date")

prog-mode

(fixme (if (derived-mode-p 'emacs-lisp-mode) ";; " comment-start) "FIXME ")
(todo (if (derived-mode-p 'emacs-lisp-mode) ";; " comment-start) "TODO ")
(bug (if (derived-mode-p 'emacs-lisp-mode) ";; " comment-start) "BUG ")
(hack (if (derived-mode-p 'emacs-lisp-mode) ";; " comment-start) "HACK ")

latex-mode

(abstract "\\begin{abstract}\n" r> n> "\\end{abstract}")
(align "\\begin{align}\n" r> n> "\\end{align}")
(alignn "\\begin{align*}\n" r> n> "\\end{align*}")
(gather "\\begin{gather}\n" r> n> "\\end{gather}")
(gatherr "\\begin{gather*}\n" r> n> "\\end{gather*}")
(appendix "\\begin{appendix}\n" r> n> "\\end{appendix}")
(begin "\\begin{" (s env) "}" r> n> "\\end{" (s env) "}")
(center "\\begin{center}\n" r> n> "\\end{center}")
(displaymath "\\begin{displaymath}\n" r> n> "\\end{displaymath}")
(document "\\begin{document}\n" r> n> "\\end{document}")
(enumerate "\\begin{enumerate}\n\\item " r> n> "\\end{enumerate}")
(equation "\\begin{equation}" r> n> "\\end{equation}")
(flushleft "\\begin{flushleft}" r> n> "\\end{flushleft}")
(flushright "\\begin{flushright}" r> n> "\\end{flushright}")
(frac "\\frac{" p "}{" q "}")
(fussypar "\\begin{fussypar}" r> n> "\\end{fussypar}")
(itemize "\\begin{itemize}\n\\item " r> n> "\\end{itemize}")
(letter "\\begin{letter}\n" r> n> "\\end{letter}")
(math "\\begin{math}\n" r> n> "\\end{math}")
(minipage "\\begin{minipage}[t]{0.5\linewidth}\n" r> n> "\\end{minipage}")
(quotation "\\begin{quotation}\n" r> n> "\\end{quotation}")
(quote "\\begin{quote}\n" r> n> "\\end{quote}")
(sloppypar "\\begin{sloppypar}\n" r> n> "\\end{sloppypar}")
(theindex "\\begin{theindex}\n" r> n> "\\end{theindex}")
(trivlist "\\begin{trivlist}\n" r> n> "\\end{trivlist}")
(verbatim "\\begin{verbatim}\n" r> n> "\\end{verbatim}")
(verbatimm "\\begin{verbatim*}\n" r> n> "\\end{verbatim*}")
(matrix (p (read-number "Rows: ") rows noinsert)
        (p (read-number "Cols: ") cols noinsert)
        "\\begin{" (p "pmatrix" type) "}" n
        (* (1- rows) (p " ") (* (1- cols) " & " (p " ")) "\\\\" n)
        (p " ") (* (1- cols) " & " (p " ")) n
        "\\end{" type "}")

texinfo-mode

(defmac "@defmac " p n> r> "@end defmac")
(defun "@defun " p n> r> "@end defun")
(defvar "@defvar " p n> r> "@end defvar")
(example "@example " p n> r> "@end example")
(lisp "@lisp " p n> r> "@end lisp")
(bullet "@itemize @bullet{}" n> r> "@end itemize")
(code "@code{" p "}")
(var "@var{" p "}")

lisp-mode emacs-lisp-mode ;; Specify multiple modes

(lambda "(lambda (" p ")" n> r> ")")

emacs-lisp-mode

(autoload ";;;###autoload")
(pt "(point)")
(var "(defvar " p "\n  \"" p "\")")
(local "(defvar-local " p "\n  \"" p "\")")
(const "(defconst " p "\n  \"" p "\")")
(custom "(defcustom " p "\n  \"" p "\"" n> ":type '" p ")")
(face "(defface " p " '((t :inherit " p "))\n  \"" p "\")")
(group "(defgroup " p " nil\n  \"" p "\"" n> ":group '" p n> ":prefix \"" p "-\")")
(macro "(defmacro " p " (" p ")\n  \"" p "\"" n> r> ")")
(alias "(defalias '" p " '" p ")")
(fun "(defun " p " (" p ")\n  \"" p "\"" n> r> ")")
(iflet "(if-let (" p ")" n> r> ")")
(whenlet "(when-let (" p ")" n> r> ")")
(whilelet "(while-let (" p ")" n> r> ")")
(andlet "(and-let* (" p ")" n> r> ")")
(cond "(cond" n "(" q "))" >)
(pcase "(pcase " (p "scrutinee") n "(" q "))" >)
(let "(let (" p ")" n> r> ")")
(lett "(let* (" p ")" n> r> ")")
(pcaselet "(pcase-let (" p ")" n> r> ")")
(pcaselett "(pcase-let* (" p ")" n> r> ")")
(rec "(letrec (" p ")" n> r> ")")
(dotimes "(dotimes (" p ")" n> r> ")")
(dolist "(dolist (" p ")" n> r> ")")
(loop "(cl-loop for " p " in " p " do" n> r> ")")
(command "(defun " p " (" p ")\n  \"" p "\"" n> "(interactive" p ")" n> r> ")")
(advice "(defun " (p "adv" name) " (&rest app)" n> p n> "(apply app))" n>
        "(advice-add #'" (p "fun") " " (p ":around") " #'" (s name) ")")
(header ";;; " (file-name-nondirectory (or (buffer-file-name) (buffer-name)))
        " --- " p " -*- lexical-binding: t -*-" n
        ";;; Commentary:" n ";;; Code:" n n)
(provide "(provide '" (file-name-base (or (buffer-file-name) (buffer-name))) ")" n
         ";;; " (file-name-nondirectory (or (buffer-file-name) (buffer-name)))
         " ends here" n)
(package (i header) r n n (i provide))

markdown-mode

(s "```" p n q n "```")
(js "```javascript" p n q n "```")
(ts "```typescript" p n q n "```")
(sh "```sh" p n q n "```")

;; GitHub extensions
;;
;; See: https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax

(nb "> [!NOTE]" n "> " q)
(tip "> [!TIP]" n "> " q)
(imp "> [!IMPORTANT]" n "> " q)
(wa "> [!WARNING]" n "> " q)
(ca "> [!CAUTION]" n "> " q)

eshell-mode

(for "for " (p "i") " in " p " { " q " }")
(while "while { " p " } { " q " }")
(until "until { " p " } { " q " }")
(if "if { " p " } { " q " }")
(ife "if { " p " } { " p " } { " q " }")
(unl "unless { " p " } { " q " }")
(unle "unless { " p " } { " p " } { " q " }")

text-mode

(box "┌─" (make-string (length str) ?─) "─┐" n
     "│ " (s str)                       " │" n
     "└─" (make-string (length str) ?─) "─┘" n :doc "UNICODE BOX")
(abox "+-" (make-string (length str) ?-) "-+" n
      "| " (s str)                       " |" n
      "+-" (make-string (length str) ?-) "-+" n :doc "ASCII BOX")
(cut "--8<---------------cut here---------------start------------->8---" n r n
     "--8<---------------cut here---------------end--------------->8---" n)
(rot13 (p "plain text" text) n "----" n (rot13 text))
(calc (p "taylor(sin(x),x=0,3)" formula) n "----" n (format "%s" (calc-eval formula)))
(table (p (read-number "Rows: ") rows noinsert)
       (p (read-number "Cols: ") cols noinsert)
       "| " (p "  ") (* (1- cols) " | " (p "  ")) " |" n
       "|" (* cols "----|") n
       (* rows "| " (p "  ") (* (1- cols) " | " (p "  ")) " |" n))

rst-mode

(title (make-string (length title) ?=) n (p "Title: " title) n (make-string (length title) ?=) n)

java-mode

(class "public class " (p (file-name-base (or (buffer-file-name) (buffer-name)))) " {" n> r> n "}")

c-mode :when (re-search-backward "^\\S-*$" (line-beginning-position) 'noerror)

(inc "#include <" (p (concat (file-name-base (or (buffer-file-name) (buffer-name))) ".h")) ">")
(incc "#include \"" (p (concat (file-name-base (or (buffer-file-name) (buffer-name))) ".h")) "\"")

org-mode

(caption "#+caption: ")
(drawer ":" p ":" n r ":end:")
(begin "#+begin_" (s name) n> r> n "#+end_" name)
(quote "#+begin_quote" n> r> n "#+end_quote")
(sidenote "#+begin_sidenote" n> r> n "#+end_sidenote")
(marginnote "#+begin_marginnote" n> r> n "#+end_marginnote")
(example "#+begin_example" n> r> n "#+end_example")
(center "#+begin_center" n> r> n "#+end_center")
(ascii "#+begin_export ascii" n> r> n "#+end_export")
(html "#+begin_export html" n> r> n "#+end_export")
(latex "#+begin_export latex" n> r> n "#+end_export")
(comment "#+begin_comment" n> r> n "#+end_comment")
(verse "#+begin_verse" n> r> n "#+end_verse")
(src "#+begin_src " q n r n "#+end_src")
(gnuplot "#+begin_src gnuplot :var data=" (p "table") " :file " (p "plot.png") n r n "#+end_src" :post (org-edit-src-code))
(elisp "#+begin_src emacs-lisp" n r n "#+end_src" :post (org-edit-src-code))
(inlsrc "src_" p "{" q "}")
(title "#+title: " p n "#+author: " p n "#+language: " p n n)
;; Local Variables:
;; mode: lisp-data
;; outline-regexp: "[a-z]"
;; End:
