;;; ef-keybindings.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:
;;; Global Keybindings
;;;; Unset Unnecessary Bindings
;; Unbind unneeded keys
(global-set-key (kbd "C-z") nil)
(global-set-key (kbd "M-z") nil)
(global-set-key (kbd "M-m") nil)
(global-set-key (kbd "C-x C-z") nil)


(global-unset-key (kbd "C-z"))
;;;; Set Necessary Keybindings
;;;; Restart Emacs
(global-set-key (kbd "C-c C-q") 'restart-emacs)

;;;; Eval Buffer
(global-set-key (kbd "M-e") 'my/eval-buffer-or-region)

;;;; Comment Line
;; (global-set-key (kbd "C-/") 'comment-line)
;; (global-set-key (kbd "C-x /") 'comment-or-uncomment-region)

;;;; BETTER DEFAULTS FOR UPCASE AND DOWNCASE
(global-set-key (kbd "M-u") 'upcase-dwim)
(global-set-key (kbd "M-l") 'downcase-dwim)
(global-set-key (kbd "M-c") 'capitalize-dwim)

;;;; TEXT SCALE
;; (global-set-key (kbd "C-=") 'text-scale-increase)
;; (global-set-key (kbd "C--") 'text-scale-decrease)
;; (global-set-key (kbd "C-0") 'text-scale-adjust)

;;;; Completion At Point
(global-set-key (kbd "M-<tab>") 'completion-at-point)

;;;; Remap mark-sexp
(global-set-key (kbd "M-SPC") 'mark-sexp)

;;;; Truncate lines
(global-set-key (kbd "C-x C-l") #'toggle-truncate-lines)

;;;; Remap Home and End Keys
(global-set-key [home] 'beginning-of-buffer)
(global-set-key [end]  'end-of-buffer)

(define-key global-map (kbd "RET") 'newline-and-indent)
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
;;;; Buffer Mapping
(defvar-keymap ef-applications-keymap
  :doc "Prefix for toggling stuff."
  )
(bind-key "C-c a" ef-applications-keymap 'global-map)

;;;; Buffer Mapping
(defvar-keymap ef-buffer-keymap
  :doc "Prefix for toggling stuff."
  )
(bind-key "C-c b" ef-buffer-keymap 'global-map)

;;;; Custom Function Keybindings
(defvar-keymap ef-functions-keymap
  :doc "Prefix for custom function commands.")
(bind-key "C-c e" ef-functions-keymap 'global-map)

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


;;;; Window Mapping
(defvar-keymap ef-window-keymap
  :doc "Prefix for toggling stuff.")
(bind-key "C-c w" ef-window-keymap 'global-map)


;;; Alternative
;; bind-keys is used to bind multiple keys at once
;; (bind-keys &rest args)
;; It can be used to add mapping to already existing mappings.
;; such as help-map. Example:
(bind-keys :prefix-map applications-map
          :prefix "C-z a"
          :prefix-docstring "Mapping for various applications"
          ("m" . man))

(bind-keys :prefix-map toggle-map
           :prefix "C-z t"
           :prefix-docstring "Toggling"
           ("o" . outline-minor-mode)
           )

(bind-keys :map help-map
           ("u" . apropos-user-option))


;; Custom Function Keybindings
(bind-keys :map ef-applications-keymap
           ("p" . proced))

;; Or to create user defined keymaps
(bind-keys :map ef-window-keymap
           ("q" . quit-window))



;;; Another Options
(define-prefix-command 'Apropos-Prefix nil "Apropos (a,d,f,l,v,C-v)")
(global-set-key (kbd "C-z h") 'Apropos-Prefix)
(define-key Apropos-Prefix (kbd "a")   'apropos)
(define-key Apropos-Prefix (kbd "C-a") 'apropos)
(define-key Apropos-Prefix (kbd "d")   'apropos-documentation)
(define-key Apropos-Prefix (kbd "f")   'apropos-command)
(define-key Apropos-Prefix (kbd "l")   'apropos-library)
(define-key Apropos-Prefix (kbd "v")   'apropos-variable)
(define-key Apropos-Prefix (kbd "C-v") 'apropos-value)

(provide 'ef-keybindings)
;;; ef-keybindings.el ends here
