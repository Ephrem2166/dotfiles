;;; ef-reading.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:

;;; Adaptive Wrap
(use-package adaptive-wrap
  :disabled
  :ensure t
  :hook (visual-line-mode . adaptive-wrap-prefix-mode))

;;; DocView
;; Document viewer for Emacs (Builtin)
(use-package doc-view
  :ensure nil
  :config
  (setq doc-view-continuous t)
  (add-hook 'doc-view-mode-hook 'auto-revert-mode)
  )
;;; Logos
;; Simple focus mode and extras
(use-package logos
  :disabled
  :ensure t
  :bind
  (("C-x n n" . logos-narrow-dwim)
   ("C-x ]" . logos-forward-page-dwim)
   ("C-x [" . logos-backward-page-dwim)
   ;; I don't think I ever saw a package bind M-] or M-[...
   ("M-]" . logos-forward-page-dwim)
   ("M-[" . logos-backward-page-dwim)
   ("<f9>" . logos-focus-mode))
  :config
  (setq logos-outlines-are-pages t)
  (setq logos-outline-regexp-alist
		`((emacs-lisp-mode . ,(format "\\(^;;;+ \\|%s\\)" logos-page-delimiter))
		  (org-mode . ,(format "\\(^\\*+ +\\|^-\\{5\\}$\\|%s\\)" logos-page-delimiter))
		  (markdown-mode . ,(format "\\(^\\#+ +\\|^[*-]\\{5\\}$\\|^\\* \\* \\*$\\|%s\\)" logos-page-delimiter))
		  ;; (conf-toml-mode . "^\\["))
		  )
		)
  (setq-default logos-hide-mode-line t)
  (setq-default logos-hide-header-line t)
  (setq-default logos-hide-buffer-boundaries t)
  (setq-default logos-hide-fringe t)
  (setq-default logos-variable-pitch t) ; see my `fontaine' configurations
  (setq-default logos-buffer-read-only nil)
  (setq-default logos-scroll-lock nil)
  (setq-default logos-olivetti t)
  )

;;; Nov
;; Featureful EPUB reader mode
(use-package nov
  :ensure t
  :defer t
  :mode ("\\.epub\\'" . nov-mode)
  :config
  (setq nov-text-width 80)
  (setq nov-variable-pitch nil)
  (setq visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow))
  (add-hook 'nov-mode-hook (lambda ()
							 (visual-line-mode 1)
							 (setq-local line-spacing 0.2)))
  :bind (:map nov-mode-map

			  ("p" . nov-previous-document)
			  ("<up>" . nov-scroll-up)
			  ("k" . nov-scroll-up)
			  ("<down>" . nov-scroll-down)
			  ("j" . nov-scroll-down)
			  ("n" . nov-next-document)
			  ("L" . nov-next-document)
			  ("t" . nov-goto-toc)
			  ("<end>" . nov-goto-end)))

;;; Olivetti
;; Minor mode to automatically balance window margins
(use-package olivetti
  :ensure t
  :hook (
		 ;; (olivetti-mode-on . my/olivetti-mode-on)
		 ;; (olivetti-mode-off . my/olivetti-mode-off)

		 ((org-mode Info-mode  markdown-mode) . olivetti-mode)
		 )
  :config
  (setq olivetti-lighter nil)
  ;; (setq olivetti-hide-mode-line nil)
  (setq olivetti-body-width 80)
  (setq olivetti-style 'fancy)
  (setq olivetti-minimum-body-width 70)
  (setq olivetti-recall-visual-line-mode-entry-state t)
  (setq olivertti-margin-width 3)
  ;; Olivetti Mode Hook On
  ;; (defun my/olivetti-mode-on ()
  ;;   (text-scale-adjust 2)
  ;;   (setq-local original-flymake-fringe-indicator-position
  ;;               flymake-fringe-indicator-position)

  ;;               vi-tilde-fringe-mode)
  ;;   (setq-local original-display-fill-column-indicator-mode
  ;;               display-fill-column-indicator-mode)
  ;;   (when (fboundp 'git-gutter-mode)
  ;;     (setq-local original-git-gutter-mode
  ;;                 git-gutter-mode))
  ;;   (setq-local original-display-line-numbers-mode
  ;;               display-line-numbers-mode)
  ;;   (setq-local original-org-modern-block-fringe
  ;;               org-modern-block-fringe)
  ;;   ;; The of org-modern blocks is not quite right with olivetti.
  ;;   (setq-local org-modern-block-fringe nil)
  ;;   (setq-local flymake-fringe-indicator-position nil)
  ;;   ;; By restarting org-modern-mode, I hide the expansive fringe; thus
  ;;   ;; preserving the "beauty" of Olivetti
  ;;   (when (eq major-mode 'org-mode)
  ;;     (org-modern-mode 1))
  ;;   (vi-tilde-fringe-mode -1)
  ;;   (display-line-numbers-mode -1)
  ;;   (display-fill-column-indicator-mode -1)
  ;;   (when (fboundp 'git-gutter-mode)
  ;;     (git-gutter-mode -1))
  ;;   )
  ;; ;; Olivetti Mode Hook Off
  ;; (defun my/olivetti-mode-off ()
  ;;   (text-scale-adjust 0)
  ;;   (setq-local flymake-fringe-indicator-position
  ;;               original-flymake-fringe-indicator-position)
  ;;   (when (eq major-mode 'org-mode)
  ;;     (org-modern-mode 1))
  ;;   (vi-tilde-fringe-mode
  ;;    original-vi-tilde-fringe-mode)
  ;;   (display-fill-column-indicator-mode
  ;;    original-display-fill-column-indicator-mode)
  ;;   (display-line-numbers-mode
  ;;    original-display-line-numbers-mode)
  ;;   (when (fboundp 'git-gutter-mode)
  ;;     (git-gutter-mode
  ;;      original-git-gutter-mode))
  ;;   (setq-local org-modern-block-fringe
  ;;               original-org-modern-block-fringe))
  ;;
  ;; (defun my/olivetti-mode (&rest args)
  ;;   ;; Turn off org-modern-mode as it's drawing of the
  ;;   ;; overlays conflicts with Olivetti.  We'll turn it on later.
  ;;   (when (eq major-mode 'org-mode)
  ;;     (org-modern-mode -1)))
  ;; (advice-add 'olivetti-mode :before #'my/olivetti-mode)
  )




;;; Pdf Tools
(use-package pdf-tools
  :ensure t
  ;;:defer t
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :config
  (pdf-tools-install :no-query)
  (require 'pdf-tools)
  (require 'pdf-view)
  (require 'pdf-misc)
  (require 'pdf-occur)
  (require 'pdf-util)
  (require 'pdf-annot)
  (require 'pdf-info)
  (require 'pdf-isearch)
  (require 'pdf-history)
  (require 'pdf-links)
  (require 'pdf-outline)
  (require 'pdf-sync)
  ;; (pdf-tools-install :no-query)
  (setq-default pdf-view-display-size 'fit-page)
  ;; (setq pdf-view-midnight-colors '("#D8DEE9" . "#2E3440"))
  ;; :hook (
  ;;        (pdf-tools-enabled . pdf-view-midnight-minor-mode)
  ;;        (pdf-view-mode . (lambda () (display-line-numbers-mode -1)))
  ;;        )
  :bind (:map pdf-view-mode-map
			  ("J" . pdf-view-next-line-or-next-page)
			  ("K" . pdf-view-previous-line-or-previous-page)
			  ("h" . pdf-view-previous-page)
			  ("l" . pdf-view-next-page)
			  ("<home>" . pdf-view-first-page)
			  ("<end>" . pdf-view-last-page)
			  ("r" . pdf-view-reset-slice)))






(provide 'ef-reading)
;;; ef-reading.el ends here
