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
  :config
  (setq ediff-window-setup-function 'ediff-setup-windows-plain)
  (setq ediff-split-window-function 'split-window-horizontally)
  (setq ediff-merge-split-window-function 'split-window-horizontally)
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


;;; TODO MAGIT
;; Since magit requires a newer version of transient
;; we need to install it on top of the built-in transient
(use-package transient)

;;;; Magit
(use-package magit
  :ensure t
  :defer-incrementally (dash f s with-editor git-commit transient)
  :init
  (setq magit-auto-revert-mode nil)  ; we do this ourselves further down
  ;; Must be set early to prevent ~/.emacs.d/transient from being created
  (setq transient-levels-file  (concat user-emacs-directory "transient/levels")
        transient-values-file  (concat user-emacs-directory  "transient/values")
        transient-history-file (concat user-emacs-directory "transient/history"))
  :after transient
  :custom
  (magit-no-message (list "Turning on magit-auto-revert-mode..."))
  (magit-define-global-key-bindings nil)
  (magit-uniquify-buffer-names nil)
  (magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1)
  (magit-bury-buffer-function #'magit-restore-window-configuration)
  (magit-refs-show-commit-count 'all)
  ;; (magit-refresh-status-buffer nil)
  (magit-repository-directories '(
                                  ("~/dotfiles/" . 0)
                                  ))
  (magit-bury-buffer-function 'magit-mode-quit-window)
  :config
  (setq magit-push-always-verify t)
  (setq transient-default-level 5)
  (setq magit-diff-refine-hunk t)
  (setq magit-save-repository-buffers nil)
  (setq magit-revision-show-gravatars '("^Author:     " . "^Commit:     "))
  (setq transient-display-buffer-action '(display-buffer-below-selected))
  (add-hook 'magit-popup-mode-hook #'hide-mode-line-mode)
  (with-eval-after-load 'magit
    (setq magit-format-file-function #'magit-format-file-nerd-icons))

  (with-eval-after-load 'magit
    (remove-hook 'magit-refs-sections-hook 'magit-insert-tags)
    (remove-hook 'server-switch-hook 'magit-commit-diffq)
    (remove-hook 'with-editor-filter-visit-hook 'magit-commit-diff))

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



(provide 'ef-vcs)
;;; ef-vcs.el ends here
