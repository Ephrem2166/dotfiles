;;; ef-languages.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:
;;; LATEX
(use-package auctex
  :ensure nil
  :hook ((LaTeX-mode . LaTeX-preview-setup)
         (LaTeX-mode . LaTeX-math-mode)
         (LaTeX-mode . flyspell-mode)
         (LaTeX-mode . turn-on-reftex))
  :mode ("\\.tex\\'" . latex-mode)
  :config
  (setq TeX-auto-save t
        TeX-parse-self t
        TeX-save-query nil
        TeX-PDF-mode t
        TeX-source-correlate-mode t
        TeX-source-correlate-method 'auto
        TeX-source-correlate-start-server t))

;;; TODO C
;; (use-package cc-mode
;;   :ensure nil
;;   :mode (("\\.c\\'" . c-mode)
;;          ("\\.h\\'" . c-mode)
;;          ("\\.cpp\\'" . cpp-mode)
;;          ("\\.hpp\\'" . cpp-mode))
;;   )

;;; TODO C++

;;; Conf Mode
;; Simple major mode for editing conf/ini/properties files
(use-package conf-mode
  :ensure nil
  :mode ("\\*.conf\\'" "\\config\\'" "\\.env\\..*\\'" "\\.env\\'"))

;;; CSS
(use-package css-ts-mode
  :ensure nil
  :mode ("\\*.css\\'"))

;;; Docker
(use-package dockerfile-ts-mode
  :mode "Dockerfile\\'")

(use-package docker-compose-mode
  :ensure t
  :mode "docker-compose\\'")
;;; Emacslisp
(use-package emacs-lisp-mode
  :ensure nil
  :mode ("\\.el\\'" "\\.el.tmpl\\'"))

;;; Elisp Autofmt
;; Emacs lisp auto-format
(use-package elisp-autofmt
  :ensure t
  :defer t
  :commands(elisp-autofmt-mode
            elisp-autofmt-buffer
            elisp-autofmt-region))

;;; Elisp Refs
;; Provides functions to find references to functions, macros, variables,
;; special forms, and symbols in Emacs Lisp
(use-package elisp-refs
  :ensure t
  :defer t
  :commands (elisp-refs-function
             elisp-refs-macro
             elisp-refs-variable
             elisp-refs-special
             elisp-refs-symbol))

;;; Elpy
;; Elpy is an Emacs package to bring powerful
;; Python editing to Emacs.
(use-package elpy
  :disabled
  :ensure t
  :defer t
  :init
  (elpy-enable))

;;; Emmet
;; (use-package emmet-mode
;;   :ensure t
;;   :hook ((web-mode . emmet-mode)
;;          (html-mode . emmet-mode)
;;          (css-mode . emmet-mode)))

;;; Git Mode
(use-package git-modes
  :ensure t
  :mode (("/.gitignore\\'" . gitignore-mode)
         ("/.dockerignore\\'" . gitignore-mode))
  )

;;; TODO HTML
;;; JSON
(use-package json-ts-mode
  :ensure nil
  :mode ("\\.json\\'" "\\.jsonc\\'" "\\.jsonc.tmpl\\'")
  )

;;; Jsonrpc
(use-package jsonrpc
  :ensure nil
  :config
  (fset #'jsonrpc--log-event #'ignore) ;; speed up lsp output.
  )

;;; JavaScript
(use-package js-json-mode
  :ensure nil
  :defer t
  :hook (
         (js-json-mode . rainbow-mode)
         (js-json-mode . display-line-numbers-mode)
         )
  :mode ("\\.json\\’" "\\.jsonc\\’")
  )

;;; Lispy
(use-package lispy
  :disabled
  :ensure t
  :hook (emacs-lisp-mode . lispy-mode))

;;; LUA
;; (use-package lua-mode
;;   :ensure t
;;   :defer t
;;   :custom
;;   (lua-indent-level 2)
;;   (lua-indent-string-contents t)
;;   :config
;;   (add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
;;   (add-to-list 'interpreter-mode-alist '("lua" . lua-mode))
;;   )

(use-package lua-ts-mode
  :ensure nil
  :defer t
  :mode ("\\*.lua$\\'")
  )



;;; MARKDOWN
;; Markdown Header Configuration
(defun my/markdown-headers ()
  (set-face-attribute 'markdown-header-face-1 nil :height 2.0)
  (set-face-attribute 'markdown-header-face-2 nil :height 1.75)
  (set-face-attribute 'markdown-header-face-3 nil :height 1.5)
  (set-face-attribute 'markdown-header-face-4 nil :height 1.3)
  (set-face-attribute 'markdown-header-face-5 nil :height 1.15)
  (set-face-attribute 'markdown-header-face-6 nil :height 1.05)
  (set-face-attribute 'markdown-code-face nil :inherit 'fixed-pitch)
  ;; '(custom-set-faces!
  ;;   '(markdown-header-face-1 :height 1.25 :weight extra-bold :inherit markdown-header-face)
  ;;   '(markdown-header-face-2 :height 1.15 :weight bold       :inherit markdown-header-face)
  ;;   '(markdown-header-face-3 :height 1.08 :weight bold       :inherit markdown-header-face)
  ;;   '(markdown-header-face-4 :height 1.00 :weight bold       :inherit markdown-header-face)
  ;;   '(markdown-header-face-5 :height 0.90 :weight bold       :inherit markdown-header-face)
  ;;   '(markdown-header-face-6 :height 0.75 :weight extra-bold :inherit markdown-header-face))
  )

;;;; Markdown (markdown-mode)
(use-package markdown-mode
  :ensure t
  :defer t
  :hook (
         (markdown-mode . visual-line-mode)
         (markdown-mode . lsp)
         (markdown-mode . my/markdown-headers)
         )

  :mode (("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :config
  (require 'lsp-marksman)
  (setopt markdown-indent-on-enter 'indent-and-new-item)
  (setopt markdown-hide-markup t)
  (setopt markdown-enable-math t)
  (setopt markdown-fontify-code-blocks-natively t))

;;; Markdown Preview Mode
;; To view markdown files in a browser (firefox)
(use-package markdown-preview-mode
  :disabled
  :ensure t
  :hook ((markdown-mode . markdown-preview-mode)
         (gfm-mode . markdown-preview-mode))
  :custom (browse-url-browser-function 'browse-url-firefox))

;;; Paredit
;; Prevent parenthesis imbalance
(use-package paredit
  :disabled
  :ensure t
  :defer t
  :diminish paredit-mode
  :commands paredit-mode
  :hook
  (emacs-lisp-mode . paredit-mode)
  ;; :config
  ;; (define-key paredit-mode-map (kbd "RET") nil))
  )

;;; Prettier
(use-package prettier-js
  :ensure t
  :hook
  ((json-mode js2-mode inferior-js-mode typescript-mode css-mode) . prettier-js-mode))

;;; TODO Python
(use-package python-ts-mode
  :ensure nil
  :mode "\\.py\\'"
  :custom
  (python-indent-guess-indent-offset t)
  (python-indent-guess-indent-offset-verbose nil)
  :init
  (setq-default python-shell-interpreter "python3")
  (setq-default python-indent-offset 4))

;;; TODO Rust
;; (use-package rust-ts-mode
;;   :ensure nil
;;   :defer t
;;   :mode "\\.rs\\'"
;;   :custom
;;   (rust-indent-offset 4)
;;   (rust-format-on-save t)
;;   )

;;; Shell Mode
(use-package sh-mode
  :ensure nil
  :defer t
  :hook (sh-mode . flymake-mode)
  :mode ("\\.\\(sh\\|bash\\|zsh\\|zsh-theme\\)\\'" . sh-mode)
  :mode
  (("bashrc$" . sh-mode)
   ("bash_profile$" . sh-mode)
   ("bash_aliases$" . sh-mode)
   ("bash_local$" . sh-mode)
   ("bash_completion$" . sh-mode)
   ("\\.zsh" . sh-mode)
   ("zshrc" . sh-mode)
   ("runcoms/[a-zA-Z]+$" . sh-mode)))

;;; TOML
(use-package toml-ts-mode
  :ensure nil
  :defer t
  :hook (
         (toml-ts-mode . rainbow-mode)
         ( toml-ts-mode . display-line-numbers-mode)
         )
  :mode "\\.toml\\'"
  :mode "/\\(Cargo.lock\\|\\.cargo/config\\)\\'"
  )

;;; Vimrc
(use-package vimrc-mode
  :ensure t
  :mode (".vi\\(mrc\\|mperatorrc\\|fmrc\\|ebrc\\)?$")
  )

;;; Web Mode
(use-package web-mode
  :ensure t
  :mode
  (("\\.phtml\\'" . web-mode)
   ("\\.php\\'" . web-mode)
   ;; ("\\.css\\'"    . web-mode)
   ("\\.tpl\\'" . web-mode)
   ("\\.[agj]sp\\'" . web-mode)
   ("\\.as[cp]x\\'" . web-mode)
   ("\\.erb\\'" . web-mode)
   ("\\.mustache\\'" . web-mode)
   ("\\.djhtml\\'" . web-mode)
   ("\\.html\\'" . web-mode)
   ("\\.htm\\'" . web-mode)
   )
  :config
  ;; Indentation
  (setq
   web-mode-markup-indent-offset 2
   web-mode-css-indent-offset 2
   web-mode-code-indent-offset 2
   )
  ;; Comment
  (setq web-mode-comment-style 2)
  ;; Comment Keyword
  (setq web-mode-enable-comment-interpolation t)
  ;; Autopairing
  (setq web-mode-enable-auto-pairing t)
  ;; Colorization
  (setq web-mode-enable-css-colorization t)
  )

;;; YAML
(use-package yaml-ts-mode
  :ensure nil
  :mode
  ("\\.yml\\'" "\\.yaml\\'")

  )

(provide 'ef-languages)
;;; ef-languages.el ends here
