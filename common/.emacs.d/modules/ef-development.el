;;; ef-development.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:

;;; Apheleia
(use-package apheleia
  :ensure t
  :defer t
  :hook (apheleia-post-format . delete-trailing-whitespace)
  :config
  (setq apheleia-formatters-respect-fill-column t)
  (setq apheleia-formatters-respect-indent-level t)
  (setq apheleia-formatters
		(append
		 '((prettier . ("prettier" "--stdin-filepath" filepath))
		   (black . ("black" "-"))
		   (biome . ("biome"))
		   (stylua . ("stylua" "-"))
		   ;; (shfmt . ("shfmt" "-i" "2" "-ci" "-"))
		   (shfmt . ("shfmt" "-i" "2" "-ci"))
		   (tombi . ("tombi" "format" "-"))
		   )
		 apheleia-formatters))

  ;; Customize mode-to-formatter mapping.
  (setq apheleia-mode-alist
		'((python-mode . black)
		  ;; (javascript-mode . prettier)
		  ;; (typescript-mode . prettier)
		  (ruby-mode . rubocop)
		  (sh-mode . shfmt)
		  (lua-mode . stylua)
		  (yaml-ts-mode . prettier)
		  ;;; TRYING biome
		  ((css-mode css-ts-mode js-json-mode js-mode json-mode json-ts-mode tsx-ts-mode) . biome)
		  ((toml-ts-mode toml-mode) . tombi)
		  )        )
  :init
  (apheleia-global-mode 1))


;;; Eldoc
;;;; Eldoc (Emacs live documentation feedback)
;; Document thing at point.
(use-package eldoc
  :ensure nil
  ;; :hook (prog-mode . eldoc-mode)
  :custom
  (eldoc-print-after-edit nil)
  (eldoc-idle-delay 0.2)
  (eldoc-documentation-strategy
   'eldoc-documentation-compose-eagerly)
  (eldoc-echo-area-use-multiline-p 'truncate-sym-name-if-fit)
  (eldoc-echo-area-display-truncation-message t)
  (eldoc-echo-area-prefer-doc-buffer t)
  :config
  (setq eldoc-minor-mode-string "")
  (setq eldoc-message-function #'message)
  :init
  (global-eldoc-mode)
  )

;;; Eglot
;; Eglot (built-in client for the language server protocol)
(use-package eglot
  :ensure nil
  ;; :disabled
  ;; :defer t
  :bind (
		 ("C-c e i" . eglot-find-implementation)
		 ("C-c e e" . eglot)
		 ("C-c e d" . eglot-shutdown-all)
		 ("C-c e r" . eglot-rename)
		 ("C-c e R" . eglot-reconnect)
		 ("C-c e a" . eglot-code-actions)
		 ("C-c e m" . eglot-menu)
		 ("C-c e f" . eglot-format-buffer)
		 ("C-c e h" . eglot-inlay-hints-mode)
		 )
  ;; :hook (
  ;;        (bash-ts-mode . eglot-ensure)
  ;;        (c++-ts-mode . eglot-ensure)
  ;;        (c-ts-mode . eglot-ensure)
  ;; (html-ts-mode . eglot-ensure)
  ;;        ;; (lua-mode . eglot-ensure)
  ;;        (lua-ts-mode . eglot-ensure)
  ;;        (sh-mode . eglot-ensure)
  ;; (markdown-mode . eglot-ensure)
  ;;        (python-ts-mode . eglot-ensure)
  ;;        (js-ts-mode . eglot-ensure)
  ;;        (typescript-ts-mode . eglot-ensure)
  ;;        (rust-ts-mode . eglot-ensure)
  ;;        (css-ts-mode . eglot-ensure)
  ;;        (toml-ts-mode . eglot-ensure)
  ;;        (yaml-ts-mode . eglot-ensure)
  ;;        (web-mode . eglot-ensure)
  ;;        (before-save . eglot-format-buffer)
  ;; )
  :config
  (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster)
  ;; use eglot-server-programs variable to find out LSP
  ;; (with-eval-after-load 'eglot
  ;;   (add-to-list 'eglot-server-programs
  ;;                '(markdown-mode . ("marksman")))
  ;;   ;; (add-to-list 'eglot-server-programs '((yaml-ts-mode) . ("yaml-language-server" "--stdio")))
  ;;   ;; (add-to-list 'eglot-server-programs '((sh-mode bash-ts-mode) . ("bash-language-server" "start")))
  ;;   ;; (add-to-list 'eglot-server-programs '((css-ts-mode) . ("vscode-css-language-server" "--stdio")))
  ;;   ;; (add-to-list 'eglot-server-programs
  ;;   ;; '(web-mode . ("vscode-css-language-server" "--stdio")))
  ;;   ;; (add-to-list 'eglot-server-programs '((toml-ts-mode) . ("taplo" "--stdio")))
  ;;   ;; (add-to-list 'eglot-server-programs '((lua-mode) . ("stylua")))
  ;;   )
  (setq eglot-send-changes-idle-time 0.1)
  (setq eglot-events-buffer 0)
  (setq eglot-autoshutdown t)
  (setq eglot-sync-connect 1)
  (setq eglot-confirm-server-edits nil)
  (setq eglot-extend-to-xref t)
  (setq eglot-autoreconnect t)
  (setq eglot-stay-out-of '(yasnippet))
  (setq eglot-prefer-plaintext nil)
  (setq jsonrpc-event-hook nil)
  (setq eglot-events-buffer-config '(:size 0 :format full))
  (with-eval-after-load 'eglot
	(add-to-list
	 'eglot-server-programs
	 '(markdown-mode . ("marksman"))))
  (with-eval-after-load 'eglot
	(add-to-list
	 'eglot-server-programs
	 '((html-mode) .  ("vscode-html-language-server" "--stdio"))

	 ))
  (add-to-list 'eglot-server-programs '((toml-ts-mode) . ("tombi" "--stdio")))
  ;; Don't log every event
  (fset #'jsonrpc--log-event #'ignore)
  ;; (advice-add 'jsonrpc--log-event :override #'ignore)
  (setq completion-category-overrides '((eglot (styles orderless))))
  (defun my/eglot-setup ()
	"Setup eglot mode with specific exclusions."
	(unless (eq major-mode 'emacs-lisp-mode)
	  (eglot-ensure)))

  (add-hook 'prog-mode-hook #'my/eglot-setup)
  ;; Eldoc Integration
  (add-hook 'eglot-managed-mode-hook
			(lambda ()
			  (setq eldoc-documentation-functions
					(cons #'flymake-eldoc-function
						  (remove #'flymake-eldoc-function eldoc-documentation-functions))
					)

			  )

			)

  )



;;; Eglot Booster
;; eglot-booster: Boost eglot using lsp-booster
;; (use-package eglot-booster
;;   :ensure t
;;   :after eglot
;;   :config
;;   (eglot-booster-mode))

;;; Flymake
(use-package flymake
  :disabled
  :ensure nil
  :defer 10
  :bind ("C-c C-n" . flymake-show-buffer-diagnostics)
  :hook
  (prog-mode . flymake-mode)
  (text-mode . flymake-mode)
  (web-mode . flymake-mode)
  :config
  ;; Disable the legacy proc backend.
  (setq-default flymake-diagnostic-functions nil)
  (with-eval-after-load 'flymake-proc
	(remove-hook 'flymake-diagnostic-functions 'flymake-proc-legacy-flymake))
  (setq elisp-flymake-byte-compile-load-path '("./"))
  (setq flymake-fringe-indicator-position 'left-fringe)
  (setq flymake-margin-indicator-position 'right-margin)
  (setq flymake-suppress-zero-counters t)
  (setq flymake-no-changes-timeout nil)
  (setq flymake-start-on-flymake-mode t)
  (setq flymake-start-on-save-buffer t)
  ;; (setq flymake-proc-compilation-prevents-syntax-check t)
  (setq flymake-wrap-around nil)
  (setq flymake-mode-line-format
		'("" flymake-mode-line-exception flymake-mode-line-counters))
  (setq flymake-mode-line-counter-format
		'("" flymake-mode-line-error-counter
		  flymake-mode-line-warning-counter
		  flymake-mode-line-note-counter ""))
  (setq flymake-show-diagnostics-at-end-of-line nil)
  (setq flymake-indicator-type nil)
  (setq flymake-margin-indicators-string
		'((error   "X" compilation-error)
		  (warning "!" compilation-warning)
		  (note    "■" compilation-info)))

  (flymake-mode t)
  )

;;; Flymake Colletction
;; Collection of checkers for flymake, bringing flymake to the level of flycheck
(use-package flymake-collection
  :disabled
  :ensure t
  :after flymake
  :hook ((prog-mode) . flymake-collection-hook-setup)
  :custom
  (flymake-collection-hook-inherit-config t)
  (flymake-collection-hook-ignore-modes nil)
  )

;;; Flymake Flycheck
;; Use flycheck backends with flymake
(use-package flymake-flycheck
  :disabled
  :ensure t
  :after flymake
  :init
  (setopt flycheck-disabled-checkers '(python-mypy haskell-ghc haskell-hlint))
  :config
  (add-hook 'flymake-mode-hook 'flymake-flycheck-auto))

;;; Flymake Shellcheck
(use-package flymake-shellcheck
  :disabled
  :ensure t)

;;; Package Lint Flymake
;; Elisp packaging requirements
(use-package package-lint-flymake
  :disabled
  :ensure t
  :after flymake
  :config
  (add-hook 'flymake-diagnostic-functions #'package-lint-flymake))


;;; GUD
(use-package gud
  :ensure nil
  :custom
  (gud-highlight-current-line t))

;;;   Prog Mode
(use-package prog-mode
  :ensure nil
  :hook (prog-mode . prog-mode-setup)
  :preface
  (defun prog-mode-setup ()
	(setq-local fill-column 80)
	(prettify-symbols-mode t)
	(hl-line-mode t)
	(whitespace-mode t)
	)
  :init
  (add-to-list 'safe-local-variable-values '(fill-column . 120))

  (add-hook 'prog-mode-hook
			(lambda ()
			  (font-lock-add-keywords nil
									  '(("\\<\\(NOTE\\|FIXME\\|TODO\\|BUG\\|HACK\\|REFACTOR\\|THE HORROR\\)" 1 font-lock-warning-face t)))))
  )

;;; Sh-Script
(use-package sh-script
  :ensure nil
  :defer t
  :mode
  ("/\\.env\\'" . sh-mode)
  ("/\\.env\\." . sh-mode)
  ("/\\.envrc\\'" . sh-mode)
  ("/\\.envrc\\." . sh-mode)
  ("\\.zsh\\'" . sh-mode)
  ("/zshenv\\'" . sh-mode)
  ("/zshrc\\'" . sh-mode)
  ("\\.tmux\\'" . sh-mode)
  ("\\.tmuxsh\\'" . sh-mode)
  ("\\.tmuxtheme\\'" . sh-mode)

  ;; Auto-chmod scripts on save
  :hook (after-save . executable-make-buffer-file-executable-if-script-p)
  :bind (:map sh-mode-map
			  ([remap display-local-help] . man))
  :custom
  (sh-basic-offset 2)
  (sh-indentation  2)
  (sh-indent-for-continuation 'always)
  )

;;; Treesiter
(use-package treesit
  :ensure nil
  :defer t
  ;; :hook (bash-ts-mode json-ts-mode toml-ts-mode js-ts-mode python-ts-mode elisp-ts-mode markdown-ts-mode yaml-ts-mode css-ts-mode)
  :init
  (setq treesit-font-lock-level 4)
  ;; (setq treesit-auto-install-grammar t)
  ;; To check if grammar is working:
  ;; (treesit-language-available-p 'python)
  (setq treesit-language-source-alist
		'(
		  (bash "https://github.com/tree-sitter/tree-sitter-bash")
		  (c . ("https://github.com/tree-sitter/tree-sitter-c"))
		  (cmake           . ("https://github.com/uyha/tree-sitter-cmake"))
		  (cpp . ("https://github.com/tree-sitter/tree-sitter-cpp"))
		  (css "https://github.com/tree-sitter/tree-sitter-css")
		  (dockerfile      . ("https://github.com/camdencheek/tree-sitter-dockerfile"))
		  (elisp "https://github.com/Wilfred/tree-sitter-elisp")
		  (html . ("https://github.com/tree-sitter/tree-sitter-html"))
		  (java            . ("https://github.com/tree-sitter/tree-sitter-java"))
		  (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript"))
		  (json            . ("https://github.com/tree-sitter/tree-sitter-json"))
		  (jsdoc . "https://github.com/tree-sitter/tree-sitter-jsdoc" )
		  (latex           . ("https://github.com/latex-lsp/tree-sitter-latex"))
		  ;; (lua . ("https://github.com/Azganoth/tree-sitter-lua"))
		  (lua             . ("https://github.com/tree-sitter-grammars/tree-sitter-lua"))
		  (json "https://github.com/tree-sitter/tree-sitter-json")
		  (make . ("https://github.com/alemuller/tree-sitter-make"))
		  (markdown . (https://github.com/tree-sitter-grammars/tree-sitter-markdown ))
		  (markdown-inline . "https://github.com/tree-sitter-grammars/tree-sitter-markdown")
		  ;; (php . ("https://github.com/tree-sitter/tree-sitter-php"))
		  (python . ("https://github.com/tree-sitter/tree-sitter-python"))
		  ;; (rust . ("https://github.com/tree-sitter/tree-sitter-rust"))
		  ;; (sql . ("https://github.com/m-novikov/tree-sitter-sql"))
		  (typescript . "https://github.com/tree-sitter/tree-sitter-typescript")
		  (toml . ("https://github.com/tree-sitter/tree-sitter-toml"))
		  (yaml .  "https://github.com/tree-sitter-grammars/tree-sitter-yaml")


		  ))
  :config
  (dolist (lang '(bash c cmake cpp elisp html javascript json lua make yaml css python toml))
	(unless (treesit-language-available-p lang)
	  (treesit-install-language-grammar lang)))
  (setq major-mode-remap-alist
		'((bash-mode . bash-ts-mode)
		  (c-mode . c-ts-mode)
		  (c++-mode . c++-ts-mode)
		  (cpp-mode . cpp-ts-mode)
		  (html-mode . html-ts-mode)
		  (javascript-mode . javascript-ts-mode)
		  (json-mode . json-ts-mode)
		  (lua-mode . lua-ts-mode)
		  (css-mode . css-ts-mode)
		  (elisp-mode . elisp-ts-mode)
		  ;; (markdown-mode . markdown-ts-mode)
		  ;; (php-mode . php-ts-mode)
		  (python-mode . python-ts-mode)
		  ;; (rust-mode . rust-ts-mode)
		  (sh-mode . bash-ts-mode)
		  (shell-script-mode . bash-ts-mode)
		  (toml-mode . toml-ts-mode)
		  (yaml-mode . yaml-ts-mode)))
  ;; Alternative
  (push '(css-mode . css-ts-mode) major-mode-remap-alist)
  (push '(typescript-mode . tsx-ts-mode) major-mode-remap-alist)
  ;; FIXME: Functions
  ;;   (defun treesitter-config-reinstall-grammars ()
  ;; 	"Force reinstallation of all grammars in `treesit-language-source-alist'.
  ;; Use this to update grammars to their latest versions."
  ;; 	(interactive)
  ;; 	(dolist (lang-source treesit-language-source-alist)
  ;; 	  (let ((lang (car lang-source)))
  ;; 		(message "Treesitter: Reinstalling grammar for %s..." lang)
  ;; 		(cl-letf (((symbol-function 'y-or-n-p) (lambda (&rest _) t)))
  ;; 		  (treesit-install-language-grammar lang)))))
  ;;
  ;;   ;; Bootstrap missing grammars
  ;;   (dolist (lang-source treesit-language-source-alist)
  ;; 	(let ((lang (car lang-source)))
  ;; 	  (unless (treesit-language-available-p lang)
  ;; 		(message "Treesitter: Installing grammar for %s..." lang)
  ;; 		(condition-case err
  ;; 			(cl-letf (((symbol-function 'y-or-n-p) (lambda (&rest _) t)))
  ;; 			  (treesit-install-language-grammar lang))
  ;; 		  (error
  ;; 		   (display-warning 'treesitter
  ;; 							(format "Failed to install tree-sitter grammar for %s: %s"
  ;; 									lang (error-message-string err))
  ;; 							:error)))))))
  ;;
  ;; ;; Warn if tree-sitter is unavailable
  ;; (unless (and (fboundp 'treesit-available-p)
  ;; 			 (treesit-available-p))
  ;;   (display-warning 'treesitter "Tree-sitter is not available (not compiled in or library missing); skipping grammar bootstrap." :warning)

  )


(provide 'ef-development)
;;; ef-development.el ends here
