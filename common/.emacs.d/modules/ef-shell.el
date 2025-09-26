;;; ef-shell.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:
;; Eshell
;; Capf autosuggest
;; History autosuggestions for comint and eshell
(use-package capf-autosuggest
  :ensure t
  :hook
  (eshell-mode . capf-autosuggest-mode))

;; TODO: ESHELL

;; Exec Path from Shell
;; Get Environment variables such as $PATH from the shell
(use-package exec-path-from-shell
  :ensure t
  :defer t
  :if (memq window-system '(mac ns x pgtk))
  :custom
  (exec-path-from-shell-variables
   '("PATH" "MANPATH" "NODE_PATH")
   )
  :config
  (exec-path-from-shell-initialize))



;; Shell
;; Built-in shell
(use-package shell
  :ensure nill
  :custom
  (async-shell-command-buffer 'confirm-kill-processes)
  (ansi-color-for-comint-mode t)
  (shell-command-prompt-show-cwd 1)
  (shell-input-autoexpand 'input)
  (shell-highlight-undef-enable t)
  (shell-has-auto-cd nil)
  (shell-get-old-input-include-continuation-lines t)
  (shell-kill-buffer-on-exit t)
  )



;; Vterm
;; Fully featured terminal emulator
(use-package vterm
  :defer t
  :bind
  (("M-<RET>" . vterm))
  :config
  (setq vterm-kill-buffer-on-exit nil)
  (setq vterm-timer-delay nil)
  (setq vterm-shell "/usr/bin/fish"
        vterm-always-compile-module t))

;; Eat
;; Emulate a terminal, in a region, in a buffer and in eshell
;; (use-package eat
;;   :ensure t
;;   :config
;;   (eat-eshell-visual-command-mode 1))


(provide 'ef-shell)
;;; ef-shell.el ends here
