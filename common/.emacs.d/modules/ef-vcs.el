;;; ef-vcs.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:

;; Builtin
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

;;;; `ediff'
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


;; VC
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
(use-package magit
  :ensure t
  :after transient)


(provide 'ef-vcs)
;;; ef-vcs.el ends here
