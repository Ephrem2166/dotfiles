;;; ef-vcs.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:

;;; Diff
(use-package diff
  :ensure nil
  :defer t
  :config
  (setq diff-default-read-only t)
  (setq diff-advance-after-apply-hunk t)
  (setq diff-update-on-the-fly t)
  (setq diff-refine nil)
  (setq diff-font-lock-syntax 'hunk-also)
  (setq diff-font-lock-prettify t))

;;; Ediff
(use-package ediff
  :ensure nil
  :commands (ediff-buffers ediff-files ediff-buffers3 ediff-files3)
  :init
  (setq ediff-split-window-function 'split-window-horizontally)
  (setq ediff-window-setup-function 'ediff-setup-windows-plain)
  :config
  (setq ediff-keep-variants nil)
  (setq ediff-make-buffers-readonly-at-startup nil)
  (setq ediff-merge-revisions-with-ancestor t)
  (setq ediff-show-clashes-only t))

;;; Log Edit
(use-package log-edit
  :ensure nil
  :custom
  (log-edit-headers-alist
   '(("Summary" . log-edit-summary)
     ("Fixes")
     ("Author")))
  (log-edit-setup-add-author nil)
  )

;;; VC
(use-package vc
  :ensure nil
  :defer 60
  :init
  (setq vc-follow-symlinks t)
  :config
  (setq vc-handled-backends '(Git))
  (setq vc-revert-show-diff t)
  (setq vc-annotate-display-mode 'fullscale)
  (setq vc-find-revision-no-save t)
  (setq vc-allow-rewriting-published-history 'ask)

  )

;; TODO MAGIT
;; Since magit requires a newer version of transient
;; we need to install it on top of the built-in transient
(use-package transient)
;;; Magit
(use-package magit
  :ensure t
  :defer t
  :after transient
  :custom
  (magit-define-global-key-bindings nil)
  (magit-uniquify-buffer-names nil)
  (magit-auto-revert-mode nil)
  (magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1)
  (magit-bury-buffer-function #'magit-restore-window-configuration)
  (magit-refs-show-commit-count 'all)
  ;; (magit-refresh-status-buffer nil)
  (with-eval-after-load 'magit
    (setq magit-format-file-function #'magit-format-file-nerd-icons))

  (with-eval-after-load 'magit
    (remove-hook 'magit-refs-sections-hook 'magit-insert-tags)
    (remove-hook 'server-switch-hook 'magit-commit-diffq)
    (remove-hook 'with-editor-filter-visit-hook 'magit-commit-diff))

  )


(provide 'ef-vcs)
;;; ef-vcs.el ends here
