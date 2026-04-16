;;; early-init.el --- Emacs Early Startup -*- no-byte-compile: t; lexical-binding: t; -*-
;;; Commentary:
;;; Code:
;;; Garbage Collection Settings
(setq read-process-output-max (* 1024 1024 3))
(setq gc-cons-threshold most-positive-fixnum
	  gc-cons-percentage 0.6)
;; From Doom Emacs
(add-hook 'emacs-startup-hook
		  (lambda ()
			(setq gc-cons-threshold (* 100 1024 1024))
			(setq gc-cons-percentage 0.1)
			))
;; Suppress GC messages for a cleaner startup log.
(setq garbage-collection-messages nil)

;;; File Name Handler List
;; Every file opened and
;; loaded by Emacs will run through this list to check for a proper handler for
;; the file, but during startup, it won’t need any of them.
(defvar file-name-handler-alist-old file-name-handler-alist)
(setq file-name-handler-alist nil)
(add-hook 'emacs-startup-hook
		  (lambda ()
			(setq file-name-handler-alist file-name-handler-alist-old)))

;;; Native Compilation
;; Ensure JIT compilation is enabled for improved performance by
;; native-compiling loaded .elc files asynchronously
(setq native-comp-jit-compilation t)

;; Disable certain byte compiler warnings to cut down on the noise.
(setq byte-compile-warnings '(not obsolete free-vars unresolved noruntime lexical make-local))
;; Silence compiler warnings as they can be pretty disruptive
(setq native-comp-async-report-warnings-errors nil)
(setq native-comp-warning-on-missing-source nil)
;; Ensure that quitting only occurs once Emacs finishes native compiling,
;; preventing incomplete or leftover compilation files in `/tmp`.
(setq native-comp-async-query-on-exit t)
(setq confirm-kill-processes t)

(setq native-comp-async-jobs-number 1) ;; Slower but also quieter

;;; Hack to avoid being flashbanged
(defun my/emacs-no-minibuffer-scroll-bar (frame)
  "Remove the minibuffer scroll bars from FRAME."
  (when scroll-bar-mode
	(set-window-scroll-bars (minibuffer-window frame) nil nil nil nil :persistent)))

(add-hook 'after-make-frame-functions #'my/emacs-no-minibuffer-scroll-bar)

(defun my/emacs-re-enable-frame-theme (_frame)
  "Re-enable active theme, if any, upon FRAME creation.
 Add this to `after-make-frame-functions' so that new frames do
 not retain the generic background set by the function
 `prot-emacs-avoid-initial-flash-of-light'."
  (when-let* ((theme (car custom-enabled-themes)))
	(enable-theme theme)))

(defun ef/avoid-initial-flash-of-light ()
  "Avoid flash of light when starting Emacs."
  (setq mode-line-format nil)
  (setq default-frame-alist '(
							  (tool-bar-lines . 0)
							  (menu-bar-lines . 0)
							  (horizontal-scroll-bars)
							  (vertical-scroll-bars)
							  (undecorated-round . t)
							  (background-color . "#282C34")
							  (ns-appearance . dark)
							  (ns-transparent-titlebar . t)
							  )
		)
  ;; These colors should match your selected theme for maximum effect
  ;; Note that for catppuccin whenever we create a new frame or open it on terminal
  ;; it is necessary to reload the theme.
  (set-face-attribute 'default nil :background "#282C34" :foreground "#FFFFFF")
  (set-face-attribute 'mode-line nil :background "#282C34" :foreground "#FFFFFF" :box 'unspecified)
  (add-hook 'after-make-frame-functions #'my/emacs-re-enable-frame-theme)
  )

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

;;; Default Emacs Window Size
;; FIXME: Move to avoid ef/avoid-initial-flash-of-light
;; (push '(tool-bar-lines . 0) default-frame-alist)
;; (push '(vertical-scroll-bars) default-frame-alist)
;; (push '(horizontal-scroll-bars) default-frame-alist)
;; (push '(menu-bar-lines . 0) default-frame-alist)
(push '(width . 80) default-frame-alist)
(push '(height . 44) default-frame-alist)

;;; Frame
(setopt frame-resize-pixelwise t)
(setopt frame-inhibit-implied-resize t)
(setopt frame-title-format '("Emacs - %b"))
(setopt window-resize-pixelwise t)

(setopt icon-title-format '("Emacs - %b"))

;;; Inhibit Startup Properties
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


;; once the config is loaded settings from our configuration will make
;; x-resources redundant. ignore it.
(advice-add #'x-apply-session-resources :override #'ignore)


(setq inhibit-compacting-font-caches t)
(setq redisplay-skip-fontification-on-input t)
;; Declare all themes safe
(setopt custom-safe-themes t)

;; Never show the hello file
(defalias #'view-hello-file #'ignore)

;; Disable warnings from the legacy advice API.
(setq ad-redefinition-action 'accept)

;;; Package Settings to Use for Elpaca
;; Prevent package.el loading packages
(setq package-enable-at-startup nil)
(setq package-quickstart nil)
(setq package-archives nil)
(setq load-prefer-newer t)
(setq package--init-file-ensured nil)
;;; Avoid raising the *Messages* buffer if anything is still without
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


;;; Profile emacs startup
(defun my/display-startup-time ()
  (add-hook 'after-init-hook
			(lambda ()
			  (message "🚀 Emacs loaded in %s with %d garbage collections."
					   (format "%.3f seconds"
							   (float-time
								(time-subtract after-init-time before-init-time)))
					   gcs-done))))
(my/display-startup-time)
;; (eval-and-compile
;;   (defconst emacs-start-time (current-time))
;;
;;   (defun report-time-since-load (&optional suffix)
;;     (message " Loading init...done (%.3fs)%s"
;;              (float-time (time-subtract (current-time) emacs-start-time))
;;              suffix)))

;; (add-hook 'after-init-hook
;;           (lambda () (report-time-since-load " after-init"))
;;           t)

;;; Initial Scratch Message
;; (setq-default
;;  initial-scratch-message
;;  (let ((emacs-version (replace-regexp-in-string "\s\(.*\)\n" "" (emacs-version))))
;;    (format ";; %s, initialization in %s\n\n"
;;            emacs-version (emacs-init-time "%.3fs"))))

;; Remove command line options that aren't relevant to the current OS; this
;; results in slightly less processing at startup.
(unless (eq system-type 'darwin)
  (setq command-line-ns-option-alist nil))
(unless (eq system-type 'gnu/linux)
  (setq command-line-x-option-alist nil))




;;; Increase CPU Processing Restrictions
;; Increase process output buffer for LSP
(when (boundp 'read-process-output-max)
  (setq-default process-adaptive-read-buffering nil
				read-process-output-max
				(or (ignore-errors (with-temp-buffer
									 (insert-file-contents "/proc/sys/fs/pipe-max-size")
									 (string-to-number (buffer-string))))
					(* 4 1024 1024))))



(provide 'early-init)
;;; early-init ends here
