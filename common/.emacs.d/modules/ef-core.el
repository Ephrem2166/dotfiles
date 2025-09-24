(use-package files
  :ensure nil
  :config
  (setq make-backup-files nil)
  (setq delete-old-version t)
  (setq auto-save-default nil)
  (setq create-lockfiles nil))

;; General Properties
(use-package emacs
  :ensure nil
  :config
  (setq default-input-method nil)
  (setq use-short-answers t))
(provide 'ef-core)
