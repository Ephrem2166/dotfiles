;;; ef-keybindings.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:
;;; Unset Unnecessary Bindings
;; Unbind unneeded keys
(global-set-key (kbd "C-z") nil)
(global-set-key (kbd "M-z") nil)
(global-set-key (kbd "M-m") nil)
(global-set-key (kbd "C-x C-z") nil)
(global-set-key (kbd "M-/") nil)

;;; Global Keybindings
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
;; (global-set-key (kbd "C-=") 'text-scale-increase)
;; (global-set-key (kbd "C--") 'text-scale-decrease)
;; (global-set-key (kbd "C-0") 'text-scale-adjust)

(global-set-key (kbd "M-<tab>") 'completion-at-point)


;; Truncate lines
(global-set-key (kbd "C-x C-l") #'toggle-truncate-lines)

;; Remap Home and End Keys
(global-set-key [home] 'beginning-of-buffer)
(global-set-key [end]  'end-of-buffer)


;;; Alternative
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
;; (define-key ctl-x-x-map "z" 'bury-buffer)

;;; Global Map Definitions
;; Buffer Mapping
(defvar-keymap ef-buffer-keymap
  :doc "Prefix for toggling stuff."
  )
(bind-key "C-c b" ef-buffer-keymap 'global-map)

;;;; File Mapping
(defvar-keymap ef-file-keymap
  :doc "Prefix for file-related commands.")
(bind-key "C-c f" ef-file-keymap 'global-map)


(defvar-keymap ef-help-keymap
  :doc "Prefix for file-related commands."
  )
(bind-key "C-c h" ef-help-keymap 'global-map)

;;;; Toggle Mapping
(defvar-keymap ef-toggle-keymap
  :doc "Prefix for toggling stuff.")
(bind-key "C-c t" ef-toggle-keymap 'global-map)



;;; Alternative
;; bind-keys is used to bind multiple keys at once
;; (bind-keys &rest args)
;; It can be used to add mapping to already existing mappings.
;; such as help-map. Example:
(bind-keys :map help-map
           ("u" . apropos-user-option))

;; Or to create user defined keymaps
(bind-keys
 :prefix-map ef-window-keymap
 :prefix "C-c w"
 :prefix-docstring "Window management keymaps"
 ;; :menu-name "windows"
 ("q" . quit-window))



(provide 'ef-keybindings)
;;; ef-keybindings.el ends here
