;;; ef-keybindings.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:
;;; ---------------------------------------------------------------------------
;;; 1. Minimal global overrides
;;; ---------------------------------------------------------------------------

;; Unbind genuinely unused defaults.  RET/Home/End are left alone so modes
;; can bind them locally as expected.
;; (keymap-global-unset "C-x C-z")   ; suspend-frame


;; Restart
(keymap-global-set "C-c C-q" #'restart-emacs)

;; Eval buffer or region
(keymap-global-set "M-e" #'my/eval-buffer-or-region)

;; Escape quits (some terminals send ESC as a keypress, not C-g)
(keymap-global-set "<escape>" #'keyboard-quit)

;; Case commands — default M-u/M-l/M-c operate on a word at point, but the
;; *-dwim variants operate on the region if active.  Better ergonomics.
(keymap-global-set "M-u" #'upcase-dwim)
(keymap-global-set "M-l" #'downcase-dwim)
(keymap-global-set "M-c" #'capitalize-dwim)

;; Completion at point (was C-M-i by default)
(keymap-global-set "M-<tab>" #'completion-at-point)

;; Mark sexp
(keymap-global-set "M-SPC" #'mark-sexp)

;;; ---------------------------------------------------------------------------
;;; 2. Prefix keymaps
;;; ---------------------------------------------------------------------------
;; The `:doc' strings are shown by `which-key' when you press the prefix.
(defvar-keymap ef-super-keymap
  :doc "C-z prefix — replaces stock suspend-frame.")

(keymap-global-set "C-z" ef-super-keymap)


(defvar-keymap ef-applications-keymap
  :doc "Applications and external tools.")

(defvar-keymap ef-buffer-keymap
  :doc "Buffer operations.")

(defvar-keymap ef-functions-keymap
  :doc "Custom functions.")

(defvar-keymap ef-file-keymap
  :doc "File operations.")

(defvar-keymap ef-toggle-keymap
  :doc "Toggle minor modes and UI elements."
  "w" #'writeroom-mode
  "v" #'visual-line-mode
  "l" #'display-line-numbers-mode
  "n" #'narrow-to-region
  "N" #'widen
  )

(defvar-keymap ef-window-keymap
  :doc "Window operations.")

(keymap-global-set "C-c A" ef-applications-keymap)
(keymap-global-set "C-c b" ef-buffer-keymap)
(keymap-global-set "C-c E" ef-functions-keymap)     ; capital E — was C-c e
(keymap-global-set "C-c f" ef-file-keymap)
(keymap-global-set "C-c t" ef-toggle-keymap)
(keymap-global-set "C-c w" ef-window-keymap)

;;; ---------------------------------------------------------------------------
;;; 3. Bindings that live entirely in this file
;;; ---------------------------------------------------------------------------

;; Applications
(keymap-set ef-applications-keymap "p" #'proced)
(keymap-set ef-applications-keymap "m" #'man)

;; Windows
(keymap-set ef-window-keymap "q" #'quit-window)

;; Help extensions
(keymap-set help-map "u" #'apropos-user-option)


(provide 'ef-keybindings)
;;; ef-keybindings.el ends here
