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


(provide 'ef-experiment)

;;; ef-experiment.el ends here
