;;; ef-keybindings.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:

;; Restart Emacs
(global-set-key (kbd "C-c C-q") 'restart-emacs)

;; Eval Buffer
(global-set-key (kbd "M-e") 'eval-buffer)

;; Comment Line
;; (global-set-key (kbd "C-/") 'comment-line)
;; (global-set-key (kbd "C-x /") 'comment-or-uncomment-region)

;; BETTER DEFAULTS FOR UPCASE AND DOWNCASE
(global-set-key (kbd "M-u") 'upcase-dwim)
(global-set-key (kbd "M-l") 'downcase-dwim)
(global-set-key (kbd "M-c") 'capitalize-dwim)


;; TEXT SCALE
(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "C-0") 'text-scale-adjust)



(provide 'ef-keybindings)
;;; ef-keybindings.el ends here
