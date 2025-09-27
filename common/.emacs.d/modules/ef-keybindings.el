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


(global-set-key (kbd "M-<tab>") 'completion-at-point)

;; (use-package emacs
;;   :ensure nil
;;   :preface
;;   (defvar my/leader-map (make-sparse-keymap) "key-map for leader key")
;;   (defvar my/buffer-map (make-sparse-keymap) "key-map for buffer commands")
;;   (defvar my/file-map (make-sparse-keymap) "key-map for buffer commands")
;;   :config
;;   (keymap-set global-map "C-x" my/leader-map)
;;   (define-key my/leader-map (kbd "b") (cons "buffer" my/buffer-map))
;;   (define-key my/leader-map (kbd "f") (cons "file" my/file-map))
;;   :bind
;;   (
;;    :map my/buffer-map
;;    ("e" . eval-buffer)
;;    ("k" . kill-current-buffer)
;;    ("K" . kill-buffer)
;;    ))



(provide 'ef-keybindings)
;;; ef-keybindings.el ends here
