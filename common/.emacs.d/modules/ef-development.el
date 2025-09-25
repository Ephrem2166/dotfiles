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
  :disabled
  :ensure nil
  :diminish
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
  (fset #'jsonrpc--log-event #'ignore)
  ;; use eglot-server-programs variable to find out LSP
  (add-to-list 'eglot-server-programs
               '(markdown-mode . ("marksman")))
  (add-to-list 'eglot-server-programs '((yaml-ts-mode) . ("yaml-language-server" "--stdio")))
  (add-to-list 'eglot-server-programs '((sh-mode bash-ts-mode) . ("bash-language-server" "start")))
  (add-to-list 'eglot-server-programs '((css-ts-mode) . ("vscode-css-language-server" "--stdio")))
  (add-to-list 'eglot-server-programs
               '(web-mode . ("vscode-css-language-server" "--stdio")))
  (setq eglot-sync-connect 1)
  (setq eglot-autoshutdown t)
  (setq eglot-confirm-server-edits nil)
  (setq eglot-extend-to-xref t)
  (setq eglot-autoreconnect t)
  (setq eglot-stay-out-of '(yasnippet))
  :init
  (setq completion-category-overrides '((eglot (styles orderless))))
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
  (dolist (lang '(bash c cpp elisp html javascript json lua make yaml css markdown python toml))
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
