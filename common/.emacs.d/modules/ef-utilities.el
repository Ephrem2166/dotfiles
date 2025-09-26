;;; ef-utilities.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:
;; Ace Window
;; Quickly Switch Windows
(use-package ace-window
  :ensure t
  :bind (("M-o" . ace-window))
  :config
  ;; (set-face-attribute
  ;; 'aw-leading-char-face nil
  ;; :weight 'bold
  ;; :height 2.0)
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  (setq aw-scope 'frame)
  )

;; Anzu
;; Show number of matches in mode-line while searching
(use-package  anzu
  :ensure t
  :diminish anzu-mode
  :config
  (global-anzu-mode 1))


;;  AVY
(use-package avy
  :ensure t
  :bind (
         ("C-x a ." . avy-resume)
         ("C-x a c" . avy-goto-char)
         ("C-x a w" . avy-goto-word-1)
         ("C-x a l" . avy-goto-line)
         ("C-x a k" . avy-goto-line-above)
         ("C-x a j" . avy-goto-line-below)
         ("C-x a d" . avy-kill-region)
         ("C-x a r" . avy-copy-region)
         ("C-x a y" . avy-copy-line)
         ("C-x a L" . avy-move-line)
         ("C-x a R" . avy-move-region)
         ("C-x a e" . avy-goto-end-of-line)
         )
  :config
  (setq avy-timeout-seconds 0.27)
  (setq avy-all-windows nil)
  (setq avy-all-windows-alt t)
  (setq avy-background t)
  (setq avy-style 'pre)
  (setq avy-single-candidate-jump nil)
  )



;; Consult Dir
;; Insert paths into the minibuffer prompt
(use-package consult-dir
  :ensure t
  :after consult
  :hook (consult)
  :bind (("C-x C-d" . consult-dir)
         :map minibuffer-local-filename-completion-map
         ("C-x C-d" . consult-dir)
         ("C-x C-j" . consult-dir-jump-file))
  )

;; Consult flycheck
(use-package consult-flycheck
  :after (:all consult flycheck))

;; Consult Flyspell
(use-package consult-flyspell
  :after (:all consult flyspell)
  :bind
  (:map flyspell-mode-map
        ("C-c j $" . consult-flyspell))
  :config
  (progn))

;; Dashboard
(use-package dashboard
  :ensure t
  :disabled
  :config
  (dashboard-setup-startup-hook))



;; Deadgrep
;; Fast searching with ripgrep
(use-package deadgrep
  :ensure t)


;; Diminish
;; Diminished modes are minor modes with no modeline display
(use-package diminish
  :ensure t)

;; Dumb Jump
(use-package dumb-jump
  :ensure t
  :config
  (setq dumb-jump-quiet t)
  (setq dumb-jump-force-searcher 'rg)
  (setq dumb-jump-prefer-searcher 'rg)
  (setq dumb-jump-rg-search-args "")
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
  :bind (

         ("C-c . g" . dumb-jump-go)
         ("C-c . e" . dumb-jump-go-prefer-external)
         ("C-c . p" . dumb-jump-go-prompt)
         ("C-c . q" . dumb-jump-quick-look)
         ("C-c . <backspace>" . dumb-jump-back)
         )
  )

;; Embark
;; Embark makes it easy to choose a command to run based on what is near point,
;; both during a minibuffer completion session and in normal buffers.
(use-package embark
  :ensure t
  :defer t
  :after vertico
  :init
  :bind
  (("C-," . embark-act)
   ("C-;" . embark-dwim)
   ("C-h B" . embark-bindings)
   :map minibuffer-local-map
   ("C-d" . embark-act)
   :map vertico-map
   ("C-." . embark-act)
   ("C-/" . embark-become)
   )
  :config
  (setq embark-confirm-all-all nil)
  (setq embark-mixed-indicator-both nil)
  (setq embark-indicators '(embark-mixed-indicator embark-highlight-indicator))
  (setq embark-verbose-indicator-nested nil)
  (setq embark-verbose-indicator-buffer-sections '(bindings))
  (setq embark-cycle-key "<XF86Travel>")
  ;; (setq embark-cycle-key (kbd "C-n"))
  (setq prefix-help-command #'embark-prefix-help-command)
  (setq embark-quit-after-action '((kill-buffer . t) (t . nil)))
  (setq embark-verbose-indicator-excluded-actions
        '(embark-cycle embark-act-all embark-collect embark-export embark-insert))

  )

;; Embak Consult
(use-package embark-consult
  :ensure t
  :after (embark consult)
  :hook
  (embark-collect-mode . consult-preview-at-point-mode)
  )


;; Expand Region
;; Increase selected region by semantic units
(use-package expand-region
  :ensure t
  :defer t
  :bind ("C-=" . er/expand-region))

;; GCMH
;; The Garbage Collector Magic Hack
(use-package gcmh
  ;; :disabled
  :ensure t
  :demand t
  :diminish gcmh-mode
  :hook
  (emacs-startup . gcmh-mode)
  :init
  (setq gcmh-idle-delay 'auto)
  (setq gcmh-auto-idle-delay-factor 10)
  (setq gcmh-verbose nil)
  (setq gcmh-high-cons-threshold (* 64 1024 1024)) ; 64MB
  :config
  (setq garbage-collection-messages nil))



;; Helpful
;; Alternative to builtin Emacs help
;; Provides contextual information
(use-package helpful
  :ensure t
  :defer t
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  ;; Keybindings
  :bind
  ([remap describe-function] . helpful-function)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-callable] . helpful-callable)
  ([remap describe-key] . helpful-key)
  ([remap describe-command] . helpful-command)
  ([remap describe-symbol] . helpful-symbol)
  ("C-c C-d" . helpful-at-point)
  ;; (keymap-global-set "C-c C-d" #'helpful-at-point)
  )

;; Hl-TODO
;; Highlight TODO and similar keywords
(use-package hl-todo
  :ensure t
  :hook (prog-mode . global-hl-todo-mode)
  :bind
  :custom
  (hl-todo-include-modes '(prog-mode elisp-mode conf-mode text-mode))
  (hl-todo-text-modes '(markdown-mode org-mode text-mode))
  (hl-todo-exclude-modes nil)
  (hl-todo-require-punctuation t)
  (hl-todo-highlight-punctuation ": ")
  (hl-todo-keyword-faces
   '(("TODO"   . "#BF616A")
     ("FIXME"  . "#FF0000")
     ("NOTE"  error bold)
     ("DEBUG"  . "#EBCB9B")
     ("BUG" error italic)
     ("GOTCHA" . "#FF4500")
     ("STUB"   . "#1E90FF"))))

;; Info-colors
;; Extra colors for info mode
(use-package info-colors
  :ensure t
  :defer t
  :commands info-colors-fontify-node
  :hook (Info-selection . info-colors-fontify-node)
  ;; :hook (Info-mode      . mixed-pitch-mode)
  )




;; Lin
;; Make `hl-line-mode' more suitable for selection UIs
(use-package lin
  :ensure t
  :hook (after-init . lin-global-mode)
  :config
  (setq lin-face 'lin-cyan))


;; Move text
;; Move current line or region with M-up or M-down
(use-package move-text
  :ensure t
  :bind
  (
   ("M-<up>" . move-text-up)
   ("M-<down>" . move-text-down)
   )
  :config
  (move-text-default-bindings)
  )

;; Multiple cursors
;; Multiple Cursors for Emacs
(use-package multiple-cursors
  :ensure t
  :defer t
  :bind (
         ("C-M-a" . mc/edit-lines)
         ("C-M-/" . mc/mark-all-dwim)
         ("C-M-." . mc/mark-next-like-this)
         ("C-M-," . mc/mark-previous-like-this)
         )
  
  )


;; No Littering
;; Help Keeping ~/.config/emacs clean
(use-package no-littering
  :ensure t
  :demand t
  :init
  (eval-and-compile
    (setq no-littering-etc-directory (expand-file-name "etc/" user-emacs-directory)
          no-littering-var-directory (expand-file-name "var/" user-emacs-directory)))
  :config
  ;; Ensure the directories exist
  (mkdir no-littering-etc-directory t)
  (mkdir no-littering-var-directory t)
  (with-eval-after-load 'recentf
    (add-to-list 'recentf-exclude no-littering-var-directory)
    (add-to-list 'recentf-exclude no-littering-etc-directory)))


;; Outline Indent
;; Folding text based on indentation (origami alternative)
(use-package outline-indent
  :ensure t
  :defer t
  :commands outline-indent-minor-mode
  :init
  (add-hook 'python-mode-hook #'outline-indent-minor-mode)
  (add-hook 'python-ts-mode-hook #'outline-indent-minor-mode)

  (add-hook 'yaml-mode-hook #'outline-indent-minor-mode)
  (add-hook 'yaml-ts-mode-hook #'outline-indent-minor-mode)

  :custom
  (outline-indent-ellipsis " ▼ ")
  )



;; Popper
;; Summon and dismiss buffers as popups
(use-package popper
  :ensure t
  :bind (("C-c b p"   . popper-toggle)
         ("C-c C-p"   . popper-cycle)
         ("C-c b ," . popper-toggle-type))
  :init
  (setq popper-reference-buffers
        '("\\*Messages\\*"
          "Output\\*$"
          "\\*Warnings\\*"
          "\\*xref\\*"
          "\\*Backtrace\\*"
          "*Flymake diagnostics.*"
          "\\*eldoc\\*"
          "\\*Async Shell Command\\*"
          help-mode
          compilation-mode
          vterm-mode
          helpful-mode
          ))
  (setq popper-display-control t)
  (setq popper-window-height 12)
  (popper-mode +1)
  (popper-echo-mode +1))


;; Smartparens
;; Automatic Insertion, wrapping and paredit-like navigation
;; (use-package smartparens
;;   :disabled
;;   :ensure t
;;   :hook ((prog-mode text-mode) . smartparens-mode)
;;   :config
;;   ;; keybinding management
;;   (define-key smartparens-mode-map (kbd "C-M-f") 'sp-forward-sexp)
;;   (define-key smartparens-mode-map (kbd "C-M-b") 'sp-backward-sexp)
;;
;;   (define-key smartparens-mode-map (kbd "C-M-d") 'sp-down-sexp)
;;   (define-key smartparens-mode-map (kbd "C-M-a") 'sp-backward-down-sexp)
;;   (define-key smartparens-mode-map (kbd "C-S-d") 'sp-beginning-of-sexp)
;;   (define-key smartparens-mode-map (kbd "C-S-a") 'sp-end-of-sexp)
;;
;;   (define-key smartparens-mode-map (kbd "C-M-e") 'sp-up-sexp)
;;   (define-key smartparens-mode-map (kbd "C-M-u") 'sp-backward-up-sexp)
;;   (define-key smartparens-mode-map (kbd "C-M-t") 'sp-transpose-sexp)
;;
;;   (define-key smartparens-mode-map (kbd "C-M-n") 'sp-forward-hybrid-sexp)
;;   (define-key smartparens-mode-map (kbd "C-M-p") 'sp-backward-hybrid-sexp)
;;
;;   (define-key smartparens-mode-map (kbd "C-M-k") 'sp-kill-sexp)
;;   (define-key smartparens-mode-map (kbd "C-M-w") 'sp-copy-sexp)
;;
;;   (define-key smartparens-mode-map (kbd "M-<delete>") 'sp-unwrap-sexp)
;;   (define-key smartparens-mode-map (kbd "M-<backspace>") 'sp-backward-unwrap-sexp)
;;
;;   (define-key smartparens-mode-map (kbd "C-<right>") 'sp-forward-slurp-sexp)
;;   (define-key smartparens-mode-map (kbd "C-<left>") 'sp-forward-barf-sexp)
;;   (define-key smartparens-mode-map (kbd "C-M-<left>") 'sp-backward-slurp-sexp)
;;   (define-key smartparens-mode-map (kbd "C-M-<right>") 'sp-backward-barf-sexp)
;;
;;   (define-key smartparens-mode-map (kbd "M-D") 'sp-splice-sexp)
;;   (define-key smartparens-mode-map (kbd "C-M-<delete>") 'sp-splice-sexp-killing-forward)
;;   (define-key smartparens-mode-map (kbd "C-M-<backspace>") 'sp-splice-sexp-killing-backward)
;;   (define-key smartparens-mode-map (kbd "C-S-<backspace>") 'sp-splice-sexp-killing-around)
;;
;;   (define-key smartparens-mode-map (kbd "C-]") 'sp-select-next-thing-exchange)
;;   (define-key smartparens-mode-map (kbd "C-<left_bracket>") 'sp-select-previous-thing)
;;  (define-key smartparens-mode-map (kbd "C-M-]") 'sp-select-next-thing)
;;
;;  (define-key smartparens-mode-map (kbd "M-F") 'sp-forward-symbol)
;;  (define-key smartparens-mode-map (kbd "M-B") 'sp-backward-symbol)
;;
;;  (define-key smartparens-mode-map (kbd "M-i") 'sp-change-enclosing)
;;  (define-key smartparens-mode-map (kbd "C-\"") 'sp-change-inner)
;;
;;  ;; Unbind
;;  (define-key smartparens-mode-map (kbd "M-<up>") nil)
;;  (define-key smartparens-mode-map (kbd "M-<down>") nil)
;;  (setq sp-base-key-bindings 'paredit)
;;  (setq sp-autoskip-closing-pair 'always)
;;  (setq sp-hybrid-kill-entire-symbol nil)
;;  ;; In Elisp & org modes, do not ‘close’ a back-tick or single quote!
;;  (sp-local-pair 'emacs-lisp-mode "`" nil :when '(sp-in-string-p))
;;  (sp-local-pair 'emacs-lisp-mode "'" nil :when '(sp-in-string-p))
;;  (sp-local-pair 'org-mode "`" nil :when '(sp-in-string-p))
;;  (sp-local-pair 'org-mode "'" nil :when '(sp-in-string-p))
;;  (sp-local-pair
;;   '(org-mode)
;;   "<<" ">>"
;;   :actions '(insert))
;;  ;; Pair Management
;;  (sp-local-pair 'minibuffer-inactive-mode "'" nil :actions nil)
;;
;;
;;      ;;; markdown-mode
;;  (sp-with-modes '(markdown-mode gfm-mode rst-mode)
;;    (sp-local-pair "*" "*" :bind "C-*")
;;    (sp-local-tag "2" "**" "**")
;;    (sp-local-tag "s" "```scheme" "```")
;;    (sp-local-tag "<"  "<_>" "</_>" :transform 'sp-match-sgml-tags))
;; ;;; html-mode
;;  (sp-with-modes '(html-mode sgml-mode web-mode)
;;    (sp-local-pair "<" ">"))
;;     ;;; lisp modes
;;  (sp-with-modes sp--lisp-modes
;;    (sp-local-pair "(" nil :bind "C-("))
;;  (sp-use-paredit-bindings)
;;  (require 'smartparens-config)
;;  )



;; TLDR
;; TLDR cients for Emacs
(use-package tldr
  :ensure t
  :hook (tldr-mode . visual-line-mode)
  :defer t
  :config
  ;;  (setq tldr-use-word-at-point t)
  )


;; Visual Fill Column
(use-package visual-fill-column
  :ensure t
  :hook ((markdown-mode org-mode) . my/activate-visual-fill-column)
  :init
  (defun my/activate-visual-fill-column ()
    (interactive)
    (setq-local fill-column 111)
    (visual-line-mode t)
    (visual-fill-column-mode t))
  :config
  (setq-default visual-fill-column-center-text t)
  (setq-default visual-fill-column-fringes-outside-margins nil)

  )


;; Vundo
;; Visualize Undo Tree
(use-package vundo
  :ensure t
  :defer 1
  :bind
  (("C-x u" . vundo))
  :config
  (setq vundo-window-max-height 4)
  (setq vundo-compact-display t)
  (setq vundo-highlight-saved-nodes t)
  (setq vundo-glyph-alist vundo-unicode-symbols))




(provide 'ef-utilities)
;;; ef-utilities.el ends here
