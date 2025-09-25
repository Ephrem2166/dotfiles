;;; ef-core.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:




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
  ;; Personal Information
  (setopt user-full-name "Ephrem Getachew")
  (setopt user-login-name "ephrem")
  (setopt user-mail-address "ephrem2166@gmail.com")
  ;; Genertal Settings 
  (setopt default-input-method nil)
  (setopt use-short-answers t)
 (setopt undo-limit (* 13 160000)
      undo-strong-limit (* 13 240000)
      undo-outer-limit (* 13 24000000))
 ;; Language
 (set-language-environment 'utf-8)
 (set-default-coding-systems 'utf-8)

  )


(provide 'ef-core)
;;; ef-core.el ends here


