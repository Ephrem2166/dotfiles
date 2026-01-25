;;; ef-org.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-

;;; Commentary:
;;; Code:
;;; Functions
(defun ef/org-mode-hooks ()
  "Various modes to run in org mode."
  (setq-default line-spacing 1)
  ;; Toggle automatic line breaking (Auto Fill mode).
  (auto-fill-mode)
  (visual-line-mode 1)
  (display-line-numbers-mode -1)
  (prettify-symbols-mode)
  (setq evil-auto-indent nil)
  (setq-local fill-column 120)
  (setq-local evil-auto-indent nil)
  ;; default `org-indent-line' inserts extra spaces at the beginning of lines
  (setq-local indent-line-function 'indent-relative)
  ;; It conflicts with org-modern block prettification
  ;; Use it with org-modern-indent
  ;; (org-indent-mode 1)
  ;; (truncate-lines 1)
  ;; (center-document-mode 1)
  (org-display-inline-images 1)
  ;; It messes with org-table
  ;; (variable-pitch-mode)
  ;; (lambda () (setq-local line-spacing 0.2 fill-column 100))
  ;; display wrapped lines instead of truncated lines
  (setq truncate-lines nil)
  (setq word-wrap t)
  ;; (toc-org-enable)
  ;; Prevent flickering when org indent is enabled
  (show-paren-mode nil)
  (abbrev-mode)
  )
(add-hook 'org-mode-hook #'ef/org-mode-hooks)


;;; Variable Pitch Mode
(defun my/enable-variable-pitch-mode ()
  "Enable variable-pitch-mode for relevant org-mode text."
  (variable-pitch-mode 1)
  (set-face-attribute 'variable-pitch nil
                      :family "Iosevka Aile"
                      :height 120)
  ;; keep code related stuff clean
  (dolist (face '(org-block
                  org-document-title
                  org-table
                  org-verbatim
                  org-drawer
                  org-date
                  org-code
                  org-block-begin-line
                  org-block-end-line
                  org-meta-line
                  org-document-info-keyword))
    (set-face-attribute face nil :inherit 'fixed-pitch)))

(add-hook 'org-mode-hook #'my/enable-variable-pitch-mode)

;;;; Org SRC Code Block in monospace font
(use-package org
  :ensure nil
  :config
  (defun my-adjoin-to-list-or-symbol (element list-or-symbol)
    (let ((list (if (not (listp list-or-symbol))
                    (list list-or-symbol)
                  list-or-symbol)))
      (require 'cl-lib)
      (cl-adjoin element list)))

  (eval-after-load "org"
    '(mapc
      (lambda (face)
        (set-face-attribute
         face nil
         :inherit
         (my-adjoin-to-list-or-symbol
          'fixed-pitch
          (face-attribute face :inherit))))
      (list 'org-code 'org-block
            ;; 'org-table 'org-block-background
            )))
  )

;;; Org General Settings
(use-package org
  :ensure nil
  :defer-incrementally (calendar find-func format-spec org-macs org-compat org-faces org-entities
                                 org-list org-pcomplete org-src org-footnote org-macro ob org org-agenda
                                 org-capture)
  :init
  (setq-default org-directory "~/Org/")
  :config
  ;; General Settings
  (setq org-imenu-depth 7)
  (setq org-startup-folded t)

  ;; Editing and Appearance
  (setq org-hide-leading-stars t)
  (setq org-hide-emphasis-markers t)

  ;;(setq org-odd-levels-only nil)
  (setq org-special-ctrl-a/e t)
  (setq org-special-ctrl-k nil)
  (setq org-return-follows-link t)
  ;; (setq org-blank-before-new-entry t)

  ;; Macro Replacement
  (setq org-hide-macro-markers t)

  ;; Leave an empty line between folded subtrees
  (setq org-cycle-separator-lines 1)

  ;; Some characters to choose from: …, ⤵, ▼, ↴, ⬎, ⤷, and ⋱
  (setq org-ellipsis "⮧")

  (setq org-insert-heading-respect-content t)
  (setq org-fold-catch-invisible-edits 'show)
  (setq org-M-RET-may-split-line '((default . nil)))

  (setq org-loop-over-headlines-in-active-region 'start-level)

  ;; Automatically change the list bullets when you change list levels
  (setq org-list-demote-modify-bullet '(("+" . "-")
                                        ("*" . "-")
                                        ("1." . "-")
                                        ("1)" . "-")
                                        ("A)" . "-")
                                        ("B)" . "-")
                                        ("a)" . "-")
                                        ("b)" . "-")
                                        ("A." . "-")
                                        ("B." . "-")
                                        ("a." . "-")
                                        ("b." . "-")))


  ;; (setq org-highlight-latex-and-related nil)
  (setq org-highlight-latex-and-related '(native))

  ;; Keywords
  (setq org-hidden-keywords nil)

  ;; Startup
  (setq org-startup-align-all-tables t)
  (setq org-startup-indented t)
  (setq org-startup-with-inline-images t)
  (setq org-startup-with-latex-preview nil)
  (setq org-startup-align-all-tables t)
  (setq org-startup-shrink-all-tables t)
  ;; Pretty
  (setq org-pretty-entities t)
  (setq org-pretty-entities-include-sub-superscripts nil)
  (setq org-use-sub-superscripts nil)
  ;; Image
  (setq org-image-actual-width 400)
  (setq org-image-align 'center)

  ;; Blank line before new entry
  (setq org-blank-before-new-entry
        '(
          (heading . t)
          (plain-list-item . auto)
          ))

  ;; Allow a, A, a) and A) as list elements
  (setq org-list-allow-alphabetical t)

  ;; Better lists
  (setq org-list-indent-offset 1)

  ;; Shift selct
  (setq org-support-shift-select 'always)

  )

;;; Org Faces
(use-package org-faces
  :ensure nil
  :config
  (setq org-priority-faces
        '((?A . error)
          (?B . warning)
          (?C . success)))
  (setq org-fontify-emphasized-text t)
  (setq org-fontify-todo-headline t)
  (setq org-fontify-done-headline t)
  (setq org-fontify-quote-and-verse-blocks t)
  (setq org-fontify-whole-heading-line t)
  (setq org-fontify-whole-block-delimiter-line t))


;;;  FIXME  Autoinsertion for Org
(use-package org
  :ensure nil
  :after org
  :config
  (define-auto-insert 'org-mode
    '(t
      "#+TITLE: " (read-string "Title: ") "\n"
      "#+AUTHOR: " (user-full-name) "\n"
      (if (y-or-n-p "Add Date? ") (concat "#+DATE: " (format-time-string "%Y-%m-%d") "\n"))
      ;; Startup options completion
      ;; "#+startup: " ((completing-read "Startup: " org-startup-options nil t) str " ") "\n"
      )    )

  )

;;; Org Num
;; (use-package org-num
;;   :ensure nil
;;   :custom
;;   (org-num-face 'fixed-pitch)
;;   (org-num-skip-commented t)
;;   (org-num-skip-footnotes t)
;;   (org-num-skip-unnumbered t))


                                        ;Org Indent
;; (use-package org
;;   :ensure nil
;;   :config
;;   (setq org-adapt-indentation nil)
;;   (setq org-indent-mode-turns-off-org-adapt-indentation nil)
;;   (setq org-indent-mode-turns-on-hiding-stars nil)
;;   (setq org-indent-indentation-per-level 2))

;;; Org Todo and Refile
(use-package org
  :ensure nil
  :config
  (setq org-refile-targets
        '((org-agenda-files . (:maxlevel . 2))
          (nil . (:maxlevel . 2))))
  (setq org-refile-use-outline-path t)
  (setq org-refile-allow-creating-parent-nodes 'confirm)
  (setq org-refile-use-cache t)
  (setq org-reverse-note-order nil)
  (setq org-fontify-done-headline nil)
  (setq org-fontify-todo-headline nil)
  (setq org-fontify-whole-heading-line nil)
  (setq org-enforce-todo-dependencies t)
  (setq org-enforce-todo-checkbox-dependencies t)
  )

;;; ORG TODO Appearance
(use-package org
  :ensure nil
  :config
  (setq org-todo-keywords
        '((sequence "TODO" "|" "IN-PROGRESS" "|" "DONE" "|" "CANCELED")
          (sequence "TOREAD" "|" "READ")
          (sequence "TOWATCH" "|" "WATCHED")
          ))

  (setq org-todo-keyword-faces
        '(("TODO" . "#BF616A")        ;; Polar Night Red
          ("NEXT" . "#D08770")
          ("IN-PROGRESS" . "#EBCB8B") ;; Nordic Yellow
          ("WAITING" . "#B48EAD")     ;; Nordic Purple
          ("HOLD" . "#4C566A")        ;; Dark Gray (Polar Night)
          ("DONE" . "#A3BE8C")        ;; Nordic Green
          ("CANCELED" . "#BF616A")
          ("DELEGATED" . "#81A1C1")   ;; Nordic Blue
          ("REVIEW" . "#88C0D0")      ;; Light Blue
          ("READ" . "#BF616A")
          ("WATCH" . "#BF616A")
          ("WATCHED" . "#A3BE8C")        ;; Nordic Green
          ("BLOCKED" . "#5E81AC"))
        )   ;; Deep Blue
  (setq org-use-fast-todo-selection t)
  )


;;; Org Structure Template List
;; A list of keys and block types
;; <s[TAB]
(use-package org
  :ensure nil
  :config
  (setq org-structure-template-alist
        '(("s" . "src")
          ("S" . "src sh")
          ("c" . "comment")
          ("C" . "center")
          ("v" . "verse")
          ("l" . "latex")
          ("e" . "src emacs-lisp")
          ("E" . "src emacs-lisp :results value code :lexical t")
          ("t" . "src emacs-lisp :tangle FILENAME")
          ("T" . "src emacs-lisp :tangle FILENAME :mkdirp yes")
          ("x" . "example")
          ("X" . "export")
          ("q" . "quote")))
  )

;;; Pretty Symbol List
(use-package org
  :ensure nil
  :config
  (setq-default prettify-symbols-alist '(
                                         ;; SRC CODE
                                         ("#+BEGIN_SRC" . "»")
                                         ("#+END_SRC" . "«")
                                         ("#+begin_src" . "»")
                                         ("#+end_src" . "«")
                                         ;; Quote
                                         ("#+begin_quote" . "")
                                         ("#+end_quote" . "―")
                                         ;; Greek Symbols
                                         ("delta"  . ?Δ)
                                         ("gamma"  . ?Γ)
                                         ("phi"    . ?φ)
                                         ("psi"    . ?ψ)
                                         ("lambda"  . "λ")
                                         ;; Arrow
                                         ("->" . "→")
                                         ("->>" . "↠")
                                        ; Agenda tags 
                                         (":@projects:"  . ?☕)
                                         (":work:"       . ?🚀)
                                         (":@inbox:"     . ?✉)
                                         (":goal:"       . ?🎯)
                                         (":task:"       . ?📋)
                                         (":@thesis:"    . ?📝)
                                         (":thesis:"     . ?📝)
                                         (":emacs:"      . ?)
                                         (":learn:"      . ?🌱)
                                         (":code:"       . ?💻)
                                         (":fix:"        . ?🛠)
                                         (":bug:"        . ?🚩)
                                         (":read:"       . ?📚)
                                        ; Drawers
                                         (":properties:" . ?)
                                        ; Agenda scheduling
                                         ("#+STARTUP:" . "")
                                         ("#+TITLE: " . "")
                                         ("#+title: " . "")
                                         ("#+RESULTS:" . "")
                                         ("#+NAME:" . "")
                                         ("#+ROAM_TAGS:" . "")
                                         ("#+FILETAGS:" . "")
                                         ("#+HTML_HEAD:" . "")
                                         ("#+SUBTITLE:" . "")
                                         ("#+AUTHOR:" . "")
                                         (":Effort:" . "")
                                         ("SCHEDULED:" . "")
                                         ("DEADLINE:" . "")
                                         ("SCHEDULED:"   . ?🕘)
                                         ("DEADLINE:"    . ?⏰)

                                         ))

  (setq prettify-symbols-unprettify-at-point 'right-edge))

;;; Org-archive
(use-package org-archive
  :ensure nil
  :custom
  (org-archive-subtree-save-file-p 'from-org)
  (org-archive-subtree-add-inherited-tags t))


;;; Org Custom Heading Faces
(use-package org
  :ensure nil
  :config
  ;; Org Mode Headings Fonts
  (custom-set-faces
   '(org-level-1 ((t (:inherit outline-1 :height 1.7))))
   '(org-level-2 ((t (:inherit outline-2 :height 1.6))))
   '(org-level-3 ((t (:inherit outline-3 :height 1.5))))
   '(org-level-4 ((t (:inherit outline-4 :height 1.4))))
   '(org-level-5 ((t (:inherit outline-5 :height 1.3))))
   '(org-level-6 ((t (:inherit outline-5 :height 1.2))))
   '(org-level-7 ((t (:inherit outline-5 :height 1.1)))))
  )

;;; Org Attach
;; The dispatcher for attachment commands
(use-package org-attach
  :ensure nil
  :after org
  :custom
  (org-attach-preferred-new-method 'id) ; Necessary to add the ATTACH tag
  (org-attach-auto-tag "ATTACH")       ; See `org-roam-db-node-include-function'
  (org-attach-dir-relative nil)        ; Use relative file paths?
  (org-attach-id-dir (expand-file-name "resources" org-directory))
  (org-attach-method 'cp)            ; Attach copies of files
  (org-attach-archive-delete 'query) ; If subtree is deleted or archived, ask user
  (org-attach-id-to-path-function-list
   '(org-attach-id-ts-folder-format
     org-attach-id-uuid-folder-format
     org-attach-id-fallback-folder-format)))

;;; Org Text Colors
(use-package org
  :ensure nil
  :config
  (setq org-emphasis-alist '(("*" (bold :foreground "#BF616a"))
                             ("/" (italic :foreground "#8aadf4"))
                             ("_" underline)
                             ("=" (:foreground "#a3be8c" :family "Berkeley Nerd Font"))
                             ("~" (:foreground "#d08770" :family "Berkeley Nerd Font"))
                             )))

;;; Org SRC Blocks
(use-package org
  :ensure nil
  :config
  (setq org-src-block-faces nil)
  (setq org-inline-src-prettify-results '("⟨" . "⟩"))
  (setq org-src-window-setup 'current-window)
  (setq org-src-fontify-natively t)
  (setq org-src-tab-acts-natively t)
  (setq org-src-preserve-indentation t)
  (setq org-edit-src-persistent-message nil)
  (setq org-edit-src-turn-on-auto-save nil)
  ;; Fontify highlighting in code blocks in latext
  (setq org-latex-listings 'minted)
  (setq org-edit-src-auto-save-idle-delay 3)
  (setq org-edit-src-content-indentation 0))

;;; Org Footnote
(use-package org-footnote
  :ensure nil
  :after org
  :custom
  (org-footnote-section nil)
  (org-footnote-auto-adjust t)
  (org-footnote-define-inline nil))

;;; Org Tags
(use-package org
  :ensure nil
  :config
  ;; (setq org-tag-alist nil)
  ;; Tags with fast selection keys
  (setq org-tag-alist (quote ((:startgroup)
                              ("WAITING" . ?w)
                              ("HOLD" . ?h)
                              ("MEETING" . ?m)
                              ("REVIEW" . ?r)
                              ("NOTE" . ?n)
                              (:endgroup)
                              ("PERSONAL" . ?p)
                              ("WORK" . ?W)
                              ("crypt" . ?c)
                              ("EMACS" . ?e)
                              ("CLASS" . ?c)
                              ("IDEA" . ?i)
                              ("LINUX" . ?l)
                              ("FLAGGED" . ??))))
  (setq org-auto-align-tags nil)
  ;; Allow setting single tags without the menu
  (setq org-fast-tag-selection-single-key (quote expert))

  (setq org-tags-column 0))

;;; ORG-ID
(use-package org-id
  :ensure nil
  :after org
  :custom
  (org-clone-delete-id t)
  (org-id-method 'ts)
  (org-id-link-to-org-use-id 'use-existing))


;;; Org Links
(use-package org
  :ensure nil
  :after org
  :config
  (setq org-link-abbrev-alist
        '(("github"      . "https://github.com/%s")
          ("youtube"     . "https://youtube.com/watch?v=%s")
          ("google"      . "https://google.com/search?q=")
          ("wikipedia"   . "https://en.wikipedia.org/wiki/%s")))

  (setq org-link-context-for-files t)
  (setq org-link-keep-stored-after-insertion nil)
  (setq org-id-link-to-org-use-id 'create-if-interactive-and-no-custom-id))



;;; Org-faces
(use-package org-faces
  :ensure nil
  :after org
  :custom
  (org-fontify-todo-headline nil)
  (org-fontify-done-headline nil)
  (org-fontify-whole-block-delimiter-line nil)
  (org-fontify-quote-and-verse-blocks t))

;;; Org-babel
(use-package ob
  :ensure nil
  :after org
  :hook (after-init . (lambda ()
                        "Activate Languages"
                        (org-babel-do-load-languages
                         'org-babel-load-languages
                         '((emacs-lisp . t)
                           (python . t)
                           (shell . t)
                           ;; (mermaid . t)
                           (org . t)
                           (plantuml . t)
                           (latex . t)
                           (js . t)
                           ))))
  :config
  (setq org-babel-default-header-args
        '((:session . "none")
          (:results . "replace")
          (:exports . "code")
          (:cache . "no")
          (:noweb . "no")
          (:hlines . "no")
          (:tangle . "no")
          (:comments . "link")))
  (setq org-confirm-babel-evaluate t))

;;; Better Org-Return
;;;; Option 1
(use-package org
  :ensure nil
  :bind (:map org-mode-map
              ("RET" . my/org-return-dwim))
  :config

  (defun my/org-element-descendant-of (type element)
    "Return non-nil if ELEMENT is a descendant of TYPE.
TYPE should be an element type, like `item' or `paragraph'.
ELEMENT should be a list like that returned by `org-element-context'."
    ;; MAYBE: Use `org-element-lineage'.
    (when-let* ((parent (org-element-property :parent element)))
      (or (eq type (car parent))
          (my/org-element-descendant-of type parent))))

  (defun my/org-return-dwim (&optional default)
    "A helpful replacement for `org-return'.  With prefix, call `org-return'.

On headings, move point to position after entry content.  In
lists, insert a new item or end the list, with checkbox if
appropriate.  In tables, insert a new row or end the table."
    ;; Inspired by John Kitchin:
    ;; http://kitchingroup.cheme.cmu.edu/blog/2017/04/09/A-better-return-in-org-mode/
    (interactive "P")
    (if default
        (org-return)
      (cond
       ;; Act depending on context around point.

       ((and (eq 'link (car (org-element-context)))
             org-return-follows-link)
        ;; Link: Open it.
        (org-open-at-point-global))

       ;; ((or (eq
       ;;       (get-char-property (min (1+ (point)) (point-max)) 'org-overlay-type)
       ;;       'org-latex-overlay)
       ;;      (let ((context (org-element-context)))
       ;;        (and (memq (org-element-type context)
       ;;                   '(latex-fragment latex-environment))
       ;;             (eq (point)
       ;;                 (save-excursion
       ;;                   (goto-char (org-element-property :end context))
       ;;                   (skip-chars-backward "\n\r\t ")
       ;;                   (point))))))
       ;;  (org-latex-preview))

       ((org-at-heading-p)
        ;; Heading: Move to position after entry content.
        ;; NOTE: This is probably the most interesting feature of this function.
        (let ((heading-start (org-entry-beginning-position)))
          (goto-char (org-entry-end-position))
          (cond ((and (org-at-heading-p)
                      (= heading-start (org-entry-beginning-position)))
                 ;; Entry ends on its heading; add newline after
                 (end-of-line)
                 (insert "\n\n"))
                (t
                 ;; Entry ends after its heading; back up
                 (forward-line -1)
                 (end-of-line)
                 (when (org-at-heading-p)
                   ;; At the same heading
                   (forward-line)
                   (insert "\n")
                   (forward-line -1))
                 ;; FIXME: looking-back is supposed to be called with more arguments.
                 (while (not (looking-back (rx (repeat 3 (seq (optional blank) "\n")))))
                   (insert "\n"))
                 (forward-line -1)))))

       ((org-in-item-p)
        ;; Plain list.  Yes, this gets a little complicated...
        (let ((context (org-element-context)))
          (if (or (eq 'plain-list (car context))  ; First item in list
                  (and (eq 'item (car context))
                       (not (eq (org-element-property :contents-begin context)
                                (org-element-property :contents-end context))))
                  (my/org-element-descendant-of 'item context))  ; Element in list item, e.g. a link
              ;; Non-empty item: Add new item.
              (if (org-at-item-checkbox-p)
                  (org-insert-todo-heading nil)
                (org-insert-item))
            ;; Empty item: Close the list.
            ;; TODO: Do this with org functions rather than operating on the
            ;; text. Can't seem to find the right function.
            (delete-region (line-beginning-position) (line-end-position))
            (insert "\n"))))

       ((when (fboundp 'org-inlinetask-in-task-p)
          (org-inlinetask-in-task-p))
        ;; Inline task: Don't insert a new heading.
        (org-return))

       ((org-at-table-p)
        (cond ((save-excursion
                 (beginning-of-line)
                 ;; See `org-table-next-field'.
                 (cl-loop with end = (line-end-position)
                          for cell = (org-element-table-cell-parser)
                          always (equal (org-element-property :contents-begin cell)
                                        (org-element-property :contents-end cell))
                          while (re-search-forward "|" end t)))
               ;; Empty row: end the table.
               (delete-region (line-beginning-position) (line-end-position))
               (org-return))
              (t
               ;; Non-empty row: call `org-return'.
               (org-return))))
       (t
        ;; All other cases: call `org-return'.
        (org-return))))))



;;;; ORG META RETURN ADVICE
(defun my/org-meta-return (&optional arg)
  "Insert a new heading or wrap a region in a table.
Calls `org-insert-heading', `org-insert-item',
`org-table-wrap-region', or `modi/org-split-block' depending on
context.  When called with an argument, unconditionally call
`org-insert-heading'."
  (interactive "P")
  (org-check-before-invisible-edit 'insert)
  (or (run-hook-with-args-until-success 'org-metareturn-hook)
      (call-interactively (cond (arg #'org-insert-heading)
                                ((org-at-table-p) #'org-table-wrap-region)
                                ((org-in-item-p) #'org-insert-item)
                                (t #'org-insert-heading)))))
(advice-add 'org-meta-return :override #'my/org-meta-return)
;;; TODO Org-Refile
;; (defconst my-org-todos "~/Org/Capture/")



;;; Strikethrough DONE headlines
(use-package org
  :ensure nil
  :config
  (setq org-fontify-done-headline t)
  (custom-set-faces
   '(org-done ((t (:foreground "PaleGreen"
                               :weight normal
                               :strike-through t))))
   '(org-headline-done
     ((((class color) (min-colors 16) (background dark))
       (:foreground "LightSalmon" :strike-through t))))))

;; Remove hooks
;; For better tables
(remove-hook 'text-mode-hook #'visual-line-mode)
(add-hook 'text-mode-hook #'auto-fill-mode)



;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; Better Org Modern ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package org
  :ensure nil
  :config
  ;;; Better Org Modern
  (defun my/org-modern-hook ()
    "Enabling org-modern and changing all sorts of settings according to its README."
    (interactive)

    ;; Option 1: Per buffer
    (add-hook 'org-mode-hook #'org-modern-mode)
    (add-hook 'org-agenda-finalize-hook #'org-modern-agenda)

    ;; Option 2: Globally
    (global-org-modern-mode)

    ;; Minimal UI
    (package-initialize)
    (menu-bar-mode -1)
    (tool-bar-mode -1)
    (scroll-bar-mode -1)
                                        ;  (modus-themes-load-operandi)

    ;; Choose some fonts
    (set-face-attribute 'default nil :family "Berkeley Nerd Font")
    (set-face-attribute 'variable-pitch nil :family "SN Pro")
    (set-face-attribute 'org-modern-symbol nil :family "Berkeley Nerd Font")

    ;; Add frame borders and window dividers
    (modify-all-frames-parameters
     '((right-divider-width . 40)
       (internal-border-width . 40)))
    (dolist (face '(window-divider
                    window-divider-first-pixel
                    window-divider-last-pixel))
      (face-spec-reset-face face)
      (set-face-foreground face (face-attribute 'default :background)))
    (set-face-background 'fringe (face-attribute 'default :background))

    (setq
     ;; Edit settings
     org-auto-align-tags nil
     org-tags-column 0
     org-catch-invisible-edits 'show-and-error
     org-special-ctrl-a/e t
     org-insert-heading-respect-content t

     ;; Org styling, hide markup etc.
     org-hide-emphasis-markers t
     org-pretty-entities t
     org-ellipsis "…"

     ;; Do not add source block fringe markers if org-indent-mode is
     ;; enabled. org-indent-mode uses line prefixes for indentation.
     ;; Therefore we cannot have both.

     ;; Agenda styling
     org-agenda-tags-column 0
     org-agenda-block-separator ?─
     org-agenda-time-grid
     '((daily today require-timed)
       (800 1000 1200 1400 1600 1800 2000)
       " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
     org-agenda-current-time-string
     "⭠ now ─────────────────────────────────────────────────")

    ;; (global-org-modern-mode)

    )


  )

;;;;;;;;;;;;;;;;;;;;
;; ;;; Org Export ;;
;;;;;;;;;;;;;;;;;;;;
;;; Org OX
(use-package ox
  :ensure nil
  :init
  (setq org-export-backends '(html latex odt icalendar texinfo md ascii))
  :config
  (setq org-export-with-broken-links t)
  (setq org-export-default-language "en")
  (setq org-export-coding-system "utf-8")
  (setq org-export-with-tags t)
  (setq org-export-with-smart-quotes t)
  (setq org-export-with-sub-superscripts '{})
  (setq org-export-async-debug t)
  (setq org-export-with-section-numbers nil)
  (setq org-time-stamp-formats
        '("%Y-%m-%d %a" . "%Y-%m-%d %a %H:%M"))
  (setq org-display-custom-times t)
  (setq org-time-stamp-custom-formats
        '("%a, %b %-d" . "%a, %b %-d (%-H:%M%p)"))
  (setq org-image-actual-width 700)
  (setq org-export-in-background nil)

  (setq org-export-with-toc t)
  (setopt org-export-with-priority t)
  (setopt org-export-dispatch-use-expert-ui t)
  (setopt org-export-use-babel t)
  (setq org-export-headline-levels 8)
  (setq org-export-dispatch-use-expert-ui nil)
  )

;;; Export to html
(use-package org
  :ensure nil
  :config
  ;; Other options css, inline css
  (setq org-html-htmlize-output-type nil)
  (setq org-html-head-include-default-style nil)
  (setq org-html-head-include-scripts nil)
  )

;; ;;;; HTML Export for Org
;; ;; For this to work set `org-html-htmlize-output-type' to css
;; (use-package htmlize
;;   :ensure t
;;   :commands (htmlize-buffer
;;              htmlize-file
;;              htmlize-many-files
;;              htmlize-many-files-dired
;;              htmlize-region))


;;;; Ox-ODT
(use-package ox-odt
  :ensure nil
  :config
  (setq org-odt-preferred-output-format "docx"))

;;;; TODO ox-epub
;;;; OX-Latex
(use-package ox-latex
  :ensure nil
  :after org
  :custom
  (org-latex-compiler "lualatex")
  (org-latex-src-block-backend 'engraved)
  (org-latex-pdf-process
   (list "latexmk -shell-escape  -pdf -%latex -interaction=nonstopmode -output-directory=%o %f"))
  (org-export-with-toc t)
  )
;;;; Ox-pandoc
;; Export to whatever file format pandoc can export to
(use-package ox-pandoc
  :ensure t
  :after org
  )






;;; TODO: Org Present
(use-package org-present
  :after org
  )





(define-key org-mode-map (kbd "C-<tab>") 'yas-expand)



(provide 'ef-org)
;;; ef-org.el ends here
