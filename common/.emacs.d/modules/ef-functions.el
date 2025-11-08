;;; ef-functions.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:

;;; General Configuration
;;;; Open Directories
(defconst personal-dir "~/Org")
(defconst config-dir "~/dotfiles")
(defun my/open-personal ()
  " Open Personal Directory"
  (interactive)
  (dired personal-dir)
  )

(defun my/open-dotfiles ()
  "Open Dotfiles Directory"
  (interactive)
  (dired config-dir)
  )


;;;; Better C-g from Prot
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

;;;; Better `keyboard-quit'
;; (defun my/keyboard-quit-context ()
;;   "Quit current context.
;; This function is a combination of `keyboard-quit' and `keyboard-escape-quit'
;; with some parts omitted and some custom behavior added."
;;   (interactive)
;;   (cond
;;    ((region-active-p)
;;     ;; Avoid adding the region to the window selection.
;;     (setq saved-region-selection nil)
;;     (let (select-active-regions)
;;       (deactivate-mark)))
;;
;;    ((eq last-command 'mode-exited)
;;     nil)
;;
;;    (current-prefix-arg
;;     nil)
;;
;;    (defining-kbd-macro
;;     (message
;;      (substitute-command-keys
;;       "Quit is ignored during macro defintion, use \\[kmacro-end-macro] if you want to stop macro definition"))
;;     (cancel-kbd-macro-events))
;;
;;    ((active-minibuffer-window)
;;     (when (get-buffer-window "*Completions*")
;;       ;; hide completions first so point stays in active window when
;;       ;; outside the minibuffer
;;       (minibuffer-hide-completions))
;;     (abort-recursive-edit))
;;
;;    (t
;;     (keyboard-quit))))

;; (define-key global-map (kbd "C-g") #'my/keyboard-quit-context)
;; (global-set-key [remap keyboard-quit] #'my/keyboard-quit-context)

;;;; Doom Emacs Escape
(defvar doom-escape-hook nil
  "A hook run when C-g is pressed (or ESC in normal mode, for evil users).

More specifically, when `doom/escape' is pressed. If any hook returns non-nil,
all hooks after it are ignored.")

(defun doom/escape (&optional interactive)
  "Run `doom-escape-hook'."
  (interactive (list 'interactive))
  (let ((inhibit-quit t))
    (cond ((minibuffer-window-active-p (minibuffer-window))
           ;; quit the minibuffer if open.
           (when interactive
             (setq this-command 'abort-recursive-edit))
           (abort-recursive-edit))
          ;; Run all escape hooks. If any returns non-nil, then stop there.
          ((run-hook-with-args-until-success 'doom-escape-hook))
          ;; don't abort macros
          ((or defining-kbd-macro executing-kbd-macro) nil)
          ;; Back to the default
          ((unwind-protect (keyboard-quit)
             (when interactive
               (setq this-command 'keyboard-quit)))))))

(with-eval-after-load 'eldoc
  (eldoc-add-command 'doom/escape))

(global-set-key [remap keyboard-quit] #'doom/escape)
(global-set-key [remap abort-recursive-edit] #'doom/escape)
;;;; Reload Emacs
(defun ef/reload-config ()
  "Reload the Emacs configuration file."
  (interactive)
  (message "Reloading init.el ...")
  (load-file (expand-file-name "init.el" user-emacs-directory))
  ;; (load user-init-file nil 'nomessage)
  (message "Reloading init.el Done!!!")

  )

(define-key global-map (kbd "C-x r") #'ef/reload-config)

;;; Quit Emacs
;; EXIT MESSAGES form doom emacs
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

(setq confirm-kill-emacs #'my/quit-emacs)



;;(global-set-key "\C-x\C-c" 'save-buffers-kill-emacs-with-confirm)

;;;; Open Files Externally
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

;;;; Eval Buffer or Region
(defun my/eval-buffer-or-region (&optional start end)
  "Evaluate the current region, or the whole buffer if no region is active.
It uses `ef/reload-config'
"
  (interactive)
  (if (and buffer-file-name
           (member (file-truename buffer-file-name)
                   (list
                    (when (bound-and-true-p early-init-file)
                      (file-truename early-init-file))
                    (file-truename user-init-file)))
           (not (region-active-p)))
      (ef/reload-config)
    (let ((name nil))
      (if (region-active-p)
          (progn
            (setq start (region-beginning))
            (setq end (region-end))
            (setq name "region"))
        (setq start (point-min))
        (setq end (point-max))
        (setq name (buffer-name)))
      (let ((load-file-name (buffer-file-name)))
        (message "Evaluating %s..." name)
        (eval-region start end)
        (message "Evaluating %s...done" name)))))

;;;; Insert Current Time As a String
;; (defun my/current-time-as-string ()
;;   "Return a string of the current time."
;;   (concat
;;    (format-time-string "%Y-%m-%dT%H%M%SZ%z")))

;;; Kill Emacs and Exit
(defun my/hard-kill-emacs ()
  "Use `call-process' to send ourselves a KILL signal."
  (interactive)
  (call-process "kill" nil nil nil "-9" (number-to-string (emacs-pid))))

;;; Insert Header and Footer into a New Lisp File
(defun my/insert-header-and-footer ()
  "Add a minimal header and footer to an elisp buffer."
  (interactive)
  (let ((fname (if (buffer-file-name)
                   (file-name-nondirectory (buffer-file-name))
                 (error "This buffer is not visiting a file"))))
    (save-excursion
      (goto-char (point-min))
      (insert ";;; " fname "  -*- lexical-binding: t; no-byte-compile: t; -*-\n"
              ";;; Commentary:\n"
              ";;; Code:\n\n")
      (goto-char (point-max))
      (setq name (file-name-nondirectory (file-name-sans-extension fname)))
      (insert "(provide '"name")\n")
      (insert ";;; " fname " ends here\n"))))

;;; Buffer

;;; Windows
;;;; Switch or Rotate Window
(defun my/switch-or-rotate-buffer ()
  "Switch to the previous buffer or rotate window configuration.

If there is only one window in the frame, this function switches
to the previous buffer, cycling through the buffer list in the
current window.

If there are multiple windows in the frame, this function rotates
the window configuration, moving to the previous window in the
cyclic order."
  (interactive)
  (if (one-window-p t)
      ;; Switch to the previous buffer.
      (switch-to-buffer (other-buffer (current-buffer) 1))
    ;; Move to the previous window in a multi-window configuration.
    (other-window -1)))

(global-set-key (kbd "C-z 0") #'my/switch-or-rotate-buffer)

;;; Toggle or Delete Window Layout
(defun my/toggle-or-delete-window-layout ()
  "Toggle or delete the window layout.
If there is only one window in the frame, this function will split the window
either horizontally or vertically, depending on the frame's width, as defined by
`split-width-threshold' variable. If the frame width is greater than
`split-width-threshold', it will split the window horizontally, otherwise
vertically.

If there are multiple windows in the frame, this function will delete all other
windows, leaving only the currently active window visible."
  (interactive)
  (cond ((one-window-p t)
         (select-window
          (if (> (frame-width) split-width-threshold)
              (split-window-right)
            (split-window-below))))
        (t
         (delete-other-windows))))

(global-set-key (kbd "<f5>") #'my/toggle-or-delete-window-layout)

;;; Sticky Window
;; Make the current window stick
(defun my/sticky-window ()
  "Toggle whether the current active window is dedicated or not."
  (interactive)
  (let* ((window (selected-window))
         (dedicated (window-dedicated-p window)))
    (set-window-dedicated-p window (not dedicated))
    (message "[Window %sdedicated to %s]"
             (if dedicated "no longer " "")
             (buffer-name))))

;; Press [pause] key in each window you want to "freeze".
(global-set-key (kbd "C-z ;") #'my/sticky-window)



;;; Editing
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

;;; Appearance
;;;; Better Theme Switcher
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
;;; Advice for a better load-theme
;; This will make load-theme disable old theme before loading new one
(defadvice load-theme
    (before disable-before-load (theme &optional no-confirm no-enable) activate)
  (mapc 'disable-theme custom-enabled-themes))

;;;; Better way to load themes
(defun my/load-theme (theme)
  "Load custom THEME.

Load THEME exclusively, disabling any other enabled theme.

When called with universal arg, it will append the theme to `custom-enabled-themes'."
  (interactive
   (list
    (intern (completing-read "Load custom theme: "
                             (mapcar #'symbol-name
                                     (custom-available-themes))))))
  (unless (custom-theme-name-valid-p theme)
    (error "Invalid theme name `%s'" theme))
  (unless current-prefix-arg
    (dolist (theme custom-enabled-themes) (disable-theme theme))
    (setq custom-enabled-themes nil))
  (load-theme theme t))

;;; Functions from Doom Emacs
;;;; Large File Handling
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

;;;; Incremenal Loading
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

(defvar doom-incremental-first-idle-timer 5.0
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

;;; Explicit Approach
;; (doom-load-packages-incrementally
;;  '(calendar find-func format-spec org-agenda org-macs org-compat
;;             org-faces org-entities org-list org-pcomplete org-src
;;             org-footnote org-macro ob org org-clock org-agenda
;;             org-capture))

(doom-load-packages-incrementally
 '(calendar find-func format-spec org-macs org-compat
            org-faces org-entities org-list org-pcomplete org-src
            org-footnote org-macro ob org org-clock org-agenda org-capture
            org-attach magit-log magit-diff magit-status bookmark
            eshell em-alias em-banner em-basic em-cmpl em-glob em-hist em-ls
            em-prompt em-script em-term em-unix em-smart
            init-eglot)
 )
;;;;
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
;; Better Exit
(defun my/clean-exit ()
  "Exit Emacs cleanly.
If there are unsaved buffer, pop up a list for them to be saved
before existing. Replaces ‘save-buffers-kill-terminal’.
From https://archive.casouri.cc/note/2021/clean-exit/index.html"
  (interactive)
  (if (frame-parameter nil 'client)
      (server-save-buffers-kill-terminal nil)
    (if-let* ((buf-list (seq-filter (lambda (buf)
                                      (and (buffer-modified-p buf)
                                           (buffer-file-name buf)))
                                    (buffer-list))))
        (progn
          (pop-to-buffer (list-buffers-noselect t buf-list))
          (message "s to save, C-k to kill, x to execute"))
      (save-buffers-kill-terminal))))

;;;; Old Version
(defun my/restart-or-kill-emacs (&optional arg restart)
  "Kill Emacs.
If called with RESTART (`universal-argument’ interactively) restart
Emacs instead. Passes ARG to `save-buffers-kill-emacs'."
  (interactive "P")
  (save-buffers-kill-emacs arg (or restart (equal arg '(4)))))

(bind-key [remap save-buffers-kill-terminal] #'my/clean-exit)



;;; Close Frame If Not the Last, Kill Emacs Otherwise
(defun my/delete-frame-or-kill-emacs ()
  "Delete frame or kill Emacs if there is only one frame."
  (interactive)
  (if (> (length (frame-list)) 1)
      (delete-frame)
    (save-buffers-kill-terminal)))
(global-set-key (kbd "C-c 0") 'my/delete-frame-or-kill-emacs)

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

;;; Scrolling
;;;; Move half screen above and below
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

;;;; Scrolling Alternative
(defun my/window-half-height ()
  (max 1 (/ (1- (window-height (selected-window))) 2)))

(defun my/scroll-up-half ()
  (interactive)
  (scroll-up (my/window-half-height)))

(defun my/scroll-down-half ()
  (interactive)
  (scroll-down (my/window-half-height)))

(global-set-key (kbd "C-p") 'my/scroll-down-half)
(global-set-key (kbd "C-n") 'my/scroll-up-half)

;;; Create Scratch Buffer
(defun my/create-scratch-buffer ()
  "Create a scratch buffer."
  (interactive)
  (switch-to-buffer (get-buffer-create "*scratch*"))
  (lisp-interaction-mode))

;;; Delete this file
;; (defun my/delete-this-file ()
;;   "Delete the current file, and kill the buffer."
;;   (interactive)
;;   (unless (buffer-file-name)
;;     (error "No file is currently being edited"))
;;   (when (yes-or-no-p (format "Really delete '%s'?"
;;                              (file-name-nondirectory buffer-file-name)))
;;     (delete-file (buffer-file-name))
;;     (kill-this-buffer)))

;;;; Better
(defun my/delete-this-file (&optional path force-p)
  "Delete PATH. If PATH is not specified, default to the current buffer's file.
If FORCE-P, delete without confirmation."
  (interactive
   (list (buffer-file-name (buffer-base-buffer)) current-prefix-arg))
  (let* ((path (or path (buffer-file-name (buffer-base-buffer))))
         (short-path (abbreviate-file-name path)))
    (unless (and path (file-exists-p path))
      (user-error "Buffer is not visiting any file"))
    (unless (file-exists-p path)
      (error "File doesn't exist: %s" path))
    (unless (or force-p (y-or-n-p (format "Really delete %S?" short-path)))
      (user-error "Aborted"))
    (unwind-protect
        (progn (delete-file path delete-by-moving-to-trash) t)
      (when (file-exists-p path)
        (error "Failed to delete %S" short-path)))
    )
  (kill-this-buffer)
  )

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

;;; Switch Message Buffer
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

;;; Switch to Help Buffer
(defun my/view-help-buffer ()
  "View the `*Help*' buffer."
  (interactive)
  (pop-to-buffer (help-buffer)))
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

(bind-key "C-x 2" 'my/split-window-horizontally-and-focus)
(bind-key "C-x 3" 'my/split-window-vertically-and-focus)

;;; Server Shutdown
(defun my/server-shutdown ()
  "Save buffers, Quit, and Shutdown (kill) server"
  (interactive)
  (save-some-buffers)
  (kill-emacs)
  )


;;; Make Temporary Buffer
(defvar temp-buffer-count 0)
(defun my/make-temp-buffer ()
  (interactive)
  (let ((temp-buffer-name (format "*temp-%d*" temp-buffer-count)))
    (switch-to-buffer temp-buffer-name)
    (message "New temp buffer (%s) created." temp-buffer-name))
  (setq temp-buffer-count (1+ temp-buffer-count)))

(define-key ef-buffer-keymap (kbd "n") #'my/make-temp-buffer)                                       ; Key Bindings

;;; Transparency
;;;; Simple Transparency
(defun my/transparency (value)
  "Sets the transparency of the frame window. 0=transparent/100=opaque"
  (interactive "nTransparency Value 0 - 100 opaque:")
  (set-frame-parameter (selected-frame) 'alpha-background value))


;;;; Toggle Transparency
(defun my/toggle-transparency ()
  "Toggle transparency."
  (interactive)
  (let ((alpha-background (frame-parameter nil 'alpha-background)))
    (set-frame-parameter
     nil 'alpha-background
     (if (eql (cond ((numberp alpha-background) alpha-background)
                    ((numberp (cdr alpha-background)) (cdr alpha-background))
                    ;; Also handle undocumented (<active> <inactive>) form.
                    ((numberp (cadr alpha-background)) (cadr alpha-background)))
              100)
         70
       100))))

;;;; Better Transparency
(defun my/set-opacity (opacity &optional frames)
  "Interactively change the current frame's opacity.

OPACITY is an integer between 0 to 100, inclusive. FRAMES is a list of frames to
apply the change to or `t' (meaning all open and future frames). If called
interactively, FRAMES defaults to the current frame (or `t' with the prefix
arg)."
  (interactive
   (list 'interactive (if current-prefix-arg t (list (selected-frame)))))
  (let* ((parameter
          (if (eq window-system 'pgtk)
              'alpha-background
            'alpha))
         (opacity
          (if (eq opacity 'interactive)
              (read-number "Opacity (0-100): "
                           (or (frame-parameter nil parameter)
                               100))
            opacity))
         (alist `((,parameter . ,opacity))))
    (if (eq frames t)
        (modify-all-frames-parameters alist)
      (dolist (frame frames)
        (modify-frame-parameters frame alist)))))

;;;; Adjust transparency using arrow keys
(defun my/frame-transparency-adjust ()
  "Adjust current frame's transparency using <up> and <down>."
  (declare (interactive-only "Use `set-frame-parameter' instead."))
  (interactive)
  ;; If `alpha' is not a number in [0, 100], reset to 100
  (pcase (frame-parameter nil 'alpha)
    ((and (pred numberp) n (guard (<= 0 n 100))))
    (_ (setf (frame-parameter nil 'alpha) 100)))
  (while (pcase (read-key (format "%2d%%  Press <up> and <down> to adjust"
                                  (frame-parameter nil 'alpha)))
           ((or (and 'up   (let new-alpha (1+ (frame-parameter nil 'alpha))))
                (and 'down (let new-alpha (1- (frame-parameter nil 'alpha)))))
            (when (<= 0 new-alpha 100)
              (setf (frame-parameter nil 'alpha) new-alpha))
            t))))

;;; Invisible window dividers for themes
(defun my/invisible-window-dividers (_theme)
  "Make windows dividers for THEME invisible."
  (let ((bg (face-background 'default)))
    (custom-set-faces
     `(fringe ((t :background ,bg :foreground ,bg)))
     ;; `(vertical-border ((t :background ,bg :foreground ,bg)))
     `(window-divider ((t :background ,bg :foreground ,bg)))
     `(window-divider-first-pixel ((t :background ,bg :foreground ,bg)))
     `(window-divider-last-pixel ((t :background ,bg :foreground ,bg))))))

(add-hook 'enable-theme-functions #'my/invisible-window-dividers)

;;; Insert Current Date
(defun my/insert-current-date ()
  "Insert current date."
  (interactive)
  (insert (shell-command-to-string "echo -n $(date +'%b %d, %Y')")))

;;; Insert Current Date ISO Format
(defun my/insert-date-iso ()
  "Insert the current date, ISO format eg. 2016-12-09."
  (interactive "*")
  (insert (format-time-string "%F")))

;;; Insert Current File Name
(defun my/insert-current-filename ()
  "Insert current buffer filename."
  (interactive)
  (insert (file-relative-name buffer-file-name)))

;;; Kill Buffer and Windows
(defun my/kill-buffer-and-windows (buffer)
  "Kill the buffer and delete all the windows it's displayed in."
  (dolist (window (get-buffer-window-list buffer))
    (unless (one-window-p t)
      (delete-window window)))
  (kill-buffer buffer))

;;; Delete Whitespace backward
(defun my/backward-delete-whitespace ()
  (interactive)
  (save-match-data
    (let ((st (point))
          (en (progn
                (re-search-backward "[^ \t\r\n]+" nil t)
                (forward-char 1)
                (point))))
      (if (= st en)
          (progn
            (while (looking-back ")")
              (backward-char))
            (backward-kill-word 1))
        (delete-region st en)))))

;;; FIXME Delete Whitespace
;; Remove useless whitespace before saving a file
(defun delete-trailing-whitespace-except-current-line ()
  "An alternative to `delete-trailing-whitespace'.
The original function deletes trailing whitespace of the current line."
  (interactive)
  (let ((begin (line-beginning-position))
        (end (line-end-position)))
    (save-excursion
      (when (< (point-min) (1- begin))
        (save-restriction
          (narrow-to-region (point-min) (1- begin))
          (delete-trailing-whitespace)
          (widen)))
      (when (> (point-max) (+ end 2))
        (save-restriction
          (narrow-to-region (+ end 2) (point-max))
          (delete-trailing-whitespace)
          (widen))))))

(defun smart-delete-trailing-whitespace ()
  "Invoke `delete-trailing-whitespace-except-current-line' on selected major modes only."
  (unless (member major-mode '(diff-mode))
    (delete-trailing-whitespace-except-current-line)))

(defun toggle-auto-trailing-ws-removal ()
  "Toggle trailing whitespace removal."
  (interactive)
  (if (member #'smart-delete-trailing-whitespace before-save-hook)
      (progn
        (remove-hook 'before-save-hook #'smart-delete-trailing-whitespace)
        (message "Disabled auto remove trailing whitespace."))
    (add-hook 'before-save-hook #'smart-delete-trailing-whitespace)
    (message "Enabled auto remove trailing whitespace.")))
;; Add to hook during startup
(add-hook 'before-save-hook #'smart-delete-trailing-whitespace)

;;; Delete Blank Lines
(defun my/delete-blank-lines-dwim ()
  "Delete all blank lines surrounding point or, between point and mark."
  (interactive)
  (let ((regexp "^[ \t]*$")
        (col (current-column)))
    (if (region-active-p)
        (flush-lines regexp (region-beginning) (region-end) nil)
      (delete-blank-lines)
      (if (looking-at regexp) (delete-blank-lines)))
    (move-to-column col)))
;; (define-key ef-file-keymap (kbd "o") #'my/delete-blank-lines-dwim)

;;; Delete Blank Lines
(defun my/delete-blank-lines ()
  "Delete all newline around cursor.
URL `http://ergoemacs.org/emacs/emacs_shrink_whitespace.html'
Version 2018-04-02"
  (interactive)
  (let ($p3 $p4)
    (skip-chars-backward "\n")
    (setq $p3 (point))
    (skip-chars-forward "\n")
    (setq $p4 (point))
    (delete-region $p3 $p4)))

;;; Delete Backward Whitespace or Word
(defun my/kill-whitespace-or-word (arg)
  "Kill forward whitespace or word.
With argument ARG, do this that many times.
Restricts the effect of `kill-word' to the current line."
  (interactive "p")
  (if (looking-at-p "[ \t\n]")
      (let ((pt (point)))
        (re-search-forward "[^ \t\n]" nil :no-error)
        (backward-char)
        (kill-region pt (point)))
    (save-restriction
      (narrow-to-region (line-beginning-position) (line-end-position))
      (kill-word arg)
      (widen))))

(defun my/backward-kill-whitespace-or-word (arg)
  "Kill backward whitespace or word.
With argument ARG, do this that many times.
Restricts the effect of `backward-kill-word' to the current line."
  (interactive "p")
  (if (save-excursion (backward-char) (looking-at-p "[ \t\n]"))
      (let ((pt (point)))
        (re-search-backward "[^ \t\n]" nil :no-error)
        (forward-char)
        (kill-region pt (point)))
    (save-restriction
      (narrow-to-region (line-beginning-position) (line-end-position))
      (backward-kill-word arg)
      (widen))))



;;; Set initial frame size and position
;; (defun my/set-initial-frame ()
;;   (let* ((base-factor 0.70)
;;          (a-width (* (display-pixel-width) base-factor))
;;          (a-height (* (display-pixel-height) base-factor))
;;          (a-left (truncate (/ (- (display-pixel-width) a-width) 2)))
;;          (a-top (truncate (/ (- (display-pixel-height) a-height) 2))))
;;     (set-frame-position (selected-frame) a-left a-top)
;;     (set-frame-size (selected-frame) (truncate a-width)  (truncate a-height) t)))
;; (setq frame-resize-pixelwise t)
;; (my/set-initial-frame)

;;;; Alternative
;; (add-hook 'window-setup-hook 'toggle-frame-maximized t)

;;;;; start the initial frame maximized
;; (add-to-list 'initial-frame-alist '(fullscreen . maximized))

;;;;; start every frame maximized
;; (add-to-list 'default-frame-alist '(fullscreen . maximized))

;;; Fill or Unfill Paragraph
;; (defun my/fill-or-unfill ()
;;   "Like `fill-paragraph', but unfill if used twice."
;;   (interactive)
;;   (let ((fill-column
;;          (if (eq last-command 'my-fill-or-unfill)
;;              (progn (setq this-command nil)
;;                     (point-max))
;;            fill-column)))
;;     (call-interactively 'fill-paragraph nil (vector nil t))))
;;
;; ;; (global-set-key [remap fill-paragraph] 'my/fill-or-unfill)
;; (global-set-key (kbd "M-q") 'my/fill-or-unfill)

;;;; Unfill paragraph
;; Protesilaos's `prot-simple-unfill-region-or-paragraph'
(defun my/unfill-region-or-paragraph (&optional beg end)
  "Unfill paragraph or, when active, the region.
Join all lines in region delimited by BEG and END, if active, while
respecting any empty lines (so multiple paragraphs are not joined, just
unfilled).  If no region is active, operate on the paragraph.  The idea
is to produce the opposite effect of both `fill-paragraph' and
`fill-region'."
  (interactive "r")
  (let ((fill-column most-positive-fixnum))
    (if (use-region-p)
        (fill-region beg end)
      (fill-paragraph))))
;; (bind-key "M-Q" #'my/unfill-region-or-paragraph)

;;; Better Fill and Unfill Paragraph
;; Toggle paragraph filling/unfilling with optional custom width.
(defun my/toggle-paragraph-fill (arg)
  "Fill or unfill paragraph/region with customizable column width.
  With numeric ARG (e.g., C-u 80), set fill column width explicitly.
  When called twice consecutively without prefix, unfills the paragraph.
  In Org mode, uses `org-fill-paragraph` for specialized formatting."
  (interactive "P")
  (let ((fill-column (cond
                      (arg
                       (prefix-numeric-value arg))
                      ((eq last-command 'my/toggle-paragraph-fill)
                       (setq this-command nil)
                       (point-max))
                      (t
                       fill-column))))
    (if (derived-mode-p 'org-mode)
        (org-fill-paragraph)
      (fill-paragraph))))

;; M-q.
(global-set-key [remap fill-paragraph] #'my/toggle-paragraph-fill)
(with-eval-after-load 'org
  (define-key org-mode-map (kbd "M-q") #'my/toggle-paragraph-fill))


;;; Better Comment Box
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; example:                                                                ;;
;; from http://irreal.org/blog/?p=374                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun my/comment-box (b e)
  "Draw a box comment around the region but arrange for the region to extend to at least the fill column. Place the point after the comment box."

  (interactive "r")

  (let ((e (copy-marker e t)))
    (goto-char b)
    (end-of-line)
    (insert-char ?  (- fill-column (current-column)))
    (comment-box b e 1)
    (goto-char e)
    (set-marker e nil)))
(global-set-key (kbd "C-c e b") 'my/comment-box)

;;; Toggle Dark and Bright Theme
(defvar my-toggle-dark-bright-theme-status nil
  "Toggle between dark emacs theme and bright emacs theme; nil means initial switch to dark theme, t means initial switch to bright theme")

(defun my-toggle-dark-bright-theme ()
  "Toggle between dark emacs theme and bright emacs theme"
  (interactive)
  (cond (my-toggle-dark-bright-theme-status
         (message "Loading bright theme")
         (disable-theme 'doom-nord)
         (load-theme 'modus-operandi-deuteranopia t)
         (setq my-toggle-dark-bright-theme-status nil)
         )
        (t
         (message "Loading dark theme")
         (disable-theme 'modus-operandi-deuteranopia)
         (load-theme 'doom-nord t) ;; dark theme
         (setq my-toggle-dark-bright-theme-status t)
         )
        )
  )

(global-set-key [(shift f12)] 'my-toggle-dark-bright-theme)

;;; Indent Whole Buffer
(defun my/indent-whole-buffer ()
  "Indent the entire buffer without affecting point or mark."
  (interactive)
  (save-excursion
    (save-restriction
      (indent-region (point-min) (point-max)))))

(global-set-key (kbd "C-c TAB") 'my/indent-whole-buffer)

;;; Minibuffer and Mouse
(defun abort-minibuffer-using-mouse ()
  "Abort the minibuffer when using the mouse."
  (when (and (>= (recursion-depth) 1) (active-minibuffer-window))
    (abort-recursive-edit)))

(add-hook 'mouse-leave-buffer-hook 'abort-minibuffer-using-mouse)

;; keep the point out of the minibuffer
(setq-default minibuffer-prompt-properties '(read-only t point-entered minibuffer-avoid-prompt face minibuffer-prompt))

;;; Delete Word Backward
;; (defun my/delete-backward-word (arg)
;;   "Like `backward-kill-word', but doesn't affect the kill-ring."
;;   (interactive "p")
;;   (let (kill-ring)
;;     (backward-kill-word arg)))
(defun backward-kill-word-or-region (&optional arg)
  "Kill word backward if region is inactive; else kill region"
  (interactive "p")
  (if (region-active-p)
      (kill-region (region-beginning) (region-end))
    (if (looking-back "^[ \t]+" (line-beginning-position))
        (delete-region (line-beginning-position) (point))
      (backward-kill-word arg))))

(global-set-key (kbd "C-w") 'backward-kill-word-or-region)

;;; Replace text in buffer
(defun my/replace-in-buffer ()
  (interactive)
  (save-excursion
    (if (equal mark-active nil) (mark-word))
    (setq curr-word (buffer-substring-no-properties (mark) (point)))
    (setq old-string (read-string "OLD string:\n" curr-word))
    (setq new-string (read-string "NEW string:\n" old-string))
    (query-replace old-string new-string nil (point-min) (point-max))
    )
  )

(global-set-key (kbd "C-c s w") 'replace-in-buffer)

;;; Multiple Search and Replace
(defun my/batch-replace-strings (replacement-alist)
  "Prompt user for pairs of strings to search/replace, then do so in the current buffer"
  (interactive (list (batch-replace-strings-prompt)))
  (dolist (pair replacement-alist)
    (save-excursion
      (replace-string (car pair) (cdr pair) nil (region-beginning) (region-end)))))

(defun batch-replace-strings-prompt ()
  "prompt for string pairs and return as an association list"
  (let (from-string
        ret-alist)
    (while (not (string-equal "" (setq from-string (read-string "String to search (RET to stop): "))))
      (setq ret-alist
            (cons (cons from-string (read-string (format "Replace %s with: " from-string)))
                  ret-alist)))
    ret-alist))

(global-set-key (kbd "C-c s r") 'my/batch-replace-strings)

;;; Open File in Sudo
(defun my/simple-sudo ()
  "Find the current file or directory using `sudo'."
  (interactive)
  (let ((destination (or buffer-file-name default-directory))
        (auto-save-default nil))
    (if (string= (file-remote-p destination 'method) "sudo")
        (user-error "Already using `sudo'")
      (find-file (format "/sudo::/%s" destination)))))

;;;; Sudo Edit
;; The simplest solution is C-x C-f /sudo:user@localhost:/etc/motd RET
(defun sudo-edit (&optional arg)
  "Edit currently visited file as root.
With a prefix ARG prompt for a file to visit.
Will also prompt for a file to visit if current
buffer is not visiting a file."
  (interactive "P")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:"
                         (ido-read-file-name "Find file(as root): ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

;;; Sudo save
;; If the current buffer is not writable, ask if it should be saved with sudo.
(defun my/sudo-file-name (filename)
  "Prepend '/sudo:root@`system-name`:' to FILENAME if appropriate.
This is, when it doesn't already have a sudo-prefix."
  (if (not (or (string-prefix-p "/sudo:root@localhost:"
                                filename)
               (string-prefix-p (format "/sudo:root@%s:" system-name)
                                filename)))
      (format "/sudo:root@%s:%s" system-name filename)
    filename))

(defun my/sudo-save-buffer ()
  "Save FILENAME with sudo if the user approves."
  (interactive)
  (when buffer-file-name
    (let ((file (ph/sudo-file-name buffer-file-name)))
      (if (yes-or-no-p (format "Save file as %s ? " file))
          (write-file file)))))

(advice-add 'save-buffer :around
            '(lambda (fn &rest args)
               (when (or (not (buffer-file-name))
                         (not (buffer-modified-p))
                         (file-writable-p (buffer-file-name))
                         (not (ph/sudo-save-buffer)))
                 (call-interactively fn args))))

;;;; Sudo Notify File When It Requires It

(defun my/sudo-edit-notify ()
  "Notify myself when edit a file owned by root.
This should be add to `find-file-hook'."
  (let ((old-msg (current-message)))
    (when (and old-msg
               (string= old-msg "Note: file is write protected")
               ;; `chunyang-sudo-edit' doesn't work for remote files
               ;; for now
               (not (file-remote-p (buffer-file-name))))
      (message "%s, %s"
               old-msg
               "use M-x sudo-edit RET to edit via sudo"))))
(add-hook 'find-file-hook #'my/sudo-edit-notify)

;;; Dictionary Lookup
(defun my/lookup-word (word)
  (interactive (list (thing-at-point 'word)))
  (browse-url (format "http://en.wiktionary.org/wiki/%s" word)))

(global-set-key (kbd "M-#") 'lookup-word)

;;; Delete backward from Point
(defun my/backward-kill-line (arg)
  "Kill ARG lines backward, but does not put it in the `kill-ring'."
  (interactive "p")
  (kill-line (- 1 arg))
  (setq kill-ring (cdr kill-ring)))
;; (global-set-key (kbd "C-<backspace>") 'my/backward-kill-line)

;;; Backward Delete
(defun my/delete-dont-kill (arg)
  "Delete characters backward until encountering the beginning of a word.
   With argument ARG, do this that many times. Don't add to kill ring."
  (interactive "p")
  (delete-region (point) (progn (backward-word arg) (point))))

(defun my/backward-delete ()
  "Delete a word, a character, or whitespace."
  (interactive)
  (cond
   ;; If you see a word, delete all of it
   ((looking-back (rx (char word)) 1)
    (my/delete-dont-kill 1))
   ;; If you see a single whitespace and a word, delete both together
   ((looking-back (rx (seq (char word) (= 1 blank))) 1)
    (my/delete-dont-kill 1))
   ;; If you see several whitespaces, delete them until the next word
   ((looking-back (rx (char blank)) 1)
    (delete-horizontal-space t))
   ;; If you see a single non-word character, delete that
   (t
    (backward-delete-char-untabify 1))))
(global-set-key (kbd "C-<backspace>") 'my/backward-delete)


;;; Delete Empty Lines Around a Point
(defun my/spacing-delete-newlines ()
  "Removes whitespace before and after the point."
  (interactive)
  (if (version< emacs-version "24.4")
      (just-one-space -1)
    (cycle-spacing -1)))
(define-key ef-file-keymap (kbd "x") 'my/spacing-delete-newlines)

;;; Search Backward and Forward for Word Under Cursor
;;;; From https://github.com/larstvei/dot-emacs
(defun my/jump-to-symbol-internal (&optional backwardp)
  "Jumps to the next symbol near the point if such a symbol
exists. If BACKWARDP is non-nil it jumps backward."
  (let* ((point (point))
         (bounds (find-tag-default-bounds))
         (beg (car bounds)) (end (cdr bounds))
         (str (isearch-symbol-regexp (find-tag-default)))
         (search (if backwardp 'search-backward-regexp
                   'search-forward-regexp)))
    (goto-char (if backwardp beg end))
    (funcall search str nil t)
    (cond ((<= beg (point) end) (goto-char point))
          (backwardp (forward-char (- point beg)))
          (t  (backward-char (- end point))))))

(defun my/jump-to-previous-like-this ()
  "Jumps to the previous occurrence of the symbol at point."
  (interactive)
  (my/jump-to-symbol-internal t))

(defun my/jump-to-next-like-this ()
  "Jumps to the next occurrence of the symbol at point."
  (interactive)
  (my/jump-to-symbol-internal))

(define-key ef-file-keymap (kbd ",") 'my/jump-to-previous-like-this)

(define-key ef-file-keymap (kbd ".") 'my/jump-to-next-like-this)

;;; Insert Random Strings and Password
(defun random-string (chars len)
  "Return a string of LEN random characters from CHARS."
  (apply #'string (make-list* len #'seq-random-elt chars)))

(defun make-list* (n fun &rest args)
  "Call FUN with ARGS N times and return a list of the results."
  (let ((res '()))
    (dotimes (_ n)
      (push (apply fun args) res))
    res))

(defun insert-random-password (len)
  "Insert a password-friendly random string of length LEN."
  (interactive "NLength: ")
  (insert
   (random-string
    "!#%+23456789:=?@ABCDEFGHJKLMNPRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
    len)))

(defun insert-random-string (len)
  "Insert a random alphanumeric ASCII-string of length LEN."
  (interactive "NLength: ")
  (insert
   (random-string
    (append (number-sequence ?0 ?9)
            (number-sequence ?a ?z)
            (number-sequence ?A ?Z))
    len)))

;;; Generate Password
(defun my/generate-password-non-interactive ()
  (string-trim (shell-command-to-string "pwgen -A 24")))

(defun my/generate-password ()
  "Generates and inserts a new password"
  (interactive)
  (insert
   (shell-command-to-string
    (concat "pwgen -A " (read-string "Length: " "24") " 1"))))


;;; Create New Frame
;; M-n for new frame (M-n is unbound in vanilla emacs)
(defun my/new-frame ()
  (interactive)
  (select-frame (make-frame))
  (switch-to-buffer "*scratch*"))
(global-set-key (kbd "M-n") 'my/new-frame)
(global-set-key (kbd "M-`") 'other-frame)

;;; TRY Delete
;; (defun kill-region-or-backward-delete-sexp (&optional arg region)
;;   "Kill region if active, else backward delete sexp."
;;   (interactive
;;    (list (prefix-numeric-value current-prefix-arg) (use-region-p)))
;;   (if region
;;       (kill-region (region-beginning) (region-end) t)
;;     (let ((end (point)))
;;       (save-excursion
;;         (backward-sexp)
;;         (delete-region (point) end)))))
;;
;;
;; (defun kill-region-or-backward-kill-sexp (&optional arg region)
;;   "`kill-region' if the region is active, otherwise
;; `backward-kill-sexp'"
;;   (interactive
;;    (list (prefix-numeric-value current-prefix-arg) (use-region-p)))
;;   (if region
;;       (kill-region (region-beginning) (region-end) t)
;;     (backward-kill-sexp arg)))

;;; Sort Symbols
(defun sort-symbols (reverse beg end)
  "Sort symbols in region alphabetically, in REVERSE if negative.
See `sort-symbols'."
  (interactive "*P\nr")
  (sort-regexp-fields reverse "\\(\\sw\\|\\s_\\)+" "\\&" beg end))

;;; Sort Words Alphabetically
(defun sort-words (reverse beg end)
  "Sort words in region alphabetically, in REVERSE if negative.
Prefixed with negative \\[universal-argument], sorts in reverse.

The variable `sort-fold-case' determines whether alphabetic case
affects the sort order.

See `sort-regexp-fields'."
  (interactive "*P\nr")
  (sort-regexp-fields reverse "\\w+" "\\&" beg end))

;;; Window Related
;;;; Toggle Window Split
(defun my/toggle-window-split ()
  (interactive)
  "Toggles the window split between horizontal and vertical when
the fram has exactly two windows."
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
             (next-win-buffer (window-buffer (next-window)))
             (this-win-edges (window-edges (selected-window)))
             (next-win-edges (window-edges (next-window)))
             (this-win-2nd (not (and (<= (car this-win-edges)
                                         (car next-win-edges))
                                     (<= (cadr this-win-edges)
                                         (cadr next-win-edges)))))
             (splitter
              (if (= (car this-win-edges)
                     (car (window-edges (next-window))))
                  'split-window-horizontally
                'split-window-vertically)))
        (delete-other-windows)
        (let ((first-win (selected-window)))
          (funcall splitter)
          (if this-win-2nd (other-window 1))
          (set-window-buffer (selected-window) this-win-buffer)
          (set-window-buffer (next-window) next-win-buffer)
          (select-window first-win)
          (if this-win-2nd (other-window 1))))))
(global-set-key (kbd "C-x -") 'my/toggle-window-split)

;;; Erase the Contents of a buffer
(defun my/safe-erase-buffer (&optional prefix)
  "prompts to really erase and then erases the current buffer"
  (interactive "P")
  (barf-if-buffer-read-only)
  (when (or prefix
            (y-or-n-p (concat "Erase content of buffer "
                              (buffer-name)
                              " ?")))
    (erase-buffer)))

;;; Lists faces at point
;;;; Good for testing faces
(defun my/list-faces (&optional point)
  (interactive "d")
  (or point (setq point (point)))
  (let ((faces (remq nil
                     `(,(get-char-property point 'read-face-name)
                       ,(get-char-property point 'face)
                       ,(plist-get (text-properties-at point) 'face)))))
    (and (called-interactively-p 'any) (message (format "%s" faces)))
    faces))

;;; Toggle Relative Line Numbers
(defun my/toggle-relative-linum (&optional arg)
  "toggle relative line numbers in the current buffer
when ARG is given and is 0, then relative line numbers are disabled,
otherwise if ARG is greater than 0 then they're enabled and if ARG is
nil then relative line-numbers are toggled."
  (interactive "P")
  (setq display-line-numbers
        (cond
         ((and arg (zerop (prefix-numeric-value arg)))
          t)
         (arg 'relative)
         (t
          (if (eq display-line-numbers 'relative) t 'relative)))))


;;; Better Toggle line numbers
(defun my/toggle-line-numbers ()
  "Toggle line numbers.

Cycles through regular, relative and no line numbers. The order depends on what
`display-line-numbers-type' is set to. If you're using Emacs 26+, and
visual-line-mode is on, this skips relative and uses visual instead.

See `display-line-numbers' for what these values mean."
  (interactive)
  (defvar doom--line-number-style display-line-numbers-type)
  (let* ((styles `(t ,(if visual-line-mode 'visual 'relative) nil))
         (order (cons display-line-numbers-type (remq display-line-numbers-type styles)))
         (queue (memq doom--line-number-style order))
         (next (if (= (length queue) 1)
                   (car order)
                 (car (cdr queue)))))
    (setq doom--line-number-style next)
    (setq display-line-numbers next)
    (message "Switched to %s line numbers"
             (pcase next
               (`t "normal")
               (`nil "disabled")
               (_ (symbol-name next))))))



;;; Delete to the end of the buffer
(defun my/delete-to-end-of-buffer ()
  (interactive)
  (kill-region (point) (point-max)))

;;; View Clipboard
(defun my/view-clipboard ()
  (interactive)
  (delete-other-windows)
  (switch-to-buffer "*Clipboard*")
  (let ((inhibit-read-only t))
    (erase-buffer)
    (clipboard-yank)
    (goto-char (point-min))))

;;; Kill All Buffers Except Current Buffer
(defun my/kill-all-but-current-buffer ()
  "Kill all other buffers, but not current buffer."
  (interactive)
  (mapc 'kill-buffer (cdr (buffer-list (current-buffer))))
  "All other buffers have been killed!")

;;; Kill Dired Buffers
(defun my/kill-dired-buffers ()
  "Kill all open dired buffers."
  (interactive)
  (mapc (lambda (buffer)
          (when (eq 'dired-mode (buffer-local-value 'major-mode buffer))
            (kill-buffer buffer)))
        (buffer-list)))

;;; Advice to `kill-region'
;; With this it can either kill region or line
;; (defadvice kill-region (before slick-cut activate compile)
;;   "When called interactively with no active region, kill a single line instead."
;;   (interactive
;;    (if mark-active (list (region-beginning) (region-end))
;;      (list (line-beginning-position)
;;            (line-beginning-position 2)))))
(defun my/better-cut-region (orig-fn beg end &rest args)
  "Cut the selected region or the current line if no region is active and
called interactively."
  (interactive (if (use-region-p)
                   (list (region-beginning) (region-end))
                 (list (line-beginning-position) (line-beginning-position 2))))
  (if (called-interactively-p 'any)
      (let ((region-active (and (mark t) (use-region-p))))
        (if region-active
            ;; Region is active and mark is set, use the region bounds.
            (apply orig-fn (region-beginning) (region-end) args)
          ;; No active region or mark not set, cut the current line.
          (progn
            (message "[Cut the current line]")
            (apply orig-fn (line-beginning-position) (line-beginning-position 2) args))))
    ;; If not called interactively, pass the original arguments unchanged.
    (apply orig-fn beg end args)))

(advice-add 'kill-region :around #'my/better-cut-region)

;;; Advice for copy region
;; Function to perform slick copy for the kill-ring-save command.
(defun my/better-copy-region (orig-fn beg end &rest args)
  "Copy the selected region or the current line if no region is active and
called interactively."
  (interactive (if (use-region-p)
                   (list (region-beginning) (region-end))
                 (list (line-beginning-position) (line-beginning-position 2))))
  (if (called-interactively-p 'any)
      (let ((region-active (and (mark t) (use-region-p))))
        (if region-active
            ;; Region is active and mark is set, use the region bounds.
            (apply orig-fn (region-beginning) (region-end) args)
          ;; No active region or mark not set, copy the current line.
          (progn
            (message "[Copied the current line]")
            (apply orig-fn (line-beginning-position) (line-beginning-position 2) args))))
    ;; If not called interactively, pass the original arguments unchanged.
    (apply orig-fn beg end args)))

(advice-add 'kill-ring-save :around #'my/better-copy-region)


;;; Check for Agenda
(defun my/org-check-agenda ()
  "Peek at agenda."
  (interactive)
  (cond
   ((derived-mode-p 'org-agenda-mode)
    (if (window-parent) (delete-window) (bury-buffer)))
   ((get-buffer "*Org Agenda*")
    (switch-to-buffer-other-window "*Org Agenda*"))
   (t (org-agenda nil "a"))))

;;; Better move to the beginning of the line
(defun my/smarter-move-beginning-of-line (arg)
  "Move point back to indentation of beginning of line.

      Move point to the first non-whitespace character on this line.
      If point is already there, move to the beginning of the line.
      Effectively toggle between the first non-whitespace character and
      the beginning of the line.

      If ARG is not nil or 1, move forward ARG - 1 lines first.  If
      point reaches the beginning or end of the buffer, stop there."
  (interactive "^p")
  (setq arg (or arg 1))

  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))

  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))

;; remap C-a to `smarter-move-beginning-of-line'
(global-set-key [remap move-beginning-of-line]
                'my/smarter-move-beginning-of-line)

;;; Copy File Name to Clipboard
(defun my/copy-file-name-to-clipboard ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (kill-new filename)
      (message "Copied buffer file name '%s' to the clipboard." filename))))

;;; Redact and Unredact Region
(defun my/redact (s)
  "Replace S with x characters."
  (make-string (length s) ?x))

(defun my/redact-region (beg end &optional func)
  "Redact from BEG to END."
  (interactive "r")
  (let ((overlay (make-overlay beg end)))
    (overlay-put overlay 'redact t)
    (overlay-put overlay 'display
                 (cond
                  ((functionp func)
                   (funcall func))
                  ((stringp func)
                   func)
                  (t (make-string (- end beg) ?x))))))

(defun my/unredact ()
  (interactive)
  (mapc 'delete-overlay
        (seq-filter (lambda (overlay) (overlay-get overlay 'redact))
                    (overlays-in (point-min) (point-max)))))

;;; Screeshot
(defvar my-picture-dir "Pictures/")
(defun my/screenshot ()
  "Save a screenshot of the current frame as an SVG image.
Saves to a temp file and puts the filename in the kill ring."
  (interactive)
  (let* ((filename
          (expand-file-name
           (format-time-string "%Y-%m-%d-%H-%M-%S.svg")
           my-picture-dir))
         (data (x-export-frames nil 'png)))
    (with-temp-file filename
      (insert data))
    (kill-new filename)
    (message filename)))
(keymap-global-set "C-c C-s" #'my/screenshot)

;;; Cycle through different paragraph formats
(defvar my-repeat-counter '()
  "How often `my-repeat-next' was called in a row using the same command.
This is an alist of (cat count list) so we can use it for different functions.")

(defun my-unfill-paragraph ()
  "Replace newline chars in current paragraph by single spaces.
This command does the inverse of `fill-paragraph'."
  (interactive)
  (let ((fill-column most-positive-fixnum))
    (fill-paragraph)))

(defun my-fill-paragraph-semlf-long ()
  (interactive)
  (let ((fill-column most-positive-fixnum))
    (fill-paragraph-semlf)))

(defun my-repeat-next (category &optional element-list reset)
  "Return the next element for CATEGORY.
Initialize with ELEMENT-LIST if this is the first time."
  (let* ((counter
          (or (assoc category my-repeat-counter)
              (progn
                (push (list category -1 element-list)
                      my-repeat-counter)
                (assoc category my-repeat-counter)))))
    (setf (elt (cdr counter) 0)
          (mod
           (if reset 0 (1+ (elt (cdr counter) 0)))
           (length (elt (cdr counter) 1))))
    (elt (elt (cdr counter) 1) (elt (cdr counter) 0))))

(defun my-in-prefixed-comment-p ()
  (or (member 'font-lock-comment-delimiter-face (face-at-point nil t))
      (member 'font-lock-comment-face (face-at-point nil t))
      (save-excursion
        (beginning-of-line)
        (comment-search-forward (line-end-position) t))))

;; It might be nice to figure out what state we're
;; in and then cycle to the next one if we're just
;; working with a single paragraph. In the
;; meantime, just going by repeats is fine.
(defun my-reformat-paragraph-or-region ()
  "Cycles the paragraph between three states: filled/unfilled/fill-sentences.
If a region is selected, handle all paragraphs within that region."
  (interactive)
  (let ((func (my-repeat-next 'my-reformat-paragraph
                              '(fill-paragraph my-unfill-paragraph fill-paragraph-semlf
                                               my-fill-paragraph-semlf-long)
                              (not (eq this-command last-command))))
        (deactivate-mark nil))
    (if (region-active-p)
        (save-restriction
          (save-excursion
            (narrow-to-region (region-beginning) (region-end))
            (goto-char (point-min))
            (while (not (eobp))
              (skip-syntax-forward " ")
              (let ((elem (and (derived-mode-p 'org-mode)
                               (org-element-context))))
                (cond
                 ((eq (org-element-type elem) 'headline)
                  (org-forward-paragraph))
                 ((member (org-element-type elem)
                          '(src-block export-block headline property-drawer))
                  (goto-char
                   (org-element-end (org-element-context))))
                 (t
                  (funcall func)
                  (if fill-forward-paragraph-function
                      (funcall fill-forward-paragraph-function)
                    (forward-paragraph)))))
              )))
      (funcall func))))

(keymap-global-set "M-q" #'my-reformat-paragraph-or-region)

;;; Copy Line or Region

(defun my/copy-line-or-region ()
  (interactive)
  (cond
   (current-prefix-arg (copy-region-as-kill (point-min) (point-max)))
   ((and (boundp 'rectangle-mark-mode) rectangle-mark-mode)
    (copy-region-as-kill (region-beginning) (region-end) t))
   ((region-active-p) (copy-region-as-kill (region-beginning) (region-end)))
   ((eq last-command this-command)
    (if (eobp)
        nil
      (progn
        (kill-append "\n" nil)
        (kill-append (buffer-substring (line-beginning-position) (line-end-position)) nil)
        (end-of-line)
        (forward-char))))
   ((eobp)
    (if (eq (char-before) 10)
        (progn)
      (progn
        (copy-region-as-kill (line-beginning-position) (line-end-position))
        (end-of-line))))
   (t
    (copy-region-as-kill (line-beginning-position) (line-end-position))
    (end-of-line)
    (forward-char))))

;;; Cut Line or Region
(defun my/cut-line-or-region ()
  (interactive)
  (if current-prefix-arg
      (progn ; not using kill-region because we don't want to include previous kill
        (kill-new (buffer-string))
        (delete-region (point-min) (point-max)))
    (progn (if (region-active-p)
               (kill-region (region-beginning) (region-end) t)
             (kill-region (line-beginning-position) (line-beginning-position 2))))))

;;; Copy Region or Buffer

(defun my/copy-all-or-region ()
  (interactive)
  (if (region-active-p)
      (progn
        (kill-new (buffer-substring (region-beginning) (region-end)))
        (message "Text selection copied."))
    (progn
      (kill-new (buffer-string))
      (message "Buffer content copied."))))

;;; Cut Region or Buffer
(defun my/cut-all-or-region ()
  (interactive)
  (if (region-active-p)
      (progn
        (kill-new (buffer-substring (region-beginning) (region-end)))
        (delete-region (region-beginning) (region-end)))
    (progn
      (kill-new (buffer-string))
      (delete-region (point-min) (point-max))
      (message "buffer text cut"))))

;;; Paste Recursively
(defun my/paste-or-paste-previous ()
  "Paste. When called repeatedly, paste previous.
This command calls `yank', and if repeated, call `yank-pop'.
If `universal-argument' is called first with a number arg, paste that many times.
"
  (interactive)
  (progn
    (when (and delete-selection-mode (region-active-p))
      (delete-region (region-beginning) (region-end)))
    (if current-prefix-arg
        (progn
          (dotimes (_ (prefix-numeric-value current-prefix-arg))
            (yank)))
      (if (eq real-last-command this-command)
          (yank-pop 1)
        (yank)))))

;;; Cycle through cases
(defun my/cycle-cases ()
  "Toggle the letter case of current word or selection.
Always cycle in this order: Init Caps, ALL CAPS, all lower."
  (interactive)
  (let ((deactivate-mark nil) xbeg xend)
    (if (region-active-p)
        (setq xbeg (region-beginning) xend (region-end))
      (save-excursion
        (skip-chars-backward "[:alnum:]")
        (setq xbeg (point))
        (skip-chars-forward "[:alnum:]")
        (setq xend (point))))
    (when (not (eq last-command this-command))
      (put this-command 'state 0))
    (cond
     ((equal 0 (get this-command 'state))
      (upcase-initials-region xbeg xend)
      (put this-command 'state 1))
     ((equal 1 (get this-command 'state))
      (upcase-region xbeg xend)
      (put this-command 'state 2))
     ((equal 2 (get this-command 'state))
      (downcase-region xbeg xend)
      (put this-command 'state 0)))))

;;; Delete Current Text Block
(defun mydelete-current-text-block ()
  "Delete the current text block plus blank lines, or selection, and copy to `kill-ring'.
If cursor is between blank lines, delete following blank lines."
  (interactive)
  (let (xbeg xend (xp (point)))
    (if (region-active-p)
        (setq xbeg (region-beginning) xend (region-end))
      (progn
        (setq xbeg
              (if (re-search-backward "\n[ \t]*\n+" nil 1)
                  (match-end 0)
                (point)))
        (goto-char xp)
        (setq xend (if (re-search-forward "\n[ \t]*\n+" nil 1)
                       (match-end 0)
                     (point-max)))))
    (kill-region xbeg xend)))

;;; Clean Empty Lines
(defun my/clean-empty-lines ()
  "Replace repeated blank lines to just 1, in whole buffer or selection.
Respects `narrow-to-region'."
  (interactive)
  (let (xbegin xend)
    (if (region-active-p)
        (setq xbegin (region-beginning) xend (region-end))
      (setq xbegin (point-min) xend (point-max)))
    (save-excursion
      (save-restriction
        (narrow-to-region xbegin xend)
        (progn
          (goto-char (point-min))
          (while (re-search-forward "\n\n\n+" nil 1)
            (replace-match "\n\n")))))))

;;; Clean Whitespaces
(defun my/clean-whitespace (&optional Begin End)
  "Delete trailing whitespace, and replace repeated blank lines to just 1.
Only space and tab is considered whitespace here.
Works on whole buffer or selection, respects `narrow-to-region'.
"
  (interactive)
  (let (xbeg xend)
    (seq-setq (xbeg xend)
              (if (and Begin End)
                  (list Begin End)
                (if (region-active-p)
                    (list (region-beginning) (region-end))
                  (list (point-min) (point-max)))))

    (save-excursion
      (save-restriction
        (narrow-to-region xbeg xend)
        (progn
          (goto-char (point-min))
          (while (re-search-forward "[ \t]+\n" nil t) (replace-match "\n")))
        (progn
          (goto-char (point-min))
          (while (re-search-forward "\n\n\n+" nil t) (replace-match "\n\n")))
        (progn
          (goto-char (point-max))
          (while (eq (char-before) 32) (delete-char -1))))))
  (message "done xah-clean-whitespace"))

;;; Search Current Word
(defun my/search-current-word ()
  "Call `isearch' on current word or selection.
“word” here is A to Z, a to z, and hyphen [-] and lowline [_], independent of syntax table.
"
  (interactive)
  (let (xbeg xend)
    (if (region-active-p)
        (setq xbeg (region-beginning) xend (region-end))
      (save-excursion
        (skip-chars-backward "-_A-Za-z0-9")
        (setq xbeg (point))
        (right-char)
        (skip-chars-forward "-_A-Za-z0-9")
        (setq xend (point))))
    (deactivate-mark)
    (when (< xbeg (point)) (goto-char xbeg))
    (isearch-mode t)
    (isearch-yank-string (buffer-substring-no-properties xbeg xend))))


;;; Better C-g
(defun my/cancel ()
  "Cancle selection or call `minibuffer-keyboard-quit' and `keyboard-quit'.
This command is intended to replace key C-g , but not always work. Sometimes you still need to press C-g to cancel or abort or exit some commands.
"
  (interactive)
  (if (minibufferp (current-buffer))
      (progn (minibuffer-keyboard-quit))
    (if (region-active-p)
        (progn (deactivate-mark))
      (progn (keyboard-quit)))))

(define-key ef-functions-keymap (kbd "c") 'my/cancel)
;;; Display Keymappings For the Current Buffer
(defun my/locate-key-binding (key)
  "Determine in which keymap KEY is defined."
  (interactive "kPress key: ")
  (let ((ret (list (key-binding-at-point key)
                   (minor-mode-key-binding key)
                   (local-key-binding key)
                   (global-key-binding key))))
    (when (called-interactively-p 'any)
      (message "At Point: %s\nMinor-mode: %s\nLocal: %s\nGlobal: %s"
               (or (nth 0 ret) "")
               (or (mapconcat (lambda (x) (format "%s: %s" (car x) (cdr x)))
                              (nth 1 ret) "\n             ")
                   "")
               (or (nth 2 ret) "")
               (or (nth 3 ret) "")))
    ret))

(defun key-binding-at-point (key)
  (mapcar (lambda (keymap) (lookup-key keymap key))
          (cl-remove-if-not #'keymapp
                            (append (mapcar (lambda (overlay)
                                              (overlay-get overlay 'keymap))
                                            (overlays-at (point)))
                                    (get-text-property (point) 'keymap)
                                    (get-text-property (point) 'local-map)))))


;;; Save and Kill Buffer
(defun my/save-and-kill-buffer ()
  (interactive)
  (progn
    (save-buffer)
    (kill-current-buffer)))

;;; Save and Delete Window
(defun my/save-and-delete-window ()
  (interactive)
  (progn
    (save-buffer)
    (delete-window)))


;;; Server Restart
(defun my/server-restart ()
  "Restart the Emacs server."
  (interactive)
  (server-force-delete)
  (while (server-running-p)
    (sleep-for 1))
  (server-start))

;;; Server Shutdown
(defun my/server-shutdown ()
  "Save buffers, Quit, and Shutdown (kill) server"
  (interactive)
  (save-some-buffers)
  (kill-emacs))

;;; Describe at Point
(defun my/describe-at-point ()
  "Show help for the symbol at point."
  (interactive)
  (if-let* ((sym (symbol-at-point))
            (fn (cond ((and (fboundp sym) (boundp sym))
                       (if (= ?v (read-char-choice (format "Ambiguous `%s', describe [v]ariable or [c]allable? " sym) '(?v ?c)))
                           'describe-variable
                         'describe-function))
                      ((fboundp sym) 'describe-function)
                      ((boundp sym) 'describe-variable)
                      ((symbolp sym) 'describe-symbol))))
      (funcall fn sym)
    (user-error "There is no symbol at point")))

;;; Describe at point better
(defun my/describe-symbol-at-point ()
  "Like `describe-symbol' but doesn't query always."
  (interactive)
  (require 'help-mode)
  (describe-symbol
   (or (pcase (variable-at-point)
         (0 nil)
         (v v))
       (function-called-at-point)
       (let* ((is-symbol-p
               (lambda (vv)
                 (cl-some (lambda (x) (funcall (nth 1 x) vv))
                          describe-symbol-backends)))
              (sym
               (or (let ((it (intern (current-word))))
                     (when (funcall is-symbol-p it)
                       it))
                   (completing-read
                    "Describe symbol: "
                    obarray
                    is-symbol-p
                    t))))
         sym))))


;;; Open Default Config Folder For Emacs
(defun my/user-config (ask)
  "Open MinEmacs user configuration.

When ASK is non-nil (\\[universal-argument]), ask about which file to open."
  (interactive "P")
  (if ask
      (find-file (read-file-name "Select which file to open: " user-emacs-directory))
    (dired user-emacs-directory)))

;;; Font Increase, Decrease, Reset and Code View
(defvar my/default-font-height 110
  "The default font height to use.")

(defvar my/height-modifier 2
  "Default value to increment the size of font based on the screen size")

;; BUG:
(defun my/font-size-increase ()
  "Increase the font size by `my/height-modifier' amount."
  (interactive)
  (dolist (face '(default
                  mode-line
                  mode-line-inactive
                  minibuffer-prompt
                  variable-pitch))
    (set-face-attribute face nil :height (+ (face-attribute face :height)
                                            my/height-modifier))))

(defun my/font-size-decrease ()
  "Decreas the font size by `my/height-modifier' amount."
  (interactive)
  (dolist (face '(default
                  mode-line
                  mode-line-inactive
                  minibuffer-prompt
                  variable-pitch))
    (set-face-attribute face nil :height (- (face-attribute face :height)
                                            my/height-modifier))))

(defun my/font-size-reset ()
  "Go back to the default font size and `line-spacing'"
  (interactive)
  (dolist (face '(default
                  mode-line
                  mode-line-inactive
                  minibuffer-prompt
                  variable-pitch))
    (set-face-attribute face nil :height my/default-font-height))
  (text-scale-adjust 0)
  (when (fboundp 'minimap-mode)
    (condition-case err
        (minimap-mode 0)
      ('error 0)))
  (setq line-spacing 0))

(defun my/code-reading-mode ()
  "Do a bunch of fancy stuff to make reading/browsing code
easier. When you're done, `my/font-size-decrease' is a great way
to go back to a normal setup."
  (interactive)
  (delete-other-windows)
  (text-scale-increase 1)
  (setq line-spacing 5)
  (use-package minimap :ensure t)
  (when (not minimap-mode)
    (minimap-mode 1)))


;;; Jump between functions
(defun my/previous-function ()
  (interactive)
  (beginning-of-defun))

(defun my/next-function ()
  (interactive)
  (beginning-of-defun -1))


;;; First Attempt: Delete the Content of a Buffer

(defun my/empty-buffer ()
  "Kill the content of a buffer"
  (interactive)
  (kill-region (point-min) (point-max))
  )





;;; Describe modes in the current buffer
(defun my/active-minor-modes ()
  "Return a list of active minor-mode symbols."
  (cl-loop for mode in minor-mode-list
           if (and (boundp mode) (symbol-value mode))
           collect mode))
(defun my/describe-active-minor-mode (mode)
  "Get information on an active minor mode. Use `describe-minor-mode' for a
selection of all minor-modes, active or not."
  (interactive
   (list (completing-read "Describe active mode: " (my/active-minor-modes))))
  (let ((symbol
         (cond ((stringp mode) (intern mode))
               ((symbolp mode) mode)
               ((error "Expected a symbol/string, got a %s" (type-of mode)))))
        (fn (if (fboundp symbol) #'describe-function #'describe-variable)))
    (funcall (or (command-remapping fn) fn)
             symbol)))


;;; Offer to create parent directories if they do not exist
(defun my/create-non-existent-directory ()
  "Automatically create missing directories when creating new files."
  (unless (file-remote-p buffer-file-name)
    (let ((parent-directory (file-name-directory buffer-file-name)))
      (and (not (file-directory-p parent-directory))
           (y-or-n-p (format "Directory `%s' does not exist! Create it?"
                             parent-directory))
           (progn (make-directory parent-directory 'parents)
                  t)
           )
      )))
(add-hook 'find-file-not-found-functions 'my/create-non-existent-directory)

;;; Make Directory
(defun my/make-directory-maybe ()
  "Create parent directory if not exists while visiting file."
  (let ((dir (file-name-directory buffer-file-name)))
    (unless (file-exists-p dir)
      (if (y-or-n-p (format "Directory %s does not exist,do you want you create it? " dir))
          (make-directory dir t)
        (keyboard-quit)))))

;;; Save All Buffers
(defun my/save-all-buffers ()
  "Silently save every buffer that is visiting a file.
If the file does not yet exist on disk, create it without
confirmation.  Non–file‑visiting buffers are ignored."
  (interactive)
  (let ((confirm-nonexistent-file-or-buffer nil)) ; suppress “create file?” prompt
    (dolist (buf (buffer-list))
      (with-current-buffer buf
        (when buffer-file-name
          (when (or (buffer-modified-p)
                    (not (file-exists-p buffer-file-name)))
            (save-buffer)))))))

;;; Function for using tab for autocompletion
(defun my/auto-complete-at-point ()
  (when (and (not (minibufferp))
             auto-complete-mode
             (looking-back "\\(\\sw\\|\\s_\\)")
             (not (looking-at "\\sw\\|\\s_")))
    (auto-complete)))

(defun my/set-auto-complete-as-completion-at-point-function ()
  (setq completion-at-point-functions
        (cons 'my/auto-complete-at-point
              (remove 'my/auto-complete-at-point completion-at-point-functions))))

(add-hook 'auto-complete-mode-hook 'my/set-auto-complete-as-completion-at-point-function)

;;; Enable `hs-minor-mode' in supported modes
;; Minor mode to selectively hide/show code and comment blocks.
(defun my/enable-hs ()
  (ignore-errors
    (hs-minor-mode)))

(add-hook 'prog-mode-hook 'my/enable-hs)

;;; Better Goto line
(defun my/goto-line-with-line-numbers ()
  "Go to a specific line while temporarily enabling line numbers.

  This function prompts the user to enter a line number to navigate to.
  It temporarily enables line numbers, moves the point to the specified line,
  and then restores the original state of line numbers after navigation."
  (interactive)
  (let ((line-numbers-enabled (display-line-numbers-mode))
        (line-number (read-number "Goto line: ")))
    (unwind-protect
        (progn
          (display-line-numbers-mode 1)
          (let ((line-count (count-lines (point-min) (point-max))))
            (if (or (< line-number 1) (> line-number line-count))
                (error "Line number must be between 1 and %d" line-count)
              (goto-char (point-min))
              (forward-line (1- line-number))
              (message "[Moved to line %d]" line-number))))
      (display-line-numbers-mode line-numbers-enabled))))

;; Remap goto-line.
(global-set-key [remap goto-line] #'my/goto-line-with-line-numbers)


;;; Describe minor modes available in a buffer
(defun my/active-minor-modes ()
  "Return a list of active minor-mode symbols."
  (cl-loop for mode in minor-mode-list
           if (and (boundp mode) (symbol-value mode))
           collect mode))


(defun my/describe-active-minor-mode (mode)
  "Get information on an active minor mode. Use `describe-minor-mode' for a
selection of all minor-modes, active or not."
  (interactive
   (list (completing-read "Describe active mode: " (my/active-minor-modes))))
  (let ((symbol
         (cond ((stringp mode) (intern mode))
               ((symbolp mode) mode)
               ((error "Expected a symbol/string, got a %s" (type-of mode)))))
        (fn (if (fboundp symbol) #'describe-function #'describe-variable)))
    (funcall (or (command-remapping fn) fn)
             symbol)))

;;; Auto save files when out of focus
(defun my/save-all-buffers ()
  "Save all buffers, because, why not?"
  (interactive)
  (save-some-buffers t))
;; See 'after-focus-change-function?
(add-hook 'focus-out-hook 'my/save-all-buffers)

;;; Recent Files
;;;; Open Recent Files
(defun my/open-recent-files ()
  (interactive)
  (let* ((all-files recentf-list)
         (tocpl (mapcar (function
                         (lambda (x) (cons (file-name-nondirectory x) x))) all-files))
         (prompt (append '("File name: ") tocpl))
         (fname (completing-read (car prompt) (cdr prompt) nil nil)))
    (find-file (cdr (assoc-string fname tocpl)))))

(global-set-key (kbd "C-c r") #'my/open-recent-files)



;;; Isearch word at point
(defun my/isearch-yank-word-hook ()
  (when (equal this-command 'my-isearch-word-at-point)
    (let ((string (concat "\\<"
                          (buffer-substring-no-properties
                           (progn (skip-syntax-backward "w_") (point))
                           (progn (skip-syntax-forward "w_") (point)))
                          "\\>")))
      (if (and isearch-case-fold-search
               (eq 'not-yanks search-upper-case))
          (setq string (downcase string)))
      (setq isearch-string string
            isearch-message
            (concat isearch-message
                    (mapconcat 'isearch-text-char-description
                               string ""))
            isearch-yank-flag t)
      (isearch-search-and-update))))

(add-hook 'isearch-mode-hook 'my/isearch-yank-word-hook)


;;; Occur inside isearch
;; Isearch Occur
(defun my/isearch-occur ()
  (interactive)
  (let ((case-fold-search isearch-case-fold-search))
    (occur
     (if isearch-regexp isearch-string (regexp-quote isearch-string)))))



;;; Replace Word
(defun my/replace-word (tosearch toreplace)
  (interactive "sSearch for word: \nsReplace with: ")
  (save-excursion
    (goto-char (point-min))
    (let ((case-fold-search nil)
          (count 0))
      (while (re-search-forward (concat "\\b" tosearch "\\b") nil t)
        (setq count (1+ count))
        (replace-match toreplace 'fixedcase 'literal))
      (message "Replaced %s match(es)" count))))

;;; Utilities
;; Show ASCII Table List
(defun my/ascii-table ()
  "Print the ascii table."
  (interactive)
  (switch-to-buffer "*ASCII*")
  (erase-buffer)
  (insert (format "ASCII characters up to number %d.\n" 254))
  (let* ((i 0))
    (while (< i 254)
      (setq i (+ i 1))
      (insert (format "%4d  %c\n " i i))))
  (goto-char (point-min)))

;;; Add numbering to a region
(defun my/number-region (beg end)
  "Add numbering to a highlighted region."
  (interactive "r")
  (let ((counter 1)
        (end-marker (copy-marker end)))
    (save-excursion
      (goto-char beg)
      (beginning-of-line)
      (while (< (point) end-marker)
        (insert (format "%d. " counter))
        (setq counter (1+ counter))
        (forward-line 1))
      (set-marker end-marker nil))))

;;; Insert Lorem Ipsum
(defun my/insert-lorem-ipsum ()
  "Insert a lorem ipsum."
  (interactive)
  (insert "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do "
          "eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim"
          "ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut "
          "aliquip ex ea commodo consequat. Duis aute irure dolor in "
          "reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla "
          "pariatur. Excepteur sint occaecat cupidatat non proident, sunt in "
          "culpa qui officia deserunt mollit anim id est laborum."))

;;; Better `timestamp' and datestamp
(defun my/insert-timestamp()
  "Insert the current time in yyyy-mm-dd format."
  (interactive "*")
  (if (eq major-mode 'org-mode)
      (progn
        (org-insert-time-stamp nil t nil)
        (insert " ")
        )
    (insert (format-time-string "%Y-%m-%d" (current-time)))
    )
  )

(defun my/insert-datestamp()
  "Insert the current date in yyyy-mm-dd format."
  (interactive "*")
  (if (eq major-mode 'org-mode)
      (progn
        (org-insert-time-stamp nil nil nil)
        (insert " ")
        )
    (insert (format-time-string "%Y-%m-%d" (current-time)))
    )
  )

;;; Better Switcher
(defun my/switch-to-thing ()
  "Using an unified interface to Switch to:
- a buffer,
- a recently visited file,
- a bookmark,
- a recently used dired directory,
- an eyebrowser slot

(disabled switching to themes)
"
  (interactive)
  (let* ((buffers (mapcar #'buffer-name (buffer-list)))
         (recent-files recentf-list)
         (bookmarks (bookmark-all-names))
         ;; (file-at-point (list (ffap-guesser)))
         ;;(themes (custom-available-themes))
         ;; (directories dired-recent-directories)
         ;; (eyebrowse (--map (eyebrowse-format-slot it) (eyebrowse--get 'window-configs)))
         (all-options (append
                       buffers
                       recent-files
                       bookmarks
                       ;; eyebrowse
                       ;; directories
                       ;; (mapcar (lambda (theme) (concat "Theme: " (symbol-name theme))) themes)
                       ))
         (selection (completing-read "Switch to: "
                                     (lambda (str pred action)
                                       (if (eq action 'metadata)
                                           '(metadata . ((category . file)))
                                         (complete-with-action action all-options str pred)))
                                     nil t nil 'file-name-history)))
    (message (concat "DEBUG: selection =" selection))
    (pcase selection
      ;; ((pred (lambda (sel) (member sel eyebrowse)))
      ;;  ;; may be a bit hacky but this trick converts the string selection that looks like "3:my config" to the number 3:
      ;;  (eyebrowse-switch-to-window-config (my-number-or-float selection)))
      ((pred (lambda (sel) (member sel buffers))) (switch-to-buffer selection))
      ((pred (lambda (sel) (member sel bookmarks))) (bookmark-jump selection))
      ;; ((pred (lambda (sel) (member sel directories))) (dired selection))
      ;;((pred (lambda (sel) (string-prefix-p "Theme: " sel)))
      ;; (load-theme (intern (substring selection (length "Theme: "))) t))
      (_ (find-file selection)))))

(global-set-key (kbd "C-c SPC") 'my/switch-to-thing)


;;; Add advice to `delete-blank-lines'
(defun my/delete-blank-lines-in-region (&rest args)
  (let ((do-not-run-orig-fn (use-region-p)))
    (when do-not-run-orig-fn
      (flush-lines "^[[:blank:]]*$" (region-beginning) (region-end)))
    do-not-run-orig-fn))
(advice-add 'delete-blank-lines :before-until #'my/delete-blank-lines-in-region)

;;; Anonymize
;; Hide words
(defun my/anonymize (&optional only-numbers)
  "Replace alphabetical and numerical characters with random lowercase alphabets.

Anonymize the selected region. If no region is selected, apply this function on
the whole buffer.

This function is useful when you want share an anonymized code snippet to someone
to help with some debug.

If ONLY-NUMBERS is non-nil, randomize only the numbers."
  (interactive "P")
  (let ((beg (if (use-region-p) (region-beginning) (point-min)))
        (end (if (use-region-p) (region-end) (point-max))))
    (save-restriction
      (narrow-to-region beg end)
      (save-excursion
        (let ((case-fold-search nil))
          (unless only-numbers
            (goto-char (point-min))
            (while (re-search-forward "[a-z]" nil :noerror)
              (replace-match (char-to-string (+ ?a (random (- ?z ?a))))))
            (goto-char (point-min))
            (while (re-search-forward "[A-Z]" nil :noerror)
              (replace-match (char-to-string (+ ?A (random (- ?Z ?A)))))))
          (goto-char (point-min))
          (while (re-search-forward "[0-9]" nil :noerror)
            (replace-match (char-to-string (+ ?0 (random (- ?9 ?0)))))))))))





;;; Accept non-y responses as no
(defun my/y-or-n-p-optional (prompt)
  "Prompt the user for a yes or no response, but accept any non-y
response as a no."
  (let ((query-replace-map (copy-keymap query-replace-map)))
    (define-key query-replace-map [t] 'skip)
    (y-or-n-p prompt)))

;;; Show the evaluated value of an expression as a comment
(defun my/show-me ()
  "Evaluate a Lisp expression and insert its value
   as a comment at the end of the line.

   Useful for documenting values or checking values.
  "
  (interactive)
  (-let [it
         (thread-last (thing-at-point 'line)
                      read-from-string
                      car
                      eval
                      (format " ;; ⇒ %s"))]
    (end-of-line)
    (insert it)))

;;; Kill all buffers that are not associated with a file
(defun my/clean-buffers ()
  "Kill all buffers that are not associated with a file.
  By convention, such files are named in *earmuffs* style."
  (interactive)
  (ignore-errors (mapcar #'kill-buffer (--filter (s-matches? "\\*.*\\*" it) (mapcar #'buffer-name (buffer-list))))))


;;; My `Agenda' for the Day
(defun my/agenda-for-day ()
  "Call this method, then enter say “-fri” to see tasks timestamped for last Friday."
  (interactive)
  (let* ((date (org-read-date))
         (org-agenda-buffer-tmp-name (format "*Org Agenda(a:%s)*" date))
         (org-agenda-sticky nil)
         (org-agenda-span 'day)
         ;; Putting the agenda in log mode, allows to see the tasks marked as DONE
         ;; at the corresponding time of closing. If, like me, you clock all your
         ;; working time, the task will appear also every time it was worked on.
         ;; This is great to get a sens of what was accomplished.
         (org-agenda-start-with-log-mode t))
    (org-agenda-list nil date nil)))

;;; Replace a word at point
(defun my/symbol-replace (replacement)
  "Replace all standalone symbols in the buffer matching the one at point."
  (interactive  (list (read-from-minibuffer "Replacement for thing at point: " nil)))
  (save-excursion
    (let ((symbol (or (thing-at-point 'symbol) (error "No symbol at point!"))))
      (beginning-of-buffer)
      ;; (query-replace-regexp symbol replacement)
      (replace-regexp (format "\\b%s\\b" (regexp-quote symbol)) replacement))))



;;; Change the view of the buffer
(defun my/toggle-selective-display (column)
  (interactive "P")
  (set-selective-display
   (or column
       (unless selective-display
         (1+ (current-column))))))


;;; Delete entries into the kill ring related to specific current buffer
(defun my/clean-kill-ring (&optional buffer)
  "Remove entries matching BUFFER from `kill-ring'.

Also clears PRIMARY and SECONDARY selections by setting them to
the empty string and clears CLIPBOARD by setting it to the first
remaining element of `kill-ring', which should clear the
clipboard for other applications as well."
  (interactive)
  ;; Just do this so current kill definitely doesn't contain any
  ;; sensitive info. This element will be removed anyway since the
  ;; empty string matches anything.
  (kill-new "")
  (setq kill-ring
        (cl-loop
         with bufstring = (with-current-buffer (or buffer (current-buffer)) (buffer-string))
         for kill in kill-ring
         unless (string-match-p (regexp-quote kill) bufstring)
         collect kill))
  (gui-set-selection 'CLIPBOARD (or (car kill-ring) ""))
  (gui-set-selection 'PRIMARY "")
  ;; (gui-set-selection 'SECONDARY "")
  (message "Kill ring cleared of entries matching buffer %S" (buffer-name buffer)))





;;; Create new buffer or file
(defun my/create-new-file ()
  "Create an untitled file."
  (interactive)
  (let ((buf (generate-new-buffer "untitled")))
    (switch-to-buffer buf)
    (funcall initial-major-mode)
    (setq buffer-offer-save t)
    buf))

;;; Reopen Recently Closed Buffer
(defvar killed-buffer-list nil
  "List of recently killed buffers.")

(defun add-buffer-to-killed-list ()
  "If buffer is associated with a file name, add that file
to the `killed-buffer-list' when killing the buffer."
  (when buffer-file-name
    (push buffer-file-name killed-buffer-list)))
(add-hook 'kill-buffer-hook #'add-buffer-to-killed-list)


(defun my/reopen-killed-buffer ()
  "Reopen the most recently killed file buffer, if one exists."
  (interactive)
  (when killed-buffer-list
    (find-file (pop killed-buffer-list))))

;;; Make current file executable
(defun set-file-executable ()
  "Add executable permissions on current file."
  (interactive)
  (when (buffer-file-name)
    (set-file-modes buffer-file-name
                    (logior (file-modes buffer-file-name) #o100))
    (message (concat "Made " buffer-file-name " executable"))))

;;; Create a lisp buffer for testing
(defun my/lisp-interaction-buffer ()
  (interactive)
  (let ((buf (get-buffer-create "*lisp-interaction*")))
    (with-current-buffer buf
      (lisp-interaction-mode))
    (switch-to-buffer buf)))


;;; Dired Related
;;;; Kill Dired buffers
(defun my/kill-dired-buffers ()
  "Kill all open dired buffers."
  (interactive)
  (mapc (lambda (buffer)
          (when (eq 'dired-mode (buffer-local-value 'major-mode buffer))
            (kill-buffer buffer)))
        (buffer-list)))

;;; Delete Blank Lines
(defun my/delete-blank-lines (start end)
  "Remove blank lines in a buffer."
  (interactive "r")
  (flush-lines "^\\s-*$" start end nil))

;;; Interactive cusror changer
(defconst my-cursor-types '(box hollow bar hbar)
  "Cursor types that can be set using `completing-read'.")

(defun my/set-cursor-type (&optional reset)
  "Set the `cursor-type'.

Optionally RESET the type when called with `universal-argument'."
  (interactive "P")

  (if reset
      (setq-local cursor-type t)
    (let* ((type-string (completing-read "Select cursor type: " my-cursor-types))
           (type (intern type-string)))

      (setq-local cursor-type type))))


;;; Better Kill DWIM
(defun my/kill-dwim (&optional arg)
  "Kill what I mean.

If there's an active region, kill it.

If we're at the (actual) end or (actual) beginning of a line,
kill the whole line, otherwise kill forward.

If a whole line is killed, move to the beginning of text on the
next line.

ARG is passed to `kill-line' and function `kill-whole-line'."
  (interactive "P")

  (if (region-active-p)
      (kill-region nil nil t)
    (let ((p-before (point))
          (p-end nil)
          (p-beg nil))

      (save-excursion
        (end-of-line)
        (setq p-end (point))

        (beginning-of-line)
        (setq p-beg (point)))

      (if (and (/= p-before p-beg) (/= p-before p-end))
          (kill-line arg)
        (kill-whole-line arg)
        (beginning-of-line-text)))))

(global-set-key [remap kill-line] #'my/kill-dwim)


;;; Reverse Region Characters
(defun my/reverse-region-characters (beg end)
  "Reverse the characters in the region from BEG to END.
Interactively, reverse the characters in the current region."
  (interactive "*r")
  (insert
   (reverse
    (delete-and-extract-region
     beg end))))

;;; Describe Keymap
(defun my/describe-keymap (keymap)
  "Display the bindings defined by KEYMAP, a symbol or keymap.
Interactively, select a keymap from the list of all defined
keymaps."
  (interactive
   (list
    (intern
     (completing-read
      "Keymap: " obarray
      (lambda (m)
        (and (boundp m)
             (keymapp (symbol-value m))))
      'require-match
      nil nil (thing-at-point 'symbol)))))
  (with-help-window (help-buffer)
    (with-current-buffer (help-buffer)
      (insert (format "Keymap `%S' defines the following bindings:" keymap)
              "\n\n"
              (substitute-command-keys (format "\\{%S}" keymap))))))

;;; Describe Symbol
(defun my/find-symbol (&optional symbol)
  "Same as `xref-find-definitions' but only for Elisp symbols.
SYMBOL is as in `xref-find-definitions'."
  (interactive)
  (let ((xref-backend-functions '(elisp--xref-backend))
        ;; Make this command behave the same as `find-function' and
        ;; `find-variable', i.e. always prompt for an identifier,
        ;; defaulting to the one at point.
        (xref-prompt-for-identifier t))
    (if symbol
        (xref-find-definitions symbol)
      (call-interactively 'xref-find-definitions))))

;;; Describe Symbol Without Changing Focus
(defun my/describe-peek (sym)
  "Show help for SYM without changing focus."
  (interactive
   (list (or (symbol-at-point)
             (with-demoted-errors "describe-peek error: %S"
               (save-excursion (backward-up-list)
                               (forward-char)
                               (symbol-at-point))))))
  (when sym
    (describe-symbol sym)))




;;; Org Insert Image
;; Insert image into org from selection
(defun my/org-insert-image ()
  "Select and insert an image into org file."
  (interactive)
  (let ((selected-file (read-file-name "Select image: " "~/Pictures/" nil t)))
    (when selected-file
      (insert (format "[[file:%s]]\n" selected-file))
      (org-display-inline-images))))


(provide 'ef-functions)

;;; ef-functions.el ends here
