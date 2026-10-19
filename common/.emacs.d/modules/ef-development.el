;;; ef-development.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:

;;; Apheleia
(use-package apheleia
  :ensure t
  :hook (apheleia-post-format-hook . delete-trailing-whitespace)
  :config
  (setq apheleia-formatters-respect-fill-column t)
  (setq apheleia-formatters-respect-indent-level t)
  ;; (setq apheleia-formatters
  ;; 		(append
  ;; 		 '(
  ;;
  ;; 		   (prettier . ("prettier" "--stdin-filepath" filepath))
  ;; 		   (black . ("black" "-"))
  ;; 		   (biome . ("biome"))
  ;; 		   (stylua . ("stylua" "-"))
  ;; 		   ;; (shfmt . ("shfmt" "-i" "2" "-ci" "-"))
  ;; 		   (shfmt . ("shfmt" "-i" "2" "-ci"))
  ;; 		   (tombi . ("tombi" "format" "-"))
  ;; 		   )
  ;; 		 apheleia-formatters))

  (with-eval-after-load 'apheleia
	;; Modify existing or add new formatters cleanly
	(setf (alist-get 'prettier apheleia-formatters) '("prettier" "--stdin-filepath" filepath))
	(setf (alist-get 'black apheleia-formatters)    '("black" "-"))
	(setf (alist-get 'biome apheleia-formatters)    '("biome" "format" "--stdin-file-path" filepath))
	(setf (alist-get 'stylua apheleia-formatters)   '("stylua" "-"))
	(setf (alist-get 'shfmt apheleia-formatters)    '("shfmt" "-i" "2" "-ci"))
	(setf (alist-get 'tombi apheleia-formatters)    '("tombi" "format" "-"))
	)

  ;; Customize mode-to-formatter mapping.
  (setq apheleia-mode-alist
		'((python-mode . black)
		  ;; (javascript-mode . prettier)
		  ;; (typescript-mode . prettier)
		  (ruby-mode . rubocop)
		  (sh-mode . shfmt)
		  (lua-mode . stylua)
		  ((yaml-mode yaml-ts-mode) . yamlfmt)
		  ;;; TRYING biome
		  ((css-mode css-ts-mode js-json-mode js-mode json-mode json-ts-mode tsx-ts-mode) . biome)
		  ((toml-ts-mode toml-mode) . tombi)
		  ))
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
  ;; (setq eldoc-message-function #'message)
  :init
  (global-eldoc-mode 1)
  )

;;; Eglot
;; Eglot (built-in client for the language server protocol)
;; Auto format eglot buffer
(defun ef/setup-eglot-format-on-save ()
  "Enable format-on-save for Eglot managed buffers.

Add `eglot-format-buffer' to the buffer-local `before-save-hook' when Eglot
manages the current buffer. Otherwise, remove it. Run formatting at depth -10,
before hooks at the default depth."
  (when (fboundp 'eglot-format-buffer)
	(if (and (fboundp 'eglot-managed-p)
			 (eglot-managed-p))
		(add-hook 'before-save-hook #'eglot-format-buffer -10 t)
	  (remove-hook 'before-save-hook #'eglot-format-buffer t))))

(add-hook 'eglot-managed-mode-hook #'ef/setup-eglot-format-on-save)
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
  ;; Cape integration only if cape is loaded.
  ;; (when (fboundp 'cape-wrap-buster)
  ;; 	(advice-add 'eglot-completion-at-point :around #'cape-wrap-buster))

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
  ;; (add-to-list 'eglot-server-programs '(python-mode . ("pylsp")))
  ;; (add-to-list 'eglot-server-programs '(python-ts-mode . ("pylsp")))
  ;;   )
  (setq eglot-send-changes-idle-time 0.1)
  ;; (setq eglot-events-buffer 0) ;; Deprecated
  (setq eglot-autoshutdown nil)
  ;; (setq eglot-sync-connect 1) ;; Deprecated
  (setq eglot-confirm-server-edits 'summary)
  (setq eglot-connect-timeout 1)
  (setq eglot-extend-to-xref t)
  (setq eglot-autoreconnect t)
  (setq eglot-stay-out-of '(yasnippet flymake))
  (setq eglot-prefer-plaintext nil)
  (setq jsonrpc-event-hook nil)
  (setq eglot-events-buffer-config '(:size 0 :format full))
  (setq eglot-ignored-server-capabilities '(:inlayHintProvider :codeLensProvider))
  ;; Register extra servers.
  (dolist (entry '((markdown-mode . ("marksman"))
				   ((html-mode)    . ("vscode-html-language-server" "--stdio"))
				   ((toml-ts-mode) . ("tombi" "--stdio"))))
	(add-to-list 'eglot-server-programs entry))
  ;; Don't log every event
  ;;   (fset #'jsonrpc--log-event #'ignore)
  (advice-add 'jsonrpc--log-event :override #'ignore)
  ;; (advice-add 'jsonrpc--log-event :override #'ignore)
  ;; (setq completion-category-overrides '((eglot (styles orderless))))
  (add-to-list 'completion-category-overrides '(eglot (styles orderless)))
  ;; Auto-start eglot in prog-mode buffers, skipping modes with no server.
  (defun ef/eglot-setup ()
	"Start eglot in the current buffer unless opted out."
	(unless (or (eq major-mode 'emacs-lisp-mode)
				(bound-and-true-p eglot--managed-mode))
	  (eglot-ensure)))
  (add-hook 'prog-mode-hook #'ef/eglot-setup)
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
  ;; (text-mode . flymake-mode)
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

  ;; (flymake-mode t)
  )

;;; Flymake Collection
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
  ("\\(?:^\\|/\\)\\.env\\(?:rc\\)?\\(?:\\.\\|\\'\\)" . sh-mode)
  ("\\(?:^\\|/\\)\\.zsh\\(?:rc\\|env\\|profile\\)?\\'" . sh-mode)
  ("\\(?:^\\|/\\)\\.\\(?:ba\\|z\\)shrc\\'" . sh-mode)
  ("\\(?:^\\|/\\)\\.tmux\\(?:sh\\|themes?\\|\\.conf\\)?\\'" . sh-mode)
  ;; Auto-chmod scripts on save
  ;; :hook (after-save . executable-make-buffer-file-executable-if-script-p)
  :hook (sh-mode . (lambda () (add-hook 'after-save-hook #'executable-make-buffer-file-executable-if-script-p nil t)))
  :custom
  (sh-basic-offset 2)
  (sh-indentation  2)
  ;; (sh-indent-for-continuation 'always)
  (sh-indent-after-continuation 'always)
  )

;;; Treesiter

(use-package treesit
  :ensure nil
  :preface
  (defun ef/maybe-remap-mode (from to)
	"Push (FROM . TO) onto `major-mode-remap-alist' if TO is bound."
	(when (fboundp to)
	  (push (cons from to) major-mode-remap-alist)))
  (defun ef/treesit-install-all ()
	"Install every missing grammar in `treesit-language-source-alist'."
	(interactive)
	(dolist (entry treesit-language-source-alist)
	  (let ((lang (car entry)))
		(unless (treesit-language-available-p lang)
		  (message "Installing tree-sitter grammar: %s" lang)
		  (condition-case err
			  (treesit-install-language-grammar lang)
			(error (display-warning
					'treesitter
					(format "Failed %s: %s" lang (error-message-string err))
					:error)))))))
  :init
  (setq treesit-font-lock-level 4)
  (setq treesit-language-source-alist
		'((bash            . ("https://github.com/tree-sitter/tree-sitter-bash"))
		  (c               . ("https://github.com/tree-sitter/tree-sitter-c"))
		  (cmake           . ("https://github.com/uyha/tree-sitter-cmake"))
		  (cpp             . ("https://github.com/tree-sitter/tree-sitter-cpp"))
		  (css             . ("https://github.com/tree-sitter/tree-sitter-css"))
		  (dockerfile      . ("https://github.com/camdencheek/tree-sitter-dockerfile"))
		  (elisp           . ("https://github.com/Wilfred/tree-sitter-elisp"))
		  (html            . ("https://github.com/tree-sitter/tree-sitter-html"))
		  (java            . ("https://github.com/tree-sitter/tree-sitter-java"))
		  (javascript      . ("https://github.com/tree-sitter/tree-sitter-javascript"))
		  (jsdoc           . ("https://github.com/tree-sitter/tree-sitter-jsdoc"))
		  (json            . ("https://github.com/tree-sitter/tree-sitter-json"))
		  (latex           . ("https://github.com/latex-lsp/tree-sitter-latex"))
		  (lua             . ("https://github.com/tree-sitter-grammars/tree-sitter-lua"))
		  (make            . ("https://github.com/alemuller/tree-sitter-make"))
		  (markdown        . ("https://github.com/tree-sitter-grammars/tree-sitter-markdown"
							  "split_parser" "tree-sitter-markdown/src"))
		  (markdown-inline . ("https://github.com/tree-sitter-grammars/tree-sitter-markdown"
							  "split_parser" "tree-sitter-markdown-inline/src"))
		  (python          . ("https://github.com/tree-sitter/tree-sitter-python"))
		  (typescript      . ("https://github.com/tree-sitter/tree-sitter-typescript"))
		  (toml            . ("https://github.com/tree-sitter/tree-sitter-toml"))
		  (yaml            . ("https://github.com/tree-sitter-grammars/tree-sitter-yaml"))))
  :config
  ;; Install on demand, not at startup.
  (unless (treesit-language-available-p 'python)
	(message "tree-sitter grammars missing — run M-x ef/treesit-install-all"))

  ;; Only remap when the target mode is actually defined.
  (mapc (lambda (pair) (ef/maybe-remap-mode (car pair) (cdr pair)))
		'((bash-mode       . bash-ts-mode)
		  (c-mode          . c-ts-mode)
		  (c++-mode        . c++-ts-mode)
		  (css-mode        . css-ts-mode)
		  (html-mode       . html-ts-mode)
		  (js-mode         . js-ts-mode)
		  (json-mode       . json-ts-mode)
		  (lua-mode        . lua-ts-mode)
		  (python-mode     . python-ts-mode)
		  (sh-mode         . bash-ts-mode)
		  (toml-mode       . toml-ts-mode)
		  (typescript-mode . typescript-ts-mode)
		  (yaml-mode       . yaml-ts-mode)
		  (emacs-lisp-mode . elisp-ts-mode))))




(provide 'ef-development)
;;; ef-development.el ends here
