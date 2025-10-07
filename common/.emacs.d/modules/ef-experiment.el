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





(provide 'ef-experiment)

;;; ef-experiment.el ends here
