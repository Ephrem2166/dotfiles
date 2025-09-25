;;; ef-utilities.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:

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
