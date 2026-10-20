;;; ef-shell.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:
;;; Capf autosuggest
;; History autosuggestions for comint and eshell
(use-package capf-autosuggest
  :ensure t
  :hook
  (  (eshell-mode . capf-autosuggest-mode)
	 (shell-mode . capf-autosuggest-mode))
  )
;;; Comint
(use-package comint
  :ensure nil
  :config
  (setopt comint-prompt-read-only t)
  (setopt comint-buffer-maximum-size 8192)
  (setopt comint-scroll-to-bottom-on-input t)
  (setopt comint-scroll-to-bottom-on-output nil)
  (setopt comint-input-ignoredups t)
  (setopt comint-scroll-show-maximum-output t)
  (setopt comint-input-ring-size 5000)
  (setopt comint-input-ring-file-name
		  (expand-file-name "etc/comint_history" user-emacs-directory))
  :hook ((comint-mode . ansi-color-for-comint-mode-on)
		 (comint-mode . (lambda ()
						  (add-hook 'kill-buffer-hook
									#'comint-write-input-ring nil t))))
  )

;; Eat
;; Emulate a terminal, in a region, in a buffer and in eshell
;; Alternative to vterm
;; (use-package eat
;;   :ensure t
;;   :config
;;   (eat-eshell-visual-command-mode 1))


;;; ESHELL
(use-package eshell
  :ensure nil
  :bind (("M-<RET>" . eshell)   ; or C-c e
		 :map eshell-mode-map
		 ("C-d" . eshell-delchar-or-maybe-eof)
		 ("C-c C-k" . eshell-kill-process)
		 ("M-m" . eshell-bol))
  :hook ((eshell-mode . (lambda ()
						  ;; Fix C-a to go to bol, not prompt
						  (local-set-key (kbd "C-a") #'eshell-bol)
						  ;; Fix narrowing to work
						  (setq-local pcomplete-auto-help nil)))
		 (eshell-pre-command . eshell-save-some-history))
  :custom
  (eshell-hist-ignoredups t)
  (eshell-save-history-on-exit t)
  (eshell-history-size 5000)
  (eshell-scroll-show-maximum-output t)
  (eshell-prefer-lisp-functions nil)         ; use external binaries
  (eshell-prefer-lisp-variables t)            ; use $HOME, $PATH from Lisp
  (eshell-error-if-no-glob t)
  (eshell-glob-case-insensitive t)
  (eshell-prompt-function
   (lambda ()
	 (concat (abbreviate-file-name (eshell/pwd))
			 (if (= (user-uid) 0) " # " " $ "))))
  :config
  ;; Commands that should open in a visual terminal (vim, top, htop, etc.)
  (add-to-list 'eshell-visual-commands "htop")
  (add-to-list 'eshell-visual-commands "btop")
  (add-to-list 'eshell-visual-commands "nvim")
  (add-to-list 'eshell-visual-commands "tmux")
  ;; Subcommands of visual commands
  (add-to-list 'eshell-visual-subcommands '(git log))
  (add-to-list 'eshell-visual-subcommands '(git diff))
  (add-to-list 'eshell-visual-subcommands '(docker log))
  (add-to-list 'eshell-visual-subcommands '(docker exec))
  ;; Optional: enable TRAMP remote paths in eshell
  (setq eshell-modules
		'(eshell-alias eshell-banner eshell-basic eshell-cmpl
					   eshell-glob eshell-hist eshell-ls eshell-prompt
					   eshell-pred eshell-script eshell-smart eshell-term
					   eshell-unix)))


;;; Exec Path from Shell
;; Get Environment variables such as $PATH from the shell
(use-package exec-path-from-shell
  :ensure t
  :defer t
  :if (memq window-system '(mac ns pgtk))
  :custom
  (exec-path-from-shell-variables
   '("PATH" "MANPATH" "NODE_PATH")
   )
  :config
  (exec-path-from-shell-copy-envs '("PATH" "MANPATH"))
  (exec-path-from-shell-initialize))

;;; Shell
;; Built-in shell
(use-package shell
  :ensure nil
  :hook ((shell-mode . shell-highlight-undef-mode)
		 (shell-mode . (lambda ()
						 (setq-local truncate-lines t))))
  :custom
  (async-shell-command-buffer 'confirm-kill-process)
  (ansi-color-for-comint-mode t)
  (shell-command-prompt-show-cwd t)
  (shell-input-autoexpand 'input)
  (shell-highlight-undef-enable t)
  (shell-has-auto-cd nil)
  (shell-get-old-input-include-continuation-lines t)
  (shell-kill-buffer-on-exit t)
  )

;;; Vterm
;; Fully featured terminal emulator
(use-package vterm
  :ensure t
  :defer t
  :bind
  (("M-<RET>" . vterm))
  :config
  (setq vterm-kill-buffer-on-exit nil)
  (setq vterm-timer-delay nil)
  (setq vterm-shell "/usr/bin/zsh"))

(provide 'ef-shell)
;;; ef-shell.el ends here
