;;; ef-functions.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:

;;; Better C-g from Prot
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

;; (define-key global-map (kbd "C-g") #'ef/keyboard-quit-dwim)


;;; Reload Emacs
(defun ef/reload-config ()
  "Reload the Emacs configuration file."
  (interactive)
  (load-file (expand-file-name "init.el" user-emacs-directory)))

(define-key global-map (kbd "C-x r") #'ef/reload-config)


;;; Document Centering
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

;;; EXIT MESSAGES form doom emacs
(defvar my/quit-messages
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

(defun my/quit-emacs (&rest _)
  (yes-or-no-p
   (format "%s  %s"
           (propertize (nth (random (length my/quit-messages))
                            my/quit-messages)
                       'face '(italic default))
           "Really quit Emacs?")))



( setq confirm-kill-emacs #'my/quit-emacs)

;;(global-set-key "\C-x\C-c" 'save-buffers-kill-emacs-with-confirm)


;;; Open Files Externally
(defun my/open-with (arg)
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

;;; Display time
(defun my/current-time-as-string ()
  "Return a string of the current time."
  (concat
   (format-time-string "%Y-%m-%dT%H%M%SZ%z")))

;; Better Theme Switcher
(defun my/switch-theme (theme)
  (interactive
   (list (intern (completing-read "Load custom theme: "
                                  (mapcar #'symbol-name
                                          (custom-available-themes))))))
  (mapc #'disable-theme custom-enabled-themes)
  ;; (cl-loop for enabled-theme in custom-enabled-themes
  ;;          if (not (or (eq enabled-theme 'my-theme-1)
  ;;                      (eq enabled-theme theme)))
  ;;          do (disable-theme enabled-theme))
  (load-theme theme t)
  ;; (when current-prefix-arg
  ;;   (my/regenerate-desktop))
  )

;; Functions from Doom Emacs
;; Large File Handling
(defvar-local doom-large-file-p nil)
(put 'doom-large-file-p 'permanent-local t)

(defvar doom-large-file-size-alist '(("." . 3.0))
  "An alist mapping regexps (like `auto-mode-alist') to filesize thresholds.

If a file is opened and discovered to be larger than the threshold, Doom
performs emergency optimizations to prevent Emacs from hanging, crashing or
becoming unusably slow.

These thresholds are in MB, and is used by `doom--optimize-for-large-files-a'.")

(defvar doom-large-file-excluded-modes
  '(so-long-mode
    special-mode archive-mode tar-mode jka-compr
    git-commit-mode image-mode doc-view-mode doc-view-mode-maybe
    ebrowse-tree-mode pdf-view-mode tags-table-mode)
  "Major modes that `doom-check-large-file-h' will ignore.")

(defun doom--optimize-for-large-files-a (orig-fn &rest args)
  "Set `doom-large-file-p' if the file is too large.

Uses `doom-large-file-size-alist' to determine when a file is too large. When
`doom-large-file-p' is set, other plugins can detect this and reduce their
runtime costs (or disable themselves) to ensure the buffer is as fast as
possible."
  (if (setq doom-large-file-p
            (and buffer-file-name
                 (not doom-large-file-p)
                 (file-exists-p buffer-file-name)
                 (ignore-errors
                   (> (nth 7 (file-attributes buffer-file-name))
                      (* 1024 1024
                         (assoc-default buffer-file-name
                                        doom-large-file-size-alist
                                        #'string-match-p))))))
      (prog1 (apply orig-fn args)
        (if (memq major-mode doom-large-file-excluded-modes)
            (setq doom-large-file-p nil)
          (when (fboundp 'so-long-minor-mode) ; in case the user disabled it
            (so-long-minor-mode))
          (message "Large file! Cutting corners to improve performance")))
    (apply orig-fn args)))

(advice-add 'after-find-file :around #'doom--optimize-for-large-files-a)


;; Incremenal Loading
;; https://github.com/hlissner/doom-emacs/blob/42a21dffddeee57d84e82a9f0b65d1b0cba2b2af/core/core.el#L353
(defvar doom-incremental-packages '(t)
  "A list of packages to load incrementally after startup. Any large packages
here may cause noticeable pauses, so it's recommended you break them up into
sub-packages. For example, `org' is comprised of many packages, and can be
broken up into:
  (doom-load-packages-incrementally
   '(calendar find-func format-spec org-macs org-compat
     org-faces org-entities org-list org-pcomplete org-src
     org-footnote org-macro ob org org-clock org-agenda
     org-capture))
This is already done by the lang/org module, however.
If you want to disable incremental loading altogether, either remove
`doom-load-packages-incrementally-h' from `emacs-startup-hook' or set
`doom-incremental-first-idle-timer' to nil.")

(defvar doom-incremental-first-idle-timer 2.0
  "How long (in idle seconds) until incremental loading starts.
Set this to nil to disable incremental loading.")

(defvar doom-incremental-idle-timer 0.75
  "How long (in idle seconds) in between incrementally loading packages.")

(defvar doom-incremental-load-immediately nil
  ;; (daemonp)
  "If non-nil, load all incrementally deferred packages immediately at startup.")

(defmacro appendq! (sym &rest lists)
  "Append LISTS to SYM in place."
  `(setq ,sym (append ,sym ,@lists)))

(defun doom-load-packages-incrementally (packages &optional now)
  "Registers PACKAGES to be loaded incrementally.
If NOW is non-nil, load PACKAGES incrementally, in `doom-incremental-idle-timer'
intervals."
  (if (not now)
      (appendq! doom-incremental-packages packages)
    (while packages
      (let ((req (pop packages)))
        (unless (featurep req)
          (message "Incrementally loading %s" req)
          (condition-case e
              (or (while-no-input
                    ;; If `default-directory' is a directory that doesn't exist
                    ;; or is unreadable, Emacs throws up file-missing errors, so
                    ;; we set it to a directory we know exists and is readable.
                    (let ((default-directory user-emacs-directory)
                          (gc-cons-threshold most-positive-fixnum)
                          file-name-handler-alist)
                      (require req nil t))
                    t)
                  (push req packages))
            ((error debug)
             (message "Failed to load '%s' package incrementally, because: %s"
                      req e)))
          (if (not packages)
              (message "Finished incremental loading")
            (run-with-idle-timer doom-incremental-idle-timer
                                 nil #'doom-load-packages-incrementally
                                 packages t)
            (setq packages nil)))))))

(defun doom-load-packages-incrementally-h ()
  "Begin incrementally loading packages in `doom-incremental-packages'.
If this is a daemon session, load them all immediately instead."
  (if doom-incremental-load-immediately
      (mapc #'require (cdr doom-incremental-packages))
    (when (numberp doom-incremental-first-idle-timer)
      (run-with-idle-timer doom-incremental-first-idle-timer
                           nil #'doom-load-packages-incrementally
                           (cdr doom-incremental-packages) t))))

(add-hook 'emacs-startup-hook #'doom-load-packages-incrementally-h)

;; Adds two keywords to `use-package' to expand its lazy-loading capabilities:
;;
;;   :after-call SYMBOL|LIST
;;   :defer-incrementally SYMBOL|LIST|t
;;
;; Check out `use-package!'s documentation for more about these two.
(eval-when-compile
  (dolist (keyword '(:defer-incrementally :after-call))
    (push keyword use-package-deferring-keywords)
    (setq use-package-keywords
          (use-package-list-insert keyword use-package-keywords :after)))

  (defalias 'use-package-normalize/:defer-incrementally #'use-package-normalize-symlist)
  (defun use-package-handler/:defer-incrementally (name _keyword targets rest state)
    (use-package-concat
     `((doom-load-packages-incrementally
        ',(if (equal targets '(t))
              (list name)
            (append targets (list name)))))
     (use-package-process-keywords name rest state))))

;;; Move Text Up and Down
(defun move-text-internal (arg)
  (cond
   ((and mark-active transient-mark-mode)
    (if (> (point) (mark))
        (exchange-point-and-mark))
    (let ((column (current-column))
          (text (delete-and-extract-region (point) (mark))))
      (forward-line arg)
      (move-to-column column t)
      (set-mark (point))
      (insert text)
      (exchange-point-and-mark)
      (setq deactivate-mark nil)))
   (t
    (let ((column (current-column)))
      (beginning-of-line)
      (when (or (> arg 0) (not (bobp)))
        (forward-line)
        (when (or (< arg 0) (not (eobp)))
          (transpose-lines arg)
          ;; ;; Account for changes to transpose-lines in Emacs 24.3
          ;; (when (and (eval-when-compile
          ;;              (not (version-list-<
          ;;                    (version-to-list emacs-version)
          ;;                    '(24 3 50 0))))
          ;;            (< arg 0))
          ;;   (forward-line -1))
          )
        (forward-line -1))
      (move-to-column column t)))))

(defun move-text-down (arg)
  "Move region (transient-mark-mode active) or current line
  arg lines down."
  (interactive "*p")
  (move-text-internal arg))

(defun move-text-up (arg)
  "Move region (transient-mark-mode active) or current line
  arg lines up."
  (interactive "*p")
  (move-text-internal (- arg)))

(define-key global-map (kbd "M-<up>") #'move-text-up)
(define-key global-map (kbd "M-<down>") #'move-text-down)


;;; Restart or Close Emacs
(defun my/restart-or-kill-emacs (&optional arg restart)
  "Kill Emacs.
If called with RESTART (`universal-argument’ interactively) restart
Emacs instead. Passes ARG to `save-buffers-kill-emacs'."
  (interactive "P")
  (save-buffers-kill-emacs arg (or restart (equal arg '(4)))))
(bind-key [remap save-buffers-kill-terminal] #'my/restart-or-kill-emacs)



;;; Toggle line truncate without message
;; Truncate lines by default in a number of places and do not produce
;; a message about the fact
(defun my/common-truncate-lines-silently ()
  "Toggle line truncation without printing messages."
  (let ((inhibit-message t))
    (toggle-truncate-lines t)))
(add-hook 'text-mode-hook #'my/common-truncate-lines-silently)
(add-hook 'prog-mode-hook #'my/common-truncate-lines-silently)

;;; FIXME Mark Symbolic Expressions
(defun my/simple-mark (bounds)
  "Mark between BOUNDS as a cons cell of beginning and end positions."
  (push-mark (car bounds))
  (goto-char (cdr bounds))
  (activate-mark))
(defun my/simple-mark-sexp ()
  "Mark symbolic expression at or near point.
Repeat to extend the region forward to the next symbolic
expression."
  (interactive)
  (if (and (region-active-p)
           (eq last-command this-command))
      (ignore-errors (forward-sexp 1))
    (when-let* ((thing (cond
                        ((thing-at-point 'url) 'url)
                        ((thing-at-point 'sexp) 'sexp)
                        ((thing-at-point 'string) 'string)
                        ((thing-at-point 'word) 'word))))
      (my/simple-mark (bounds-of-thing-at-point thing)))))

;; (define-key global-map (kbd "C-}") #'my/simple-mark-sexp)

;;; Move half screen above and below
(defun my/simple-multi-line-below ()
  "Move half a screen below."
  (interactive)
  (forward-line (floor (window-height) 2))
  (setq this-command 'scroll-up-command))

(defun my/simple-multi-line-above ()
  "Move half a screen above."
  (interactive)
  (forward-line (- (floor (window-height) 2)))
  (setq this-command 'scroll-down-command))

(define-key global-map (kbd "C-M-,") #'my/simple-multi-line-above)
(define-key global-map (kbd "C-M-.") #'my/simple-multi-line-below)




;;; Create Scratch Buffer
(defun my/create-scratch-buffer ()
  "Create a scratch buffer."
  (interactive)
  (switch-to-buffer (get-buffer-create "*scratch*"))
  (lisp-interaction-mode))

;;; Delete this file
(defun my/delete-this-file ()
  "Delete the current file, and kill the buffer."
  (interactive)
  (unless (buffer-file-name)
    (error "No file is currently being edited"))
  (when (yes-or-no-p (format "Really delete '%s'?"
                             (file-name-nondirectory buffer-file-name)))
    (delete-file (buffer-file-name))
    (kill-this-buffer)))
;;; Rename this file
(defun my/rename-this-file (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (unless filename
      (error "Buffer '%s' is not visiting a file!" name))
    (progn
      (when (file-exists-p filename)
        (rename-file filename new-name 1))
      (set-visited-file-name new-name)
      (rename-buffer new-name))))

;;; Comment DWIM
;; (defun my/comment-dwim ()
;;   "Comment region if active, else comment line.
;;
;; This avoids the excess region commenting of `comment-line' while also avoiding the weird single-line
;; behavior of `comment-dwim'."
;;   (interactive)
;;   (save-excursion
;;     (if (use-region-p)
;;         (call-interactively #'comment-or-uncomment-region)
;;       (call-interactively #'comment-line))))


;;; Better `keyboard-quit'
(defun my/keyboard-quit-context ()
  "Quit current context.

This function is a combination of `keyboard-quit' and `keyboard-escape-quit'
with some parts omitted and some custom behavior added."
  ;; Adapted from https://with-emacs.com/posts/tips/quit-current-context/
  (interactive)
  (cond
   ((region-active-p)
    ;; Avoid adding the region to the window selection.
    (setq saved-region-selection nil)
    (let (select-active-regions)
      (deactivate-mark)))

   ((eq last-command 'mode-exited)
    nil)

   (current-prefix-arg
    nil)

   (defining-kbd-macro
    (message
     (substitute-command-keys
      "Quit is ignored during macro defintion, use \\[kmacro-end-macro] if you want to stop macro definition"))
    (cancel-kbd-macro-events))

   ((active-minibuffer-window)
    (when (get-buffer-window "*Completions*")
      ;; hide completions first so point stays in active window when
      ;; outside the minibuffer
      (minibuffer-hide-completions))
    (abort-recursive-edit))

   (t
    (keyboard-quit))))
(define-key global-map (kbd "C-g") #'my/keyboard-quit-context)
;; (global-set-key [remap keyboard-quit] #'my/keyboard-quit-context)


;;; Toggle Maximize Buffer
(defun my/toggle-maximize-buffer ()
  "Maximize buffer."
  (interactive)
  (save-excursion
    (if (and (= 1 (length (window-list)))
             (assoc ?_ register-alist))
        (jump-to-register ?_)
      (progn
        (window-configuration-to-register ?_)
        (delete-other-windows)))))
(define-key ef-buffer-keymap (kbd "m") #'my/toggle-maximize-buffer)

;; Indent Region or Buffer
(defun my/indent-region-or-buffer (&optional arg)
  "Indent a region if selected, otherwise the whole buffer.
if prefix argument ARG is given, `untabify' first."
  (interactive)
  (save-excursion
    (if (region-active-p)
        (progn
          (when arg
            (untabify (region-beginning) (region-end)))
          (indent-region (region-beginning) (region-end))
          (message "Indented selected region."))
      (progn
        (when arg
          (untabify (region-beginning) (region-end)))
        (indent-region (point-min) (point-max))
        (message "Indented buffer.")))))
(define-key ef-buffer-keymap (kbd "i") #'my/indent-region-or-buffer)

;;; Switch to scratch buffer
(defun my/switch-to-scratch-buffer (&optional arg)
  "Switch to the `*scratch*' buffer, creating it first if needed.
if prefix argument ARG is given, switch to it in an other, possibly new window."
  (interactive "P")
  (if arg
      (switch-to-buffer-other-window (get-buffer-create "*scratch*"))
    (switch-to-buffer (get-buffer-create "*scratch*"))))
(define-key ef-buffer-keymap (kbd "s") #'my/switch-to-scratch-buffer)


;;; Message Buffer
(defun my/switch-to-messages-buffer (&optional arg)
  "Switch to the `*Messages*' buffer in an other window.
if prefix argument ARG is given, switch to it directly."
  (interactive "P")
  (with-current-buffer (messages-buffer)
    (goto-char (point-max))
    (if arg
        (switch-to-buffer (current-buffer))
      (switch-to-buffer-other-window (current-buffer)))))
(define-key ef-buffer-keymap (kbd "0") #'my/switch-to-messages-buffer)

;;; Minibuffer Window
(defun my/switch-to-minibuffer-window ()
  "Switch to minibuffer window (if active)."
  (interactive)
  (when (active-minibuffer-window)
    (select-window (active-minibuffer-window))))
(define-key ef-buffer-keymap (kbd ",") #'my/switch-to-minibuffer-window)

;;; Window Split
(defun my/split-window-vertically-and-focus ()
  "Split the window vertically and focus the new window."
  (interactive)
  (split-window-vertically)
  (windmove-down))

(defun my/split-window-horizontally-and-focus ()
  "Split the window horizontally and focus the new window."
  (interactive)
  (split-window-horizontally)
  (windmove-right))

;;; Server Shutdown
(defun my/server-shutdown ()
  "Save buffers, Quit, and Shutdown (kill) server"
  (interactive)
  (save-some-buffers)
  (kill-emacs)
  )

;;; Make Directory
(defun my/make-directory-maybe ()
  "Create parent directory if not exists while visiting file."
  (let ((dir (file-name-directory buffer-file-name)))
    (unless (file-exists-p dir)
      (if (y-or-n-p (format "Directory %s does not exist,do you want you create it? " dir))
          (make-directory dir t)
        (keyboard-quit)))))

(provide 'ef-functions)
;;; ef-functions.el ends here
