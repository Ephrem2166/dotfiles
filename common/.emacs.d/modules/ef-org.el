;;; ef-org.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:

;; Function
(defun ef/org-mode-hooks ()
  "Various modes to run in org mode."
  (abbrev-mode)
  (setq line-spacing 12)
  ;;  (setq-default line-spacing 1)
  (auto-fill-mode 0)
  ;; (electric-indent-mode nil)
  ;; (visual-fill-column-mode nil)
  ;; (variable-pitch-mode)
  (visual-line-mode 1)
  ;; (mixed-pitch-mode 1)
  ;; (fontaine-mode 1)
  (display-line-numbers-mode -1)
  (prettify-symbols-mode)
  ;; (adaptive-wrap-prefix-mode 1)
  ;;(olivetti-mode)
  ;; (setq corfu-auto nil)
  (setq evil-auto-indent nil)
  (setq-local fill-column 120)
  ;; It conflicts with org-modern block prettification
  (org-indent-mode -1)
  ;; (truncate-lines 1)
  ;; (center-document-mode 1)
  )

(add-hook 'org-mode-hook (lambda () (electric-indent-local-mode -1)))

;; Org General Settings
(use-package org
  :ensure nil
  :defer t
  :init
  (setq org-directory (expand-file-name "~/Org/"))
  :config
  ;; General Settings
  (setq org-imenu-depth 7)
  (setq org-startup-folded t)

  ;; Editing and Appearance
  (setq org-hide-leading-stars t)
  (setq org-hide-emphasis-markers t)

  ;;(setq org-odd-levels-only nil)
  (setq org-special-ctrl-a/e nil)
  (setq org-special-ctrl-k nil)
  (setq org-return-follows-link t)
  ;; (setq org-blank-before-new-entry t)

  ;; Macro Replacement
  (setq org-hide-macro-markers t)

  (setq org-cycle-separator-lines 0)

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

  ;; Pretty
  (setq org-pretty-entities t)
  (setq org-pretty-entities-include-sub-superscripts nil)
  (setq org-use-sub-superscripts nil)
  ;; Image
  (setq org-image-actual-width 600)
  (setq org-image-align 'center))

;; Fontify
(use-package org-faces
  :ensure nil
  :config
  (setq org-fontify-todo-headline t)
  (setq org-fontify-done-headline t)
  (setq org-fontify-quote-and-verse-blocks t)
  (setq org-fontify-whole-heading-line t)
  (setq org-fontify-whole-block-delimiter-line t))

;; Org Hooks
(use-package org
  :ensure nil
  :hook (
         ;; (org-mode . abbrev-mode)
         ;; (org-mode . turn-on-auto-fill)
         ;; (org-mode . variable-pitch-mode)
         ;; (org-mode . visual-line-mode)
         ;; (org-mode . prettify-symbols-mode)
         ;; (org-mode . olivetti-mode)
         (org-mode . ef/org-mode-hooks)
         ;; (org-mode . (lambda () (setq-local line-spacing 0.3 fill-column 120)))
         ;; (org-mode . (lambda () (electric-indent-local-mode -1)))
         )
  )

;; Org Indent
(use-package org
  :ensure nil
  :config
  (setq org-adapt-indentation nil)
  (setq org-indent-mode-turns-on-hiding-stars nil)
  (setq org-indent-indentation-per-level 4))

;; Org Todo and Refile
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

;; ORG TODO Appearance
(use-package org
  :ensure nil
  :config
  (setq org-todo-keywords
        '((sequence "TODO" "|" "IN-PROGRESS" "|" "DONE" "|" "CANCELED")
          (sequence "READ" "|" "DONE")
          (sequence "WATCH" "|" "WATCHED")
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
;; Org Structure Template List
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

;; Pretty Symbol List
(use-package org
  :ensure nil
  :config
  (setq-default prettify-symbols-alist '(("#+BEGIN_SRC" . "»")
                                         ("#+END_SRC" . "«")
                                         ("#+begin_src" . "»")
                                         ("#+end_src" . "«")
                                         ("lambda"  . "λ")
                                         ("->" . "→")
                                         ("->>" . "↠")))

  (setq prettify-symbols-unprettify-at-point 'right-edge))

;;;; Org-archive
(use-package org-archive
  :ensure nil
  :custom
  (org-archive-subtree-save-file-p 'from-org)
  (org-archive-subtree-add-inherited-tags t))


;; Org Custom Heading Faces
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

;; Org Links
(use-package org
  :ensure nil
  :config
  (setq org-link-context-for-files t)
  (setq org-link-keep-stored-after-insertion nil)
  (setq org-id-link-to-org-use-id 'create-if-interactive-and-no-custom-id))


;; Org Attach
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

;; Org Export (ox)
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
  (setq org-html-htmlize-output-type nil)
  (setq org-html-head-include-default-style nil)
  (setq org-html-head-include-scripts nil))

;; Ox-ODT
(use-package ox-odt
  :ensure nil
  :config
  (setq org-odt-preferred-output-format "docx"))

;; TODO ox-epub
;; OX-Latex
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




;; Org Text Colors
(use-package org
  :ensure nil
  :config
  (setq org-emphasis-alist '(("*" (bold :foreground "#BF616a"))
                             ("/" (italic :foreground "#8aadf4"))
                             ("_" underline)
                             ("=" (:foreground "#a3be8c" :family "Berkeley Nerd Font"))
                             ("~" (:foreground "#d08770" :family "Berkeley Nerd Font"))
                             )))

;; Org SRC Blocks
(use-package org
  :ensure nil
  :config
  (setq org-src-block-faces nil)
  (setq org-inline-src-prettify-results '("⟨" . "⟩"))
  (setq org-src-window-setup 'current-window)
  (setq org-src-fontify-natively t)
  (setq org-src-preserve-indentation t)
  (setq org-src-tab-acts-natively t)
  (setq org-edit-src-persistent-message nil)
  (setq org-edit-src-turn-on-auto-save nil)
  (setq org-edit-src-auto-save-idle-delay 3)
  (setq org-edit-src-content-indentation 0))


;; Org Footnote
(use-package org-footnote
  :ensure nil
  :after org
  :custom
  (org-footnote-section nil)
  (org-footnote-auto-adjust t)
  (org-footnote-define-inline nil))

;; Org Tags
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

;; ORG-ID
(use-package org-id
  :ensure nil
  :after org
  :custom
  (org-clone-delete-id t)
  (org-id-method 'ts)
  (org-id-link-to-org-use-id 'use-existing))

;; ORG-CLIPLINK
;; Insert org-mode links from the clipboard
(use-package org-cliplink
  :ensure t
  :after org)

;; Org Download
;; Image drag-and-drop for org-mode
(use-package org-download
  :ensure t
  :after org
  ;; :ensure-system-package (scrot)
  :hook (org-mode . org-download-enable)
  :custom
  (org-image-actual-width 400)
  (org-download-method 'attach)
  (org-download-screenshot-method "scrot -s %s") ; Use scrot
  (org-download-image-dir (progn (require 'org-attach) org-attach-id-dir))
  (org-download-heading-lvl nil)
  (org-download-timestamp "%Y-%m-%d_%H-%M-%S_") ; Default
  (org-download-image-html-width 700))


;;;;; Org-faces
(use-package org-faces
  :ensure nil
  :after org
  :custom
  (org-fontify-todo-headline nil)
  (org-fontify-done-headline nil)
  (org-fontify-whole-block-delimiter-line nil)
  (org-fontify-quote-and-verse-blocks t))

;; (defun ef/org-modern-spacing ()
;;   (setq-local line-spacing
;;               (if org-modern-mode
;;                   0.5 0.0)))

;; Org Modern
;; Modern Look for Org
(use-package org-modern
  :after org
  ;; :config
  ;; (global-org-modern-mode)
  :hook
  ((org-mode . org-modern-mode)
   ;;   (org-mode . ef/org-modern-spacing)
   )
  :custom
  (org-catch-invisible-edits 'show-and-error)
  (org-modern-block-fringe nil)
  (org-modern-hide-stars nil)
  ;; Todo
  (org-modern-todo nil)
  (org-modern-todo-faces
   '(("NEXT" :inherit (bold success org-modern-todo))
     ("TODO" :inherit (org-todo org-modern-todo))
     ("HOLD" :inherit (shadow error org-modern-todo))
     ("MAYBE" :inherit (shadow org-todo org-modern-todo))
     ("DONE" :inherit (bold org-done org-modern-todo))
     ("CANCELED" :inherit (error org-modern-todo))))
  (org-modern-horizontal-rule (make-string 36 ?─))
  ;; Label
  (org-modern-label-border 3)
  ;; (org-modern-label  ((t :height 0.9 :width condensed :weight regular :underline nil)))
  ;; Footnote
  (org-modern-footnote '(nil (raise 0.15) (height 0.9)))
  ;; Tag
  (org-modern-tag nil)
  (org-modern-tag-faces
   `(("project"
      :foreground ,(face-background 'default nil t)
      :background ,(face-foreground 'default nil t))))
  ;; Priority
  (org-modern-priority t)
  (org-modern-priority-faces
   '((?A :inverse-video t :inherit (bold org-priority))
     (?B :inverse-video t :inherit (bold org-priority))
     (?C :inverse-video t :inherit org-priority)
     (?D :inverse-video t :inherit org-priority)
     (?E :inverse-video t :inherit (shadow org-priority))
     (?F :inverse-video t :inherit (shadow org-priority))))
  ;; Table
  (org-modern-table t)
  (org-modern-table-vertical 5)
  (org-modern-table-horizontal 2)
  (org-modern-horizontal-rule t)
  ;; List
  (org-modern-list '((?+ . "+")
                     (?- . "-")
                     (?* . "•")))
  (org-modern-star '("✖" "✚" "◉" "○" "✸" "✿" "✤" "✜" "◆" "▶"))
  (org-modern-checkbox
   '((?X . " ")
     (?- . "▣")
     (?\s . "")))
  ;;org-modern-star '("◉" "○" "◎" "▣" "▢" "◈" "◇")
  ;; (org-modern-fold-stars
  ;; '(("▶" . "▼")
  ;;   ("▷" . "▽")
  ;;   ("⯈" . "⯆")
  ;;   ("▹" . "▿")
  ;;   ("▸" . "▾")))
  (org-modern-block-name
   '((t . t)
     ("src" "»" "«")
     ("example" "»–" "–«")
     ("quote" "❝" "❞")
     ("export" "⏩" "⏪")))
  ;; Keyword
  (org-modern-keyword "‣ ")
  (org-modern-keyword
   '((t . t)
     ("title" . "𝙏")
     ("subtitle" . "𝙩")
     ("author" . "𝘼")
     ("email" . "")
     ("date" . "𝘿")
     ("property" . "󰠳")
     ("options" . #("󰘵" 0 1 (display (height 0.75))))
     ("startup" . "⏻")
     ("macro" . "𝓜")
     ("bind" . "󰌷")
     ("bibliography" . "")
     ("print_bibliography" . "󰌱")
     ("cite_export" . "⮭")
     ("print_glossary" . "󰌱ᴬᶻ")
     ("glossary_sources" . "󰒻")
     ("include" . "⇤")
     ("setupfile" . "⇚")
     ("html_head" . "🅷")
     ("html" . "🅗")
     ("latex_class" . "🄻")
     ("latex_class_options" . "🄻󰒓")
     ("latex_header" . "🅻")
     ("latex_header_extra" . "🅻⁺")
     ("latex" . "🅛")
     ("beamer_theme" . "🄱")
     ("beamer_color_theme" . "🄱󰏘")
     ("beamer_font_theme" . "🄱𝐀")
     ("beamer_header" . "🅱")
     ("beamer" . "🅑")
     ("attr_latex" . "🄛")
     ("attr_html" . "🄗")
     ("attr_org" . "⒪")
     ("call" . "󰜎")
     ("name" . "⁍")
     ("header" . "›")
     ("caption" . "☰")
     ("results" . "🠶")))
  ;; Miscellaneous
  (org-modern-timestamp t)  )

;; Org Appear
;; Shows emphasis markers when the cursor is the emphasized
;; Region
(use-package org-appear
  :after org
  :ensure t
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-autoemphasis   t
        org-hide-emphasis-markers t
        org-appear-autolinks      'just-brackets
        org-appear-autoentities   t
        org-appear-autosubmarkers t
        org-appear-delay 0.0
        org-appear-autokeywords t
        org-appear-inside-latex t
        org-appear-triggger 'always
        )
  (run-at-time nil nil #'org-appear--set-elements))




;; Org Noter
;; A synchronized org-mode document annotator
;; Just press i
(use-package org-noter
  ;;  :ensure nil
  :defer
  :after org
  :custom
  (org-noter-always-create-frame nil)
  (org-noter-kill-frame-at-session-end nil)
  (org-noter-use-indirect-buffer t)
  (org-noter-disable-narrowing nil)
  (org-noter-hide-other t)
  (org-noter-auto-save-last-location nil)
  (org-noter-separate-notes-from-heading t)
  (org-noter-highlight-selected-text t) ; Always leave highlights from annotations
  (org-noter-arrow-foreground-color "red")
  (org-noter-arrow-background-color "black")
  (org-noter-doc-property-in-notes nil)
  (org-noter-insert-note-no-questions nil) ; Activate this setting if I rarely type my own titles
  (org-noter-max-short-selected-text-length 0) ; Always enclose in quote block
  )

;; Org Remark
;; Org-remark lets you highlight and annotate text files, websites,
;; EPUB books and Info documentation with using Org mode.
(use-package org-remark
  :hook (on-first-file . org-remark-global-tracking-mode)
  :after org
  :bind (;; :bind keyword also implicitly defers org-remark itself.
         ;; Keybindings before :map is set for global-map. Adjust the keybinds
         ;; as you see fit.
         ("C-c o m" . org-remark-mark)
         ("C-c o l" . org-remark-mark-line)
         :map org-remark-mode-map
         ("C-c o o" . org-remark-open)
         ("C-c o ]" . org-remark-view-next)
         ("C-c o [" . org-remark-view-prev)
         ("C-c o r" . org-remark-remove)
         ("C-c o d" . org-remark-delete))
  :custom
  (org-remark-source-file-name 'abbreviate-file-name)
  (org-remark-notes-file-name
   (no-littering-expand-var-file-name "org-remark/marginalia.org"))
  (org-remark-notes-display-buffer-action `((display-buffer-in-side-window)
                                            (side . right)
                                            (slot . 1)))
  (org-remark-create-default-pen-set nil)
  (org-remark-notes-auto-delete nil)
  :config
  (with-eval-after-load 'eww
    (org-remark-eww-mode 1))
  (with-eval-after-load 'nov
    (org-remark-nov-mode 1))
  (with-eval-after-load 'info
    (org-remark-info-mode 1))

  (with-eval-after-load 'all-the-icons
    (setopt org-remark-icon-notes (all-the-icons-material "details")
            org-remark-icon-position-adjusted (all-the-icons-material "error")
            org-remark-line-icon (all-the-icons-faicon "sticky-note"))))


;; Org Superstar
;; Prettify headings and plain lists in org mode
(use-package org-superstar
  :disabled t
  :hook (org-mode . org-superstar-mode)
  :init
  (setq org-superstar-headline-bullets-list '("✖" "✚" "◉" "○" "▶")
        ;; org-superstar-special-todo-items t
        org-ellipsis " ↴ ")
  :custom
  (org-hide-leading-stars nil)
  (org-indent-mode-turns-on-hiding-stars nil)
  (org-superstar-remove-leading-stars nil)

  ;; Headlines
  (org-superstar-leading-bullet ?·)
  ;; Todos
  (org-superstar-special-todo-items nil)
  ;; Update when I change `org-todo-keywords'
  (org-superstar-todo-bullet-alist
   '(("NEXT" . ?☐)
     ("TODO" . ?☐)
     ("HOLD" . ?☐)
     ("DONE" . ?☑)
     ("CANCELED" . ?☑)
     ("[ ]"  . ?☐)
     ("[X]"  . ?☑)))

  ;; Plain lists
  (org-superstar-prettify-item-bullets t)
  (org-superstar-first-inlinetask-bullet ?▶)
  (org-superstar-item-bullet-alist
   '((?+ . "◦")                         ; List taken from `org-modern'
     (?- . "–")
     (?* . "‣"))) )

;; Org Auto Tangle
;; Automatically and Asynchronously tangles org files on save
(use-package org-auto-tangle
  :after org
  :defer t
  :hook (org-mode . org-auto-tangle-mode)
  :config
  ;; Set it to t if you want it to autotangle
  (setq org-auto-tangle-default nil))

;; TODO Org-Refile
;; Transclude text content via links
;; (use-package org-transclusion
;;   :ensure nil
;;   :after org
;;   :hook
;;   (org-mode . org-transclusion-mode)
;;     :custom
;;   (org-transclusion-include-first-section t)
;;   (org-transclusion-exclude-elements '(property-drawer)))

;; toc-org
;; Add table of contents to org mode files
(use-package toc-org
  :after (org markdown-mode)
  :commands toc-org-enable
  :init
  (add-hook 'org-mode-hook 'toc-org-enable)
  (add-to-list 'org-tag-alist '("TOC" . ?T))
  :hook (markdown-mode . toc-org-enable)  )

;; (use-package org-make-toc
;;   :ensure t)

;; TODO: Org-pdftools (ERRORS)
;; Support for links to documents in pdfview mode
                                        ;(use-package org-pdftools
                                        ;  :hook (org-mode . org-pdftools-setup-link))

;; TODO Org-noter-pdftools
;; Org-babel
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


;; Ob-mermaid
;; Org-babel support for mermaid evaluation
(defconst mermaid-folder "$HOME/.npm/bin/mmdc")
(use-package ob-mermaid
  :ensure t
  :defer t
  :after org
  :config
  (setq ob-mermaid-cli-path mermaid-folder))

;; (defconst my-org-todos "~/Org/Capture/")
;; Org Agenda
(use-package org
  :ensure nil
  :bind ("C-c C-a" . org-agenda)
  :config
  (setopt org-deadline-warning-days 3)
  (setopt org-agenda-inhibit-startup t)
  ;; (setopt org-agenda-files (list org-directory))
  (setq org-agenda-files
        (list
         "~/Org/Capture/links.org"
         "~/Org/Capture/today.org"
         "~/Org/Capture/links.org"
         "~/Org/Capture/tasks.org"
         "~/Org/Capture/notes.org"
         "~/Org/Capture/journal.org"))
  ;; (setopt org-agenda-files (list my-org-todos))
  ;; (setopt org-agenda-files '(
  ;; "~/Documents/Notes/Org Notes/Agenda/tasks.org"
  ;; "~/Documents/Notes/Org Notes/Agenda/links.org"
  ;; "~/Documents/Notes/Org Notes/Agenda/codes.org"
  ;; "~/Documents/Notes/Org Notes/Agenda/journal.org"
  ;; "~/Documents/Notes/Org Notes/Agenda/notes.org"
  ;; ))
  (setopt org-agenda-remove-tags t)
  (setopt org-agenda-restore-windows-after-quit t)
  (setopt org-agenda-show-inherited-tags nil)
  (setopt org-agenda-skip-deadline-if-done t)
  (setopt org-agenda-skip-scheduled-if-done t)
  (setopt org-agenda-skip-timestamp-if-done t)
  (setopt org-agenda-sorting-strategy
          '((agenda time-up deadline-up scheduled-up todo-state-up priority-down)
            (todo todo-state-up priority-down deadline-up)
            (tags todo-state-up priority-down deadline-up)
            (search todo-state-up priority-down deadline-up)))
  (setopt org-agenda-tags-todo-honor-ignore-options t)
  (setopt org-agenda-use-tag-inheritance nil)
  (setopt org-agenda-window-frame-fractions '(0.0 . 0.5))
  ;; From protesilaos
  (setopt org-agenda-span 'week)
  (setopt org-agenda-start-on-weekday 1)
  (setopt org-agenda-confirm-kill t)
  (setopt org-agenda-show-all-dates t)
  (setopt org-agenda-show-outline-path nil)
  (setopt org-agenda-window-setup 'current-window)
  (setopt org-agenda-skip-comment-trees t)
  (setopt org-agenda-menu-show-matcher t)
  (setopt org-agenda-menu-two-columns nil)
  (setopt org-agenda-sticky nil)
  (setopt org-agenda-custom-commands-contexts nil)
  (setopt org-agenda-max-entries nil)
  (setopt org-agenda-max-todos nil)
  (setopt org-agenda-max-tags nil)
  (setopt org-agenda-max-effort nil)
  (setopt org-agenda-prefix-format
          '((agenda . " %i %-12:c%?-12t% s")
            (todo . " %i %-12:c")
            (tags . " %i %-12:c")
            (search . " %i %-12:c")))
  (setopt org-agenda-breadcrumbs-separator "->")
  (setopt org-agenda-todo-keyword-format "%-1s")
  (setopt org-agenda-fontify-priorities 'cookies)
  (setopt org-agenda-category-icon-alist nil)
  (setopt org-agenda-remove-times-when-in-prefix nil)
  (setopt org-agenda-remove-timeranges-from-blocks nil)
  (setopt org-agenda-compact-blocks nil)
  (setopt org-agenda-block-separator ?-)
  ;; Agenda marks
  (setopt org-agenda-bulk-mark-char "#")
  (setopt org-agenda-persistent-marks nil)

  ;; Agenda follow mode
  (setopt org-agenda-start-with-follow-mode nil)
  (setopt org-agenda-follow-indirect t)

  ;; Deadline and Schedule Timestamps
  (setopt org-agenda-include-deadlines t)
  (setopt org-deadline-warning-days 0)
  (setopt org-agenda-skip-scheduled-if-done nil)
  (setopt org-agenda-skip-scheduled-if-deadline-is-shown t)
  (setopt org-agenda-skip-timestamp-if-deadline-is-shown t)
  (setopt org-agenda-skip-deadline-if-done nil)
  (setopt org-agenda-skip-deadline-prewarning-if-scheduled 1)
  (setopt org-agenda-skip-scheduled-delay-if-deadline nil)
  (setopt org-agenda-skip-additional-timestamps-same-entry nil)
  (setopt org-agenda-skip-timestamp-if-done nil)
  (setopt org-agenda-search-headline-for-time nil)
  (setopt org-scheduled-past-days 365)
  (setopt org-deadline-past-days 365)
  (setopt org-agenda-move-date-from-past-immediately-to-today t)
  (setopt org-agenda-show-future-repeats t)
  (setopt org-agenda-prefer-last-repeat nil)
  (setopt org-agenda-timerange-leaders
          '("" "(%d/%d): "))
  (setopt org-agenda-scheduled-leaders
          '("Scheduled: " "Sched.%2dx: "))
  (setopt org-agenda-inactive-leader "[")
  (setopt org-agenda-deadline-leaders
          '("Deadline:  " "In %3d d.: " "%2d d. ago: "))

  ;; Time Grid
  (setopt org-agenda-time-leading-zero t)
  (setopt org-agenda-timegrid-use-ampm nil)
  (setopt org-agenda-use-time-grid t)
  (setopt org-agenda-show-current-time-in-grid t)
  (setopt org-agenda-current-time-string (concat "Now " (make-string 70 ?.)))
  (setopt org-agenda-time-grid
          '((daily today require-timed)
            ( 0500 0600 0700 0800 0900 1000
              1100 1200 1300 1400 1500 1600
              1700 1800 1900 2000 2100 2200)
            "" ""))
  (setopt org-agenda-default-appointment-duration nil)

  ;; Agenda global to-do list
  (setopt org-agenda-todo-ignore-with-date t)
  ;; (setopt org-agenda-todo-ignore-timestamp t)
  (setopt org-agenda-todo-ignore-scheduled t)
  (setopt org-agenda-todo-ignore-deadlines t)
  (setopt org-agenda-todo-ignore-time-comparison-use-seconds t)
  (setopt org-agenda-tags-todo-honor-ignore-options nil)

  ;; Agenda Tagged Items
  (setopt org-agenda-show-inherited-tags t)
  (setopt org-agenda-use-tag-inheritance
          '(todo search agenda))
  (setopt org-agenda-hide-tags-regexp nil)
  (setopt org-agenda-remove-tags nil)
  (setopt org-agenda-tags-column -100)

  )

;; Org Log
(use-package org
  :ensure nil
  :config
  (setopt org-log-done 'time)
  (setopt org-log-into-drawer t)
  (setopt org-log-note-clock-out nil)
  (setopt org-log-redeadline 'time)
  (setopt org-log-reschedule 'time)
  )

;; Org Capture
(use-package org-capture
  :ensure nil
  :bind ("C-c C-c" . org-capture)
  :config
  (setq org-capture-templates
        '(
          ;; Tasks
          ("t" "Tasks" entry
           (file+headline "~/Org/Capture/tasks.org" "My tasks")
           "* TODO %^{Todo} %^G \n:PROPERTIES:\n:CREATED: %U\n:END:\n\n%?")
          ;; Links
          ("l" "Link" entry
           (file+headline  "~/Org/Capture/links.org" "Links")
           "* READ %^{Title} %^G\n:PROPERTIES:\n:CREATED: %U\n:END:\n\n%^{Link}L")
          ;; Journal
          ("j" "Journal" entry
           (file+olp+datetree "~/Org/Capture/journal.org" "My Journal")
           "* %^{TITLE} %^G \nEntered on %U\n  %i\n %?")
          ;; Today
          ("." "Today Tasks" entry
           (file+headline "~/Org/Capture/today.org" "Today's Tasks")
           "* TODO %^{Task} %^G \n:PROPERTIES:\n:CREATED: %U\n:END:\n\n%?")
          ;; Notes
          ("n" "Note" entry
           (file+headline "~/Org/Capture/notes.org" "Notes")
           "* %^{Title} %^G \n:PROPERTIES:\n:CREATED: %U\n:END:\n\n%?"
           :empty-lines 1)
          ;; Code Snippets
          ("c" "Code Snippet" entry
           (file+headline "~/Org/Capture/codes.org" "Snippets")
           "* %?\t%^g\n#+BEGIN_SRC %^{language}\n\n#+END_SRC")
          )
        )
  )

;; ORG JOURNAL
(use-package org-journal
  :ensure t
  :after org
  :config
  (setq org-journal-dir (concat org-directory "my_journal"))
  (setq org-journal-file-type 'weekly)
  (setq org-journal-file-format "%Y-%m-%d.org")
  (setq org-journal-date-format "%A, %Y-%m-%d")
  )


;; Strikethrough DONE headlines
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


;; Performance Tweaks for Org Agenda
(use-package org-agenda
  :ensure nil
  :after org
  :config
  (setq org-agenda-inhibit-startup t)
  (setq org-agenda-use-tag-inheritance nil)
  (add-hook 'after-init-hook                ;;   then revert after-init
            #'(lambda () (setq org-agenda-show-inherited-tags 'always)))
  (setq-default org-agenda-skip-scheduled-if-deadline-is-shown 'not-today)
  )

;; Valign
(use-package valign
  :ensure t
  :hook (org-mode . valign-mode)
  )

;; TODO Org Present
(use-package org-present
  :after org
  )

(provide 'ef-org)
;;; ef-org.el ends here
