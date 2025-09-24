(use-package files
  :ensure nil
  :config
  (setq make-backup-files nil)
  (setq delete-old-version t)
  (setq auto-save-default nil)
  (setq create-lockfiles nil))


(provide 'ef-core)
