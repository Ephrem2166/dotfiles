(dolist (paths (list (expand-file-name "modules" user-emacs-directory)))
  (add-to-list 'load-path paths))

;;(load-theme 'modus-vivendi-tinted)

(require 'ef-core)
(require 'ef-themes)
(require 'ef-fonts)
