;;; ef-org-external.el ---  -*- lexical-binding: t; -*-

;;; Commentary:
;;

;;; Code:


;;; Org Appear
;; Shows emphasis markers when the cursor is on the emphasized region
(use-package org-appear
  :disabled
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


;;; Org Auto Tangle
;; Automatically and Asynchronously tangles org files on save
(use-package org-auto-tangle
  :after org
  :defer t
  :hook (org-mode . org-auto-tangle-mode)
  :config
  ;; Set it to t if you want it to autotangle
  (setq org-auto-tangle-default nil))



;;; ORG-CLIPLINK
;; Insert org-mode links from the clipboard
(use-package org-cliplink
  :ensure t
  :after org)



;;; Org Download
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


;;; Org Modern Indent
;; Instead of org outline mode
(use-package org-modern-indent
  :ensure (:host github :repo "jdtsmith/org-modern-indent")
  :defer t
  :init
  ;; Add late to hook
  (add-hook 'org-mode-hook #'org-modern-indent-mode))



;;; ORG JOURNAL
(use-package org-journal
  :ensure t
  :after org
  :config
  (setq org-journal-dir (expand-file-name (concat org-directory "my_journal/")))
  (setq org-journal-file-type 'weekly)
  (setq org-journal-file-format "%Y-%m-%d.org")
  (setq org-journal-date-format "%A, %Y-%m-%d")
  )



;;; Mermaid
;; Org-babel support for mermaid evaluation
(defconst mermaid-folder "$HOME/.npm/bin/mmdc")
(use-package ob-mermaid
  :ensure t
  :defer t
  :after org
  :config
  (setq ob-mermaid-cli-path mermaid-folder))


;;; Org Modern
;; Modern Look for Org
(use-package org-modern
  :ensure t
  :after org
  ;; :config
  ;; (global-org-modern-mode)
  :hook
  ((org-mode . org-modern-mode)
   (org-agenda-finalize . org-modern-agenda)
   (org-mode . ef/org-modern-spacing)
   )
  :config
  (defun ef/org-modern-spacing ()
    (setq-local line-spacing
                (if org-modern-mode
                    0.3 0.0)))
  :custom
  (org-catch-invisible-edits 'show-and-error)
  (org-modern-block-fringe nil)
  ;; Needed for org-modern-indent
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
  (org-modern-label-border 1)
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
  (org-modern-table nil)
  (org-modern-table-vertical nil)
  (org-modern-table-horizontal nil)
  (org-modern-horizontal-rule t)
  ;; List
  (org-modern-list '((?+ . "+")
                     (?- . "-")
                     (?* . "•")))
  ;; Org Modern Star Options
  (org-modern-star '("✖" "✚" "◉" "○" "✸" "✿" "✤" "✜" "◆" "▶"))
  ;; (org-modern-star ["◉" "○" "✸" "✳" "◈" "◇" "✿" "❀" "✜"])
  ;; (org-modern-star ["◉" "·○" "··◈" "···◇" "····✳"]) ; OK.
  ;; (org-modern-star ["◈" "·◈" "··◇" "···◇" "·····"]) ; OK.

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

  ;; Block Names Options
  ;;
  ;; (org-modern-block-name
  ;;  '((t . t)
  ;;    ("src" "»" "«")
  ;;    ("example" "»–" "–«")
  ;;    ("quote" "❝" "❞")
  ;;    ("export" "⏩" "⏪")))
  ;; Another Option
  (org-modern-block-name
   '((t . t)
     ("src" "»" "∥")
     ("example" "»–" "∥")
     ("quote" "❝" "❞")))

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
     ("call" . "󰜎")
     ("name" . "⁍")
     ("header" . "›")
     ("caption" . "☰")
     ("results" . "∴")
     ("options" . "  ")
     ("property" . "  ")
     ("reveal" . " 󰐩 ")
     ("logbook" . "  ")
     ("language" . " 󰗊 ")
     ("todo" . "  ")
     ("tags" . "  ")
     ("exclude_tags" . " 󱈣 ")
     ("latex" . "  ")
     ("latex_compiler" . "  ")
     ("latex_class" . "  ")
     ("latex_header" . "  ")
     ("html_head" . "  ")



     )

   )
  ;; Miscellaneous
  (org-modern-timestamp t)

  (modify-all-frames-parameters
   '((right-divider-width . 2)
     (internal-border-width . 0)))

  )


;;; Org Noter
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


;;; TODO: Org-pdftools (ERRORS)
;; Support for links to documents in pdfview mode
;; (use-package org-pdftools
;;   :ensure t
;;   :hook (org-mode . org-pdftools-setup-link))


;;; FIXME: Org Present
(use-package org-present
  :ensure t
  :after org
  :preface
  (defun my/org-present-start (&rest args)
    (menu-bar--display-line-numbers-mode-none)
    (visual-line-mode 1)
    (org-display-inline-images)
    (org-present-hide-cursor)
    (org-present-read-only)
    (org-present-big)
    (setq header-line-format " "))
  (defun my/org-present-end (&rest args)
    (menu-bar--display-line-numbers-mode-visual)
    (visual-line-mode 0)
    (org-remove-inline-images)
    (org-present-show-cursor)
    (org-present-read-write)
    (setq header-line-format nil))
  (defun my/org-present-prepare-slide (buffer-name heading)
    ;; Show only top-level headlines
    (org-overview)
    ;; Unfold the current entry
    (org-fold-show-entry)
    ;; Show only direct subheadings of the slide but don't expand them
    (org-fold-show-children))
  :hook (org-present-mode . my/org-present-start)
  :hook (org-present-mode-quit . my/org-present-end)
  :custom
  (org-present-after-navigate-functions  #'my/org-present-prepare-slide)
  )



;;; Org Remark
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




;;; Org Superstar
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

;;; toc-org
;; Add table of contents to org mode files
(use-package toc-org
  :ensure t
  :after (org markdown-mode)
  :commands toc-org-enable
  :init
  (add-hook 'org-mode-hook 'toc-org-enable)
  (add-to-list 'org-tag-alist '("TOC" . ?T))
  :hook (markdown-mode . toc-org-enable)  )

;;; Org Make TOC
;; (use-package org-make-toc
;;   :ensure t)


;;; Org-Transclusion
;; Transclude text content via links
;; (use-package org-transclusion
;;   :ensure nil
;;   :after org
;;   :hook
;;   (org-mode . org-transclusion-mode)
;;     :custom
;;   (org-transclusion-include-first-section t)
;;   (org-transclusion-exclude-elements '(property-drawer)))


;;; TODO Org-noter-pdftools



;;; Valign
(use-package valign
  :ensure t
  :hook ((org-mode markdown-mode) . valign-mode)
  :init
  (setq valign-fancy-bar t)
  )



(provide 'ef-org-external)
;;; ef-org-external.el ends here
