;;; ef-experiment.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:

;;; Better Help Using <f1>
(global-set-key (kbd "<f1>") #'info)
(defun my/describe-elisp-symbol-at-point ()
  "Get help for the symbol at point."
  (interactive)
  (let ((sym (intern-soft (current-word))))
    (unless
        (cond ((null sym))
              ((not (eq t (help-function-arglist sym)))
               (describe-function sym))
              ((boundp sym)
               (describe-variable sym)))
      (message "[nothing]"))))

(global-set-key (kbd "<f1>") #'my/describe-elisp-symbol-at-point)



;;; Auto Indent On Paste
;; Auto-indentation of pasted code in programming modes,
;; but not in Makefile modes.
;; (fall back to default, non-indented, yanking by preceding the yanking
;; command `C-y' with `C-u').
(dolist (command '(yank yank-pop))
  (advice-add command :after
              (lambda (&rest _)
                "Indent yanked text in programming mode (unless prefix arg or in Makefile mode)."
                (when (and (not current-prefix-arg)
                           (derived-mode-p 'prog-mode)
                           (not (derived-mode-p 'makefile-mode)))
                  (let ((mark-even-if-inactive t))
                    (indent-region (region-beginning) (region-end) nil))))))


;;; Cursor customization based on buffer state.
;; (defun my/update-cursor-appearance ()
;;   "Update cursor color and shape based on buffer state (read-only, overwrite, or insert)."
;;   (let* ((is-light-theme (eq (frame-parameter nil 'background-mode) 'light))
;;          (cursor-colors `((read-only . "red")
;;                           (overwrite . "lightblue")
;;                           (default . ,(if is-light-theme "black" "white"))))
;;          current-color
;;          current-type)
;;     (setq current-color
;;           (cond (buffer-read-only
;;                  (cdr (assoc 'read-only cursor-colors)))
;;                 (overwrite-mode
;;                  (cdr (assoc 'overwrite cursor-colors)))
;;                 (t
;;                  (cdr (assoc 'default cursor-colors)))))
;;     (setq current-type (if overwrite-mode 'box 'bar))
;;     (when (color-defined-p current-color)
;;       (set-cursor-color current-color))
;;     (setq cursor-type current-type)))
;;
;; ;; Update cursor on every command.
;; (add-hook 'post-command-hook #'my/update-cursor-appearance)


;;; Performance
;; revert buffers when their files/state have changed
(defun my-visible-buffers (&optional buffer-list all-frames)
  "Return a list of visible buffers (i.e. not buried)."
  (let ((buffers
         (delete-dups
          (cl-loop for frame in (if all-frames (visible-frame-list) (list (selected-frame)))
                   if (window-list frame)
                   nconc (mapcar #'window-buffer it)))))
    (if buffer-list
        (cl-loop for buf in buffers
                 unless (memq buf buffer-list)
                 collect buffers)
      buffers)))
(defun my/auto-revert-buffer-h ()
  "Auto revert current buffer, if necessary."
  (unless (or auto-revert-mode
              (active-minibuffer-window)
              (and buffer-file-name
                   auto-revert-remote-files
                   (file-remote-p buffer-file-name nil t)))
    (let ((auto-revert-mode t))
      (auto-revert-handler))))

(defun my/auto-revert-buffers-h ()
  "Auto revert stale buffers in visible windows, if necessary."
  (dolist (buf (my-visible-buffers))
    (with-current-buffer buf
      (my/auto-revert-buffer-h))))
(add-hook 'after-save-hook #'my/auto-revert-buffers-h)

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



;;; TEST:
;;; Better Color Support for Org Mode Src Code
(defun org-src-color-blocks-light ()
  "Colors the block headers and footers to make them stand out more for lighter themes"
  (interactive)
  (custom-set-faces
   '(org-block-begin-line
     ((t (:underline "#A7A6AA" :foreground "#008ED1" :background "#EAEAFF"))))
   '(org-block-background
     ((t (:background "#FFFFEA"))))
   '(org-block
     ((t (:background "#FFFFEA"))))
   '(org-block-end-line
     ((t (:overline "#A7A6AA" :foreground "#008ED1" :background "#EAEAFF"))))))

(defun org-src-color-blocks-dark ()
  "Colors the block headers and footers to make them stand out more for dark themes"
  (interactive)
  (custom-set-faces
   '(org-block-begin-line
     ((t (:foreground "#008ED1" :background "#002E41"))))
   '(org-block-background
     ((t (:background "#000000"))))
   '(org-block
     ((t (:background "#000000"))))
   '(org-block-end-line
     ((t (:foreground "#008ED1" :background "#002E41"))))))


;;; Interactive Buffer Switcher
(defun my/switch-to-buffer (buffer)
  "Display BUFFER in the selected window.
If BUFFER is displayed in some window, select that window instead."
  (interactive
   (list (get-buffer (read-buffer
                      "Switch to buffer: "
                      (other-buffer (current-buffer))))))
  (cond
   ((eq buffer (window-buffer)))
   (t (let ((win (get-buffer-window buffer)))
        (if win
            (select-window win)
          (switch-to-buffer buffer))))))

;;*---------------------------------------------------------------------------*/
;;*                                                                          */
;;*---------------------------------------------------------------------------*/
;;; Better Comment Box
(defun my/comment-section (start end)
  (interactive "*r")
  (cond ((memq major-mode '(emacs-lisp-mode lisp-interaction-mode
                                            racket-mode))
         (let* ((c
                 (substring comment-start 0 1))
                (template
                 (concat
                  c c "*" (make-string (- fill-column 5) ?-) "*/" "\n"
                  c c "*" "%s" "*/" "\n"
                  c c "*" (make-string (- fill-column 5) ?-)  "*/" "\n"))
                (comment
                 (buffer-substring start end))
                (comment-with-padding
                 (format (concat "%-" (number-to-string (- fill-column 5)) "s")
                         (concat "    " comment))))
           (delete-region start end)
           (insert (format template comment-with-padding))))
        ((memq major-mode '(c-mode))
         (let ((comment
                (buffer-substring start end))
               (template
                "/*** %s ***/"))
           (delete-region start end)
           (insert (format template comment))))))

;;; TEST: Org Table Align
(defun my/align-all-tables ()
  (interactive)
  (org-table-map-tables 'org-table-align 'quietly))

;;; Kill Back to Indentation Instead of Full Line
(defun my/kill-back-to-indentation ()
  "Kill from point back to the first non-whitespace character on the line."
  (interactive)
  (let ((prev-pos (point)))
    (back-to-indentation)
    (kill-region (point) prev-pos)))

;;; TEST: Better Comment
(defun my/comment-dwim-line (&optional arg)
"Replacement for the comment-dwim command.
If no region is selected and current line is not blank and we are not at the end of the line,
then comment current line.
Replaces default behaviour of comment-dwim, when it inserts comment at the end of the line."
(interactive "*P")
(if (bound-and-true-p paredit-mode)
    (paredit-comment-dwim arg)
  (comment-normalize-vars)
  (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
      (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    (comment-dwim arg))))

;;; TEST: Auto insert
;; (use-package auto-insert
;;   :ensure nil
;;   :config
;;
;;   (setq auto-insert-query nil)
;;   ;; Python
;;   (define-auto-insert
;;     '("\\.py\\'" . "Python")
;;     '(nil
;;       "# -*- coding: utf-8 -*-\n"
;;       ))
;;
;;   ;; Org
;;   (define-auto-insert
;;     '("\\.org\\'" . "Org")
;;     '(nil
;;       "#+TITLE: " (read-from-minibuffer "Title: " (replace-regexp-in-string "\\(^.+\\)\.org$" "\\1" (buffer-real-name))) "\n"
;;       "#+DATE: " (format-time-string "%Y/%m/%d（%a）%H:%M") "\n"
;;       "#+AUTHOR: " user-full-name "\n"
;;       "#+EMAIL: " user-mail-address "\n"
;;       "#+OPTIONS: ':nil *:t -:t ::t <:t H:3 \\n:nil ^:t arch:headline\n"
;;       "#+OPTIONS: author:t c:nil creator:comment d:(not \"LOGBOOK\") date:t\n"
;;       "#+OPTIONS: e:t email:nil f:t inline:t num:t p:nil pri:nil stat:t\n"
;;       "#+OPTIONS: tags:t tasks:t tex:t timestamp:t toc:nil todo:t |:t\n"
;;       "#+CREATOR: " (format "Emacs %s (Org mode %s)"
;;                             emacs-version (org-version nil nil)) "\n"
;;       "#+DESCRIPTION:\n"
;;       "#+EXCLUDE_TAGS: noexport\n"
;;       "#+KEYWORDS:\n"
;;       "#+LANGUAGE: en\n"
;;       "#+SELECT_TAGS: export\n"
;;       ))
;;   )

;;; TEST: Download File
(defun my/download-file (url directory file-name)
  "Download the file at URL into DIRECTORY.
The FILE-NAME defaults to the one used in the URL."
  (interactive
   ;; We're forced to let-bind url here since we access it before
   ;; interactive binds the function parameters.
   (let ((url (read-from-minibuffer "URL: ")))
     (list
      url
      (read-directory-name "Destination dir: ")
      ;; deliberately not using read-file-name since that inludes the directory
      (read-from-minibuffer
       "File name: "
       (car (last (s-split "/" url)))))))
  (let ((destination (f-join directory file-name)))
    (url-copy-file url destination 't)
    (find-file destination)))

;;; TEST: Create a Duplicate Buffer
(defun my/duplicate-buffer (new-name)
  "Create a copy of the current buffer with the filename NEW-NAME.
The original buffer and file are untouched."
  (interactive (list (read-from-minibuffer "New name: " (buffer-file-name))))

  (let ((filename (buffer-file-name))
        (new-directory (file-name-directory new-name))
        (contents (buffer-substring (point-min) (point-max))))
    (unless filename (error "Buffer '%s' is not visiting a file!" (buffer-name)))

    (make-directory new-directory t)
    (find-file new-name)
    (insert contents)
    (basic-save-buffer)))

;;; TEST: Mark Text Using M-SPC
(defun my/mark-symbol-at-point ()
  (interactive)
  (let ((bounds (bounds-of-thing-at-point 'symbol)))
    (cl-assert bounds nil "No symbol at point")
    (goto-char (car bounds))
    (push-mark (cdr bounds) nil t)))
(global-set-key (kbd "M-SPC") #'my/mark-symbol-at-point )


;;; Goto matching parens using `%`
(defun my/goto-match-paren (arg)
  "Go to the matching paren/bracket, otherwise (or if ARG is not
    nil) insert %.  vi style of % jumping to matching brace."
  (interactive "p")
  (if (not (memq last-command '(set-mark
                                cua-set-mark
                                zz/goto-match-paren
                                down-list
                                up-list
                                end-of-defun
                                beginning-of-defun
                                backward-sexp
                                forward-sexp
                                backward-up-list
                                forward-paragraph
                                backward-paragraph
                                end-of-buffer
                                beginning-of-buffer
                                backward-word
                                forward-word
                                mwheel-scroll
                                backward-word
                                forward-word
                                mouse-start-secondary
                                mouse-yank-secondary
                                mouse-secondary-save-then-kill
                                move-end-of-line
                                move-beginning-of-line
                                backward-char
                                forward-char
                                scroll-up
                                scroll-down
                                scroll-left
                                scroll-right
                                mouse-set-point
                                next-buffer
                                previous-buffer
                                previous-line
                                next-line
                                back-to-indentation
                                )))
      (self-insert-command (or arg 1))
    (cond ((looking-at "\\s\(") (sp-forward-sexp) (backward-char 1))
          ((looking-at "\\s\)") (forward-char 1) (sp-backward-sexp))
          (t (self-insert-command (or arg 1))))))


(bind-key "%" 'my/goto-match-paren)

;;; Create non-existing folder when saving a file.
(defun my/offer-to-create-parent-directories-on-save ()
  "When saving a file in a directory that doesn't exist, offer
to (recursively) create the file's parent directories."
  (add-hook 'before-save-hook
            (lambda ()
              (when buffer-file-name
                (let ((dir (file-name-directory buffer-file-name)))
                  (when (and (not (file-exists-p dir))
                             (y-or-n-p (format "Directory %s does not exist. Create it?" dir)))
                    (make-directory dir t)))))))

;;; Quiet Macro
;; Example application (quiet! (recentf-mode 1))
(defmacro quiet! (&rest forms)
  "Run FORMS without generating any output.

This silences calls to `message', `load', `write-region' and anything that
writes to `standard-output'. In interactive sessions this inhibits output to the
echo-area, but not to *Messages*."
  (declare (indent 0))
  `(if init-file-debug
       (progn ,@forms)
     ,(if noninteractive
          `(quiet!! ,@forms)
        `(let ((inhibit-message t)
               (save-silently t))
           (prog1 ,@forms (message ""))))))


(defun doom-shut-up-a (fn &rest args)
  "Generic advisor for silencing noisy functions.

In interactive Emacs, this just inhibits messages from appearing in the
minibuffer. They are still logged to *Messages*.

In tty Emacs, messages are suppressed completely."
  (quiet! (apply fn args)))





;;; TEST: Keybinding (move it to functions)
(use-package bind-key
  :ensure nil
  :bind
  (:prefix-map my/files-map
               :prefix "C-z f")
  :bind
  (:prefix-map my/toggles-map
               :prefix "C-z x"))

;;; TEST: Shortcut to insert global-set-key
(defun my/insert-global-set-key (key command)
  (interactive (list (read-key-sequence "Key sequence: ")
                     (read-command "Command: ")))
  (prin1 `(global-set-key (kbd ,(key-description key)) ',command)
         (current-buffer)))

;;; TEST: Open Directory in System Viewer
(defmacro when-system (type &rest body)
  "Evaluate BODY if `system-type' equals TYPE."
  (declare (indent defun))
  `(when (eq system-type ',type)
     ,@body))

(defun my/open-directory-in-system-viewer ()
  (interactive)
  (when-system gnu/linux
    (if default-directory
        (browse-url-of-file (expand-file-name default-directory))
      (error "No `default-directory' to open")))
  (when-system windows-nt
    (require 'w32-browser)
    (if default-directory
        (w32explore (expand-file-name default-directory))
      (error "No `default-directory' to open"))))



;;; TEST: Copy/paste a region from emacs buffer with line + file reference
(defun my/kill-with-linenum (beg end)
  (interactive "r")
  (save-excursion
    (goto-char end)
    (skip-chars-backward "\n \t")
    (setq end (point))
    (let* ((chunk (buffer-substring beg end))
           (chunk (concat
                   (format "╭──────── #%-d ─ %s ──\n│ "
                           (line-number-at-pos beg)
                           (or (buffer-file-name) (buffer-name)))
                   (replace-regexp-in-string "\n" "\n│ " chunk)
                   (format "\n╰──────── #%-d ─"
                           (line-number-at-pos end)))))
      (kill-new chunk)))
  (deactivate-mark))



;;; TEST: Goto Line
(defun my/goto-line-number ()
  (interactive)
  (goto-char (point-min))
  (forward-line (1- (string-to-number
                     (read-from-minibuffer
                      "Goto line: "
                      (char-to-string last-command-event))))))

;; (cl-loop for n from 1 to 9 do
;;          (global-set-key (format "\M-g%d" n) 'my/goto-line-number))
;; (global-set-key "\M-g?" 'describe-prefix-bindings)


;;; TEST: Different Fonts for different org faces
;; (defun my/org-font-setup ()
;;   "Setup fixed-pitch font for Org."
;;   (custom-set-faces
;;    '(org-block ((t (:inherit fixed-pitch))))
;;    '(org-table ((t (:inherit fixed-pitch))))
;;    '(org-formula ((t (:inherit fixed-pitch))))
;;    '(org-code ((t (:inherit fixed-pitch))))
;;    '(org-verbatim ((t (:inherit fixed-pitch))))
;;    '(org-special-keyword ((t (:inherit fixed-pitch))))
;;    '(org-checkbox ((t (:inherit fixed-pitch))))
;;    '(line-number ((t (:inherit fixed-pitch))))
;;    '(line-number-current-line ((t (:inherit fixed-pitch))))
;;    '(org-block-begin-line ((t (:inherit fixed-pitch))))
;;    '(org-block-end-line ((t (:inherit org-block-begin-line))))))
;;
;; (add-to-list 'org-mode-hook #'my/org-font-setup)
;;;; Alternative
;; Ensure that anything that should be fixed-pitch in Org files appears that way
;; (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
;; (set-face-attribute 'org-code nil   :inherit '(default fixed-pitch))
;; (set-face-attribute 'org-table nil   :inherit '(default fixed-pitch))
;; (set-face-attribute 'org-verbatim nil :inherit '(default fixed-pitch))
;; (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
;; (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
;; (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)


;;; Outline Mode
;; Outline cycle buffer: hide, show, show all, hide all (whole buffer)
(defun outline--cycle-state ()
  "Return the cycle state of current heading.
Return either 'hide-all, 'headings-only, or 'show-all."
  (save-excursion
    (let (start end ov-list heading-end)
      (outline-back-to-heading)
      (setq start (point))
      (outline-end-of-heading)
      (setq heading-end (point))
      (outline-end-of-subtree)
      (setq end (point))
      (setq ov-list (cl-remove-if-not
                     (lambda (o) (eq (overlay-get o 'invisible) 'outline))
                     (overlays-in start end)))
      (cond ((eq ov-list nil) 'show-all)
            ;; (eq (length ov-list) 1) wouldn’t work: what if there is
            ;; one folded subheading?
            ((and (eq (overlay-end (car ov-list)) end)
                  (eq (overlay-start (car ov-list)) heading-end))
             'hide-all)
            (t 'headings-only)))))
(defun my/outline-cycle-buffer ()
  "Cycle the whole buffer like in ‘outline-cycle’."
  (interactive)
  (pcase outline--cycle-buffer-state
    ('show-all (save-excursion
                 (outline-hide-sublevels
                  (or (ignore-errors
                        (outline-back-to-heading)
                        (outline-level))
                      1)))
               (setq outline--cycle-buffer-state 'top-level)
               (message "Top level headings"))
    ('top-level (outline-show-all)
                (outline-hide-region-body (point-min) (point-max))
                (setq outline--cycle-buffer-state 'all-heading)
                (message "All headings"))
    ('all-heading (outline-show-all)
                  (setq outline--cycle-buffer-state 'show-all)
                  (message "Show all"))))



;;;; Outline Cycle
(defun outline-has-subheading-p ()
  "Return t if this heading has subheadings, nil otherwise."
  (save-excursion
    (outline-back-to-heading)
    (< (save-excursion (outline-next-heading) (point))
       (save-excursion (outline-end-of-subtree) (point)))))

(defun outline-cycle ()
  "Cycle between “hide all”, “headings only” and “show all”.

“Hide all” means hide all subheadings and their bodies.
“Headings only” means show sub headings but not their bodies.
“Show all” means show all subheadings and their bodies."
  (interactive)
  (condition-case nil
      (pcase (outline--cycle-state)
        ('hide-all (if (outline-has-subheading-p)
                       (progn (outline-show-children)
                              (message "Only headings"))
                     (outline-show-subtree)
                     (message "Show all")))
        ('headings-only (outline-show-subtree)
                        (message "Show all"))
        ('show-all (outline-hide-subtree)
                   (message "Hide all")))
    ;; If error: "Before first heading" occurs, ignore it.
    (error nil)))


;;; List Loaded Packages
(defvar my-loaded-features-buffer "*loaded-features*"
  "Buffer name for data about loaded features.")

(defun my/list-loaded-features()
  "List all currently loaded features."
  (interactive)
  (with-current-buffer (get-buffer-create my-loaded-features-buffer)
    (erase-buffer)
    (pop-to-buffer (current-buffer))

    (insert (format "\n** %d features currently loaded\n"
                    (length features)))

    (let ((features-vec (apply 'vector features)))
      (cl-sort features-vec 'string-lessp)
      (cl-loop for x across features-vec
               do (insert (format "  - %-25s: %s\n" x
                                  (locate-library (symbol-name x))))))

    (goto-char (point-min))))




;;; FIXME: Modify keybindings to use in org mode to bold, italize etc.
;; (defun +org-emphasize-below-point (&optional char)
;;   "Emphasize region with CHAR.
;;
;; If there's no region, marks the closest sexp first."
;;   (interactive)
;;   (unless (region-active-p)
;;     (backward-sexp)
;;     (mark-sexp))
;;   (org-emphasize char))
;;
;; (defun +org-emphasize-bindings ()
;;   (dolist (binding '(("s-i b" ?*)
;;                      ("s-i i" ?/)
;;                      ("s-i u" ?_)
;;                      ("s-i v" ?=)
;;                      ("s-i c" ?~)
;;                      ("s-i s" ?+)))
;;     (let ((key (car binding))
;;           (char (cadr binding)))
;;       (define-key org-mode-map (kbd key)
;;                   `(lambda () (interactive) (+org-emphasize-below-point ,char))))))

;;; Org Formatting Helpers
(defun my/org-apply-format (prefix suffic)
  "Apply the specified PREFIX and SUFFIX to the active region or current line.
If there is an active region, wrap it directly. If there is no active region,
apply to the current line, ignoring leading whitespace."
  (interactive "sPrefix: \nsSuffix: ")
  (let* ((use-region (region-active-p))
         (beg (if use-region
                  (region-beginning)
                (save-excursion
                  (beginning-of-line)
                  (skip-chars-forward " \t") ; ignore leading whitespace
                  (point))))
         (end (if use-region
                  (region-end)
                (line-end-position)))
         (text (buffer-substring-no-properties beg end)))
    (delete-region beg end)
    (insert (concat prefix text suffix))))

(defun my/org-apply-bold ()
  "Wrap region or line in Org *bold* markers."
  (interactive)
  (my/org-apply-format "*" "*"))

(defun my/org-apply-italic ()
  "Wrap region or line in Org /italic/ markers."
  (interactive)
  (my/org-apply-format "/" "/"))

(defun my/org-apply-strike-through ()
  "Wrap region or line in Org +strike-through+ markers."
  (interactive)
  (my/org-apply-format "+" "+"))

(defun my/org-apply-verbatim ()
  "Wrap region or line in Org =verbatim= markers."
  (interactive)
  (my/org-apply-format "=" "="))


(defun my/org-apply-code ()
  "Wrap region or line in Org ~code~ markers."
  (interactive)
  (my/org-apply-format "~" "~"))

;;; Reopen File
(defun my/reopen-file-at-buffer ()
  "Re-open the file at buffer, replacing buffer.

After reopening, cursor will attempt to return to the point it was previously
on. This may cause a jump if the file has changed significantly. Finally, the
buffer will be recentered to the line at point."
  (interactive)
  (let ((initial-line (line-beginning-position))
        (initial-point (point))
        (initial-total-lines (count-lines (point-min) (point-max))))
    (find-alternate-file (buffer-file-name))
    (if (= initial-total-lines (count-lines (point-min) (point-max)))
        ;; If total lines have not changed, we can reasonably guess that the
        ;; content has not changed significantly (if at all), so we can jump
        ;; right back to the initial point.
        (goto-char initial-point)
      ;; If total lines /have/ changed, we can reasonably guess that the initial
      ;; point is contextually not where we were before. The best thing we can
      ;; do now is return to the same line number, and hope it's close. Getting
      ;; closer than this would require text parsing, which is more complex than
      ;; we need for a simple file replacement.
      (goto-char initial-line))
    ;; Finally, recenter the line. We may not have been centered before, but this is more often than
    ;; not what we want.
    (recenter))
  (setq buffer-name buffer-file-name)
  (message "%s Restarted!" buffer-name)
  )

(current-buffer)

;;; Replace Unnecessary Characters
(defun my/replace-chars ()
  "Replace goofy MS and other garbage characters with Latin1 equivalents."
  (interactive)
  (let ((beg (point-min))
        (end (point-max)))
    (when (region-active-p)
      (setq beg (region-beginning))
      (setq end (region-end)))
    (save-excursion ;save the current point
      (replace-string "΄" "'" nil beg end)
      (replace-string "‘" "'" nil beg end)
      (replace-string "’" "'" nil beg end)
      (replace-string "“" "\"" nil beg end)
      (replace-string "”" "\"" nil beg end)
      (replace-string "" "'" nil beg end)
      (replace-string "" "'" nil beg end)
      (replace-string "" "\"" nil beg end)
      (replace-string "" "\"" nil beg end)
      (replace-string "" "\"" nil beg end)
      (replace-string "" "\"" nil beg end)
      (replace-string "‘" "\"" nil beg end)
      (replace-string "’" "'" nil beg end)
      (replace-string "¡\"" "\"" nil beg end)
      (replace-string "¡­" "..." nil beg end)
      (replace-string "" "..." nil beg end)
      (replace-string "" " " nil beg end) ; M-SPC
      (replace-string "" "`" nil beg end)  ; \221
      (replace-string "" "'" nil beg end)  ; \222
      (replace-string "" "``" nil beg end)
      (replace-string "" "''" nil beg end)
      (replace-string "" "*" nil beg end)
      (replace-string "" "--" nil beg end)
      (replace-string "" "--" nil beg end)
      (replace-string " " " " nil beg end) ; M-SPC
      (replace-string "¡" "\"" nil beg end)
      (replace-string "´" "\"" nil beg end)
      (replace-string "»" "<<" nil beg end)
      (replace-string "Ç" "'" nil beg end)
      (replace-string "È" "\"" nil beg end)
      (replace-string "é" "e" nil beg end) ;; &eacute;
      (replace-string "ó" "-" nil beg end)

      ;; mine
      (replace-string "•" "-" nil beg end)
      (replace-string "–" "--" nil beg end)
      (replace-string "—" "---" nil beg end) ; multi-byte
      (replace-string "…" "..." nil beg end)
      (replace-string "&#38;" "&" nil beg end)
      (replace-string "&#39;" "'" nil beg end)

      (message "Garbage in, garbage out.") )))






;;; Test Emacs
(defun my/test-emacs ()
  "Test if emacs starts correctly."
  (interactive)
  (if (eq last-command this-command)
      (save-buffers-kill-terminal)
    (require 'async)
    (async-start
     (lambda () (shell-command-to-string
            "emacs --batch --eval \"
(condition-case e
    (progn
      (load \\\"~/.emacs.d/init.el\\\")
      (message \\\"-OK-\\\"))
  (error
   (message \\\"ERROR!\\\")
   (signal (car e) (cdr e))))\""))
     `(lambda (output)
        (if (string-match "-OK-" output)
            (when ,(called-interactively-p 'any)
              (message "All is well"))
          (switch-to-buffer-other-window "*startup error*")
          (delete-region (point-min) (point-max))
          (insert output)
          (search-backward "ERROR!")))))    )

;;; TEST: Org

(defun org-capture-select-template-prettier (&optional keys)
  "Select a capture template, in a prettier way than default
Lisp programs can force the template by setting KEYS to a string."
  (let ((org-capture-templates
         (or (org-contextualize-keys
              (org-capture-upgrade-templates org-capture-templates)
              org-capture-templates-contexts)
             '(("t" "Task" entry (file+headline "" "Tasks")
                "* TODO %?\n  %u\n  %a")))))
    (if keys
        (or (assoc keys org-capture-templates)
            (error "No capture template referred to by \"%s\" keys" keys))
      (org-mks org-capture-templates
               "Select a capture template\n━━━━━━━━━━━━━━━━━━━━━━━━━"
               "Template key: "
               `(("q" ,(concat (nerd-icons-octicon "nf-oct-stop" :face `nerd-icons-red :v-adjust 0.01) "\tAbort")))))))

(advice-add 'org-capture-select-template :override #'org-capture-select-template-prettier)o



(defun my/delete-frame-after-capture ()
  "Delete frame after capturing."
  (delete-frame)
  (remove-hook 'org-capture-after-finalize-hook 'my//delete-frame-after-capture))

(defun my/capture ()
  "Capture externally"
  (interactive)
  (delete-other-windows)

  (add-hook 'org-capture-after-finalize-hook #'my//delete-frame-after-capture)
  )

;;; Org Agenda
(use-package org-agenda
  :ensure nil
  :config
  (setq org-agenda-custom-commands
        '(("d" "Dashboard for today"
           ((agenda "" ((org-agenda-overriding-header "Dashboard")
                        (org-agenda-span 'day)
                        ;; (org-agenda-current-span 'day)
                        (org-agenda-start-day (org-today))
                        ;; (org-agenda-use-time-grid nil)
                        ;; (org-agenda-remove-tags t)
                        ;; (org-agenda-current-time-string "ᐊ┈┈┈┈┈┈┈ Now")
                        ;; (org-agenda-show-log nil)
                        (org-super-agenda-groups
                         '((:name "Happy birthday 🎂"
                                  :property "BIRTHDAY"
                                  :order 2)
                           (:name "Keep your habits up 🔥"
                                  :habit t
                                  :order 3)

                           (:name "Currently working on 🧑‍🏭"
                                  :todo "INPROGRESS"
                                  :order 2)

                           (:name "Logged 📑" :log t :order 15)

                           (:discard (:todo "SOMEDAY"))
                           ;; (:name "Done today" :discard (:log t))

                           (:name "This is how your day looks 🌞"
                                  :time-grid t
                                  :order 1)

                           (:name "Waiting.. 😴"
                                  :todo "WAITING"
                                  :order 5)

                           (:name "First, do one of these 🐸"
                                  :and (:deadline today :priority "A")
                                  :deadline today
                                  :and (:deadline past :priority "A")
                                  :and (:scheduled t :priority "A")
                                  :and (:scheduled past :priority "A")
                                  :deadline past
                                  :order 3)

                           (:name "Scheduled for today ⏰"
                                  :scheduled today
                                  :order 2)

                           (:name "Upcoming deadlines 🚌"
                                  :deadline future
                                  :order 2)

                           (:name "Follow up 📆"
                                  :tag "email"
                                  :order 4)

                           (:name "Do you still need to do these? 🤔"
                                  :scheduled past
                                  :order 5)
                           ))))))

          ("W" "Dashboard for the week"
           ((agenda "" ((org-agenda-overriding-header "Dashboard")
                        (org-agenda-span 'week)
                        ;; (org-agenda-current-span 'day)
                        (org-agenda-start-day "-Mon")
                        ;; (org-agenda-clockreport-mode nil)
                        (org-agenda-log-mode-items '(state))
                        (org-super-agenda-groups
                         '((:time-grid t
                                       :order 1)
                           (:discard (:anything t))))))))

          ("w" "Work related tasks"
           ((tags-todo "@work|planet9" (
                                        (org-super-agenda-groups
                                         '(
                                           ;; (:discard (:not (:and (:tag ("@work" "planet9")))))
                                           (:name "Important tasks"
                                                  :priority ("A" "B")
                                                  :order 1)
                                           (:name "Needs refiling"
                                                  :tag "REFILE"
                                                  :order 1)))))))

          ("c" "Todays done and clocked items"
           ((agenda "" ((org-agenda-overriding-header "")
                        (org-agenda-span 'day)
                        (org-agenda-current-span 'week)
                        (org-agenda-start-day (org-today))
                        (org-super-agenda-groups
                         '((:name "Done today"
                                  :and (:regexp "State \"DONE\""
                                                :log t))
                           (:name "Clocked today"
                                  :log t)
                           (:discard (:anything t))))))))

          ("i" "In progress" tags-todo "TODO=\"INPROGRESS\"")
          ("l" "Low effort tasks" tags-todo "EFFORT>=\"0:01\"&EFFORT<=\"0:15\"")

          ("p" "Projects" tags "+project-someday-TODO=\"DONE\"-TODO=\"SOMEDAY\""
           ((org-tags-exclude-from-inheritance '("project"))
            (org-agenda-sorting-strategy '(priority-down tag-up category-keep effort-down))))

          ("O" "Timeline for today" ((agenda "" ))
           ((org-agenda-ndays 1)
            (org-agenda-show-log t)
            (org-agenda-log-mode-items '(clock closed))
            (org-agenda-clockreport-mode t)
            (org-agenda-entry-types '())))

          ("gc" "Coding" tags-todo "@coding"
           ((org-agenda-view-columns-initially t)))
          ("gd" "Done items" todo "DONE"
           ((org-agenda-view-columns-initially t)))
          ("ge" "Errands" tags-todo "errands"
           ((org-agenda-view-columns-initially t)))
          ("gh" "Home" tags-todo "@home"
           ((org-agenda-view-columns-initially t)))
          ("gi" "In progress" tags-todo "TODO=\"INPROGRESS\"")
          ("gs" "Someday" tags-todo "TODO=\"SOMEDAY\""
           ((org-agenda-view-columns-initially nil)
            (org-tags-exclude-from-inheritance '("project"))
            (org-agenda-overriding-header "Someday: ")
            (org-columns-default-format "%50ITEM %TODO %3PRIORITY %Effort{:} %TAGS")
            (org-agenda-sorting-strategy '(todo-state-up priority-down effort-up tag-up category-keep))))
          ("gw" "Waiting for" todo "WAITING")
          ("gP" "By priority"
           ((tags-todo "+PRIORITY=\"A\"")
            (tags-todo "+PRIORITY=\"B\"")
            (tags-todo "+PRIORITY=\"\"")
            (tags-todo "+PRIORITY=\"C\""))
           ((org-agenda-prefix-format "%-10c %-10T %e ")
            (org-agenda-sorting-strategy '(priority-down tag-up category-keep effort-down))))

          ("o" "Overview"
           ((agenda "Agenda today" ((org-agenda-span 'day)
                                    (org-super-agenda-groups
                                     '((:name "Today"
                                              :time-grid t
                                              :date today
                                              :todo "TODAY"
                                              :scheduled today
                                              :order 1)))))
            (alltodo "All todos" ((org-agenda-overriding-header "")
                                  (org-super-agenda-groups
                                   '((:name "Next to do"
                                            :todo "NEXT"
                                            :order 1)
                                     (:name "Important"
                                            :tag "Important"
                                            :priority "A"
                                            :order 6)
                                     (:name "Due Today"
                                            :deadline today
                                            :order 2)
                                     (:name "Due Soon"
                                            :deadline future
                                            :order 8)
                                     (:name "Overdue"
                                            :deadline past
                                            :face error
                                            :order 7)
                                     (:name "Projects"
                                            :tag "Project"
                                            :order 14)
                                     (:name "Emacs"
                                            :tag "emacs"
                                            :order 13)
                                     (:name "To read"
                                            :tag "toread"
                                            :order 30)
                                     (:name "Waiting"
                                            :todo "WAITING"
                                            :order 20)
                                     (:discard (:tag ("Chore" "Routine" "Daily")))))))))

          ("D" "Playground"
           ((tags "test"
                  ((org-agenda-overriding-header "Work things\n")))
            (agenda ""
                    ((org-agenda-overriding-header "Todays agenda")
                     (org-agenda-block-separator ?*)
                     (org-deadline-warning-days 0)
                     (org-agenda-day-face-function (lambda (date) 'org-agenda-date))
                     ;; (org-super-agenda-date-format "%A %-e %B %Y")
                     (org-agenda-span 1))
                    )))))

  )


(provide 'ef-experiment)

;;; ef-experiment.el ends here
