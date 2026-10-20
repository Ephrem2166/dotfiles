;;; ef-functions.el ---  -*- lexical-binding: t; -*-

;;; Commentary:
;;

;;; Code:

;;; Kill DWIM
(defun my/kill-dwim (&optional arg)
  "Kill what I mean.

If there is an active region, kill it.
If at the actual end or beginning of a line, kill the whole line;
otherwise kill forward.  If a whole line is killed, move point to
the first non-whitespace character on the next line.

ARG is passed to `kill-line' and `kill-whole-line'."
  (interactive "P")
  (if (region-active-p)
      (kill-region nil nil t)
    (let ((p-before (point)))
      (if (or (= p-before (line-beginning-position))
              (= p-before (line-end-position)))
          (progn
            (kill-whole-line arg)
            (beginning-of-line-text))
        (kill-line arg)))))

;;; Delete Don't Kill
(defun my/delete-dont-kill (arg)
  "Delete characters backward to the start of the word, ARG times.
Does not add to the kill ring."
  (interactive "p")
  (delete-region (point) (progn (backward-word arg) (point))))


;;; Backward Delete
(defun my/backward-delete ()
  "Delete a word, a character, or whitespace backward."
  (interactive)
  (cond
   ((looking-back (rx (char word)) (1- (point)))
    (my/delete-dont-kill 1))
   ((looking-back (rx (seq (char word) (= 1 blank))) (max (point-min) (- (point) 2)))
    (my/delete-dont-kill 1))
   ((looking-back (rx (char blank)) (1- (point)))
    (delete-horizontal-space t))
   (t
    (backward-delete-char-untabify 1))))


;;; Kill Whitespace or Word
(defun my/kill-whitespace-or-word (arg)
  "Kill forward whitespace, or one word when no whitespace ahead."
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
  "Kill backward whitespace, or one word when no whitespace behind."
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

;;; Better Cut Region
(defun my/better-cut-region (orig-fn beg end &rest args)
  "Cut the region, or the current line when called with no region."
  (interactive (if (use-region-p)
                   (list (region-beginning) (region-end))
                 (list (line-beginning-position) (line-beginning-position 2))))
  (if (and (called-interactively-p 'any) (not (use-region-p)))
      (apply orig-fn (line-beginning-position) (line-beginning-position 2) args)
    (apply orig-fn beg end args)))
(advice-add 'kill-region :around #'my/better-cut-region)


;;; Better Copy Region
(defun my/better-copy-region (orig-fn beg end &rest args)
  "Copy the region, or the current line when called with no region."
  (interactive (if (use-region-p)
                   (list (region-beginning) (region-end))
                 (list (line-beginning-position) (line-beginning-position 2))))
  (if (and (called-interactively-p 'any) (not (use-region-p)))
      (apply orig-fn (line-beginning-position) (line-beginning-position 2) args)
    (apply orig-fn beg end args)))
(advice-add 'kill-ring-save :around #'my/better-copy-region)

;;; Kill With Line Numbers
(defun my/kill-with-linenum (beg end)
  "Copy region BEG..END into the kill ring with file/line banner."
  (interactive "r")
  (let* ((file (or (buffer-file-name) (buffer-name)))
         (start-line (line-number-at-pos beg))
         (end-line   (line-number-at-pos end))
         (body       (buffer-substring-no-properties beg end)))
    (kill-new (concat
               (format "╭──────── #%d ─ %s ──\n│ " start-line file)
               (replace-regexp-in-string "\n" "\n│ " body)
               (format "\n╰──────── #%d ─" end-line)))))


;;; Clean Kill Ring
(defun my/clean-kill-ring (&optional buffer)
  "Remove entries from `kill-ring' that appear in BUFFER (or current).
Also clears PRIMARY and CLIPBOARD selections so sensitive text does
not linger in the X selection or on the clipboard."
  (interactive)
  (let ((buf (or buffer (current-buffer))))
    ;; Force the current selection into the ring so we can drop it.
    (kill-new "")
    (let ((bufstring (with-current-buffer buf (buffer-string))))
      (setq kill-ring
            (cl-loop for kill in kill-ring
                     unless (string-match-p (regexp-quote kill) bufstring)
                     collect kill)))
    (gui-set-selection 'CLIPBOARD (or (car kill-ring) ""))
    (gui-set-selection 'PRIMARY "")
    (message "Kill ring cleared of entries matching %S"
             (buffer-name buf))))



;;; File Operations
(defun my/delete-this-file (&optional path force-p)
  "Delete PATH (default: current buffer's file) and kill the buffer.
With FORCE-P, skip the confirmation prompt."
  (interactive
   (list (buffer-file-name (buffer-base-buffer)) current-prefix-arg))
  (let* ((path (or path (buffer-file-name (buffer-base-buffer))))
         (short-path (abbreviate-file-name path)))
    (unless (and path (file-exists-p path))
      (user-error "Buffer is not visiting any file"))
    (unless (or force-p (y-or-n-p (format "Really delete %S?" short-path)))
      (user-error "Aborted"))
    (delete-file path delete-by-moving-to-trash)
    (when (file-exists-p path)
      (error "Failed to delete %S" short-path))
    (kill-current-buffer)))

(defun my/rename-this-file (new-name)
  "Rename the current buffer's file and buffer to NEW-NAME."
  (interactive "sNew name: ")
  (let ((filename (buffer-file-name)))
    (unless filename (error "Buffer is not visiting a file"))
    (when (file-exists-p filename)
      (rename-file filename new-name 1))
    (set-visited-file-name new-name)
    (rename-buffer new-name)))

(defun my/reopen-file-at-buffer ()
  "Re-read the current buffer's file from disk, preserving point if possible."
  (interactive)
  (let ((initial-line (line-beginning-position))
        (initial-point (point))
        (initial-total (count-lines (point-min) (point-max))))
    (find-alternate-file (buffer-file-name))
    (if (= initial-total (count-lines (point-min) (point-max)))
        (goto-char initial-point)
      (goto-char initial-line))
    (recenter)))

(defun my/set-file-executable ()
  "Add executable permissions to the current file."
  (interactive)
  (when (buffer-file-name)
    (set-file-modes buffer-file-name
                    (logior (file-modes buffer-file-name) #o100))
    (message "Made %s executable" buffer-file-name)))

(defun my/open-with (arg)
  "Open current file in its default external program.
With a prefix ARG, prompt for the command."
  (interactive "P")
  (when buffer-file-name
    (shell-command
     (concat
      (cond
       ((and (not arg) (eq system-type 'darwin)) "open")
       ((and (not arg) (member system-type '(gnu gnu/linux gnu/kfreebsd)))
        "xdg-open")
       (t (read-shell-command "Open current file with: ")))
      " " (shell-quote-argument buffer-file-name)))))

(defun my/copy-file-name-to-clipboard ()
  "Copy the current buffer's file name to the kill ring."
  (interactive)
  (let ((filename (if (eq major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (kill-new filename)
      (message "Copied: %s" filename))))

(defvar my/killed-buffer-list nil
  "Recently killed file-visiting buffer names.")

(defun my/add-buffer-to-killed-list ()
  "Record the buffer's file name before it is killed."
  (when buffer-file-name
    (push buffer-file-name my/killed-buffer-list)))
(add-hook 'kill-buffer-hook #'my/add-buffer-to-killed-list)

(defun my/reopen-killed-buffer ()
  "Reopen the most recently killed file buffer."
  (interactive)
  (if my/killed-buffer-list
      (find-file (pop my/killed-buffer-list))
    (user-error "No killed file buffer to reopen")))


;;; Sudo-save support: only when the user explicitly saves a non-writable file.
(defun my/sudo-file-name (filename)
  "Prepend a sudo TRAMP prefix to FILENAME if not already present."
  (if (or (string-prefix-p "/sudo:root@localhost:" filename)
          (string-prefix-p (format "/sudo:root@%s:" system-name) filename))
      filename
    (format "/sudo:root@%s:%s" system-name filename)))

(defun my/sudo-save-buffer ()
  "Save current buffer using TRAMP sudo, if the user approves."
  (interactive)
  (when buffer-file-name
    (let ((file (my/sudo-file-name buffer-file-name)))
      (when (yes-or-no-p (format "Save file as %s? " file))
        (write-file file)))))

(advice-add 'save-buffer :around
            (lambda (fn &rest args)
              (if (and (called-interactively-p 'interactive)
                       buffer-file-name
                       (not (file-writable-p buffer-file-name))
                       (not (file-remote-p buffer-file-name)))
                  (my/sudo-save-buffer)
                (apply fn args))))


;;; Buffer Management
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



(defun my/kill-all-but-current-buffer ()
  "Kill all buffers except the current one, after confirmation."
  (interactive)
  (when (y-or-n-p "Kill all other buffers?")
    (mapc #'kill-buffer (cdr (buffer-list (current-buffer))))
    (message "Killed all other buffers")))

(defun my/kill-buffer-and-windows (buffer)
  "Kill BUFFER and delete all windows displaying it."
  (dolist (window (get-buffer-window-list buffer))
    (unless (one-window-p t)
      (delete-window window)))
  (kill-buffer buffer))

(defun my/clean-buffers ()
  "Kill all non-file buffers whose name matches `*...*'."
  (interactive)
  (dolist (buf (buffer-list))
    (when (and (not (buffer-file-name buf))
               (string-match-p "\\`\\*.*\\*\\'" (buffer-name buf)))
      (kill-buffer buf))))

(defun my/save-all-buffers ()
  "Save all file-visiting buffers without prompting."
  (interactive)
  (save-some-buffers t))

(defun my/default-hide-app ()
  "Bury the current buffer or delete its window."
  (interactive)
  (if (one-window-p) (bury-buffer) (delete-window)))

(defun my/switch-to-scratch-buffer (&optional arg)
  "Switch to *scratch* (in another window with prefix ARG)."
  (interactive "P")
  (if arg
      (switch-to-buffer-other-window (get-buffer-create "*scratch*"))
    (switch-to-buffer (get-buffer-create "*scratch*"))))

(defun my/switch-to-messages-buffer (&optional arg)
  "Switch to *Messages* (in another window with prefix ARG)."
  (interactive "P")
  (with-current-buffer (messages-buffer)
    (goto-char (point-max))
    (if arg
        (switch-to-buffer (current-buffer))
      (switch-to-buffer-other-window (current-buffer)))))

(defvar my/temp-buffer-count 0
  "Counter for `my/make-temp-buffer'.")

(defun my/make-temp-buffer ()
  "Create a new *temp-N* scratch buffer."
  (interactive)
  (let ((name (format "*temp-%d*" my/temp-buffer-count)))
    (switch-to-buffer name)
    (message "New temp buffer (%s)" name))
  (cl-incf my/temp-buffer-count))

(defun my/switch-buffer-same-major-mode ()
  "Switch to a buffer with the same major mode."
  (interactive)
  (switch-to-buffer
   (completing-read
    "Buffer: "
    (mapcar #'buffer-name
            (cl-remove-if-not
             (lambda (buf)
               (provided-mode-derived-p
                (buffer-local-value 'major-mode buf) major-mode))
             (buffer-list))))))

(defun my/open-recent-files ()
  "Pick a recent file by base name and open it."
  (interactive)
  (let* ((all recentf-list)
         (tocpl (mapcar (lambda (f) (cons (file-name-nondirectory f) f)) all)))
    (find-file (cdr (assoc-string (completing-read "File: " tocpl nil t) tocpl)))))

(defun my/switch-to-thing ()
  "Switch to a buffer, recent file, or bookmark via a unified prompt."
  (interactive)
  (let* ((buffers (mapcar #'buffer-name (buffer-list)))
         (recent recentf-list)
         (bookmarks (bookmark-all-names))
         (options (append buffers recent bookmarks))
         (selection (completing-read "Switch to: " options nil t)))
    (cond
     ((member selection buffers)   (switch-to-buffer selection))
     ((member selection bookmarks) (bookmark-jump selection))
     (t                             (find-file selection)))))


;;; Window Management
(defun my/switch-or-rotate-buffer ()
  "Single window: switch to previous buffer.  Multiple windows: rotate."
  (interactive)
  (if (one-window-p t)
      (switch-to-buffer (other-buffer (current-buffer) 1))
    (other-window -1)))

(defun my/toggle-or-delete-window-layout ()
  "Single window: split appropriately.  Multiple: delete others."
  (interactive)
  (if (one-window-p t)
      (select-window
       (if (> (frame-width) split-width-threshold)
           (split-window-right)
         (split-window-below)))
    (delete-other-windows)))

(defun my/sticky-window ()
  "Toggle dedication of the current window."
  (interactive)
  (let* ((window (selected-window))
         (dedicated (window-dedicated-p window)))
    (set-window-dedicated-p window (not dedicated))
    (message "[Window %sdedicated to %s]"
             (if dedicated "no longer " "") (buffer-name))))

(defun my/toggle-maximize-buffer ()
  "Maximize buffer (save/restore window config via register `_')."
  (interactive)
  (if (and (= 1 (length (window-list))) (assoc ?_ register-alist))
      (jump-to-register ?_)
    (window-configuration-to-register ?_)
    (delete-other-windows)))

(defun my/switch-to-minibuffer-window ()
  "Select the active minibuffer window, if any."
  (interactive)
  (when (active-minibuffer-window)
    (select-window (active-minibuffer-window))))

(defun my/split-window-vertically-and-focus ()
  "Split vertically (stacked) and focus the new window."
  (interactive)
  (split-window-below)
  (windmove-down))

(defun my/split-window-horizontally-and-focus ()
  "Split horizontally (side-by-side) and focus the new window."
  (interactive)
  (split-window-right)
  (windmove-right))

(defun my/toggle-window-split ()
  "Toggle split orientation when exactly two windows are shown."
  (interactive)
  (when (= (count-windows) 2)
    (let* ((this-buf (window-buffer))
           (next-buf (window-buffer (next-window)))
           (this-edges (window-edges (selected-window)))
           (next-edges (window-edges (next-window)))
           (this-2nd? (not (and (<= (car this-edges) (car next-edges))
                                (<= (cadr this-edges) (cadr next-edges)))))
           (splitter (if (= (car this-edges) (car (window-edges (next-window))))
                         #'split-window-horizontally
                       #'split-window-vertically)))
      (delete-other-windows)
      (let ((first (selected-window)))
        (funcall splitter)
        (when this-2nd? (other-window 1))
        (set-window-buffer (selected-window) this-buf)
        (set-window-buffer (next-window) next-buf)
        (select-window first)
        (when this-2nd? (other-window 1))))))


;;; Navigation and Marking
(defun my/smarter-move-beginning-of-line (arg)
  "Move point to first non-whitespace, then to real BOL on next call."
  (interactive "^p")
  (setq arg (or arg 1))
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))
  (let ((orig (point)))
    (back-to-indentation)
    (when (= orig (point))
      (move-beginning-of-line 1))))

(defun my/previous-function ()
  "Move to beginning of current or previous defun."
  (interactive)
  (beginning-of-defun))

(defun my/next-function ()
  "Move to beginning of next defun."
  (interactive)
  (beginning-of-defun -1))

(defun my/backward-up-sexp (arg)
  "Jump up ARG enclosing sexps, respecting string boundaries."
  (interactive "p")
  (let ((ppss (syntax-ppss)))
    (cond ((elt ppss 3)
           (goto-char (elt ppss 8))
           (my/backward-up-sexp (1- arg)))
          ((backward-up-list arg)))))

(defun my/goto-line-with-line-numbers ()
  "Goto line, temporarily enabling line numbers."
  (interactive)
  (let ((prev display-line-numbers)
        (line-number (read-number "Goto line: ")))
    (unwind-protect
        (progn
          (setq display-line-numbers t)
          (let ((total (count-lines (point-min) (point-max))))
            (if (or (< line-number 1) (> line-number total))
                (error "Line number must be between 1 and %d" total)
              (goto-char (point-min))
              (forward-line (1- line-number))
              (message "[Moved to line %d]" line-number))))
      (setq display-line-numbers prev))))

(defun my/scroll-up-half ()
  "Scroll up half a screen."
  (interactive)
  (scroll-up (max 1 (/ (1- (window-height (selected-window))) 2))))

(defun my/scroll-down-half ()
  "Scroll down half a screen."
  (interactive)
  (scroll-down (max 1 (/ (1- (window-height (selected-window))) 2))))

(defun my/simple-multi-line-below ()
  "Move point down half a screen."
  (interactive)
  (forward-line (floor (window-height) 2))
  (setq this-command 'scroll-up-command))

(defun my/simple-multi-line-above ()
  "Move point up half a screen."
  (interactive)
  (forward-line (- (floor (window-height) 2)))
  (setq this-command 'scroll-down-command))

(defun my/jump-to-symbol-internal (&optional backwardp)
  "Jump to next (or previous, if BACKWARDP) occurrence of symbol at point."
  (let ((point (point)))
    (when-let* ((bounds (bounds-of-thing-at-point 'symbol))
                (beg (car bounds))
                (end (cdr bounds))
                (str (isearch-symbol-regexp
                      (buffer-substring-no-properties beg end))))
      (goto-char (if backwardp beg end))
      (funcall (if backwardp #'search-backward-regexp #'search-forward-regexp)
               str nil t)
      (cond ((<= beg (point) end) (goto-char point))
            (backwardp            (forward-char (- point beg)))
            (t                    (backward-char (- end point)))))))

(defun my/jump-to-previous-like-this ()
  "Jump to previous occurrence of symbol at point."
  (interactive)
  (my/jump-to-symbol-internal t))

(defun my/jump-to-next-like-this ()
  "Jump to next occurrence of symbol at point."
  (interactive)
  (my/jump-to-symbol-internal nil))

(defun my/mark-symbol-at-point ()
  "Mark the symbol at point."
  (interactive)
  (when-let* ((bounds (bounds-of-thing-at-point 'symbol)))
    (goto-char (car bounds))
    (push-mark (cdr bounds) nil t)))


;;; Text Manipulation
(defun my/toggle-paragraph-fill (arg)
  "Fill/unfill paragraph or region.

With numeric ARG (e.g. C-u 80), set fill column explicitly.
Repeated invocation without prefix toggles between filled and unfilled.
In Org mode, dispatches to `org-fill-paragraph'."
  (interactive "P")
  (let ((fill-column (cond
                      (arg (prefix-numeric-value arg))
                      ((eq last-command 'my/toggle-paragraph-fill)
                       (setq this-command nil)
                       (point-max))
                      (t fill-column))))
    (if (derived-mode-p 'org-mode)
        (org-fill-paragraph)
      (fill-paragraph))))

(defun my/unfill-region-or-paragraph (&optional beg end)
  "Unfill paragraph, or region BEG..END if active."
  (interactive "r")
  (let ((fill-column most-positive-fixnum))
    (if (use-region-p) (fill-region beg end) (fill-paragraph))))

(defun my/delete-blank-lines-dwim ()
  "Delete all blank lines around point, or between point and mark."
  (interactive)
  (let ((regexp "^[ \t]*$")
        (col (current-column)))
    (if (region-active-p)
        (flush-lines regexp (region-beginning) (region-end) nil)
      (delete-blank-lines)
      (when (looking-at regexp) (delete-blank-lines)))
    (move-to-column col)))

(defun my/spacing-delete-newlines ()
  "Remove whitespace around point down to a single space."
  (interactive)
  (cycle-spacing -1))

(defun my/indent-region-or-buffer (&optional arg)
  "Indent region or buffer.  With ARG, `untabify' first."
  (interactive)
  (let ((beg (if (use-region-p) (region-beginning) (point-min)))
        (end (if (use-region-p) (region-end) (point-max))))
    (when arg (untabify beg end))
    (indent-region beg end)
    (message "Indented %s." (if (use-region-p) "region" "buffer"))))

(defun my/indent-whole-buffer ()
  "Indent the whole buffer without moving point."
  (interactive)
  (save-excursion (indent-region (point-min) (point-max))))

(defun my/comment-box (b e)
  "Draw a boxed comment around the region BEG..END."
  (interactive "r")
  (let ((end (copy-marker e t)))
    (goto-char b)
    (end-of-line)
    (insert-char ?\s (- fill-column (current-column)))
    (comment-box b end 1)
    (goto-char end)
    (set-marker end nil)))

(defun my/comment-section (start end)
  "Wrap region START..END in a section comment appropriate for the mode."
  (interactive "*r")
  (cond
   ((memq major-mode '(emacs-lisp-mode lisp-interaction-mode racket-mode))
    (let* ((c (substring comment-start 0 1))
           (template (concat c c "*" (make-string (- fill-column 5) ?-) "*/" "\n"
                             c c "*" "%s" "*/" "\n"
                             c c "*" (make-string (- fill-column 5) ?-) "*/" "\n"))
           (body (buffer-substring start end))
           (padded (format (concat "%-" (number-to-string (- fill-column 5)) "s")
                           (concat "    " body))))
      (delete-region start end)
      (insert (format template padded))))
   ((eq major-mode 'c-mode)
    (let ((body (buffer-substring start end)))
      (delete-region start end)
      (insert (format "/*** %s ***/" body))))))

(defun my/replace-in-buffer ()
  "Replace a string or symbol throughout the buffer."
  (interactive)
  (let* ((curr (or (thing-at-point 'symbol)
                   (buffer-substring-no-properties (region-beginning) (region-end))))
         (old (read-string "OLD string: " curr))
         (new (read-string "NEW string: " old)))
    (query-replace old new nil (point-min) (point-max))))

(defun my/batch-replace-strings (alist)
  "Prompt for pairs of search/replace strings, then apply to region."
  (interactive (list (my/batch-replace-strings-prompt)))
  (dolist (pair alist)
    (save-excursion
      (replace-string (car pair) (cdr pair) nil (region-beginning) (region-end)))))

(defun my/batch-replace-strings-prompt ()
  "Read pairs of strings from the minibuffer."
  (let (from alist)
    (while (not (string-empty-p (setq from (read-string "Find (RET to stop): "))))
      (push (cons from (read-string (format "Replace %s with: " from))) alist))
    alist))

(defun my/lookup-word (word)
  "Open Wiktionary for WORD."
  (interactive (list (thing-at-point 'word)))
  (browse-url (format "https://en.wiktionary.org/wiki/%s" word)))

;;; Org Helpers
(defun my/org-apply-format (prefix suffix)
  "Wrap region or line in PREFIX and SUFFIX markup."
  (interactive "sPrefix: \nsSuffix: ")
  (let* ((region (region-active-p))
         (beg (if region
                  (region-beginning)
                (save-excursion
                  (beginning-of-line)
                  (skip-chars-forward " \t")
                  (point))))
         (end (if region (region-end) (line-end-position)))
         (text (buffer-substring-no-properties beg end)))
    (delete-region beg end)
    (insert (concat prefix text suffix))))

(defun my/org-apply-bold          () (interactive) (my/org-apply-format "*" "*"))
(defun my/org-apply-italic        () (interactive) (my/org-apply-format "/" "/"))
(defun my/org-apply-strike-through() (interactive) (my/org-apply-format "+" "+"))
(defun my/org-apply-verbatim      () (interactive) (my/org-apply-format "=" "="))
(defun my/org-apply-code          () (interactive) (my/org-apply-format "~" "~"))

(defun my/align-all-tables ()
  "Align all Org tables in the buffer."
  (interactive)
  (org-table-map-tables #'org-table-align :quietly))

(defun my/insert-timestamp ()
  "Insert a timestamp (Org-aware)."
  (interactive "*")
  (if (eq major-mode 'org-mode)
      (progn (org-insert-time-stamp nil t nil) (insert " "))
    (insert (format-time-string "%Y-%m-%d"))))

(defun my/insert-datestamp ()
  "Insert a date stamp (Org-aware)."
  (interactive "*")
  (if (eq major-mode 'org-mode)
      (progn (org-insert-time-stamp nil nil nil) (insert " "))
    (insert (format-time-string "%Y-%m-%d"))))

;;; Insertion Functions
(defun my/insert-date-iso ()
  "Insert the current date as YYYY-MM-DD."
  (interactive "*")
  (insert (format-time-string "%F")))

(defun my/insert-current-filename ()
  "Insert the current buffer's file name relative to `default-directory'."
  (interactive)
  (insert (file-relative-name buffer-file-name)))

(defun my/generate-password-non-interactive ()
  "Return a random password from `pwgen'."
  (string-trim (shell-command-to-string "pwgen -A 24 1")))

(defun my/generate-password ()
  "Insert a password of user-specified length from `pwgen'."
  (interactive)
  (insert (shell-command-to-string
           (concat "pwgen -A " (read-string "Length: " "24") " 1"))))


;;; Font Related
(defvar my/default-font-height 110
  "Default face height in tenths of a point.")

(defvar my/height-modifier 2
  "Amount to change font height per call.")

(defun my/font-size-increase ()
  "Increase font size by `my/height-modifier'."
  (interactive)
  (dolist (face '(default mode-line mode-line-inactive minibuffer-prompt variable-pitch))
    (let ((h (face-attribute face :height)))
      (set-face-attribute face nil :height
                          (+ (if (numberp h) h my/default-font-height)
                             my/height-modifier)))))

(defun my/font-size-decrease ()
  "Decrease font size by `my/height-modifier'."
  (interactive)
  (dolist (face '(default mode-line mode-line-inactive minibuffer-prompt variable-pitch))
    (let ((h (face-attribute face :height)))
      (set-face-attribute face nil :height
                          (- (if (numberp h) h my/default-font-height)
                             my/height-modifier)))))

(defun my/font-size-reset ()
  "Reset faces to the default height."
  (interactive)
  (dolist (face '(default mode-line mode-line-inactive minibuffer-prompt variable-pitch))
    (set-face-attribute face nil :height my/default-font-height))
  (text-scale-adjust 0))

(defun my/toggle-line-numbers ()
  "Cycle between normal, relative, and disabled line numbers."
  (interactive)
  (setq display-line-numbers
        (pcase display-line-numbers
          ('nil        'relative)
          ('relative   'visual)
          ('visual     't)
          (_           'nil)))
  (message "Line numbers: %s" display-line-numbers))

(defun my/set-opacity (opacity &optional frames)
  "Set frame OPACITY (0-100).  With FRAMES, apply to all frames."
  (interactive
   (list 'interactive (if current-prefix-arg t (list (selected-frame)))))
  (let* ((parameter (if (eq window-system 'pgtk) 'alpha-background 'alpha))
         (opacity (if (eq opacity 'interactive)
                      (read-number "Opacity (0-100): "
                                   (or (frame-parameter nil parameter) 100))
                    opacity))
         (alist `((,parameter . ,opacity))))
    (if (eq frames t)
        (modify-all-frames-parameters alist)
      (dolist (frame frames) (modify-frame-parameters frame alist)))))


;;; Themes
(defun my/load-theme (theme)
  "Load THEME exclusively.  With prefix arg, add to existing themes."
  (interactive
   (list (intern (completing-read "Theme: "
                                  (mapcar #'symbol-name
                                          (custom-available-themes))))))
  (unless (custom-theme-name-valid-p theme)
    (user-error "Invalid theme %S" theme))
  (unless current-prefix-arg
    (mapc #'disable-theme custom-enabled-themes)
    (setq custom-enabled-themes nil))
  (load-theme theme t))

(advice-add 'load-theme :before
            (lambda (&rest _)
              (mapc #'disable-theme custom-enabled-themes)))

(defvar my/toggle-dark-bright-status nil
  "Nil = currently dark (next call goes bright); t = currently bright.")

(defun my/toggle-dark-bright-theme ()
  "Toggle between the dark and bright themes."
  (interactive)
  (cond
   (my/toggle-dark-bright-status
    (when (custom-theme-name-valid-p 'modus-operandi-deuteranopia)
      (disable-theme 'doom-nord)
      (load-theme 'modus-operandi-deuteranopia t))
    (setq my/toggle-dark-bright-status nil)
    (message "Bright theme"))
   (t
    (when (custom-theme-name-valid-p 'doom-nord)
      (disable-theme 'modus-operandi-deuteranopia)
      (load-theme 'doom-nord t))
    (setq my/toggle-dark-bright-status t)
    (message "Dark theme"))))

(defun my/invisible-window-dividers (_theme)
  "Make window dividers and fringe match the current background."
  (let ((bg (face-background 'default)))
    (custom-set-faces
     `(fringe                        ((t :background ,bg :foreground ,bg)))
     `(window-divider                ((t :background ,bg :foreground ,bg)))
     `(window-divider-first-pixel    ((t :background ,bg :foreground ,bg)))
     `(window-divider-last-pixel     ((t :background ,bg :foreground ,bg))))))
(add-hook 'enable-theme-functions #'my/invisible-window-dividers)



;;; Help and Describe Functions/Commands
(defun my/describe-keymap (keymap)
  "Display bindings defined by KEYMAP."
  (interactive
   (list
    (intern
     (completing-read
      "Keymap: " obarray
      (lambda (m) (and (boundp m) (keymapp (symbol-value m))))
      'require-match nil nil (thing-at-point 'symbol)))))
  (with-help-window (help-buffer)
    (with-current-buffer (help-buffer)
      (insert (format "Keymap `%S' bindings:\n\n" keymap)
              (substitute-command-keys (format "\\{%S}" keymap))))))

(defun my/find-symbol (&optional symbol)
  "Jump to definition of SYMBOL via Elisp xref backend."
  (interactive)
  (let ((xref-backend-functions '(elisp--xref-backend))
        (xref-prompt-for-identifier t))
    (if symbol
        (xref-find-definitions symbol)
      (call-interactively #'xref-find-definitions))))

(defun my/describe-symbol-at-point ()
  "Describe the symbol at point (variable, function, or generic symbol)."
  (interactive)
  (let ((sym (or (pcase (variable-at-point) (0 nil) (v v))
                 (function-called-at-point)
                 (intern (or (current-word) "")))))
    (when (symbolp sym) (describe-symbol sym))))

(defun my/describe-elisp-symbol-at-point ()
  "Describe the function or variable at point."
  (interactive)
  (let ((sym (intern-soft (current-word))))
    (cond ((null sym)              (message "[nothing]"))
          ((not (eq t (help-function-arglist sym)))
           (describe-function sym))
          ((boundp sym)            (describe-variable sym))
          (t                       (message "[nothing]")))))

(defun my/describe-major-mode ()
  "Describe only the current major mode."
  (interactive)
  (describe-function major-mode))

(defun my/active-minor-modes ()
  "Return a list of active minor-mode symbols."
  (cl-loop for mode in minor-mode-list
           when (and (boundp mode) (symbol-value mode))
           collect mode))

(defun my/describe-active-minor-mode (mode)
  "Describe an active minor mode chosen from `my/active-minor-modes'."
  (interactive
   (list (completing-read "Minor mode: " (mapcar #'symbol-name (my/active-minor-modes)))))
  (let ((sym (intern mode)))
    (funcall (if (fboundp sym) #'describe-function #'describe-variable) sym)))


;;; Emacs
;; Better C-g / escape (from Doom Emacs)
(defvar doom-escape-hook nil
  "Hook run when `C-g' (or ESC in Evil normal state) is pressed.
If any hook returns non-nil, subsequent hooks are skipped.")

(defun doom/escape (&optional interactive)
  "Run `doom-escape-hook' and quit the current context.

If the minibuffer is active, close it.  Otherwise run all hooks in
`doom-escape-hook'; if any returns non-nil, stop there.  During
macro recording/execution, does nothing (to preserve the macro).
Finally falls through to `keyboard-quit'."
  (interactive (list 'interactive))
  (let ((inhibit-quit t))
    (cond
     ((minibuffer-window-active-p (minibuffer-window))
      (when interactive
        (setq this-command 'abort-recursive-edit))
      (abort-recursive-edit))
     ((run-hook-with-args-until-success 'doom-escape-hook))
     ((or defining-kbd-macro executing-kbd-macro) nil)
     (t
      (unwind-protect (keyboard-quit)
        (when interactive
          (setq this-command 'keyboard-quit)))))))

(with-eval-after-load 'eldoc
  (eldoc-add-command 'doom/escape))

(defvar my/quit-messages
  '(
    ;; ── Doom (1993 / 2016 / Eternal) ───────────────────────────────
    "Please don't leave, there's more demons to toast!"
    "Let's beat it -- This is turning into a bloodbath!"
    "Don't leave yet -- There's a demon around that corner!"
    "Ya know, next time you come in here I'm gonna toast ya."
    "Go ahead and leave. See if I care."
    "Are you sure you want to quit this great editor?"
    "Rip and tear, until it is done."
    "Hurt me plenty."
    "The demons will still be here tomorrow. Will you?"

    ;; ── Portal / Aperture Science ─────────────────────────────────
    "Thank you for participating in this Aperture Science computer-aided enrichment activity."
    "You can't fire me, I quit!"
    "The cake is a lie."
    "We do what we must, because we can."
    "It's been a long time. How have you been?"
    "This was a triumph. I'm making a note here: HUGE SUCCESS."
    "Look at me still talking when there's science to do."
    "When I look out there, it makes me GLaD I'm not you."
    "Please be advised that a noticeable taste of blood is not part of any test protocol."

    ;; ── The Matrix ─────────────────────────────────────────────────
    "Wake up, Mr. Stallman. Wake up and smell the ashes."
    "There is no spoon."
    "Free your mind."
    "Unfortunately, no one can be told what Emacs is. You have to use it for yourself."

    ;; ── Half-Life / Valve ──────────────────────────────────────────
    "The right man in the wrong place can make all the difference in the world."
    "Prepare for unforeseen consequences."

    ;; ── Star Wars / Dune / cult SF ─────────────────────────────────
    "May the Force be with you."
    "Do or do not. There is no try."
    "It's a trap!"
    "These aren't the buffers you're looking for."
    "Fear is the mind-killer."

    ;; ── Monty Python / British humour ──────────────────────────────
    "It's just a flesh wound."
    "Nobody expects the Spanish Inquisition!"
    "This parrot is no more! It has ceased to be!"
    "We are no longer the knights who say Ni."

    ;; ── Douglas Adams ──────────────────────────────────────────────
    "So long, and thanks for all the fish."
    "Don't Panic."
    "Time is an illusion. Lunchtime doubly so."

    ;; ── Terry Pratchett ────────────────────────────────────────────
    "There is no justice. There's just us."
    "The Turtle Moves."

    ;; ── Emacs / GNU / Lisp culture ─────────────────────────────────
    "Emacs will remember that."
    "Emacs, Emacs never changes."
    "Hey! Hey, M-x listen!"
    "One does not simply quit Emacs."
    "The parentheses are balanced. You are not."
    "Free as in freedom, not free as in quitting without saving."
    "Have you considered `M-x butterfly` instead?"
    "GNU Emacs: an extensible, customizable, self-documenting, extremely difficult to quit text editor."
    "Your config will not be missed. It will be rewritten."
    "RIP your unsaved buffers."
    "At least now you have time to recompile your config."

    ;; ── Vim vs Emacs ───────────────────────────────────────────────
    "A Vim user would have already quit three times by now."
    "Emacs is a great operating system, lacking only a decent editor."
    "Vi vi vi is the editor of the beast."

    ;; ── Programming culture ────────────────────────────────────────
    "The monad is just a monoid in the category of endofunctors. What's the problem?"
    "Have you tried turning it off and on again?"
    "Works on my machine."
    "That's not a bug, it's a feature."
    "You had ONE job."
    "Achievement unlocked: you quit Emacs."
    "Error: process `emacs` exited with code 0. This has never happened before."

    ;; ── Anime / internet ───────────────────────────────────────────
    "It's not like I'll miss you or anything, b-baka!"
    "Senpai noticed you're leaving. Senpai is disappointed."
    "Notice me, Emacs-senpai."
    "Omae wa mou shindeiru."
    "You thought you were done, but it was me, Emacs!"
    "It is Wednesday, my dudes."
    "This is the way."
    "This is fine."

    ;; ── Games ──────────────────────────────────────────────────────
    "You are *not* prepared!"
    "Please don't go. The drones need you. They look up to you."
    "It's dangerous to go alone! Take this."
    "You died."
    "The Princess is in another castle."
    "Do a barrel roll!"
    "The last Metroid is in captivity. The galaxy is at peace."

    ;; ── Cosmic horror ──────────────────────────────────────────────
    "That is not dead which can eternal lie, and with strange aeons even death may die."
    "Your session is but a fleeting dream of the Great Old Ones."

    ;; ── Philosophical ──────────────────────────────────────────────
    "The real Emacs was the friends we made along the way."
    "This too shall pass. Probably.")
  "Random messages shown before quitting Emacs.")
(defvar my/last-quit-message-index -1
  "Index of the last quit message shown, to avoid immediate repeats.")

(defun my/random-quit-message ()
  "Return a random quit message, never twice in a row."
  (let* ((n (length my/quit-messages))
         (idx (random n)))
    (when (> n 1)
      (while (= idx my/last-quit-message-index)
        (setq idx (random n))))
    (setq my/last-quit-message-index idx)
    (nth idx my/quit-messages)))

(defun my/quit-emacs (&rest _)
  "Ask for confirmation with a random, non-repeating quit message."
  (yes-or-no-p
   (format "%s  Really quit Emacs?"
           (propertize (my/random-quit-message)
                       'face '(italic default)))))
(setq confirm-kill-emacs #'my/quit-emacs)

(defun my/clean-exit ()
  "Exit Emacs cleanly, listing modified buffers for save if any exist."
  (interactive)
  (if (frame-parameter nil 'client)
      (server-save-buffers-kill-terminal nil)
    (let ((modified (seq-filter
                     (lambda (buf)
                       (and (buffer-modified-p buf) (buffer-file-name buf)))
                     (buffer-list))))
      (if modified
          (progn
            (pop-to-buffer (list-buffers-noselect t modified))
            (message "s to save, C-k to kill, x to execute"))
        (save-buffers-kill-terminal)))))

(defun my/delete-frame-or-kill-emacs ()
  "Delete this frame, or kill Emacs if it is the only frame."
  (interactive)
  (if (> (length (frame-list)) 1)
      (delete-frame)
    (save-buffers-kill-terminal)))


;;; Privacy and Screenshots.
(defun my/redact-region (beg end &optional replacement)
  "Overlay BEG..END with REPLACEMENT (default x's) for screenshots."
  (interactive "r")
  (let ((ov (make-overlay beg end)))
    (overlay-put ov 'redact t)
    (overlay-put ov 'display
                 (or replacement (make-string (- end beg) ?x)))))

(defun my/unredact ()
  "Remove all redaction overlays in the current buffer."
  (interactive)
  (mapc #'delete-overlay
        (seq-filter (lambda (ov) (overlay-get ov 'redact))
                    (overlays-in (point-min) (point-max)))))

(defvar my/picture-dir (expand-file-name "~/Pictures/")
  "Directory for screenshots.")

(defun my/screenshot ()
  "Save a screenshot of the current frame as PNG; add path to kill ring."
  (interactive)
  (let ((filename (expand-file-name (format-time-string "%Y-%m-%d-%H-%M-%S.png")
                                    my/picture-dir)))
    (make-directory my/picture-dir t)
    (with-temp-file filename
      (insert (x-export-frames nil 'png)))
    (kill-new filename)
    (message filename)))

;;; Move Text up and down
(defun my/move-text-internal (arg)
  "Move current line or region up/down by ARG lines."
  (cond
   ((and mark-active transient-mark-mode)
    (if (> (point) (mark)) (exchange-point-and-mark))
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
          (transpose-lines arg))
        (forward-line -1))
      (move-to-column column t)))))

(defun my/move-text-up (arg)
  "Move the current line or region ARG lines up."
  (interactive "*p")
  (my/move-text-internal (- arg)))

(defun my/move-text-down (arg)
  "Move the current line or region ARG lines down."
  (interactive "*p")
  (my/move-text-internal arg))


;;; Miscellaneous
(defun my/cancel ()
  "Cancel the current context: quit minibuffer, deactivate region, or `C-g'."
  (interactive)
  (cond
   ((minibufferp (current-buffer)) (minibuffer-keyboard-quit))
   ((region-active-p)              (deactivate-mark))
   (t                              (keyboard-quit))))

(defun my/disable-features-during-macro-call (orig &rest args)
  "Disable slow features while a macro runs, then apply ORIG to ARGS."
  (let ((post-command-hook nil)
        (font-lock-mode nil)
        (tab-always-indent (or (eq 'complete tab-always-indent) tab-always-indent)))
    (apply orig args)))
(advice-add 'kmacro-call-macro :around #'my/disable-features-during-macro-call)

;; Indent yanked text in prog modes (never in Makefiles).
(dolist (command '(yank yank-pop))
  (advice-add command :after
              (lambda (&rest _)
                (when (and (not current-prefix-arg)
                           (derived-mode-p 'prog-mode)
                           (not (derived-mode-p 'makefile-mode))
                           (region-active-p))
                  (indent-region (region-beginning) (region-end) nil)))))

(defun my/recentf-cleanup ()
  "Drop non-existent files from `recentf-list'."
  (interactive)
  (setq recentf-list (cl-remove-if-not #'file-exists-p recentf-list)))
(advice-add 'recentf-load-list :after #'my/recentf-cleanup)

;;; Reload config
(defun ef/reload-config ()
  "Reload the Emacs configuration."
  (interactive)
  (message "Reloading init.el...")
  (load-file (expand-file-name "init.el" user-emacs-directory))
  (message "Reloading init.el... done"))



;;; Keymappings
;;; Top-level (no prefix)
(keymap-global-set "M-e"                #'my/eval-buffer-or-region)    ; see ef-keybindings
(keymap-global-set "<f5>"               #'my/toggle-or-delete-window-layout)
(keymap-global-set "C-<backspace>"      #'my/backward-delete)
(keymap-global-set "M-#"                #'my/lookup-word)
(keymap-global-set "C-c 0"              #'my/delete-frame-or-kill-emacs)
(keymap-global-set "C-c k"              #'my/kill-all-but-current-buffer)
(keymap-global-set "C-c q"              #'my/default-hide-app)
(keymap-global-set "C-c r"              #'my/open-recent-files)
(keymap-global-set "C-c s r"            #'my/batch-replace-strings)
(keymap-global-set "C-c s s"            #'my/screenshot)
(keymap-global-set "C-c s w"            #'my/replace-in-buffer)
(keymap-global-set "C-c SPC"            #'my/switch-to-thing)
(keymap-global-set "C-c TAB"            #'my/indent-whole-buffer)
(keymap-global-set "<f12>"            #'my/toggle-dark-bright-theme)
(keymap-global-set "C-M-p"              #'my/scroll-down-half)
(keymap-global-set "C-M-n"              #'my/scroll-up-half)
(keymap-global-set "C-M-,"              #'my/simple-multi-line-above)
(keymap-global-set "C-M-."              #'my/simple-multi-line-below)
(keymap-global-set "<f1>"               #'my/describe-elisp-symbol-at-point)
(keymap-global-set "C-x -"              #'my/toggle-window-split)
(keymap-global-set "C-x 2"              #'my/split-window-vertically-and-focus)
(keymap-global-set "C-x 3"              #'my/split-window-horizontally-and-focus)
(keymap-global-set "C-c C-r" #'ef/reload-config)   ; ← was C-x r
(keymap-global-set "M-<up>"   #'my/move-text-up)
(keymap-global-set "M-<down>" #'my/move-text-down)

;;; Remaps (respect user bindings)
;; (define-key global-map [remap kill-line]              #'my/kill-dwim)
(keymap-global-set "<remap> <kill-line>" #'my/kill-dwim)


(define-key global-map [remap move-beginning-of-line] #'my/smarter-move-beginning-of-line)
(define-key global-map [remap backward-up-list]       #'my/backward-up-sexp)
(define-key global-map [remap goto-line]              #'my/goto-line-with-line-numbers)
(define-key global-map [remap fill-paragraph]         #'my/toggle-paragraph-fill)
(define-key global-map [remap save-buffers-kill-terminal] #'my/clean-exit)

(define-key global-map [remap keyboard-quit]        #'doom/escape)
(define-key global-map [remap abort-recursive-edit] #'doom/escape)


;;; `C-z' prefix (ef-super-keymap defined in ef-keybindings.el)
(with-eval-after-load 'ef-keybindings
  (when (boundp 'ef-super-keymap)
    (keymap-set ef-super-keymap "0" #'my/switch-or-rotate-buffer)
    (keymap-set ef-super-keymap ";" #'my/sticky-window)))

;;; `C-c b' buffer prefix
(with-eval-after-load 'ef-keybindings
  (when (boundp 'ef-buffer-keymap)
    (keymap-set ef-buffer-keymap "," #'my/switch-to-minibuffer-window)
    (keymap-set ef-buffer-keymap "0" #'my/switch-to-messages-buffer)
    (keymap-set ef-buffer-keymap "i" #'my/indent-region-or-buffer)
    (keymap-set ef-buffer-keymap "m" #'my/toggle-maximize-buffer)
    (keymap-set ef-buffer-keymap "n" #'my/make-temp-buffer)
    (keymap-set ef-buffer-keymap "s" #'my/switch-to-scratch-buffer)))

;;; `C-c f' file prefix
(with-eval-after-load 'ef-keybindings
  (when (boundp 'ef-file-keymap)
    (keymap-set ef-file-keymap "x" #'my/spacing-delete-newlines)
    (keymap-set ef-file-keymap "," #'my/jump-to-previous-like-this)
    (keymap-set ef-file-keymap "." #'my/jump-to-next-like-this)))

;;; `C-c E' custom-functions prefix
(with-eval-after-load 'ef-keybindings
  (when (boundp 'ef-functions-keymap)
    (keymap-set ef-functions-keymap "b" #'my/comment-box)
    (keymap-set ef-functions-keymap "c" #'my/cancel)))




;;; Code Ends Here
(provide 'ef-functions)
;;; ef-functions.el ends here
