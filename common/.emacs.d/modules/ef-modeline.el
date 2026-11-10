;;; ef-modeline.el --- Custom mode-line  -*- lexical-binding: t; indent-tabs-mode: nil; -*-

;;; Commentary:
;;
;; A compact, selected-window-aware mode line.
;;
;; Layout is driven by three segment lists (see `ef/modeline-left-segments',
;; `ef/modeline-center-segments', `ef/modeline-right-segments').  Each entry
;; is one of:
;;   - a function symbol: called inside an error-isolating wrapper
;;   - a string: inserted literally
;;   - a variable symbol: rendered by the mode-line machinery
;;
;; Enable or disable everything with `ef-modeline-mode'; disabling restores
;; the previous `mode-line-format'.  After changing a segment list outside
;; Customize, run `M-x ef/modeline-rebuild'.
;;
;; Icons come from `nerd-icons' lookups (no raw private-use glyphs), with
;; plain-text fallbacks when the package or an icon name is unavailable.

;;; Code:

(require 'cl-lib)
(require 'seq)
(require 'subr-x)
(require 'project)
(require 'which-func)
(require 'nerd-icons nil t)

;; Silence the byte-compiler for optional packages.
(defvar evil-state)
(defvar evil-local-mode)
(defvar flymake-mode)
(defvar visual-line-mode)
(defvar eglot--managed-mode)
(defvar lsp-mode)
(defvar multiple-cursors-mode)
(defvar iedit-mode)
(defvar iedit-occurrences-overlays)
(defvar battery-mode-line-string)
(defvar display-time-string)
(declare-function flymake-diagnostics "flymake")
(declare-function flymake-diagnostic-type "flymake")
(declare-function flymake-show-buffer-diagnostics "flymake")
(declare-function flymake-show-project-diagnostics "flymake")
(declare-function nerd-icons-icon-for-mode "nerd-icons")
(declare-function eglot-current-server "eglot")
(declare-function lsp-workspaces "lsp-mode")
(declare-function mc/num-cursors "multiple-cursors-core")
(declare-function treesit-parser-list "treesit")
(declare-function magit-status "magit-status")
(declare-function vc-dir "vc-dir")
(declare-function ef/modeline-rebuild "ef-modeline")

;;;; Customization

(defgroup ef-modeline nil
  "Custom mode-line configuration."
  :group 'mode-line)

(defun ef/modeline--set-segments (symbol value)
  "Set SYMBOL to VALUE and rebuild the mode line if it is active."
  (set-default symbol value)
  (when (bound-and-true-p ef-modeline-mode)
    (ef/modeline-rebuild)))

(defcustom ef/modeline-icon-font-family "Berkeley Nerd Font"
  "Font family used for mode-line icons.
Must match a Nerd Font variant available on the system, usually the
same family used for `default' in ef-fonts.el."
  :type 'string
  :group 'ef-modeline)

(defcustom ef/modeline-left-segments
  '(ef/modeline-macro-recording
    ef/modeline-window-number
    ef/modeline-modified-icon
    ef/modeline-remote
    ef/modeline-evil-state
    ef/modeline-major-mode-icon
    ef/modeline-project-name
    ef/modeline-buffer-name
    " "
    ef/modeline-vc)
  "Segments on the left: identity of the buffer (what and where)."
  :type '(repeat sexp)
  :set #'ef/modeline--set-segments
  :group 'ef-modeline)

(defcustom ef/modeline-center-segments
  '(" "
    mode-line-position
    " "
    ef/modeline-save-message
    ef/modeline-flymake-summary
    ef/modeline-which-function
    ef/modeline-selection-info
    ef/modeline-multi-edit
    ef/modeline-coding-system
    ef/modeline-narrow
    ef/modeline-minor-modes
    ef/modeline-edit-state
    ef/modeline-indentation
    ef/modeline-word-count
    " "
    ef/modeline-global-info
    ef/modeline-process
    ef/modeline-frame-name)
  "Segments in the middle: context about the editing session."
  :type '(repeat sexp)
  :set #'ef/modeline--set-segments
  :group 'ef-modeline)

(defcustom ef/modeline-right-segments
  '(ef/modeline-input-method
    ef/modeline-lsp
    ef/modeline-treesit
    ef/modeline-battery
    ef/modeline-clock)
  "Segments pinned to the right: ambient information."
  :type '(repeat sexp)
  :set #'ef/modeline--set-segments
  :group 'ef-modeline)

(defcustom ef/modeline-responsive-tiers
  '((110 . (ef/modeline-indentation
            ef/modeline-word-count
            ef/modeline-treesit
            ef/modeline-frame-name
            ef/modeline-global-info
            ef/modeline-minor-modes))
    (80  . (ef/modeline-which-function
            ef/modeline-edit-state
            ef/modeline-multi-edit
            ef/modeline-lsp))
    (60  . (ef/modeline-project-name
            ef/modeline-clock
            ef/modeline-input-method)))
  "Segments to hide in narrow windows.
Each entry is (WIDTH . SEGMENT-FUNCTIONS): when the window is narrower
than WIDTH columns, those segments render nothing.  Set to nil to turn
responsive hiding off."
  :type '(alist :key-type natnum :value-type (repeat symbol))
  :group 'ef-modeline)

(defcustom ef/modeline-battery-low-threshold 20
  "Battery percentage at or below which the battery turns `warning'."
  :type 'natnum
  :group 'ef-modeline)

(defcustom ef/modeline-battery-critical-threshold 10
  "Battery percentage at or below which the battery turns `error'."
  :type 'natnum
  :group 'ef-modeline)

(defcustom ef/modeline-truncate-length 9
  "Truncate mode-line strings longer than this in narrow windows."
  :type 'natnum
  :group 'ef-modeline)

(defcustom ef/modeline-save-flash-duration 0.7
  "Seconds the save indicator stays visible."
  :type 'number
  :group 'ef-modeline)

(defcustom ef/modeline-vc-branch-max-length 25
  "Maximum length of the branch name shown in the mode line."
  :type 'natnum
  :group 'ef-modeline)

(defcustom ef/modeline-selection-line-count-limit 200000
  "Above this many selected characters, skip counting lines.
`count-lines' is O(n); this keeps redisplay fast on huge regions."
  :type 'natnum
  :group 'ef-modeline)

(defcustom ef/modeline-word-count-limit 500000
  "Skip the word count in buffers larger than this many characters."
  :type 'natnum
  :group 'ef-modeline)

(defcustom ef/modeline-major-mode-icons
  '((fundamental-mode . "F "))
  "Overrides mapping major modes to icon strings.
Matched with `provided-mode-derived-p', so derived modes inherit.
Modes not listed here fall back to `nerd-icons-icon-for-mode'."
  :type '(alist :key-type symbol :value-type string)
  :group 'ef-modeline)

(defcustom ef/modeline-minor-mode-alist nil
  "Alist mapping minor-mode variables to icon/lighter strings.
Example: ((corfu-mode . \"key \") (yas-minor-mode . \"snip \")).
Empty by default, in which case the segment renders nothing."
  :type '(alist :key-type symbol :value-type string)
  :group 'ef-modeline)

(defface ef/modeline-icon-face
  '((t :inherit mode-line-emphasis :height 1.25))
  "Face for mode-line Nerd Font icons.
Bumped above `mode-line' height so glyphs are legible at mode-line size."
  :group 'ef-modeline)

;;;; Setup

(when (featurep 'nerd-icons)
  (setq nerd-icons-font-family ef/modeline-icon-font-family))

(setq mode-line-default-help-echo nil)

;;;; Helpers

(defun ef/modeline-selected-p ()
  "Non-nil when the current mode line belongs to the selected window.
Falls back to t on Emacs < 30."
  (if (fboundp 'mode-line-window-selected-p)
      (mode-line-window-selected-p)
    t))

(defun ef/modeline--face (face)
  "Return FACE in the selected window, `mode-line-inactive' elsewhere.
Used to dim segments instead of hiding them, so the layout stays stable."
  (if (ef/modeline-selected-p) face 'mode-line-inactive))

(defun ef/modeline--hidden-p (fn)
  "Non-nil when segment function FN is hidden at the current window width.
See `ef/modeline-responsive-tiers'."
  (and ef/modeline-responsive-tiers
       (symbolp fn)
       (let ((width (window-width)))
         (seq-some (lambda (tier)
                     (and (< width (car tier)) (memq fn (cdr tier))))
                   ef/modeline-responsive-tiers))))

(defun ef/modeline--safe (fn)
  "Call FN, returning a visible error marker instead of signaling.
A broken segment can then never break the whole mode line.  Segments
listed in `ef/modeline-responsive-tiers' render nothing in narrow windows."
  (unless (ef/modeline--hidden-p fn)
    (condition-case err
        (funcall fn)
      (error (propertize (format "[%s]" (car err))
                         'face 'error
                         'help-echo (format "%S: %s" fn
                                            (error-message-string err)))))))

(defmacro ef/modeline--on-click (&rest body)
  "Return a mouse command running BODY in the clicked window."
  `(lambda (event)
     (interactive "e")
     (with-selected-window (posn-window (event-start event))
       ,@body)))

(defun ef/modeline--icon (fn name fallback &optional v-adjust face)
  "Call nerd-icons function FN with icon NAME, appending a space.
Return FALLBACK if FN is unavailable or NAME is unknown.
V-ADJUST defaults to -0.05.  FACE defaults to `ef/modeline-icon-face'
for icons and is also applied to FALLBACK when given."
  (or (and (fboundp fn)
           (condition-case nil
               (concat (funcall fn name
                                :v-adjust (or v-adjust -0.05)
                                :face (or face 'ef/modeline-icon-face))
                       " ")
             (error nil)))
      (if (and face fallback) (propertize fallback 'face face) fallback)))

(defun ef/modeline--bare-icon (fn name)
  "Return the icon NAME from FN without extra text, or the empty string."
  (or (and (fboundp fn)
           (condition-case nil (funcall fn name) (error nil)))
      ""))

(defun ef/modeline-cut-middle (str)
  "Cut STR in the middle if the window is narrow."
  (if (and (< (window-width) split-width-threshold)
           (> (length str) ef/modeline-truncate-length))
      (let* ((half (/ ef/modeline-truncate-length 2))
             (head (substring str 0 half))
             (tail (substring str (- (length str) half))))
        (concat head "…" tail))
    str))

;;;; Per-buffer file state (cached, no disk access during redisplay)

(defvar-local ef/modeline--file-missing nil
  "Non-nil when the buffer's file no longer exists on disk.
Refreshed by hooks, never during redisplay.")

(defun ef/modeline--refresh-file-state (&rest _)
  "Update `ef/modeline--file-missing' for the current buffer.
Remote files are skipped so TRAMP can never block redisplay."
  (setq ef/modeline--file-missing
        (and buffer-file-name
             (not (file-remote-p buffer-file-name))
             (not (file-exists-p buffer-file-name)))))

(add-hook 'find-file-hook #'ef/modeline--refresh-file-state)
(add-hook 'after-save-hook #'ef/modeline--refresh-file-state)
(add-hook 'after-revert-hook #'ef/modeline--refresh-file-state)
(add-hook 'window-selection-change-functions #'ef/modeline--refresh-file-state)

;;;; Save indicator

(defvar-local ef/modeline-save-message nil
  "Transient save indicator shown in the mode line, or nil.")

(defvar-local ef/modeline-save-timer nil
  "Timer that clears `ef/modeline-save-message'.")

(defun ef/modeline-show-saved ()
  "Flash a \"Saved\" indicator in the mode line after saving."
  (when (timerp ef/modeline-save-timer)
    (cancel-timer ef/modeline-save-timer))
  (setq-local ef/modeline-save-message
              (concat (ef/modeline--bare-icon 'nerd-icons-mdicon
                                              "nf-md-content_save")
                      (propertize " Saved " 'face 'success)))
  (force-mode-line-update)
  (setq-local ef/modeline-save-timer
              (run-with-timer
               ef/modeline-save-flash-duration nil
               (lambda (buf)
                 (when (buffer-live-p buf)
                   (with-current-buffer buf
                     (setq ef/modeline-save-message nil
                           ef/modeline-save-timer nil)
                     (force-mode-line-update))))
               (current-buffer))))

(add-hook 'after-save-hook #'ef/modeline-show-saved)

;;;; Segments: identity (left)

(defvar-local ef/modeline--major-icon-cache nil
  "Cons of (MAJOR-MODE . ICON-STRING) for the current buffer.")

(defun ef/modeline--lookup-major-icon ()
  "Compute the icon string for the current `major-mode'."
  (or (cdr (seq-find (lambda (entry)
                       (provided-mode-derived-p major-mode (car entry)))
                     ef/modeline-major-mode-icons))
      (when (fboundp 'nerd-icons-icon-for-mode)
        (let ((icon (condition-case nil
                        (nerd-icons-icon-for-mode major-mode)
                      (error nil))))
          ;; `nerd-icons-icon-for-mode' returns a non-icon value when
          ;; nothing matches; real icons always carry a face.
          (when (and (stringp icon)
                     (not (string-empty-p icon))
                     (get-text-property 0 'face icon))
            (let ((copy (concat icon " ")))
              (add-face-text-property 0 (length copy)
                                      'ef/modeline-icon-face t copy)
              copy))))
      (concat (format-mode-line mode-name) " ")))

(defun ef/modeline-major-mode-icon ()
  "Return the clickable icon for the current major mode."
  (unless (eq (car ef/modeline--major-icon-cache) major-mode)
    (setq ef/modeline--major-icon-cache
          (cons major-mode (ef/modeline--lookup-major-icon))))
  (propertize (cdr ef/modeline--major-icon-cache)
              'help-echo "Major mode\nmouse-1: Menu\nmouse-2: Help"
              'mouse-face 'mode-line-highlight
              'local-map mode-line-major-mode-keymap))

(defun ef/modeline-modified-icon ()
  "Return a state icon (lock, floppy, or ban) in the selected window.
Returns the empty string otherwise."
  (if (not (ef/modeline-selected-p))
      ""
    (cond (buffer-read-only
           (ef/modeline--icon 'nerd-icons-octicon "nf-oct-lock" "RO "))
          ((buffer-modified-p)
           (ef/modeline--icon 'nerd-icons-faicon "nf-fa-floppy_o" "* "))
          (ef/modeline--file-missing
           (ef/modeline--icon 'nerd-icons-faicon "nf-fa-ban" "? "))
          (t ""))))

(defun ef/modeline-remote ()
  "Return the remote host (with an icon) for TRAMP buffers, or nil.
Only parses `default-directory'; it never contacts the host."
  (when (file-remote-p default-directory)
    (let ((host   (or (file-remote-p default-directory 'host) "remote"))
          (user   (file-remote-p default-directory 'user))
          (method (file-remote-p default-directory 'method)))
      (concat (ef/modeline--icon 'nerd-icons-mdicon "nf-md-ssh" "@" nil 'warning)
              (propertize (concat (ef/modeline-cut-middle host) " ")
                          'face 'warning
                          'help-echo (format "Remote: %s%s via %s"
                                             (if user (concat user "@") "")
                                             host
                                             (or method "?")))))))

(defun ef/modeline-buffer-name ()
  "Return the buffer name, styled by buffer state."
  (propertize (ef/modeline-cut-middle (buffer-name))
              'face (cond (ef/modeline--file-missing 'warning)
                          (buffer-read-only 'mode-line-buffer-id)
                          ((buffer-modified-p) 'bold)
                          (t 'mode-line-buffer-id))
              'help-echo (format "Buffer: %s" (buffer-name))))

(defun ef/modeline-macro-recording ()
  "Return a red dot when `defining-kbd-macro' is active, in the selected window."
  (when (and (ef/modeline-selected-p) defining-kbd-macro)
    (propertize "● " 'face 'error
                'help-echo "Recording keyboard macro")))

(defun ef/modeline-window-number ()
  "Return the window's position in the window list (1-indexed).
Shown only when more than one window is visible."
  (let* ((wins (window-list nil 'no-minibuffer))
         (pos  (cl-position (selected-window) wins)))
    (when (and pos (> (length wins) 1))
      (propertize (format "%d " (1+ pos))
                  'face 'mode-line-emphasis
                  'help-echo "Window number"))))

(defun ef/modeline-evil-state ()
  "Return a compact Evil state tag: N/I/V/M/O/R/E.
Nothing is shown in buffers where Evil is not active."
  (when (and (bound-and-true-p evil-local-mode) evil-state)
    (let ((state evil-state))
      (propertize
       (pcase state
         ('normal   "N ")
         ('insert   "I ")
         ('visual   "V ")
         ('motion   "M ")
         ('operator "O ")
         ('replace  "R ")
         ('emacs    "E ")
         (_         "? "))
       'face (pcase state
               ('insert 'success)
               ('visual 'warning)
               ('emacs  'shadow)
               (_       'mode-line-emphasis))
       'help-echo (format "Evil state: %s" state)))))

(defvar-local ef/modeline--project 'unset
  "Cached project name for the current buffer, nil, or the symbol `unset'.")

(defvar ef/modeline-project-map
  (let ((map (make-sparse-keymap)))
    (define-key map [mode-line mouse-1]
                (ef/modeline--on-click (call-interactively
                                        #'project-switch-project)))
    map)
  "Keymap for the project segment.")

(defun ef/modeline-project-name ()
  "Return the current project's directory name, or nil.
The lookup runs once per buffer and is skipped for remote directories.
Dimmed, not hidden, in unselected windows."
  (when (eq ef/modeline--project 'unset)
    (setq ef/modeline--project
          (and (not (file-remote-p default-directory))
               (when-let* ((proj (project-current nil)))
                 (file-name-nondirectory
                  (directory-file-name (project-root proj)))))))
  (when ef/modeline--project
    (propertize (concat ef/modeline--project " ")
                'face (ef/modeline--face 'font-lock-string-face)
                'mouse-face 'mode-line-highlight
                'local-map ef/modeline-project-map
                'help-echo (format "Project: %s\nmouse-1: switch project"
                                   ef/modeline--project))))

(defun ef/modeline-open-vc ()
  "Open Magit status if available, otherwise `vc-dir'."
  (interactive)
  (if (fboundp 'magit-status)
      (magit-status)
    (vc-dir default-directory)))

(defvar ef/modeline-vc-map
  (let ((map (make-sparse-keymap)))
    (define-key map [mode-line mouse-1]
                (ef/modeline--on-click (ef/modeline-open-vc)))
    map)
  "Keymap for the VC segment.")

(defun ef/modeline-vc ()
  "Return a branch segment, colored by VC state, or nil.
Parses `vc-mode' directly, so no advice on VC internals is needed and no
disk access happens.  State characters: `:' edited, `@' added, `!'
conflict/removed, `?' unregistered.  Dimmed in unselected windows."
  (when (stringp vc-mode)
    (let* ((matched (string-match "\\` *[[:alpha:]]+\\([-:@!?/^&]?\\)" vc-mode))
           (state   (if matched (match-string 1 vc-mode) ""))
           (start   (if matched (match-end 0) 0))
           (branch  (string-trim (substring-no-properties vc-mode start)))
           (max     ef/modeline-vc-branch-max-length)
           (face    (pcase state
                      (":" 'warning)
                      ("@" 'success)
                      ("!" 'error)
                      (_   'shadow)))
           (mark    (pcase state
                      (":" "*")
                      ("@" "+")
                      ("!" "!")
                      ("?" "?")
                      (_   ""))))
      (unless (string-empty-p branch)
        (concat
         (ef/modeline--icon 'nerd-icons-octicon "nf-oct-git_branch" "")
         (propertize (concat (if (> (length branch) max)
                                 (concat (substring branch 0 max) "…")
                               branch)
                             mark " ")
                     'face (ef/modeline--face face)
                     'mouse-face 'mode-line-highlight
                     'local-map ef/modeline-vc-map
                     'help-echo (format "Branch: %s\nmouse-1: VC status"
                                        branch)))))))

;;;; Segments: context (center)

(defvar ef/modeline-flymake-map
  (let ((map (make-sparse-keymap)))
    (define-key map [mode-line down-mouse-1] #'flymake-show-buffer-diagnostics)
    (define-key map [mode-line down-mouse-3] #'flymake-show-project-diagnostics)
    map)
  "Keymap for the Flymake mode-line indicator.")

(defun ef/modeline--flymake-severity (type)
  "Return a numeric severity for Flymake diagnostic TYPE."
  (cond ((fboundp 'flymake--severity)
         (flymake--severity type))
        ((fboundp 'flymake--lookup-type-property)
         (flymake--lookup-type-property
          type 'severity (warning-numeric-level :warning)))
        (t (pcase type
             (:error   (warning-numeric-level :error))
             (:warning (warning-numeric-level :warning))
             (_        0)))))

(defun ef/modeline--flymake-part (count label face help)
  "Return a clickable LABEL+COUNT string with FACE, or nil when COUNT is 0."
  (when (> count 0)
    (propertize (format "%s%d" label count)
                'face face
                'local-map ef/modeline-flymake-map
                'help-echo help
                'mouse-face 'mode-line-highlight)))

(defun ef/modeline-flymake-summary ()
  "Return \" [E1 W2 N3] \" with a clickable map, or nil when clean.
Computed only for the selected window to keep redisplay cheap."
  (when (and (ef/modeline-selected-p)
             (bound-and-true-p flymake-mode))
    (let ((e 0) (w 0) (n 0)
          (err-level  (warning-numeric-level :error))
          (warn-level (warning-numeric-level :warning)))
      (dolist (d (flymake-diagnostics))
        (let ((sev (ef/modeline--flymake-severity (flymake-diagnostic-type d))))
          (cond ((>= sev err-level)  (cl-incf e))
                ((>= sev warn-level) (cl-incf w))
                (t                   (cl-incf n)))))
      (when (> (+ e w n) 0)
        (let* ((help  "mouse-1: buffer diagnostics\nmouse-3: project diagnostics")
               (parts (delq nil
                            (list (ef/modeline--flymake-part e "E" 'error help)
                                  (ef/modeline--flymake-part w "W" 'warning help)
                                  (ef/modeline--flymake-part n "N" 'shadow help)))))
          (concat " [" (string-join parts " ") "] "))))))

(defun ef/modeline-which-function ()
  "Return the current defun name, or nil.
Selected window only: `which-func-table' is keyed by the selected window."
  (when (and (ef/modeline-selected-p)
             (bound-and-true-p which-function-mode)
             (derived-mode-p 'prog-mode 'text-mode))
    (let ((name (or (gethash (selected-window) which-func-table)
                    which-func-unknown)))
      (unless (string= name which-func-unknown)
        (propertize name 'face 'font-lock-function-name-face
                    'help-echo (format "Current definition: %s" name))))))

(defun ef/modeline-selection-info ()
  "Return selection size when a region is active in the selected window."
  (when (and (ef/modeline-selected-p) (use-region-p))
    (let ((chars (abs (- (region-end) (region-beginning)))))
      (propertize
       (if (> chars ef/modeline-selection-line-count-limit)
           (format "(%dC) " chars)
         (format "(%dL:%dC) "
                 (count-lines (region-beginning) (region-end))
                 chars))
       'face 'mode-line-emphasis
       'help-echo "Selection (lines:characters)"))))

(defun ef/modeline-multi-edit ()
  "Return a cursor/occurrence count for multiple-cursors or iedit."
  (when (ef/modeline-selected-p)
    (cond ((and (bound-and-true-p multiple-cursors-mode)
                (fboundp 'mc/num-cursors))
           (propertize (format "MC:%d " (mc/num-cursors))
                       'face 'warning
                       'help-echo "Multiple cursors"))
          ((and (bound-and-true-p iedit-mode)
                (boundp 'iedit-occurrences-overlays))
           (propertize (format "IE:%d " (length iedit-occurrences-overlays))
                       'face 'warning
                       'help-echo "iedit occurrences")))))

(defun ef/modeline-coding-system ()
  "Return a `[ENCODING EOL]' warning for non-UTF-8 or non-LF buffers.
Only shown in the selected window."
  (when (and (ef/modeline-selected-p) buffer-file-coding-system)
    (let* ((cs   buffer-file-coding-system)
           (base (coding-system-base cs))
           (eol  (coding-system-eol-type cs))
           (enc? (not (memq base '(utf-8 utf-8-emacs prefer-utf-8
                                         undecided us-ascii no-conversion))))
           (eol? (memq eol '(1 2))))
      (when (or enc? eol?)
        (propertize (string-trim
                     (format "[%s%s]"
                             (if enc? (symbol-name base) "")
                             (pcase eol (1 " CRLF") (2 " CR") (_ ""))))
                    'face 'warning
                    'help-echo (format "Coding system: %s" cs))))))

(defun ef/modeline-narrow ()
  "Return \" Narrow \" when the buffer is narrowed.
Dimmed, not hidden, in unselected windows."
  (when (and (buffer-narrowed-p)
             (not (memq major-mode '(Info-mode help-mode special-mode))))
    (propertize " Narrow "
                'face (ef/modeline--face 'warning)
                'help-echo "Buffer is narrowed (C-x n w to widen)")))

(defun ef/modeline-minor-modes ()
  "Return icons for enabled minor modes in `ef/modeline-minor-mode-alist'."
  (when (and ef/modeline-minor-mode-alist (ef/modeline-selected-p))
    (let (icons)
      (dolist (entry ef/modeline-minor-mode-alist)
        (when (and (boundp (car entry)) (symbol-value (car entry)))
          (push (cdr entry) icons)))
      (when icons
        (propertize (apply #'concat (nreverse icons))
                    'face 'shadow
                    'help-echo "Enabled minor modes")))))

(defun ef/modeline-edit-state ()
  "Return flags for overwrite mode, visual line mode, and dedicated windows."
  (when (ef/modeline-selected-p)
    (let (parts)
      (when overwrite-mode
        (push (propertize "OVR" 'face 'warning
                          'help-echo "Overwrite mode")
              parts))
      (when (bound-and-true-p visual-line-mode)
        (push (propertize "VL" 'face 'shadow
                          'help-echo "Visual line mode")
              parts))
      (when (window-dedicated-p)
        (push (string-trim-right
               (ef/modeline--icon 'nerd-icons-mdicon "nf-md-pin" "PIN"))
              parts))
      (when parts
        (concat (string-join (nreverse parts) " ") " ")))))

(defun ef/modeline-indentation ()
  "Return the indentation style (tabs or spaces) in code and text buffers."
  (when (and (ef/modeline-selected-p)
             (derived-mode-p 'prog-mode 'text-mode))
    (propertize (if indent-tabs-mode
                    (format "Tab:%d " tab-width)
                  "Sp ")
                'face 'shadow
                'help-echo (if indent-tabs-mode
                               "Indenting with tabs"
                             "Indenting with spaces"))))

;; Word count: computed from an idle timer, never during redisplay.
(defvar-local ef/modeline--word-count nil
  "Cached word count for the current prose buffer.")

(defvar-local ef/modeline--word-count-tick nil
  "Buffer modification tick at which `ef/modeline--word-count' was computed.")

(defvar ef/modeline--word-count-timer nil
  "Idle timer updating the word count.")

(defun ef/modeline--update-word-count ()
  "Refresh the cached word count of the current buffer when needed."
  (when (and (derived-mode-p 'text-mode)
             (not (minibufferp))
             (< (buffer-size) ef/modeline-word-count-limit)
             (not (eql ef/modeline--word-count-tick
                       (buffer-chars-modified-tick))))
    (setq ef/modeline--word-count (count-words (point-min) (point-max))
          ef/modeline--word-count-tick (buffer-chars-modified-tick))
    (force-mode-line-update)))

(defun ef/modeline-word-count ()
  "Return the cached word count in prose buffers (text, Org, Markdown)."
  (when (and ef/modeline--word-count (derived-mode-p 'text-mode))
    (propertize (format "%dw " ef/modeline--word-count)
                'face 'shadow
                'help-echo "Word count")))

(defun ef/modeline-global-info ()
  "Return `global-mode-string' minus the clock and battery.
Those two are rendered in the right-aligned block instead."
  (let ((items (seq-remove
                (lambda (item)
                  (memq item '(display-time-string battery-mode-line-string)))
                global-mode-string)))
    (when items (format-mode-line items))))

(defun ef/modeline-process ()
  "Return `mode-line-process' with a warning face."
  (when mode-line-process
    (propertize (format-mode-line mode-line-process)
                'face 'font-lock-warning-face)))

(defun ef/modeline-frame-name ()
  "Return the current frame's name, on a client frame or with multiple frames."
  (when (and (ef/modeline-selected-p)
             (or (frame-parameter nil 'client)
                 (> (length (frame-list)) 1)))
    (when-let* ((name (alist-get 'name (frame-parameters))))
      (propertize (capitalize name) 'face 'mode-line-emphasis))))

;;;; Segments: ambient (right)

(defun ef/modeline-input-method ()
  "Return the active input method's title, if any."
  (when (and (ef/modeline-selected-p) current-input-method)
    (propertize (concat current-input-method-title " ")
                'face 'warning
                'help-echo (format "Input method: %s" current-input-method))))

(defun ef/modeline--lsp-text (name ok)
  "Return an LSP status segment for client NAME; OK means connected."
  (concat (ef/modeline--icon 'nerd-icons-mdicon "nf-md-lightning_bolt"
                             "LSP " nil (if ok 'success 'warning))
          (propertize (if ok "" "off ")
                      'face 'warning
                      'help-echo (format "%s: %s" name
                                         (if ok "connected" "no server")))))

(defun ef/modeline-lsp ()
  "Return the Eglot or lsp-mode connection status, or nil."
  (when (ef/modeline-selected-p)
    (cond ((bound-and-true-p eglot--managed-mode)
           (ef/modeline--lsp-text
            "Eglot" (and (fboundp 'eglot-current-server)
                         (eglot-current-server))))
          ((bound-and-true-p lsp-mode)
           (ef/modeline--lsp-text
            "lsp-mode" (and (fboundp 'lsp-workspaces)
                            (lsp-workspaces)))))))

(defun ef/modeline-treesit ()
  "Return a \"TS\" marker when a tree-sitter parser is active."
  (when (and (ef/modeline-selected-p)
             (fboundp 'treesit-parser-list)
             (treesit-parser-list))
    (propertize "TS " 'face 'shadow
                'help-echo "Tree-sitter parser active")))

(defun ef/modeline--nonempty-string (sym)
  "Return the value of SYM if it is a non-empty string, else the empty string."
  (let ((val (and (boundp sym) (symbol-value sym))))
    (if (and (stringp val) (not (string-empty-p val))) val "")))

(defvar ef/modeline--battery-state nil
  "Cons of (PERCENT . CHARGING-P) from the last battery update, or nil.")

(defun ef/modeline--battery-update (data)
  "Record battery percentage and charging state from DATA.
Runs from `battery-update-functions', so nothing is polled during
redisplay."
  (let* ((p   (cdr (assq ?p data)))
         (b   (cdr (assq ?B data)))
         (pct (and (stringp p)
                   (string-match-p "[0-9]" p)
                   (round (string-to-number p)))))
    (setq ef/modeline--battery-state
          (and pct
               (cons pct (and (stringp b)
                              (string-prefix-p "charging" (downcase b))))))))

(defun ef/modeline--battery-icon-name (pct charging)
  "Return the mdicon name for battery level PCT, CHARGING or not."
  (let ((level (* 10 (max 1 (min 10 (/ (+ pct 5) 10))))))
    (cond ((and charging (< level 100))
           (format "nf-md-battery_charging_%d" level))
          (charging "nf-md-battery_charging_100")
          ((< level 100) (format "nf-md-battery_%d" level))
          (t "nf-md-battery"))))

(defun ef/modeline-battery ()
  "Return the battery text with a level-aware icon.
Green while charging, yellow when low, red when critical (see
`ef/modeline-battery-low-threshold' and
`ef/modeline-battery-critical-threshold').  Icons are built at render
time so they carry the right face."
  (let ((text (ef/modeline--nonempty-string 'battery-mode-line-string)))
    (unless (string-empty-p text)
      (let* ((pct      (car ef/modeline--battery-state))
             (charging (cdr ef/modeline--battery-state))
             (face     (cond (charging 'success)
                             ((and pct (<= pct ef/modeline-battery-critical-threshold))
                              'error)
                             ((and pct (<= pct ef/modeline-battery-low-threshold))
                              'warning)))
             (name     (if pct
                           (ef/modeline--battery-icon-name pct charging)
                         "nf-md-battery"))
             (icon     (or (ef/modeline--icon 'nerd-icons-mdicon name nil nil face)
                           (ef/modeline--icon 'nerd-icons-mdicon "nf-md-battery"
                                              nil nil face)
                           "")))
        (concat icon
                (if face (propertize text 'face face) text)
                " ")))))

(defun ef/modeline-clock ()
  "Return the date and time with an icon.
Built at render time so the icon carries the right face."
  (let ((text (ef/modeline--nonempty-string 'display-time-string)))
    (unless (string-empty-p text)
      (concat " "
              (ef/modeline--icon 'nerd-icons-mdicon "nf-md-calendar_clock" "")
              text
              " "))))

(defun ef/modeline-clock-battery ()
  "Return battery and clock together.
Kept for custom segment lists that still reference it."
  (let ((str (concat (ef/modeline-battery) (ef/modeline-clock))))
    (unless (string-empty-p str) str)))

(defun ef/modeline-right-legacy ()
  "Return all right segments pinned right with `:align-to'.
Fallback for Emacs versions without `mode-line-format-right-align'."
  (let ((str (apply #'concat
                    (mapcar (lambda (seg)
                              (cond ((stringp seg) seg)
                                    ((functionp seg)
                                     (let ((out (ef/modeline--safe seg)))
                                       (if (stringp out) out "")))
                                    (t "")))
                            ef/modeline-right-segments))))
    (concat (propertize " " 'display
                        `(space :align-to (- right ,(string-width str))))
            str)))

;;;; Built-in modes and variables

(setq mode-line-compact nil
      mode-line-percent-position nil
      mode-line-right-align-edge 'right-fringe
      column-number-indicator-zero-based nil
      mode-line-position-column-line-format '(" L%l:C%C"))

(column-number-mode 1)
(line-number-mode 1)
(which-function-mode 1)

;; Keep these format strings plain.  The icons are added at render time by
;; `ef/modeline-clock-battery': embedding them here means they are looked up
;; once at load time, and `format-time-string' / battery formatting can drop
;; the face that selects the Nerd Font family.
(setq display-time-format "%a, %b %e %R"
      battery-mode-line-format "%p%%")

;; Register before enabling the mode so the first update is captured.
(add-hook 'battery-update-functions #'ef/modeline--battery-update)

(display-time-mode 1)
(display-battery-mode 1)

;;;; Format construction

(defun ef/modeline--segment-construct (seg)
  "Turn segment entry SEG into a mode-line construct."
  (cond ((stringp seg) seg)
        ((functionp seg) `(:eval (ef/modeline--safe #',seg)))
        (t seg)))

(defun ef/modeline--build-format ()
  "Build `mode-line-format' from the segment lists."
  `("%e"
    "%["                                ; shows recursive-edit depth
    " "
    ;; Invisible raised/lowered spaces: force a taller mode line.
    (:propertize " " display (raise +0.4))
    (:propertize " " display (raise -0.4))
    (:propertize "λ " face font-lock-keyword-face)
    ,@(mapcar #'ef/modeline--segment-construct ef/modeline-left-segments)
    ,@(mapcar #'ef/modeline--segment-construct ef/modeline-center-segments)
    ,@(if (boundp 'mode-line-format-right-align)
          `(mode-line-format-right-align
            ,@(mapcar #'ef/modeline--segment-construct
                      ef/modeline-right-segments))
        '((:eval (ef/modeline--safe #'ef/modeline-right-legacy))))
    "%]"))

;;;; Global minor mode

(defvar ef/modeline--saved-format 'unset
  "The `mode-line-format' default saved before `ef-modeline-mode' was enabled.")

(defun ef/modeline-rebuild ()
  "Rebuild the mode line after changing a segment list."
  (interactive)
  (when (bound-and-true-p ef-modeline-mode)
    (setq-default mode-line-format (ef/modeline--build-format))
    (force-mode-line-update t)))

(defun ef/modeline--start-timers ()
  "Start the idle timer that refreshes word counts."
  (unless (timerp ef/modeline--word-count-timer)
    (setq ef/modeline--word-count-timer
          (run-with-idle-timer 1 t #'ef/modeline--update-word-count))))

(defun ef/modeline--stop-timers ()
  "Stop the word count timer."
  (when (timerp ef/modeline--word-count-timer)
    (cancel-timer ef/modeline--word-count-timer))
  (setq ef/modeline--word-count-timer nil))

;;;###autoload
(define-minor-mode ef-modeline-mode
  "Toggle the ef mode line globally.
Disabling restores the `mode-line-format' that was in place before."
  :global t
  :group 'ef-modeline
  (cond
   (ef-modeline-mode
    (when (eq ef/modeline--saved-format 'unset)
      (setq ef/modeline--saved-format (default-value 'mode-line-format)))
    (setq-default mode-line-format (ef/modeline--build-format))
    (ef/modeline--start-timers))
   (t
    (unless (eq ef/modeline--saved-format 'unset)
      (setq-default mode-line-format ef/modeline--saved-format)
      (setq ef/modeline--saved-format 'unset))
    (ef/modeline--stop-timers)))
  (force-mode-line-update t))

(ef-modeline-mode 1)

(provide 'ef-modeline)
;;; ef-modeline.el ends here
