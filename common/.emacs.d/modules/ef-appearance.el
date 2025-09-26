;;; ef-appearance.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:



;; Doom Modeline
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  ;; (setq-default mode-line-format
  ;;               (list (propertize (make-string 300 ?-)
  ;;                                 'face 'default)))
  ;; :config
  (setq doom-modeline-height 25)
  (setq doom-modeline-bar-width 4)
  (setq doom-modeline-window-width-limit 85)
  (setq doom-modeline-project-detection 'auto)
  (setq doom-modeline-buffer-file-name-style 'auto)
  (setq doom-modeline-icon t)
  (setq doom-modeline-major-mode-icon t)
  (setq doom-modeline-major-mode-color-icon t)
  (setq doom-modeline-buffer-state-icon t)
  (setq doom-modeline-buffer-modification-icon t)
  (setq doom-modeline-unicode-fallback t)
  (setq doom-modeline-buffer-name t)
  (setq doom-modeline-highlight-modified-buffer-name t)
  (setq doom-modeline-column-zero-based nil)
  (setq doom-modeline-position-line-format '("L%l"))
  (setq doom-modeline-position-column-format '("C%c"))
  (setq doom-modeline-position-column-line-format '("%l:%c"))
  (setq doom-modeline-minor-modes t)
  (setq doom-modeline-enable-word-count t)
  (setq doom-modeline-continuous-word-count-modes '(markdown-mode gfm-mode org-mode))
  (setq doom-modeline-indent-info nil)
  (setq doom-modeline-total-line-number t)
  (setq find-file-visit-truename t)
  ;; Modal State Icon (evil, god)
  (setq doom-modeline-modal t)
  (setq doom-modeline-modal-icon t)
  (setq doom-modeline-modal-modern-icon t)
  ;; Version Control
  (setq doom-modeline-vcs-icon t)
  (setq doom-modeline-vcs-max-length 15)
  (setq doom-modeline-vcs-display-function #'doom-modeline-vcs-name)
  ;; Project
  (setq doom-modeline-project-name t)
  (setq doom-modeline-workspace-name t)
  ;; LSP
  (setq doom-modeline-lsp t)
  ;; Show environment version (For all)
  (setq doom-modeline-env-version t)
  ;; Performance
  (setq inhibit-compacting-font-caches t)
  ;; Whether display the time icon. It respects option `doom-modeline-icon'.
  (setq doom-modeline-time-icon t)
  ;; Font
  ;;(setq doom-modeline-height 1) ; optional
  (custom-set-faces
   '(mode-line ((t (:family "Berkeley Nerd Font" :height 1.0))))
   '(mode-line-active ((t (:family "Berkeley Nerd Font" :height 1.0)))) ; For 29+
   '(mode-line-inactive ((t (:family "Berkeley Nerd Font" :height 1.0)))))
  )


;; Htmlize
;; Convert buffer text and decorations to html
(use-package htmlize
  :ensure t)

;; Minions
;; A minor-mode menu for the mode line
(use-package minions
  :ensure t
  :hook
  (
   (after-init . minions-mode)
   (doom-modeline-mode . minions-mode)
   )
  :custom
  (minions-mode-line-lighter "…")
  (minions-mode-line-delimiters '("[" . "]")))



(provide 'ef-appearance)
;;; ef-appearance.el ends here
