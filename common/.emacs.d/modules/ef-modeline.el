;;; ef-modeline.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:
(require 'cl-lib)
(require 'seq)
(require 'subr-x)
(require 'nerd-icons nil t)
(require 'which-func)

(defgroup ef-modeline nil
  "Custom mode-line configuration."
  :group 'mode-line)

(defcustom ef/modeline-icon-font-family "Berkeley Nerd Font"
  "Font family used for mode-line icons.
Must match a Nerd Font variant available on the system — usually the
same family used for `default' in ef-fonts.el."
  :type 'string
  :group 'ef-modeline)

;; (setq nerd-icons-font-family "Berkeley Nerd Font")
;; (setq nerd-icons-font-family ef/modeline-icon-font-family)
(when (featurep 'nerd-icons)
  (setq nerd-icons-font-family ef/modeline-icon-font-family))

(setq mode-line-default-help-echo nil
      ;; show-help-function nil
      )

(defface ef/modeline-icon-face
  '((t :inherit mode-line-emphasis :height 1.25))
  "Face for mode-line Nerd Font icons.
Bumped above `mode-line' height so glyphs are legible at mode-line size.")

(defun ef/modeline-selected-p ()
  "Non-nil when the current mode line belongs to the selected window.
Falls back to t on Emacs < 30."
  (if (fboundp 'mode-line-window-selected-p)
      (mode-line-window-selected-p)
    t))


(defcustom ef/modeline-truncate-length 9
  "Truncate mode-line strings longer than this in narrow windows."
  :type 'natnum
  :group 'ef-modeline)

(defun ef/modeline-cut-middle (str)
  "Cut STR in the middle if the window is narrow."
  (if (and (< (window-width) split-width-threshold)
           (> (length str) ef/modeline-truncate-length))
      (let* ((half (/ ef/modeline-truncate-length 2))
             (head (substring str 0 half))
             (tail (substring str (- (length str) half))))
        (concat head "…" tail))
    str))


(defconst ef/modeline-major-mode-icons
  '(


    (org-mode              . " ")
    (org-agenda-mode       . " ")
    (emacs-lisp-mode       . " ")
    (lisp-interaction-mode . " ")
    (latex-mode            . " ")
    (LaTeX-mode            . " ")
    (python-ts-mode          . " ")
    (python-mode          . " ")
    (dired-mode            . "󰉋 ")
    (fundamental-mode      . "F ")
    (markdown-mode         . " ")
    (gfm-mode              . " ")
    (yaml-mode             . " ")
    (yaml-ts-mode          . " ")
    (json-mode             . " ")
    (json-ts-mode          . " ")
    (css-mode              . " ")
    (css-ts-mode           . " ")
    (toml-mode             . " ")
    (toml-ts-mode          . " ")
    (lua-mode              . " ")
    (lua-ts-mode           . " ")
    (js-mode               . " ")
    (js-ts-mode            . " ")
    (typescript-mode       . "󰛦 ")
    (typescript-ts-mode    . "󰛦 ")
    (html-mode             . " ")
    (html-ts-mode          . " ")
    (sh-mode               . " ")
    (bash-ts-mode          . " ")
    (conf-mode             . " ")
    (dockerfile-mode       . " ")

    (vimrc-mode            . " ")
    (ron-mode              . " ")

    ;; ─── Tools ───
    (vterm-mode        . " ")
    (eshell-mode       . " ")
    (shell-mode        . " ")
    (compilation-mode  . " ")
    (help-mode         . " ")
    (helpful-mode      . " ")
    (ibuffer-mode      . " ")
    (Info-mode         . " ")
    (Man-mode          . " ")
    (occur-mode        . " ")
    (grep-mode         . " ")
    (calendar-mode     . " ")

    ;; ─── Git ───
    (magit-status-mode   . " ")
    (magit-log-mode      . " ")
    (magit-diff-mode     . " ")
    (magit-revision-mode . " ")
    (magit-mode          . " ")

    ;; ─── Documents ───
    (pdf-view-mode . " ")
    (doc-view-mode . " ")
    (image-mode    . " "))
  "Alist mapping major modes to their icons."
  )

(defconst ef/modeline-minor-mode-icons
  '(

    (corfu-mode         . " ")   ; key icon
    (yas-minor-mode     . " ")   ; snippet icon
    ;; (abbrev-mode        . " ")   ; abbreviation/cog
    ;; (subword-mode       . " ")   ; font/case icon
    ;; (eldoc-mode         . "󰙎 ")   ; info icon
    ;; (rainbow-mode       . " ")   ; tint/droplet
    ;; (valign-mode        . "󰑭 ")   ; ruler/align
    ;; (hs-minor-mode      . " ")   ; fold/compress
    ;; (outline-minor-mode . " ")   ; list tree
    ;; (visual-line-mode   . " ")   ; paragraph/wrap
    ;; (auto-revert-mode   . " ")   ; refresh

    ;; ─── Evil ───
    (evil-snipe-local-mode           . " ")   ; search
    (evil-goggles-mode               . "󰈈 ")   ; eye
    ;; (evil-commentary-mode            . "󰅺 ")   ; comment
    ;; (evil-collection-unimpaired-mode . " ")   ; operator/cogs

    ;; ─── Development ───
    (flymake-mode       . " ")   ; check-circle
    (flyspell-mode      . " ")   ; spell-check
    ;; (which-key-mode     . "󰌌 ")   ; keyboard
    ;; (gcmh-mode          . " ")   ; memory/chip
    (apheleia-mode      . " ")   ; wand/magic
    (org-indent-mode    . " ")   ; indent
    ;; (winner-mode        . "󰋚 ")   ; history
    ;; (so-long-mode       . " ")   ; warning triangle





    )
  "Alist mapping minor-mode variables to their icons."

  )

;;; Renderes
(defun ef/modeline-major-mode-icon ()
  "Return the clickable icon for the current major mode."
  (let ((icon (alist-get major-mode ef/modeline-major-mode-icons)))
    (propertize (or icon "λ ")
                ;; 'face 'mode-line-emphasis
                'face 'ef/modeline-icon-face
                'help-echo "Major mode\nmouse-1: Menu\nmouse-2: Help"
                'mouse-face 'mode-line-highlight
                'local-map mode-line-major-mode-keymap)))

(defun ef/modeline-minor-mode-icons ()
  "Return the icons for all enabled minor modes with a mapped icon."
  (when (ef/modeline-selected-p)
    (let (icons)
      (dolist (entry ef/modeline-minor-mode-icons)
        (when (and (boundp (car entry))
                   (symbol-value (car entry)))
          (push (cdr entry) icons)))
      (when icons
        (propertize (apply #'concat (nreverse icons))
                    'face 'shadow
                    'help-echo "Enabled minor modes")))))

(defun ef/modeline-modified-icon ()
  "Return a state icon: lock, floppy, or ban — or empty string."
  (if (not (ef/modeline-selected-p))
      (cond (buffer-read-only
             (if (fboundp 'nerd-icons-octicon)
                 (concat (nerd-icons-octicon "nf-oct-lock" :v-adjust -0.05 :face 'ef/modeline-icon-face ) " ")
               "RO "))
            ((buffer-modified-p)
             (if (fboundp 'nerd-icons-faicon)
                 (concat (nerd-icons-faicon "nf-fa-floppy_o" :v-adjust -0.05 :face 'ef/modeline-icon-face) " ")
               "* "))
            ((and buffer-file-name
                  (not (file-exists-p buffer-file-name)))
             (if (fboundp 'nerd-icons-faicon)
                 (concat (nerd-icons-faicon "nf-fa-ban" :v-adjust -0.05 :face 'ef/modeline-icon-face) " ")
               "? "))
            (t ""))))

(defun ef/modeline-remote-icon ()
  "Return a remote-file icon or empty string, only in the selected window."
  (if (not (and (ef/modeline-selected-p)
                buffer-file-name
                (file-remote-p buffer-file-name)))
      ""
    (if (fboundp 'nerd-icons-faicon)
        (concat (nerd-icons-faicon "nf-fa-rss" :v-adjust -0.02 :face 'ef/modeline-icon-face) " ")
      "@ ")))


(defun ef/modeline-buffer-name ()
  (propertize (ef/modeline-cut-middle (format-mode-line "%b"))
              'face (cond
                     ((and buffer-file-name
                           (not (file-exists-p buffer-file-name)))
                      'warning)
                     (buffer-read-only 'mode-line-buffer-id)
                     ((buffer-modified-p) 'bold)
                     (t 'mode-line-buffer-id))
              'help-echo (format "Buffer: %s" (buffer-name))))

(defun ef/modeline-coding-system ()
  "Return a `[mnemonic]' warning for non-UTF-8 coding, only in the selected window."
  (when (and (ef/modeline-selected-p)
             (bound-and-true-p buffer-file-coding-system))
    (let ((mnemonic (format-mode-line "%z")))
      (unless (or (string-empty-p mnemonic) (string-equal mnemonic "U"))
        (propertize (format "[%s]" mnemonic) 'face 'warning)))))


(defun ef/modeline-vc-branch (string)
  "Prepend a git icon to STRING and shorten long branch names."
  (if (not (and (stringp string) (string-prefix-p "Git" string)))
      string
    (let* ((branch (string-trim-left (substring string 3) "[:/ ]"))
           (branch (if (> (length branch) 25)
                       (concat (substring branch 0 25) "…")
                     branch))
           (icon   (if (fboundp 'nerd-icons-octicon)
                       (nerd-icons-octicon "nf-oct-git_branch" :v-adjust -0.05)
                     "Git")))
      (concat icon " " branch))))

(when (fboundp 'vc-git-mode-line-string)
  (advice-add 'vc-git-mode-line-string
              :filter-return #'ef/modeline-vc-branch))


(defvar ef/modeline-flymake-map
  (let ((map (make-sparse-keymap)))
    (define-key map [mode-line down-mouse-1] #'flymake-show-buffer-diagnostics)
    (define-key map [mode-line down-mouse-3] #'flymake-show-project-diagnostics)
    map)
  "Keymap for the Flymake mode-line indicator.")

(defun ef/modeline-flymake-summary ()
  "Return [E1 W2 N3] with clickable map, or nil when clean."
  (when (and (ef/modeline-selected-p)
             (bound-and-true-p flymake-mode))
    (let ((e 0) (w 0) (n 0))
      (dolist (d (flymake-diagnostics))
        (let* ((type (flymake-diagnostic-type d))
               (sev  (flymake--lookup-type-property
                      type 'severity (warning-numeric-level :warning))))
          (cond ((>= sev (warning-numeric-level :error))   (cl-incf e))
                ((>= sev (warning-numeric-level :warning)) (cl-incf w))
                (t                                         (cl-incf n)))))
      (when (> (+ e w n) 0)
        (let ((help "mouse-1: buffer diagnostics\nmouse-3: project diagnostics"))
          (concat " ["
                  (and (> e 0)
                       (propertize (format "E%d" e)
                                   'face 'error
                                   'local-map ef/modeline-flymake-map
                                   'help-echo help
                                   'mouse-face 'mode-line-highlight))
                  (and (> w 0)
                       (concat (and (> e 0) " ")
                               (propertize (format "W%d" w)
                                           'face 'warning
                                           'local-map ef/modeline-flymake-map
                                           'help-echo help
                                           'mouse-face 'mode-line-highlight)))
                  (and (> n 0)
                       (concat (and (> (+ e w) 0) " ")
                               (propertize (format "N%d" n)
                                           'face 'shadow
                                           'local-map ef/modeline-flymake-map
                                           'help-echo help
                                           'mouse-face 'mode-line-highlight)))
                  "] "))))))


(defun ef/modeline-macro-recording ()
  "Return a red dot when `defining-kbd-macro' is active, in the selected window."
  (when (and (ef/modeline-selected-p) defining-kbd-macro)
    (propertize "● " 'face 'error
                'help-echo "Recording keyboard macro")))

(defun ef/modeline-window-number ()
  "Return the current window's position in the window list.
Shown only when more than one window is visible."
  (let* ((wins (window-list nil 'no-minibuffer))
         (pos  (cl-position (selected-window) wins)))
    (when (and pos (> (length wins) 1))
      (propertize (format "%d " (1+ pos))
                  'face 'mode-line-emphasis
                  'help-echo "Window number (M-x ace-window to jump)"))))

(defun ef/modeline-project-name ()
  "Return the current project's directory name, or nil."
  (when-let* ((proj (project-current nil))
              (root (project-root proj)))
    (let ((name (file-name-nondirectory (directory-file-name root))))
      (propertize (format "%s " name)
                  'face 'font-lock-string-face
                  'help-echo (format "Project: %s" root)))))


(defun ef/modeline-frame-name ()
  "Return the current frame's name, when on a client frame or multiple frames."
  (when (and (ef/modeline-selected-p)
             (or (frame-parameter nil 'client)
                 (> (length (frame-list)) 1)))
    (when-let* ((name (alist-get 'name (frame-parameters))))
      (propertize (capitalize name) 'face 'mode-line-emphasis))))


(defun ef/modeline-evil-state ()
  "Return a compact Evil state tag: N/I/V/M/O/R/E."
  (when (bound-and-true-p evil-mode)
    (let ((state (or evil-state 'normal)))
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
               ('normal   'mode-line-emphasis)
               ('insert   'success)
               ('visual   'warning)
               ('emacs    'shadow)
               (_         'mode-line-emphasis))
       'help-echo (format "Evil state: %s" state)))))

(defun ef/modeline-narrow ()
  "Return \" Narrow \" when the buffer is narrowed."
  (when (and (ef/modeline-selected-p)
             (buffer-narrowed-p)
             (not (memq major-mode '(Info-mode help-mode special-mode))))
    (propertize " Narrow " 'face 'warning
                'help-echo "Buffer is narrowed (C-x n w to widen)")))


(defun ef/modeline-selection-info ()
  "Return selection size when a region is active."
  (when (use-region-p)
    (let ((chars (- (region-end) (region-beginning)))
          (lines (count-lines (region-beginning) (region-end))))
      (propertize (format "(%dL:%dC) " lines chars)
                  'face 'mode-line-emphasis
                  'help-echo "Selection (lines:characters)"))))


(defun ef/modeline-window-number ()
  "Return the window's position in the window list (1-indexed).
Only when more than one window is visible."
  (let* ((wins (window-list nil 'no-minibuffer))
         (pos  (cl-position (selected-window) wins)))
    (when (and pos (> (length wins) 1))
      (propertize (format "%d " (1+ pos))
                  'face 'mode-line-emphasis
                  'help-echo "Window number (M-x ace-window to jump)"))))

(defun ef/modeline-which-function ()
  "Return the current defun name, or nil."
  (when (and (ef/modeline-selected-p)
             (bound-and-true-p which-function-mode)
             (derived-mode-p 'prog-mode 'text-mode))
    (let ((name (or (gethash (selected-window) which-func-table)
                    which-func-unknown)))
      (unless (string= name which-func-unknown)
        (propertize name 'face 'font-lock-function-name-face
                    'help-echo (format "Current definition: %s" name))))))
(which-function-mode 1)

(setq mode-line-compact nil
      mode-line-percent-position nil
      mode-line-right-align-edge 'right-margin
      mode-line-position-column-line-format '(" L%l:C%C"))

(column-number-mode 1)
(line-number-mode 1)

(setq eol-mnemonic-unix ""
      eol-mnemonic-dos       (propertize "[CR+LF]" 'face 'warning)
      eol-mnemonic-mac       (propertize "[CR]"    'face 'warning)
      eol-mnemonic-undecided (propertize "[?]"     'face 'error))


(setq display-time-format " %a, %b %e 󰥔 %R"
      battery-mode-line-format "󰁹 %p%%%")
                                        ;

(display-time-mode 1)
(display-battery-mode 1)   ; ← 1, not bare call (bare toggles)

(defun ef/modeline-right-info ()
  "Return a right-aligned clock + battery segment.
Uses `:align-to' so it stays pinned to the right edge regardless of
the mode-line content to its left."
  (let* ((battery (if (and (boundp 'battery-mode-line-string)
                           battery-mode-line-string
                           (not (string-empty-p battery-mode-line-string)))
                      battery-mode-line-string
                    ""))
         (time    (if (and (boundp 'display-time-string)
                           display-time-string
                           (not (string-empty-p display-time-string)))
                      display-time-string
                    ""))
         (width   (+ (string-width battery) (string-width time) 1)))
    (concat
     (propertize " " 'display `(space :align-to (- right ,width)))
     battery
     " "
     time)))


(setq-default mode-line-modes
              '((:propertize ("" mode-line-process)
                             face font-lock-warning-face)))

(setq-default mode-line-misc-info
              '((:eval
                 (let ((items (seq-remove
                               (lambda (item)
                                 (memq item '(display-time-string
                                              battery-mode-line-string)))
                               global-mode-string)))
                   (when items (format-mode-line items))))))

(setq-default mode-line-format
              '("%e"
                "%["
                " "
                (:propertize " " display (raise +0.4))
                (:propertize " " display (raise -0.4))
                (:propertize "λ " face font-lock-keyword-face)
                (:eval (ef/modeline-macro-recording))
                (:eval (ef/modeline-window-number))
                (:eval (ef/modeline-modified-icon))
                ;; (:eval (ef/modeline-remote-icon))
                (:eval (ef/modeline-evil-state))
                (:eval (ef/modeline-window-number))
                (:eval (ef/modeline-major-mode-icon))
                (:eval (ef/modeline-project-name))
                (:eval (ef/modeline-buffer-name))
                " "
                ;; (:eval (ef/modeline-minor-mode-icons))
                " "
                ;; vc-mode
                mode-line-position
                " "
                (:eval (ef/modeline-flymake-summary))
                (:eval (ef/modeline-which-function))
                (:eval (ef/modeline-selection-info))
                (:eval (ef/modeline-coding-system))
                (:eval (ef/modeline-narrow))
                " "
                mode-line-misc-info
                mode-line-modes
                (:eval (ef/modeline-frame-name))
                (:eval (ef/modeline-right-info))
                "%]"))





(provide 'ef-modeline)
;;; ef-modeline.el ends here
