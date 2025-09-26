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

;; Winner
;; Restore old window configurations
(use-package winner
  :ensure nil
  :hook (after-init . winner-mode)
  :init (setq winner-boring-buffers '("*Completions*"
                                      "*Compile-Log*"
                                      "*inferior-lisp*"
                                      "*Fuzzy Completions*"
                                      "*Apropos*"
                                      "*Help*"
                                      "*cvs*"
                                      "*Buffer List*"
                                      "*Ibuffer*"
                                      "*esh command on file*")))



;; Consult
;; Provides search and navigation commands
(use-package consult
  :ensure t
  :after (vertico minibuffer)
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :bind (
         ("C-c c ." . consult-mode-command)
         ("C-c c b" . consult-buffer)
         ("C-c c B" . consult-bookmark)
         ("C-c c e" . consult-compile-error)
         ("C-c c f" . consult-find)
         ("C-c c F" . consult-fd)
         ("C-c c g" . consult-grep)
         ("C-c c h" . consult-history)
         ("C-c c i" . consult-info)
         ("C-c c j" . consult-org-heading)
         ("C-c c L" . consult-line)
         ("C-c c l" . consult-goto-line)
         ("C-c c m" . consult-man)
         ("C-c c o" . consult-outline)
         ("C-c c p" . consult-project-buffer)
         ("C-c c r" . consult-recent-file)
         ("C-c c R" . consult-register)
         ("C-c c s" . consult-isearch-history)
         ("C-c c t" . consult-theme)
         ("C-c c y" . consult-yank-pop)
         )
  :init
  ;; Register
  (setq register-preview-delay 0.5)
  (setq register-preview-function #'consult-register-format)
  (advice-add #'register-preview :override #'consult-register-window)
  ;; Xref
  (setq xref-show-xrefs-function #'consult-xref)
  (setq xref-show-definitions-function #'consult-xref)
  :config
  (require 'consult-xref)
  (setq consult-line-numbers-widen t)
  ;; (setq completion-in-region-function #'consult-completion-in-region)
  ;; (setq xref-show-xrefs-function #'consult-xref)
  ;; (setq xref-show-definitions-function #'consult-xref)
  ;; Narrowing Key
  (setq consult-narrow-key "<")
  ;; Preview trigger keys
  (setq consult-preview-key 'any)
  (setq consult-project-function nil)
  ;; (show-smartparens-global-mode +1)

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

;; Lin
;; Make `hl-line-mode' more suitable for selection UIs
(use-package lin
  :ensure t
  :hook (after-init . lin-global-mode)
  :config
  (setq lin-face 'lin-cyan))


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




(provide 'ef-utilities)
;;; ef-utilities.el ends here
