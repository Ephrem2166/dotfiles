;;; ef-programming.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:

;; Apheleia
;; Code formatters
(use-package apheleia
  :ensure t
  :config
  (apheleia-global-mode +1))

;; Enables automatic indentation of code while typing
(use-package aggressive-indent
  :ensure t
  :defer t
  :commands aggressive-indent-mode
  :hook
  (emacs-lisp-mode . aggressive-indent-mode))

;; Format All
;; Auto Format for C, C++, JS, Python, and other languages.
(use-package format-all
  :disabled
  :hook
  (after-save . (lambda () (if (derived-mode-p 'prog-mode) (format-all-buffer)))))

;; Highlights function and variable definitions in Emacs Lisp mode
(use-package highlight-defined
  :ensure t
  :defer t
  :commands highlight-defined-mode
  :hook
  (emacs-lisp-mode . highlight-defined-mode))

;; Rainbow mode
;; Colorize color names in buffers
(use-package rainbow-mode
  :ensure t
  :diminish rainbow-mode
  :hook
  ((prog-mode
    org-mode
    conf-mode
    help-mode
    emacs-lisp-mode
    web-mode
    css-mode
    yaml-ts-mode
    js-json-mode
    typescript-mode
    js2-mode) . rainbow-mode )
  )




(provide 'ef-programming)
;;; ef-programming.el ends here
