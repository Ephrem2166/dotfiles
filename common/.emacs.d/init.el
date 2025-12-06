(dolist (paths (list (expand-file-name "modules" user-emacs-directory)))
  (add-to-list 'load-path paths))

;; Move customization settings out of init.el
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file t))

;;(load-theme 'nano-theme-set-dark)
(require 'elpaca-module)
(setq elpaca-after-init-time (or elpaca-after-init-time (current-time)))
(elpaca-wait)

;; Alternative to elpaca: Builtin
;; (require 'ef-package)

(require 'ef-core)
(require 'ef-themes)
(require 'ef-fonts)
(require 'ef-development)
(require 'ef-dired)
(require 'ef-keybindings)
(require 'ef-functions)

(require 'ef-shell)
(require 'ef-vcs)
(require 'ef-writing)
(require 'ef-reading)
(require 'ef-org)
;; (require 'ef-modeline)
;; External
(require 'ef-completion)
(require 'ef-minibuffer)
(require 'ef-yasnippet)
(require 'ef-icons)
(require 'ef-utilities)
(require 'ef-appearance)
(require 'ef-programming)
(require 'ef-languages)
(require 'ef-evil)
(require 'ef-comm)
(require 'ef-experiment)
;; (require 'ef-general)
;; (require 'ef-company)
