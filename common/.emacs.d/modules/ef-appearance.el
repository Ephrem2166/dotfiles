;;; ef-appearance.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:
;;; Auto Dark
;; Automatically set the dark-mode theme based on system status
(use-package auto-dark
  :ensure t
  :disabled
  :custom
  (auto-dark-themes '((doom-nord) (modus-operandi-deuteranopia)))
  :init (auto-dark-mode)
  )

;;; Emacs: Modeline
(use-package emacs
  :ensure nil
  :config
  (setq mode-line-default-help-echo nil
        show-help-function nil)

  (defvar mode-line-cleaner-alist
    `((company-mode . " ⇝")
      (corfu-mode . " ⇝")
      (yas-minor-mode .  " ")
      (smartparens-mode . " ()")
      (evil-smartparens-mode . "")
      (eldoc-mode . "")
      (abbrev-mode . "")
      (evil-snipe-local-mode . "")
      (evil-owl-mode . "")
      (evil-rsi-mode . "")
      (evil-goggles-mode . "")
      (evil-commentary-mode . "")
      (evil-collection-unimpaired-mode . "")
      (highlight-parentheses-mode . "")
      (ivy-mode . "")
      (counsel-mode . "")
      (wrap-region-mode . "")
      (subword-mode . "")
      (rainbow-mode . "")
      (which-key-mode . "")
      (aggressive-indent-mode . "")
      (undo-tree-mode . "")
      ;; (undo-tree-mode . " ⎌")
      (auto-revert-mode . "")
      ;; Major modes
      (lisp-interaction-mode . "λ")
      (hi-lock-mode . "")
      (python-mode . "Py")
      (emacs-lisp-mode . "Eλ")
      (nxhtml-mode . "nx")
      (fundamental-mode . "f")
      (dot-mode . "")
      (scheme-mode . " SCM")
      (matlab-mode . "M")
      (valign-mode . "")
      (org-mode . "ORG")
      (eldoc-mode . "")
      (org-cdlatex-mode . "")
      (cdlatex-mode . "")
      (org-indent-mode . "")
      (org-roam-mode . "")
      (visual-line-mode . "")
      (latex-mode . "TeX")
      (outline-minor-mode . " ֍" ;; " [o]"
                          )
      (hs-minor-mode . "")
      (matlab-functions-have-end-minor-mode . "")
      (org-roam-ui-mode . " UI")
      (abridge-diff-mode . "")
      ;; Evil modes
      (evil-traces-mode . "")
      (latex-extra-mode . "")
      (strokes-mode . "")
      (flymake-mode . "fly")
      (sideline-mode . "")
      (god-mode . ,(propertize "God" 'face 'success))
      (gcmh-mode . ""))
    "Alist for `clean-mode-line'.

  ; ;; When you add a new element to the alist, keep in mind that you
  ; ;; must pass the correct minor/major mode symbol and a string you
  ; ;; want to use in the modeline *in lieu of* the original.")
  (defun clean-mode-line ()
    (cl-loop for cleaner in mode-line-cleaner-alist
             do (let* ((mode (car cleaner))
                       (mode-str (cdr cleaner))
                       (old-mode-str (cdr (assq mode minor-mode-alist))))
                  (when old-mode-str
                    (setcar old-mode-str mode-str))
                  ;; major mode
                  (when (eq mode major-mode)
                    (setq mode-name mode-str)))))


  (add-hook 'after-change-major-mode-hook 'clean-mode-line)
  )

;;; Doom Modeline
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


;;; Htmlize
;; Convert buffer text and decorations to html
(use-package htmlize
  :ensure t)

;;; Minions
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

;;; Spacious Padding
(use-package spacious-padding
  :ensure t
  :disabled
  :if (display-graphic-p)
  :bind (("C-c t s" . spacious-padding-mode))
  :init
  (setq spacious-padding-widths '(
                                  :internal-border-width 15
                                  :header-line-width 4
                                  :mode-line-width 6
                                  :tab-bar-width 4
                                  :tab-line-width 2
                                  :tab-width 4
                                  :right-divider-width 10
                                  ;; :scroll-bar-width 2
                                  :fringe-width 20
                                  ))
  (setq spacious-padding-subtle-mode-line t)
  :init
  (spacious-padding-mode)
  )


(provide 'ef-appearance)
;;; ef-appearance.el ends here
