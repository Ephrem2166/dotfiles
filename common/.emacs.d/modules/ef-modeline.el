;;; ef-modeline.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:
(setq mode-line-compact nil)
(setq mode-line-right-align-edge 'right-margin)
(setq-default mode-line-format
              '("%e" ; print error message about full memory.
                " "
                mode-line-front-space
                (:propertize "λ " face font-lock-keyword-face)
                ;; mode-line-mule-info
                ;; mode-line-client
                ;; mode-line-modified
                ;; mode-line-remote
                ;; mode-line-frame-identification
                mode-line-buffer-identification
                "   "
                ;; mode-line-position
                ;; mode-line-format-right-align
                ;; (vc-mode vc-mode)
                ;; "  "
                ;; mode-line-modes
                "   "
                ;; mode-line-misc-info
                ;; battery-mode-line-string
                mode-line-end-spaces))

(setq display-time-format "%a, %b %e %R"
      battery-mode-line-format "%p%%"  ; Default: "[%b%p%%]"
      global-mode-string   (remove 'display-time-string global-mode-string)
      mode-line-end-spaces (list (propertize " "
                                             'display '(space :align-to (- right 20)))
                                 'display-time-string))
(display-time-mode 1)
(display-time-update)





(provide 'ef-modeline)
;;; ef-modeline.el ends here
