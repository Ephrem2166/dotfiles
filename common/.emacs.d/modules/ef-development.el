;;; ef-development.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:

;; Eldoc
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



;; Eglot
;; Eglot (built-in client for the language server protocol)
(use-package eglot
  :ensure nil
  :disabled
  :diminish
  :preface
  :defer t
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
  :hook (
         (bash-ts-mode . eglot-ensure)
         (c++-ts-mode . eglot-ensure)
         (c-ts-mode . eglot-ensure)
         (sh-mode . eglot-ensure)
         (markdown-mode . eglot-ensure)
         (python-ts-mode . eglot-ensure)
         (js-ts-mode . eglot-ensure)
         (typescript-ts-mode . eglot-ensure)
         (rust-ts-mode . eglot-ensure)
         (css-ts-mode . eglot-ensure)
         (toml-ts-mode . eglot-ensure)
         (yaml-ts-mode . eglot-ensure)
         (web-mode . eglot-ensure)
         (before-save . eglot-format-buffer)
         )
  :config
  (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster)
  (fset #'jsonrpc--log-event #'ignore)
  ;; use eglot-server-programs variable to find out LSP
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 '(markdown-mode . ("marksman")))
    (add-to-list 'eglot-server-programs '((yaml-ts-mode) . ("yaml-language-server" "--stdio")))
    (add-to-list 'eglot-server-programs '((sh-mode bash-ts-mode) . ("bash-language-server" "start")))
    (add-to-list 'eglot-server-programs '((css-ts-mode) . ("vscode-css-language-server" "--stdio")))
    (add-to-list 'eglot-server-programs
                 '(web-mode . ("vscode-css-language-server" "--stdio")))
    (add-to-list 'eglot-server-programs '((toml-ts-mode) . ("taplo" "--stdio"))))
  (setq eglot-sync-connect 1)
  (setq eglot-autoshutdown t)
  (setq eglot-confirm-server-edits nil)
  (setq eglot-extend-to-xref t)
  (setq eglot-autoreconnect t)
  (setq eglot-stay-out-of '(yasnippet))
  :init
  (setq completion-category-overrides '((eglot (styles orderless))))
  )

;; eglot-booster: Boost eglot using lsp-booster
;; (use-package eglot-booster
;;   :ensure t
;;   :after eglot
;;   :config
;;   (eglot-booster-mode))

;; Flycheck
;; Use Flymake
(use-package flycheck
  :disabled
  :ensure t
  :bind (
         ("C-c t f" . flycheck-mode)
         )
  :defer t
  :init (global-flycheck-mode)
  (setq flycheck-idle-change-delay 1.0)
  ;; Display errors a little quicker (default is 0.9s))
  (setq flycheck-display-errors-delay 0.25)
  ;; Replace with `sideline-flycheck'
  (setq flycheck-display-errors-function nil)
  ;; (message-clean-mode-add-echo-commands '( flycheck-display-error-messages))
  (setq flycheck-highlighting-mode 'columns)
  (setq flycheck-help-echo-function nil)
  (setq-default left-fringe-width 1 right-fringe-width 8
                left-margin-width 1 right-margin-width 0)
  ;; Show indicators in the left margin
  (setq flycheck-indication-mode 'left-margin)
  (setq flycheck-display-errors-function
        #'flycheck-display-error-messages-unless-error-list)
  (setq flycheck-check-syntax-automatically '(save mode-enabled idle-change))
  ;; Elisp related
  (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))
  (setq flycheck-emacs-lisp-load-path 'inherit)
  )


;; Flymake
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

;; Flymake Colletction
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

;; Use flycheck backends with flymake
(use-package flymake-flycheck
  :disabled
  :ensure t
  :after flymake
  :init
  (setopt flycheck-disabled-checkers '(python-mypy haskell-ghc haskell-hlint))
  :config
  (add-hook 'flymake-mode-hook 'flymake-flycheck-auto))

;; Shell Support
(use-package flymake-shellcheck
  :disabled
  :ensure t)

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

;; LSP MODE
;; Emacs client/library for the Language Server Protocol
;; Install language servers using lsp-install-server
(use-package lsp-mode
  :ensure t
  :defer t
  :config
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l"
  (setq lsp-keymap-prefix "C-c l")
  (setq read-process-output-max (* 3 1024 1024))
  (setq lsp-auto-guess-root t)
  ;; (fset #'jsonrpc--log-event #'ignore)
  :custom
  (lsp-eldoc-render-all t)
  (lsp-idle-delay 0.6)
  (lsp-completion-enable t)
  (lsp-completion-provider :none)
  (lsp-completion-show-detail t)
  (lsp-completion-show-kind t)
  (lsp-completion-sort-initial-results t)
  (lsp-diagnostics-provider :flymake)

  (lsp-headerline-breadcrumb-enable t)
  (lsp-auto-register-remote-clients nil)

  (lsp-enable-imenu t)
  (lsp-enable-links nil)
  (lsp-enable-snippet nil)
  (lsp-enable-folding nil)
  (lsp-enable-file-watchers nil)
  (lsp-enable-symbol-highlighting t)
  (lsp-enable-text-document-color t)
  (lsp-enable-which-key-integration t)
  (lsp-enable-on-type-formatting nil)
  (lsp-enable-xref t)

  (lsp-file-watch-threshold 1000)
  (lsp-go-use-placeholders nil)

  (lsp-modeline-code-actions-enable t)
  (lsp-modeline-code-actions-segments '(count icon name))
  (lsp-modeline-diagnostics-enable t)
  (lsp-modeline-diagnostics-scope :workspace)
  (lsp-signature-auto-activate nil)
  :hook (
         (c-ts-mode          . lsp-deferred)
         (c++-ts-mode        . lsp-deferred)
         (html-ts-mode       . lsp-deferred)
         ;; (sh-mode         . lsp-deferred)
         (js-ts-mode . lsp-deferred)
         ;; (markdown-mode . lsp-deferred)
         (lsp-mode        . lsp-ui-mode)
         (python-ts-mode . lsp-deferred)
         (css-ts-mode . lsp-deferred)
         (js-json-mode . lsp-deferred)
         (toml-ts-mode   . lsp-deferred)
         (yaml-ts-mode   . lsp-deferred)
         (bash-ts-mode   . lsp-deferred)
         )
  :commands (lsp lsp-deferred)
  )
;; LSP UI
(use-package lsp-ui
  :ensure t
  :defer t
  :after lsp
  :config
  (setq lsp-ui-peek-always-show t
        lsp-ui-doc-enable t
        lsp-ui-sideline-show-diagnostics t
        lsp-ui-sideline-show-code-action t)
  :custom
  (lsp-ui-doc-delay 2)
  (lsp-ui-doc-max-height 5)
  (lsp-ui-doc-max-width 30)
  (lsp-ui-doc-position 'at-point)
  (lsp-ui-doc-show-with-cursor t)
  (lsp-ui-doc-show-with-mouse nil)
  (lsp-ui-peek-show-directory t)
  (lsp-ui-peek-enable t)
  (lsp-ui-sideline-enable nil)
  (lsp-ui-sideline-show-hover nil)
  :commands lsp-ui-mode)


;; Prog Mode
(use-package prog-mode
  :ensure nil
  :hook (
         (prog-mode . prettify-symbols-mode)

         ) )

;; Sh-Script
(use-package sh-script
  :ensure nil
  :defer t
  :bind (:map sh-mode-map
              ([remap display-local-help] . man))
  :custom
  (sh-basic-offset 2)
  (sh-indentation  2)
  )


;; TODO Treesiter
(use-package treesit
  :ensure nil
  :defer t
  ;; :hook (bash-ts-mode json-ts-mode toml-ts-mode js-ts-mode python-ts-mode elisp-ts-mode markdown-ts-mode yaml-ts-mode css-ts-mode)
  :init
  (setq treesit-font-lock-level 4)
  (setq treesit-language-source-alist
        '(
          (bash "https://github.com/tree-sitter/tree-sitter-bash")
          (c . ("https://github.com/tree-sitter/tree-sitter-c"))
          (cpp . ("https://github.com/tree-sitter/tree-sitter-cpp"))
          (css "https://github.com/tree-sitter/tree-sitter-css")
          (elisp "https://github.com/Wilfred/tree-sitter-elisp")
          (html . ("https://github.com/tree-sitter/tree-sitter-html"))
          (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript"))
          (lua . ("https://github.com/Azganoth/tree-sitter-lua"))
          (json "https://github.com/tree-sitter/tree-sitter-json")
          (make . ("https://github.com/alemuller/tree-sitter-make"))
          ;; (markdown "https://github.com/ikatyang/tree-sitter-markdown")
          ;; (php . ("https://github.com/tree-sitter/tree-sitter-php"))
          (python "https://github.com/tree-sitter/tree-sitter-python")
          ;; (rust . ("https://github.com/tree-sitter/tree-sitter-rust"))
          ;; (sql . ("https://github.com/m-novikov/tree-sitter-sql"))
          (toml . ("https://github.com/tree-sitter/tree-sitter-toml"))
          (yaml "https://github.com/ikatyang/tree-sitter-yaml")))
  :config
  (dolist (lang '(bash c cpp elisp html javascript json lua make yaml css python toml))
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
  )

(provide 'ef-development)
;;; ef-development.el ends here
