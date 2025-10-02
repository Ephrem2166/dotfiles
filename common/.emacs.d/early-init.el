;;; early-init.el --- Emacs Early Startup -*- no-byte-compile: t; lexical-binding: t; -*-
;;; Commentary:
;;; Code:
;; Garbage Collection Settings
(setq read-process-output-max (* 1024 1024 3))
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024))) 99)


;; File Name Handler List
;; Every file opened and
;; loaded by Emacs will run through this list to check for a proper handler for
;; the file, but during startup, it won’t need any of them.
(defvar file-name-handler-alist-old file-name-handler-alist)
(setq file-name-handler-alist nil)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq file-name-handler-alist file-name-handler-alist-old)))


;; Native Compilation
;; Ensure JIT compilation is enabled for improved performance by
;; native-compiling loaded .elc files asynchronously
(setq native-comp-jit-compilation t)

;; Disable certain byte compiler warnings to cut down on the noise.
(setq byte-compile-warnings '(not free-vars unresolved noruntime lexical make-local))
;; Silence compiler warnings as they can be pretty disruptive
(setq native-comp-async-report-warnings-errors nil)

;; Ensure that quitting only occurs once Emacs finishes native compiling,
;; preventing incomplete or leftover compilation files in `/tmp`.
(setq native-comp-async-query-on-exit t)
(setq confirm-kill-processes t)

(setq native-comp-async-jobs-number 1) ;; Slower but also quieter

;;; Hack to avoid being flashbanged
(defun ef/avoid-initial-flash-of-light ()
  "Avoid flash of light when starting Emacs."
  (setq mode-line-format nil)
  (setq default-frame-alist '(
                              (background-color . "#282C34")
                              (ns-appearance . dark)
                              (ns-transparent-titlebar . t)
                              )
        )
  ;; These colors should match your selected theme for maximum effect
  ;; Note that for catppuccin whenever we create a new frame or open it on terminal
  ;; it is necessary to reload the theme.
  (set-face-attribute 'default nil :background "#282C34" :foreground "#FFFFFF")
  (set-face-attribute 'mode-line nil :background "#282C34" :foreground "#FFFFFF" :box 'unspecified))

(ef/avoid-initial-flash-of-light)

;;;; Another option to avoid white light before start
;; (add-to-list 'default-frame-alist '(alpha-background . 0))
;; (add-hook
;;  'after-init-hook
;;  (lambda ()
;;    (add-to-list 'default-frame-alist '(alpha-background . nil))
;;    (set-frame-parameter nil 'alpha-background nil)))

;;; Disable GUI Elements
(setopt menu-bar-mode nil)
(setopt tool-bar-mode nil)
(setopt scroll-bar-mode nil)

(if (fboundp 'tooltip-mode) (tooltip-mode -1))
(if (fboundp 'fringe-mode) (fringe-mode -1))

;; Default Emacs Window Size
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(push '(horizontal-scroll-bars) default-frame-alist)
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
;; (setopt inhibit-startup-echo-area-message t)
(setopt inhibit-default-init t)
(setopt inhibit-startup-message nil)
(setopt initial-scratch-message nil)
(setopt initial-major-mode 'fundamental-mode)



(unless (daemonp)
  (advice-add #'display-startup-echo-area-message :override #'ignore))

(advice-add #'display-startup-screen :override #'ignore)

(advice-add #'x-apply-session-resources :override #'ignore)


(setq inhibit-compacting-font-caches t)
(setq redisplay-skip-fontification-on-input t)
;; Declare all themes safe
(setopt custom-safe-themes t)

;; Never show the hello file
(defalias #'view-hello-file #'ignore)

;; Disable warnings from the legacy advice API.
(setq ad-redefinition-action 'accept)

;; Package Settings to Use for Elpaca
;; Prevent package.el loading packages
(setq package-enable-at-startup nil)
(setq package-quickstart nil)
(setq package-archives nil)
(setq load-prefer-newer t)
(setq package--init-file-ensured nil)
;; Avoid raising the *Messages* buffer if anything is still without
;; lexical bindings
(setopt warning-minimum-level :error)
(setopt warning-suppress-types '((defvaralias) (lexical-binding)))


;; Disable bidirectional text scanning for a modest performance boost.
(setq-default bidi-display-reordering 'left-to-right
              bidi-paragraph-direction 'left-to-right)

;; Disabling the BPA makes redisplay faster
(setq bidi-inhibit-bpa t)

;; Unload jsonrpc (because elpaca can't do it)
;; (when (featurep 'jsonrpc)
;;   (unload-feature 'jsonrpc)
;;   )

;; Waste time while passing over auto-mode-alist
(setq auto-mode-case-fold nil)

;; Reduce rendering/line scan work for Emacs by not rendering cursors or regions
;; in non-focused windows.
(setq-default cursor-in-non-selected-windows nil)
(setq highlight-nonselected-windows nil)

;; Don't ping things that look like domain names.
(setq ffap-machine-p-known 'reject)


(when (boundp 'pgtk-wait-for-event-timeout)
  (setq pgtk-wait-for-event-timeout 0.001))


;; Profile emacs startup
(add-hook 'after-init-hook
          (lambda ()
            (message "🚀 Emacs loaded in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract elpaca-after-init-time before-init-time)))
                     gcs-done)) 98)

;;; Initial Scratch Message
;; (setq-default
;;  initial-scratch-message
;;  (let ((emacs-version (replace-regexp-in-string "\s\(.*\)\n" "" (emacs-version))))
;;    (format ";; %s, initialization in %s\n\n"
;;            emacs-version (emacs-init-time "%.3fs"))))


;;; TEST
;; (defconst my-preferred-fonts (list
;;                               "Berkeley Nerd Font"
;;                               "UbuntuMono Nerd Font"
;;                               "PragmataProMono Nerd Font"
;;                               "JetBrainsMono NErd Font"
;;                               "Office Code Pro D-10")
;;   "Fonts to try to use as the default if they exist(in order of priority).")
;;
;; (defun my-maybe-set-default-font (&optional frame)
;;   (let ((current-font (assq 'font default-frame-alist)))
;;     (cl-dolist (font my-preferred-fonts)
;;       (when (equal font current-font)
;;         (cl-return))
;;       (when (find-font (font-spec :name font) frame)
;;         (push (cons 'font font) default-frame-alist)
;;         (with-temp-buffer
;;           (write-file (expand-file-name font user-emacs-directory)))
;;         (cl-return)))))
;;
;; (defun my-known-font ()
;;   "Return a font from `noct-preferred-fonts' that has been previously found.
;; If no fonts have been found, return nil."
;;   (cl-dolist (font my-preferred-fonts)
;;     (when (file-exists-p (expand-file-name font user-emacs-directory))
;;       (cl-return font))))
;;
;; (let ((known-font (my-known-font)))
;;   (when known-font
;;     (push (cons 'font known-font) default-frame-alist))
;;   (unless (and known-font
;;                ;; still check if #1 preferred font exists after init
;;                (equal known-font (car my-preferred-fonts)))
;;     ;; this is too late when using the server
;;     (add-hook 'after-make-frame-functions #'my-maybe-set-default-font)))


(provide 'early-init)
;;; early-init ends here
