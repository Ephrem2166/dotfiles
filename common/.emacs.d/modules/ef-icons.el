;;; ef-icons.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:

(use-package all-the-icons
  :ensure t
  :demand t
  :if (display-graphic-p))

(use-package all-the-icons-ibuffer
  :ensure t
  :hook ('ibuffer-mode-hook . all-the-icons-ibuffer))

;; prettify dired with icons
(use-package all-the-icons-dired
  :demand t
  :hook
  (dired-mode . all-the-icons-dired-mode))

(use-package all-the-icons-completion
  :after (marginalia all-the-icons)
  :demand t
  :hook (marginalia-mode . all-the-icons-completion-marginalia-setup)
  :init (all-the-icons-completion-mode))

(use-package nerd-icons
  :ensure t
  :custom
  (nerd-icons-font-family "JetBrainsMono Nerd Font")

  )

(use-package nerd-icons-completion
  :ensure t
  ;; To use it with marginalia
  :after marginalia
  :config
  (nerd-icons-completion-mode)
  ;; To use it with marginalia
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup)
  )




(use-package nerd-icons-dired
  :ensure t
  :if (display-graphic-p)
  :hook
  (dired-mode . nerd-icons-dired-mode))


(use-package nerd-icons-ibuffer
  :ensure t
  :hook (ibuffer-mode . nerd-icons-ibuffer-mode)
  :custom
  (nerd-icons-ibuffer-color-icon t)
  (nerd-icons-ibuffer-icon-size 0.97)
  (nerd-icons-ibuffer-formats
   `((mark modified read-only ,(if (>= emacs-major-version 26) 'locked "")
           ;; Here you may adjust by replacing :right with :center or :left
           ;; According to taste, if you want the icon further from the name
           " " (icon 2 2 :right)
           " " (name 18 18 :left :elide)
           " " (size 9 -1 :right)
           " " (mode 16 16 :left :elide)
           " " filename-and-process)
     (mark " " (name 16 -1) " " filename))))


(provide 'ef-icons)
;;; ef-icons.el ends here
