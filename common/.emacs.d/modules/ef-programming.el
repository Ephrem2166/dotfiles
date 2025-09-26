;;; ef-programming.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:

;; Apheleia
;; Code formatters
(use-package apheleia
  :ensure t
  :defer t
  :config
  (setq apheleia-formatters
        (append
         '((prettier . ("prettier" "--stdin-filepath" filepath))
           (black . ("black" "-"))
           (shfmt . ("shfmt" "-i" "2" "-ci" "-")))
         apheleia-formatters))

  ;; Customize mode-to-formatter mapping.
  (setq apheleia-mode-alist
        '((python-mode . black)
          (javascript-mode . prettier)
          (typescript-mode . prettier)
          (ruby-mode . rubocop)
          (sh-mode . shfmt)))
  (apheleia-global-mode +1))

;; Enables automatic indentation of code while typing
(use-package aggressive-indent
  :ensure t
  :defer t
  :commands aggressive-indent-mode
  :hook
  (emacs-lisp-mode . aggressive-indent-mode))

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

;; Use Flycheck backends with flymake
(use-package flymake-flycheck
  :disabled
  :ensure t
  :after flymake
  :hook (flymake-mode  . flymake-flycheck-auto))


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
