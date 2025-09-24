;; Disable GUI elements
(setopt menu-bar-mode nil)
(setopt tool-bar-mode nil)
(setopt scroll-bar-mode nil)

;; Set Default Emacs Window Size
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(width . 80) default-frame-alist)
(push '(height . 44) default-frame-alist)


;; Inhibit Startup Properites
(setopt inhibit-splash-screen t)
(setopt inhibit-startup-screen t)
(setopt inhibit-x-resources t)
(setopt inhibit-startup-buffer-menu t)
(setopt inhibit-startup-echo-area-message user-login-name)

;; Declare all themes safe
(setopt custom-safe-themes t)

