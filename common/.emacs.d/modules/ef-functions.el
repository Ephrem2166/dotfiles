;;; ef-functions.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:

;; Better C-g from Prot
(defun ef/keyboard-quit-dwim ()
  "Do-What-I-Mean behaviour for a general `keyboard-quit'.

The generic `keyboard-quit' does not do the expected thing when
the minibuffer is open.  Whereas we want it to close the
minibuffer, even without explicitly focusing it.

The DWIM behaviour of this command is as follows:

- When the region is active, disable it.
- When a minibuffer is open, but not focused, close the minibuffer.
- When the Completions buffer is selected, close it.
- In every other case use the regular `keyboard-quit'."
  (interactive)
  (cond
   ((region-active-p)
    (keyboard-quit))
   ((derived-mode-p 'completion-list-mode)
    (delete-completion-window))
   ((> (minibuffer-depth) 0)
    (abort-recursive-edit))
   (t
    (keyboard-quit))))

(define-key global-map (kbd "C-g") #'ef/keyboard-quit-dwim)


;; Reload Emacs
(defun ef/reload-config ()
  "Reload the Emacs configuration file."
  (interactive)
  (load-file (expand-file-name "init.el" user-emacs-directory)))

(define-key global-map (kbd "C-x r") #'ef/reload-config)


;; ;; Document Centering
;; ;; From David Wilson
;; (defvar center-document-desired-width 120
;;   "The desired width of a document centered in the window.")
;;
;; (defun center-document--adjust-margins ()
;;   "Reset margins first before recalculating"
;;   (set-window-parameter nil 'min-margins nil)
;;   (set-window-margins nil nil)
;;
;;   ;; Adjust margins if the mode is on
;;   (when center-document-mode
;;     (let ((margin-width (max 0
;;                              (truncate
;;                               (/ (- (window-width)
;;                                     center-document-desired-width)
;;                                  2.0)))))
;;       (when (> margin-width 0)
;;         (set-window-parameter nil 'min-margins '(0 . 0))
;;         (set-window-margins nil margin-width margin-width)))))
;;
;; (define-minor-mode center-document-mode
;;   "Toggle centered text layout in the current buffer."
;;   :lighter " Centered"
;;   :group 'editing
;;   (if center-document-mode
;;       (add-hook 'window-configuration-change-hook #'center-document--adjust-margins 'append 'local)
;;     (remove-hook 'window-configuration-change-hook #'center-document--adjust-margins 'local))
;;   (center-document--adjust-margins))
;;
;; (add-hook 'org-mode-hook #'center-document-mode)

;; EXIT MESSAGES form doom emacs
(defvar my-quit-messages
  `(;; from Doom 1
    "Please don't leave, there's more demons to toast!"
    "Let's beat it -- This is turning into a bloodbath!"
    ,(format "I wouldn't leave if I were you. %s is much worse."
             (if (featurep :system 'windows) "DOS" "UNIX"))
    "Don't leave yet -- There's a demon around that corner!"
    "Ya know, next time you come in here I'm gonna toast ya."
    "Go ahead and leave. See if I care."
    "Are you sure you want to quit this great editor?"
    ;; from Portal
    "Thank you for participating in this Aperture Science computer-aided enrichment activity."
    "You can't fire me, I quit!"
    "I don't know what you think you are doing, but I don't like it. I want you to stop."
    "This isn't brave. It's murder. What did I ever do to you?"
    "I'm the man who's going to burn your house down! With the lemons!"
    "Okay, look. We've both said a lot of things you're going to regret..."
    ;; Custom
    "(setq nothing t everything 'permitted)"
    "Emacs will remember that."
    "Emacs, Emacs never changes."
    "Hey! Hey, M-x listen!"
    "It's not like I'll miss you or anything, b-baka!"
    "Wake up, Mr. Stallman. Wake up and smell the ashes."
    "You are *not* prepared!"
    "Please don't go. The drones need you. They look up to you.")
  "A list of quit messages, picked randomly by `+doom-quit'. Taken from
http://doom.wikia.com/wiki/Quit_messages and elsewhere.")

(defun my-quit-emacs (&rest _)
  (yes-or-no-p
   (format "%s  %s"
           (propertize (nth (random (length my-quit-messages))
                            my-quit-messages)
                       'face '(italic default))
           "Really quit Emacs?")))



( setq confirm-kill-emacs #'my-quit-emacs)

;;(global-set-key "\C-x\C-c" 'save-buffers-kill-emacs-with-confirm)


;; Open Files Externally
(defun my-open-with (arg)
  "Open visited file in default external program.
      With a prefix ARG always prompt for command to use."
  (interactive "P")
  (when buffer-file-name
    (shell-command (concat
                    (cond
                     ((and (not arg) (eq system-type 'darwin)) "open")
                     ((and (not arg) (member system-type '(gnu gnu/linux gnu/kfreebsd))) "xdg-open")
                     (t (read-shell-command "Open current file with: ")))
                    " "
                    (shell-quote-argument buffer-file-name)))))

;; Display time
(defun my-current-time-as-string ()
  "Return a string of the current time."
  (concat
   (format-time-string "%Y-%m-%dT%H%M%SZ%z")))

;; Better Theme Switcher
(defun my/switch-theme (theme)
  (interactive
   (list (intern (completing-read "Load custom theme: "
                                  (mapcar #'symbol-name
                                          (custom-available-themes))))))
  (cl-loop for enabled-theme in custom-enabled-themes
           if (not (or (eq enabled-theme 'my-theme-1)
                       (eq enabled-theme theme)))
           do (disable-theme enabled-theme))
  (load-theme theme t)
  (when current-prefix-arg
    (my/regenerate-desktop)))


(provide 'ef-functions)
;;; ef-functions.el ends here
