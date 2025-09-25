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


(provide 'ef-utilities)
;;; ef-utilities.el ends here
