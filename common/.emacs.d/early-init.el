;;; early-init.el --- Emacs Early Startup -*- no-byte-compile: t; lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; Disable GUI Elements
(setopt menu-bar-mode nil)
(setopt tool-bar-mode nil)
(setopt scroll-bar-mode nil)

;; Default Emacs Window Size
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(width . 80) default-frame-alist)
(push '(height . 44) default-frame-alist)

;; Frame
(setopt frame-resize-pixelwise t)
(setopt frame-inhibit-implied-resize t)
(setopt frame-title-format '("Emacs - %b"))
(setopt window-resize-pixelwise t)

(setopt icon-title-format '("Emacs - %b"))

;; Inhibit Startup Properties
(setopt inhibit-splash-screen t)
(setopt inhibit-startup-screen t)
(setopt inhibit-x-resources t)
(setopt inhibit-startup-buffer-menu t)
(setopt inhibit-startup-echo-area-message user-login-name)
(setopt inhibit-default-init t)
(setopt inhibit-startup-message nil)
(setopt initial-scratch-message nil)
(setopt initial-major-mode 'fundamental-mode)
(unless (daemonp)
  (advice-add #'display-startup-echo-area-message :override #'ignore))
;; Declare all themes safe
(setopt custom-safe-themes t)


;; Package Settings to Use for Elpaca
;; Prevent package.el loading packages
(setopt package-enable-at-startup nil)
(setopt package-quickstart nil)
(setopt package-archives nil)
(setopt load-prefer-newer t)

(provide 'early-init)
;;; early-init ends here
