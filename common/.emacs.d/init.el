(dolist (paths (list (expand-file-name "modules" user-emacs-directory)))
  (add-to-list 'load-path paths))

;; Move customization settings out of init.el
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file t))

;;(load-theme 'modus-vivendi-tinted)
(require 'elpaca-module)
(setq elpaca-after-init-time (or elpaca-after-init-time (current-time)))
(elpaca-wait)

(require 'ef-core)
(require 'ef-themes)
(require 'ef-fonts)
(require 'ef-development)
(require 'ef-minibuffer)
(require 'ef-dired)
(require 'ef-keybindings)


;; (require 'ef-shell)

;; External
(require 'ef-yasnippet)
(require 'ef-icons)
(require 'ef-utilities)
(require 'ef-completion)
(require 'ef-appearance)
(require 'ef-programming)
(require 'ef-languages)
