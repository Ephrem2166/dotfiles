;;; ef-lsp.el ---  -*- lexical-binding: t; -*-

;;; Commentary:
;;; Code:
;;; LSP MODE
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
         (lua-ts-mode . lsp-deferred)
         (python-ts-mode . lsp-deferred)
         (css-ts-mode . lsp-deferred)
         (js-json-mode . lsp-deferred)
         (toml-ts-mode   . lsp-deferred)
         (yaml-ts-mode   . lsp-deferred)
         (bash-ts-mode   . lsp-deferred)
         )
  :commands (lsp lsp-deferred)
  )

;;; LSP UI
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
  (lsp-ui-doc-max-height 25)
  (lsp-ui-doc-max-width 50)
  (lsp-ui-doc-position 'at-point)
  (lsp-ui-doc-show-with-cursor t)
  (lsp-ui-doc-show-with-mouse nil)
  (lsp-ui-peek-show-directory t)
  (lsp-ui-peek-enable t)
  (lsp-ui-sideline-enable nil)
  (lsp-ui-sideline-show-hover nil)
  :commands lsp-ui-mode)



;;; Ends Here
(provide 'ef-lsp)
;;; ef-lsp.el ends here
