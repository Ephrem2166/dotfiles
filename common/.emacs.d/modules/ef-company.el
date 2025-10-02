;;; ef-company.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:

(use-package company
  :ensure t
  :defer t
  :init
  (global-company-mode)
  :config
  ;; Basics
  (setq company-minimum-prefix-length 2)
  (setq company-idle-delay
        (lambda () (if (company-in-string-or-comment) nil 0.3)))
  ;;(setq company-global-modes '(prog-mode js-json-mode))
  (setq company-require-match nil)
  (setq company-selection-wrap-around t)
  ;; (setq company-lighter-base "C")
  (setq company-insertion-on-trigger nil)
  ;; Frontend
  (setq company-tooltip-align-annotations nil)
  (setq company-tooltip-limit 5)
  (setq company-tooltip-offset-display 'lines)
  (setq company-tooltip-minimum 5)
  (setq company-tooltip-minimum-width 0)
  (setq company-tooltip-maximum-width 30)

  ;; Backend

  (setq company-dabbrev-downcase nil)
  (setq company-dabbrev-ignore-case nil)
  (setq company-dabbrev-minimum-length 2)
  (setq company-dabbrev-other-buffers t)
  ;; Backends
  (setq company-backends
        '((company-files
           company-keywords
           company-capf)
          company-abbrev company-dabbrev)
        )
  ;; File Name Completion
  (setq company-files-exclusions '(".git/" ".DS_Store"))
  ;; Candidates Post Processing
  (setq company-transformers '(delete-consecutive-dups company-sort-by-occurrence company-sort-prefer-same-case-prefix))
  )

;; A nicer way to show company completions with icons and doc popup where available (lsp etc.)
;; Also doesn't clutter up the screen with super-big multiline truncated lines
(use-package company-box
  :ensure t
  :after (company all-the-icons)
  :if (display-graphic-p)
  :custom
  (company-box-frame-behavior 'point)
  (company-box-show-single-candidate t)
  (company-box-doc-delay 1)

  :hook
  (company-mode . company-box-mode))

;; little hack function to make company box frame bigger
(defun ef/company-box-fix-size ()
  (interactive)
  (let* ((box-frame (company-box--get-frame)))
    (when (not (null box-frame))
      (set-face-attribute 'default
                          box-frame
                          :height 180))))

;; Functions
;; Text Mode Expansion
(defun ef/my-text-mode-hook ()
  (setq-local company-backends
              '((company-dabbrev)
                company-files)))
(add-hook 'text-mode-hook #'ef/my-text-mode-hook)



(provide 'ef-company)
;;; ef-company.el ends here
