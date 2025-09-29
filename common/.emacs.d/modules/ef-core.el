;;; ef-core.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:
;;; Abbrev
(use-package abbrev
  :ensure nil
  :custom
  (abbrev-file-name (expand-file-name "etc/abbrev.el" user-emacs-directory))
  (save-abbrevs 'silently)
  (abbrev-suggest t)
  (abbrev-suggest-hint-threshold 2)
  (setq-default abbrev-mode t))
;;; Auto-revert
;;;; Auto-Revert Mode is a minor mode that affects only the current
;;;; buffer.  When enabled, it reverts the buffer when the file on
;;;; disk changes.
(use-package autorevert
  :ensure nil
  :defer t
  :hook (dired-mode . auto-revert-mode)
  :custom
  (auto-revert-interval 3)
  (auto-revert-avoid-polling t)
  (auto-revert-check-vc-info t)
  (auto-revert-verbose nil)
  (global-auto-revert-non-file-buffers t)
  (auto-revert-use-notify t)
  (auto-revert-avoid-polling t)
  ;; (setq global-auto-revert-ignore-modes '(Buffer-menu-mode))
  :config
  (global-auto-revert-mode)
  )

;;; Bookmarks
(use-package bookmark
  :ensure nil
  :custom
  (bookmark-use-annotations nil)
  (bookmark-automatically-show-annotations nil)
  (bookmark-default-file (expand-file-name "bookmarks" user-emacs-directory))
  (bookmark-save-flag 1))

;;; Browser Url
(use-package browse-url
  :ensure nil
  :custom
  ;; Use firefox as the default browser
  (browse-url-browser-function 'browse-url-firefox))


;;; Calendar
(use-package calendar
  :ensure nil
  :commands (calendar)
  :config
  (setopt calendar-mark-diary-entries-flag nil)
  (setopt calendar-mark-holidays-flag t)
  (setopt calendar-mode-line-format nil)
  (setopt calendar-time-display-form
          '(12-hours ":" minutes
                     (when time-zone (format "(%s)" time-zone))))
  (setopt calendar-week-start-day 1)
  (setopt calendar-date-style 'iso)
  (setopt calendar-time-zone-style 'numeric)
  (setopt calendar-standard-time-zone-name "+0300")
  )



;;; Compilation
(use-package compile
  :ensure nil
  :config
  (setq compilation-always-kill t)
  (setq compilation-ask-about-save nil)
  (setq compilation-auto-jump-to-first-error 'if-location-known)
  (setq compilation-context-lines 10)
  (setq compilation-scroll-output 'first-error)
  (setq compilation-skip-threshold 0)
  (setq next-error-verbose nil)
  (setq compilation-window-height 100)
  (setq compilation-message-face 'default)
  (setq next-error-message-highlight nil)
  (setq compilation-read-command nil))


;;; Cus-edit
;; (use-package cus-edit
;;   :ensure nil
;;   :config
;;   (setq-default custom-file (concat "custom.el" user-emacs-directory))
;;   (when (file-exists-p custom-file)
;;     (load custom-file))
;;   )

;;; Dabbrev
(use-package dabbrev
  :ensure nil
  :defer t
  :commands (dabbrev-expand dabbrev-completion)
  ;;  Swap M-/ and C-M-/
  :bind (("M-/" . dabbrev-expand)
         ("C-M-/" . dabbrev-completion))

  :config
  (setq dabbrev-abbrev-char-regexp "\\sw\\|\\s_")
  (setq dabbrev-abbrev-skip-leading-regexp "[$*/=~']")
  (setq dabbrev-backward-only nil)
  (setq dabbrev-case-distinction nil)
  (setq dabbrev-case-fold-search t)
  (setq dabbrev-case-replace 'case-replace)
  (setq dabbrev-check-other-buffers t)
  (setq dabbrev-eliminate-newlines t)
  (setq dabbrev-upcase-means-case-search t)
  (setq dabbrev-ignored-buffer-modes
        '(archive-mode image-mode docview-mode pdf-view-mode))
  (add-to-list 'dabbrev-ignored-buffer-regexps "\\` ")
  ;; Available since Emacs 29 (Use `dabbrev-ignored-buffer-regexps' on older Emacs)
  (add-to-list 'dabbrev-ignored-buffer-modes 'authinfo-mode)
  (add-to-list 'dabbrev-ignored-buffer-modes 'doc-view-mode)
  (add-to-list 'dabbrev-ignored-buffer-modes 'pdf-view-mode)
  (add-to-list 'dabbrev-ignored-buffer-modes 'tags-table-mode)

  )


;;; Display Line Numbers
;; Line numbers on the side of the window
(use-package display-line-numbers
  :ensure nil
  :defer t
  :bind ("C-c t l" . display-line-numbers-mode)
  :hook
  ((prog-mode . display-line-numbers-mode)

   ;; (text-mode .display-line-numbers-mode)
   )
  :config
  ;; If non-nil, count number of lines to use for line number width.
  (setq display-line-numbers-width-start t)
  (setq-default display-line-numbers 'visual)
  (setq-default display-line-numbers-widen t)
  ;; Dynamically manage line-number size
  (setq-default display-line-numbers-width nil)
  (setq-default display-line-numbers-current-absolute t)
  )

;;; Dictionary
;; `dictionary'
;; Install dict or dictd for offline use
(use-package dictionary
  :ensure nil
  :defer t
  :bind ("C-c d" . dictionary-search)
  :config
  (setopt dictionary-server "dict.org"
          dictionary-default-popup-strategy "lev"
          dictionary-read-word-function 'dictionary-read-word-default
          dictionary-search-interface nil
          dictionary-read-dictionary-function 'dictionary-completing-read-dictionary
          dictionary-create-buttons nil
          dictionary-use-single-buffer t))


;;; Delete Selection Mode
;; Delete the selected text upon the insertion of new text.
(use-package delsel
  :ensure nil
  :defer t
  :hook (after-init . delete-selection-mode))

;;; General Properties
(use-package emacs
  :ensure nil
  :config
  ;; Personal Information
  (setopt user-full-name "Ephrem Getachew")
  (setopt user-login-name "ephrem")
  (setopt user-mail-address "ephrem2166@gmail.com")
  (setopt user-emacs-directory "~/dotfiles/common/.emacs.d/")
  ;; Genertal Settings
  (setopt visible-bell nil)
  (setopt ring-bell-function #'ignore)
  (setopt default-input-method nil)
  (setopt use-short-answers t)
  (setopt confirm-nonexistent-file-or-buffer nil)
  (setopt confirm-kill-emacs 'y-or-n-p)
  (setopt confirm-kill-processes t)
  (setopt read-answer-short t)
  (setopt warning-suppress-types '((lexical-binding)))
  (setopt undo-limit (* 13 160000)
          undo-strong-limit (* 13 240000)
          undo-outer-limit (* 13 24000000))
  (setopt use-file-dialog nil)
  (setopt use-dialog-box nil)
  ;; Language
  (set-language-environment 'utf-8)
  (set-default-coding-systems 'utf-8)
  ;; Improve Emacs' responsiveness by delaying syntax highlighting during input
  (setopt redisplay-skip-fontification-on-input t)
  ;; (setopt ad-redefinition-action 'accept)

  (setopt resize-mini-windows 'grow-only)
  (setopt window-divider-default-bottom-width 1)
  (setopt window-divider-default-places t)
  (setopt window-divider-default-right-width 1)

  (setopt select-enable-clipboard t)

  (setopt sentence-end-double-space nil)

  ;; Help Related
  (setopt help-enable-completion-auto nil
          help-enable-autoload nil
          help-enable-symbol-autoload nil
          help-window-select t)

  ;;(setopt bookmark-save-flag 1)
  (setopt warning-minimum-level :error)
  (setopt word-wrap-by-category t)

  ;; Debug on error
  (setopt debug-on-error init-file-debug)
  (setopt delete-pair-blink-delay 0.03)

  ;; warn when opening files bigger than 100MB
  (setopt large-file-warning-threshold 1000000000)

  ;; Mouse
  (setopt mouse-drag-and-drop-region t
          mouse-drag-and-drop-region-cross-program t
          mouse-yank-at-point t)
;;;; Trash
  (setopt delete-by-moving-to-trash t)


  ;; Cursor Style Bar
  (setopt cursor-type 'bar)
  (setopt blink-cursor-mode nil)
  (setopt x-stretch-cursor t)
  (setopt cursor-intangible-mode t)
  ;; Truncate
  (setopt truncate-string-ellipsis "...")
  ;; Position undelines at the descent line
  (setopt x-underline-at-descent-line t)
  ;; Auto save options
  (setopt kill-buffer-delete-auto-save-files t)
  (setopt mark-even-if-inactive nil)
  ;; Show keystrokes
  (setopt echo-keystrokes 0.1)
  (setopt show-trailing-whitespace nil)
  (setopt fill-column 80)
  ;; Title bar of visible frames
  ;; (setopt frame-title-format '("Emacs" emacs-version))
  ;; Avoid automatic frame resizing when adjusting settings.
  ;;(setopt global-text-scale-adjust-resizes-frames nil)

  ;; Do not show an arrow at the top/bottomin the fringe and empty lines
  (setq-default indicate-buffer-boundaries nil)
  (setq-default indicate-empty-lines nil)

  ;; Remove warnings from narrow-to-region, upcase-region...
  (dolist (cmd '(list-timers narrow-to-region upcase-region downcase-region
                             erase-buffer scroll-left dired-find-alternate-file))
    (put cmd 'disabled nil))

  (setq-default left-fringe-width 8)
  (setq-default right-fringe-width 8)
  ;; Do not show an arrow at the top/bottomin the fringe and empty lines
  (setq-default indicate-buffer-boundaries nil)
  (setq-default indicate-empty-lines nil)
  (setq-default word-wrap t)
  ;; Disable wrapping by default due to its performance cost.
  (setq-default truncate-lines t)

  ;; Various Modes
  (set-fringe-mode 8)
  (global-prettify-symbols-mode 1)
  (auto-image-file-mode 1)
  ;; Enable global syntax highlighting
  (global-font-lock-mode 1)

  ;; Stop the system from hangind when
  ;; visiting files with long lines
  (global-so-long-mode t)
  ;; Avoid collision of mouse at point
  (mouse-avoidance-mode t)
  ;; Show context menu on right click
  (when (display-graphic-p)
    (context-menu-mode))
  ;; Visual line mode in Messages buffer
  (add-hook 'messages-buffer-mode-hook #'visual-line-mode)
  )



;;; Emacs: TAB
(use-package emacs
  :ensure nil
  ;; Tab Behavior
  :config
  (setopt tab-always-indent 'complete)
  ;; (setopt tab-first-completion 'word-or-paren-or-punct)
  (setopt tab-first-completion 'word)
  (setopt tab-width 4)
  (setopt indent-tabs-mode nil)
  )


;;; Emacs: Essential Configuration
(use-package emacs
  :ensure nil
  :demand t
  :config
  (setq delete-pair-blink-delay 0.1)
  (setq help-window-select t)
  (setq find-library-include-other-files nil)
  (setq-default truncate-partial-width-windows nil)
  )


;;; Emacs: SAVE SETTINGS
(use-package emacs
  :ensure nil
  :config
  (setopt auto-save-interval 300
          auto-save-timeout 30
          auto-save-no-message t
          auto-save-include-big-deletions t
          auto-save-list-file-name nil
          delete-auto-save-files t
          kill-buffer-delete-auto-save-files t
          ))

;;; Electric Pair
;; Toggle automatic parens pairing (Electric Pair mode).
(use-package elec-pair
  ;; :disabled
  :ensure nil
  :defer t
  :hook
  ((after-init-hook . electric-pair-mode)
   (prog-mode . electric-indent-local-mode))
  :custom
  (electric-pair-inhibit-predicate 'electric-pair-default-inhibit)
  (electric-quote-comment nil)
  (electric-quote-string nil)
  (electric-quote-context-sensitive t)
  (electric-quote-replace-double t)
  (electric-quote-inhibit-functions nil)
  (electric-pair-preserve-balance t)
  (electric-pair-skip-whitespace nil)
  (electric-pair-delete-adjacent-pairs t)
  (electric-pair-open-newline-between-pairs nil)
  (electric-pair-skip-whitespace-chars '(9 10 32))
  (electric-pair-skip-self 'electric-pair-default-skip-self)
  :config
  (electric-pair-mode 1)
  (electric-quote-mode 1)
  (electric-indent-mode -1)
  (setq electric-pair-pairs '(
                              (?\{ . ?\})
                              (?\[ . ?\])
                              )))

;;; Face Remap
;; Variable Pitch Mode Setup
(use-package face-remap
  :ensure nil
  :bind (:map ef-toggle-keymap
              ("v" . variable-pitch-mode))
  :hook ((text-mode org-mode) . my/enable-variable-pitch)
  :config
  (defun my/enable-variable-pitch ()
    (unless (derived-mode-p 'mhtml-mode 'prog-mode 'nxml-mode 'yaml-mode)
      (variable-pitch-mode 1))))

;;; Files
(use-package files
  :ensure nil
  :config
  ;; Case insensitive search if case-sensitive search fails.
  (setq auto-mode-case-fold nil)
  (setq make-backup-files nil)
  (setq delete-old-version t)
  (setq auto-save-default nil)
  (setq create-lockfiles nil)
  (setq auto-save-visited-mode t)
  (setq save-silently t)
  (setq auto-save-visited-interval 5)
  ;; Newline at the end of file
  (setq require-final-newline t)
  ;; Help
  (setq apropos-do-all t)
  ;; Others
  (setq backup-inhibited t)
  (setq backup-by-copying t)
  (setq kept-new-versions 3)

  ;; Version Control
  (setq vc-make-backup-files nil)
  (setq version-control nil)
  (setq vc-follow-symlinks t)

  (setq remote-file-name-inhibit-delete-by-moving-to-trash t)
  (setq mode-require-final-newline 'visit-save)

  (setq find-file-suppress-same-file-warnings t)
  (setq find-file-visit-truename t)

  (setq backup-directory-alist
        `(("." . ,(expand-file-name "etc/backup/" user-emacs-directory))))
  (setq auto-save-list-file-prefix
        (expand-file-name "etc/autosave/" user-emacs-directory))

  (setq write-file-functions '(my/maybe-check-parens))
  ;;; Check Parens in Emacs Mode Before Closing
  (defun my/maybe-check-parens ()
    "If derived-mode is Lisp data, check for parenthesis correcteness."
    (if (derived-mode-p 'lisp-data-mode) (check-parens)))

  )

;;; Goto Address
;; Buttonize URLs and e-mail addresses in the current buffer
(use-package goto-addr
  :ensure nil
  :hook ((compilation-mode prog-mode conf-mode eshell-mode shell-mode) . goto-address-mode))


;;; Help
(use-package help
  :ensure nil
  :custom
  (help-window-select t)
  (help-window-keep-selected t)
  (help-enable-variable-value-editing t)
  (help-clean-buttons t)
  (help-enable-symbol-autoload t)
  (describe-bindings-outline t)
  (describe-bindings-show-prefix-commands t)
  )

;;; Hideshow
(use-package hideshow
  :ensure nil
  :config
  (setq hs-hide-comments-when-hiding-all nil)
  (setq hs-set-up-overlay #'hideshow-set-up-overlay-fn)
  )

;;; Hippie Expand
(use-package hippie-exp
  :ensure nil
  :defer t
  :bind ([remap dabbrev-expand] . hippie-expand)
  :config
  ;; this will tell us what it's doing:
  (setq hippie-expand-verbose t)
  ;; allow for spaces to continue expanding, nice for phrases in writing:
  (setq hippie-expand-dabbrev-skip-space t)

  ;; change the order it tries things
  (setq hippie-expand-try-functions-list
        '(
          try-expand-list
          try-expand-dabbrev-visible
          try-expand-dabbrev
          try-expand-all-abbrevs
          try-expand-dabbrev-all-buffers
          try-complete-file-name-partially
          try-complete-file-name
          try-expand-dabbrev-from-kill
          try-expand-whole-kill
          try-expand-line
          try-complete-lisp-symbol-partially
          try-complete-lisp-symbol
          ))
  )

;;; hl-line-mode
;; Highlight Line in a Terminal
(use-package hl-line-mode
  :ensure nil
  :when (display-graphic-p)
  :defer t
  :hook (( text-mode . hl-line-mode)
         (org-mode . hl-line-mode)
         ( prog-mode . hl-line-mode)))

;;; ibuffer
(use-package ibuffer
  :ensure nil
  :preface
  ;; Keep Message and Scratch Buffers from being deleted
  (defvar protected-buffers '("*scratch*" "*Messages*")
    "Buffer that cannot be killed.")

  (defun my/protected-buffers ()
    "Protect some buffers from being killed."
    (dolist (buffer protected-buffers)
      (with-current-buffer buffer
        (emacs-lock-mode 'kill))))
  :init (my/protected-buffers)
  :hook
  (ibuffer-mode . ibuffer-auto-mode)
  :bind
  ;; ("C-c i" . ibuffer)
  ([remap list-buffers] . ibuffer)
  :config
  (setq ibuffer-save-with-custom nil)
  (setq ibuffer-default-sorting-mode 'recency)
  (setq ibuffer-eliding-string "…")
  (setq ibuffer-jump-offer-only-visible-buffers t)
  (setq ibuffer-old-time 48)
  (setq ibuffer-expert nil)
  (setq ibuffer-show-empty-filter-groups t)
  (setq ibuffer-filter-group-name-face '(:inherit (success bold))))

;;; imenu
;; Jump to a place in the buffer chosen using a buffer menu or mouse menu.
(use-package imenu
  :ensure nil
  :config
  (setq imenu-use-markers t)
  (setq org-imenu-depth 7)
  (setq imenu-auto-rescan t)
  (setq use-package-enable-imenu-support t)
  (setq imenu-flatten 'group))


;;; `Info
(use-package info
  :ensure nil
  :hook ((Info-selection . my/info-font-resize))
  :custom
  (Info-isearch-search nil)
  :config
  (defun my/info-font-resize ()
    "Increase the font size of text in Info buffers."
    (face-remap-set-base 'default `(:height 1.0))))

;;; isearch
(use-package isearch
  :ensure nil
  :config
  (defun my/isearch-hungry-delete ()
    "Delete the failed portion of the search string, or the last
char if successful."
    (interactive)
    (if (isearch-fail-pos)
        (while (isearch-fail-pos)
          (isearch-delete-char))
      (isearch-delete-char)))
  (define-key isearch-mode-map (kbd "<backspace>") #'my/isearch-hungry-delete)
  ;; Isearch Repeat Map
  (defvar isearch-repeat-map
    (let ((map (make-sparse-keymap)))
      (define-key map "s" 'isearch-repeat-forward)
      (define-key map "r" 'isearch-repeat-backward)
      map))
  (put 'isearch-repeat-forward  'repeat-map 'isearch-repeat-map)
  (put 'isearch-repeat-backward 'repeat-map 'isearch-repeat-map)

  (defun my/isearch-mark-and-exit ()
    "Mark the current search string and exit the search."
    (interactive)
    (push-mark isearch-other-end t 'activate)
    (setq deactivate-mark nil)
    (activate-mark)
    (isearch-done))
  (define-key isearch-mode-map (kbd "C-SPC") #'my/isearch-mark-and-exit)

  (defun my/isearch-other-end ()
    "End current search in the opposite side of the match.
Particularly useful when the match does not fall within the
confines of word boundaries (e.g. multiple words)."
    (interactive)
    (isearch-done)
    (when isearch-other-end
      (goto-char isearch-other-end)))
  (define-key isearch-mode-map (kbd "<C-return>") #'my/isearch-other-end)

  (defun my/isearch-forward-symbol-at-point (&optional arg)
    (interactive "p")
    (let ((arg (or arg 1)))
      (isearch-forward-symbol-at-point arg)))

  (defun my/isearch-backward-symbol-at-point (&optional arg)
    (interactive "p")
    (let ((arg (or arg 1)))
      (isearch-forward-symbol-at-point (- arg))))
  (define-key isearch-mode-map (kbd "M-s .") #'my/isearch-forward-symbol-at-point)
  (define-key isearch-mode-map (kbd "M-s ,") #'my/isearch-backward-symbol-at-point)
  ;; Abort Isearch
  (defun my/abort-isearch-dwim ()
    (interactive)
    (if (eq (length isearch-string) 0)
        (isearch-cancel)
      (isearch-del-char)
      (while (or (not isearch-success) isearch-error)
        (isearch-pop-state)))
    (isearch-update))
  (define-key isearch-mode-map (kbd "<backspace>") #'my/abort-isearch-dwim)
  ;; (setq search-default-mode 'char-fold-to-regexp)
  (setq search-default-mode nil)
  (setq search-whitespace-regexp ".*?"
        isearch-lax-whitespace t
        isearch-regexp-lax-whitespace nil)
  ;; Highlight search
  (setq search-highlight t)
  (setq isearch-lazy-highlight t)
  (setq lazy-highlight-initial-delay 0.5)
  (setq lazy-highlight-no-delay-length 4)

  (setq isearch-allow-motion t)
  (setq isearch-allow-scroll t)
  (setq isearch-lax-whitespace t)
  (setq search-whitespace-regexp ".*?")
  ;; Match counter
  (setq isearch-lazy-count t)
  (setq lazy-count-prefix-format "(%s/%s) ")
  (setq lazy-count-suffix-format nil)
  ;; Motion behavior
  (setq isearch-wrap-pause t) ; `no-ding' makes keyboard macros never quit
  (setq isearch-repeat-on-direction-change t)
  ;; Occur buffer
  (setq list-matching-lines-jump-to-current-line nil)
  (add-hook 'occur-mode-hook #'hl-line-mode)
  )

;;; Man
(use-package man
  :ensure nil
  :defer t
  :config
  (setq Man-notify-method 'pushy)
  :custom-face
  (Man-overstrike ((t (:inherit 'bold :foreground "orange red"))))
  (Man-underline ((t (:inherit 'underline :foreground "forest green"))))
  )


;;; COMMENT
(use-package newcomment
  :ensure nil
  :config
  ;; Comment Settings
  (setopt comment-auto-fill-only-comments t)
  (setopt comment-empty-lines t)
  (setopt comment-fill-column nil)
  (setopt comment-multi-line t)
  (setopt comment-style 'multi-line)
  (setopt comment-column 0)
  (setopt comment-indent-offset 1)

  ;; Better Comment
  ;; (defun ef-comment (n)
  ;; "Comment and Uncomment"
  ;; (interactive "p")
  ;; (if (use-region-p)
  ;; (comment-or-uncomment-region (region-beginning) (region-end))
  ;; (comment-line n)))
  ;; (bind-key "C-/" #'ef-comment 'global-map)
  (defun my-comment-or-uncomment-region-or-line ()
    "Comments or uncomments the region or the current line if there's no active region."
    (interactive)
    (let (beg end)
      (if (region-active-p)
          (setq beg (region-beginning) end (region-end))
        (setq beg (line-beginning-position) end (line-end-position)))
      (comment-or-uncomment-region beg end)
      (forward-line)))
  (global-set-key (kbd "C-/") #'my-comment-or-uncomment-region-or-line)

  )


;;; Outline Mode
(use-package outline
  :ensure nil
  :hook ((prog-mode conf-mode text-mode) . my/prog-outline)
  :bind (:map ef-toggle-keymap
              ("o" . outline-toggle-children))
  :custom
  (outline-minor-mode-highlight t)
  (outline-minor-mode-cycle t)
  (outline-minor-mode-cycle-filter nil)
  (outline-minor-mode-highlight 'append)
  (outline-blank-line t)
  (outline-minor-mode-use-buttons nil)
  (outline-minor-mode-use-margins nil)
  :config
  (defun my/prog-outline ()
    (outline-minor-mode 1)
    (outline-hide-sublevels 1))
  )

;;; Paren
(use-package paren
  :ensure nil
  :defer t
  :hook (prog-mode . show-paren-mode)
  :config
  (setq show-paren-delay 0.1)
  (setq show-paren-highlight-openparen t)
  (setq show-paren-when-point-inside-paren t)
  (setq show-paren-when-point-in-periphery t)
  (setq show-paren-style 'mixed)
  (setq show-paren-context-when-offscreen 'overlay)
  ;;  (set-face-attribute 'show-paren-match-expression nil :background "#363e4a")
  (show-paren-mode 1))


;;; Scroll
(use-package pixel-scroll
  :ensure nil
  :defer t
  :config
  ;; Scroll settings
  (setopt scroll-conservatively 10
          scroll-error-top-bottom nil
          scroll-preserve-screen-position t
          next-screen-context-lines 4
          scroll-minibuffer-conservatively t
          scroll-up-aggressively nil
          scroll-down-aggressively nil
          scroll-margin 0
          pixel-scroll-precision-mode t
          scroll-step 1
          fast-but-imprecise-scrolling t
          hscroll-margin 2
          hscroll-step 1
          auto-window-vscroll nil)  )

;;; Profiling
(use-package profiler
  :ensure nil
  :defer t
  :bind (
         ("C-c e s" . my/run-profiler)
         )
  :config
  (defun my/run-profiler ()
    (interactive)
    (if (and (fboundp 'profiler-running-p)
             (profiler-running-p))
        (prog1 (profiler-stop)
          (profiler-report))
      (profiler-reset)
      (profiler-start 'cpu)
      (message "CPU Profiler Started"))
    )
  )

;;; Proced
;; Generate a listing of UNIX system processes.
(use-package proced
  :ensure nil
  :defer t
  :bind
  ("C-c a p" . proced)
  :config
  (setopt proced-enable-color-flag t)
  (setopt proced-tree-flag t)
  (setopt proced-descend t)
  (setq proced-auto-update-flag t)
  (setq proced-auto-update-interval 1))


;;; Re-builder
;; Construct a regexp interactively.
(use-package re-builder
  :ensure nil
  :commands (re-builder regexp-builder)
  :config
  (setq reb-re-syntax 'read))


;;; Recentf
(use-package recentf
  :ensure nil
  :defer t
  :hook
  (after-init . recentf-mode)
  :custom
  (recentf-max-saved-items 100)
  (recentf-max-menu-items 25)
  (recentf-save-file-modes nil)
  (recentf-keep nil)
  (recentf-case-fold-search t)
  (recentf-auto-cleanup nil)
  (recentf-initialize-file-name-history nil)
  (recentf-filename-handlers nil)
  (recentf-show-file-shortcuts-flag nil)
  :config
  (setq recentf-save-file (concat user-emacs-directory "etc/recentf"))
  )

;;; Register
(use-package register
  :ensure nil
  :config
  (setq register-preview-delay 0)
  (setq register-separator " ")
  (setq register-use-preview 'traditional)
  (setq register-preview-display-buffer-alist
        '(display-buffer-at-bottom
          (window-height . fit-window-to-buffer)
          (preserve-size . (nil . t))
          (window-parameters . ((mode-line-format . none)
                                (no-other-window . t)))))
  )


;;; Repeat
;; Used to reduce key sequence length
(use-package repeat
  :ensure nil
  :hook (after-init . repeat-mode)
  :config
  (setq repeat-on-final-keystroke t)
  (setq repeat-mode t)
  (setq repeat-exit-timeout 5)
  (setq repeat-check-key t)
  (setq repeat-echo-function 'ignore)
  (setq repeat-exit-key (kbd "<escape>")))


;;; Savehist
;; Savehist Save minibuffer and related histories
(use-package savehist
  :ensure nil
  :defer t
  :hook (after-init . savehist-mode)
  :config
  (setq kill-ring-max 1000)
  (setq history-length 1000)
  (setq history-delete-duplicates t)
  (setq savehist-save-minibuffer-history t)
  (setq savehist-file (concat user-emacs-directory "etc/savehist"))
  (setq savehist-autosave-interval 60)
  (setq savehist-additional-variables '(mark-ring
                                        command-history
                                        file-name-history
                                        minibuffer-history
                                        read-expression-history
                                        custom-variable-history
                                        kill-ring
                                        set-variable-value-history
                                        Info-history-list
                                        last-kbd-macro
                                        kmacro-ring
                                        global-mark-ring
                                        register-alist
                                        search-ring
                                        regexp-search-ring
                                        extended-command-history)))

;;; Saveplace
;; saveplace remembers your location in a file when saving files
(use-package saveplace
  :ensure nil
  :init
  (save-place-mode 1)
  :defer t
  :config
  (setq save-place-file (concat user-emacs-directory "etc/saveplace"))
  (setq save-place-limit 600)
  (setq save-place-forget-unreadable-files t)
  (setq save-place-ignore-files-regexp
        "\\(?:COMMIT_EDITMSG\\|hg-editor-[[:alnum:]]+\\.txt\\|elpa\\|svn-commit\\.tmp\\|bzr_log\\.[[:alnum:]]+\\)$")
  ;; activate it for all buffers
  (setq-default save-place t))



;;; Emacs server
;; allow emacsclient to connect to running session)
;; (use-package server
;;   :ensure nil
;;   :init
;;   (setq server-client-instructions nil)
;;   :config
;;   (unless (or (daemonp) (server-running-p))
;;     (server-start)))


;;; Simple
(use-package simple
  :ensure nil
  :config
  ;; Idle time delay before updating various things on the screen.
  (setopt idle-update-delay 1.0)
  (setopt next-error-recenter '(4))
  (setopt next-error-message-highlight nil)
  (setopt kill-do-not-save-duplicates t)
  ;; Repeatedly pop mark with C-u SPC
  (setopt set-mark-command-repeat-pop t)

  (setopt cycle-spacing-actions '(just-one-space (delete-all-space -) restore))

  (setopt delete-active-region nil)
  (setopt eval-expression-print-level nil)
  (setopt next-error-message-highlight 'keep)
  (setopt eval-expression-print-length nil)
  (setopt kill-do-not-save-duplicates t)
  (setopt column-number-mode t)
  (setopt line-number-mode t)
  (setopt kill-whole-line t)
  (setopt line-move-visual nil)
  (setopt track-eol t)
  (setopt set-mark-command-repeat-pop t)
  (setopt blink-matching-paren nil)

  (setopt remote-file-name-inhibit-auto-save t)
  (setopt save-interprogram-paste-before-kill t)

  )

;;; Sppedbar
;; Summary: quick access to files and tags in a frame
(use-package speedbar
  :ensure nil
  :custom
  (speedbar-update-flag t)
  (speedbar-use-images nil)
  (speedbar-frame-parameters
   '((name . "speedbar")
     (title . "speedbar")
     (minibuffer . nil)
     (border-width . 2)
     (menu-bar-lines . 0)
     (tool-bar-lines . 0)
     (unsplittable . t)
     (left-fringe . 10)))
  :config
  ;; File Extensions
  (speedbar-add-supported-extension
   '(;; Classic Lisp Languages
     ".cl" ".el" ".scm" ".lisp"
     ;; Lua/Fennel (Lisp that transpiles to lua)
     ".lua" ".fnl" ".fennel"
     ;; JVM languages (Java, Kotlin, Clojure)
     ".java" ".kt" ".mvn" ".gradle" ".properties" ".clj"
     ;; C/C++
     ".c" ".cpp" ".cc" ".h" ".hh" ".hpp"
     ;; Shell scripts
     ".sh" ".bash"
     ;; Web Languages and Markup/Styling
     ".php" ".js" ".ts" ".html" ".htm" ".css" ".less" ".scss" ".sass"
     ;; Makefile
     "makefile" "MAKEFILE" "Makefile"
     ;; Data formats
     ".json" ".yaml" ".toml"
     ;; Notes and Markup
     ".md" ".markdown" ".org" ".txt" "README")))

;;; Subword
;; Enable builtin packages after init
;; Recognize camel case as words
;; (global-subword-mode t)
(use-package subword
  :ensure nil
  :hook ((python-mode yaml-ts-mode conf-mode
                      java-mode java-ts-mode js-mode js-ts-mode) . subword-mode))


;;; So long
;; (use-package so-long
;;   :ensure nil
;;   :hook (after-init . so-long-mode)
;;   :config
;;   (setq so-long-threshold 10000))



;;; Display Time
(use-package time
  :ensure nil
  :defer t
  :hook (after-init . display-time-mode)
  :config
  (setq display-time-format " %a %e %b, %H:%M ")
  (setq display-time-24hr-format t)
  (setq display-time-day-and-date t)
  (setq display-time-interval 60)
  (setq display-time-default-load-average nil)
  ;; Use M-x shell RET timedatectl list-timezones
  (setq zoneinfo-style-world-list
        '(("Africa/Addis_Ababa" "Addis Ababa"))
        )
  )


;;; Text Mode
(use-package text-mode
  :ensure nil
  :defer t
  :mode "\\`\\(README\\|CHANGELOG\\|COPYING\\|LICENSE\\)\\'"
  :hook
  ((text-mode . turn-on-auto-fill)
   (prog-mode . (lambda () (setq-local sentence-end-double-space t))))
  :config

  (setq word-wrap-by-category t)
  (setq sentence-end-double-space nil)
  (setq sentence-end-without-period nil)
  (setq colon-double-space nil)
  (setq use-hard-newlines nil)
  (setq adaptive-fill-mode t))

;;; Uniquify
;; Unique Buffer Names
(use-package uniquify
  :ensure nil
  :defer t
  :config
  (setq uniquify-strip-common-suffix t)
  (setq uniquify-separator " • ")
  (setq uniquify-ignore-buffers-re "^\\*")
  (setq uniquify-after-kill-buffer-p t)
  (setq uniquify-buffer-name-style 'forward))

;;; Visual Wrap
;; Respect indentation whein wrapping long lines
(use-package visual-wrap
  :ensure nil
  :when (>= emacs-major-version 30)
  :hook ((prog-mode conf-mode org-mode) . visual-wrap-prefix-mode))

;;; Which Key
;; Builtin (Emacs Version 30)
;; Display available keybindings in popup
(use-package which-key
  :ensure nil
  :init
  (which-key-mode)
  :config
  (setq which-key-side-window-location 'bottom)
  (setq which-key-side-window-slot -10)
  (setq which-key-side-window-max-height 0.25)
  (setq which-key-sort-order #'which-key-key-order-alpha)
  ;; (setq which-key-sort-order #'which-key-description-order)
  (setq which-key-allow-imprecise-window-fit nil)
  ;; Allow a key binding to be modified by multiple elements
  (setq which-key-allow-multiple-replacements nil)
  (setq which-key-sort-uppercase-first nil)
  (setq which-key-add-column-padding 1)
  (setq which-key-max-display-columns nil)
  (setq which-key-min-display-lines 6)
  (setq which-key-idle-delay 0.8)
  (setq which-key-idle-secondary-delay 1)
  ;; Show which key is immediately
  (setq which-key-show-early-on-C-h t)
  (setq which-key-max-description-length 25)
  (setq which-key-lighter "")
  (setq which-key-separator " → ")
  ;; Set the prefix string that will be inserted in front of prefix commands
  (setq which-key-prefix-prefix "+" )

  (which-key-add-key-based-replacements
    "C-c" "mode-and-user"
    "C-c a" "applications"
    "C-c b" "buffer"
    "C-c c" "consult"
    "C-c f" "file"
    "C-c t" "toggle"
    "C-x a" "avy"
    "C-x t" "tab-bar"
    )
  (add-to-list 'which-key-replacement-alist '(("TAB" . nil) . ("↹" . nil)))
  (add-to-list 'which-key-replacement-alist '(("RET" . nil) . ("⏎" . nil)))
  (add-to-list 'which-key-replacement-alist '(("DEL" . nil) . ("⇤" . nil)))
  (add-to-list 'which-key-replacement-alist '(("SPC" . nil) . ("␣" . nil)))
  )

;;; Whitespace
;;  Clean up White-space on save
(use-package whitespace
  :ensure nil
  :defer t
  :hook (
         (prog-mode . whitespace-mode)
         (before-save . whitespace-cleanup)
         )
  :config
  (setq whitespace-action '(cleanup auto-cleanup))
  (setq whitespace-line-column nil)
  (setq whitespace-display-mappings '((tab-mark ?\t [?› ?\t])
                                      (newline-mark ?\n [?¬ ?\n])
                                      (space-mark ?\  [?·] [?.])))
  (setq whitespace-style '(empty face newline newline-mark lines-tail trailing tabs tab-mark spaces space-mark indentation missing-newline-at-eof))
  (add-hook 'before-save-hook 'delete-trailing-whitespace)
  )


;;; Window
(use-package window
  :ensure nil
  :config
  ;; Windows: Prefer verticl splitting
  (setq split-width-threshold 170)
  (setq split-height-threshold 80)
  (setq window-sides-vertical t)
  (setq window-resize-pixelwise t)
  (setq window-combination-resize t)
  (setq fit-window-to-buffer-horizontally t)
  (setq switch-to-buffer-obey-display-actions t)
  (setq switch-to-buffer-in-dedicated-window 'pop)
  ;; (setq display-buffer-alist
  ;;       '(("\\*\\(Backtrace\\|Warnings\\|Compile-Log\\|Messages\\|Bookmark List\\|Occur\\|eldoc\\)\\*"
  ;;          (display-buffer-in-side-window)
  ;;          (window-height . 0.25)
  ;;          (side . bottom)
  ;;          (slot . 0))
  ;;         ;; Diff Mode
  ;;         ((major-mode . diff-mode)
  ;;          (display-buffer-same-window))
  ;;         ("\\*\\([Hh]elp\\)\\*"
  ;;          (display-buffer-in-side-window)
  ;;          (window-width . 75)
  ;;          (side . right)
  ;;          (slot . 0))
  ;;         ("\\*\\(Ibuffer\\)\\*"
  ;;          (display-buffer-in-side-window)
  ;;          (window-width . 100)
  ;;          (side . right)
  ;;          (slot . 1))
  ;;         ("\\*\\(Flymake diagnostics\\|xref\\|Completions\\)"
  ;;          (display-buffer-in-side-window)
  ;;          (window-height . 0.25)
  ;;          (side . bottom)
  ;;          (slot . 1))
  ;;         ("\\*\\(grep\\|find\\)\\*"
  ;;          (display-buffer-in-side-window)
  ;;          (window-height . 0.25)
  ;;          (side . bottom)
  ;;          (slot . 2))
  ;;         ("\\*\\(M3U Playlist\\)"
  ;;          (display-buffer-in-side-window)
  ;;          (window-height . 0.25)
  ;;          (side . bottom)
  ;;          (slot . 3))
  ;;         ;; Denote
  ;;         ((major-mode . denote-interface-mode)
  ;;          (display-buffer-same-window))
  ;;         ;; Occur
  ;;         ("\\*Occur"
  ;;          (display-buffer-reuse-mode-window display-buffer-pop-up-window display-buffer-below-selected)
  ;;          (window-height . fit-window-to-buffer)
  ;;          (post-command-select-window . t))
  ;;         ;; Embark
  ;;         ("\\*Embark Actions\\*"
  ;;          (display-buffer-in-direction)
  ;;          (window-height . fit-window-to-buffer)
  ;;          (direction . above)
  ;;          (window-parameters . ((no-other-window . t)
  ;;                                (mode-line-format . none))))
  ;;         ;; Help Mode Alternative
  ;;         ((major-mode . help-mode)
  ;;          (display-buffer-reuse-window display-buffer-pop-up-window display-buffer-below-selected)
  ;;          (window-height . shrink-window-if-larger-than-buffer))
  ;;         ;; Eldoc
  ;;         ("^\\*eldoc"
  ;;          (display-buffer-at-bottom)
  ;;          (post-command-select-window . t)
  ;;          (window-height . shrink-window-if-larger-than-buffer)
  ;;          (window-parameters . ((mode-line-format . none))))
  ;;         ;; Org and calendar
  ;;         ("\\*\\(?:Org Select\\|Agenda Commands\\)\\*"
  ;;          (display-buffer-in-side-window)
  ;;          (window-height . fit-window-to-buffer)
  ;;          (side . top)
  ;;          (slot . -2)
  ;;          (preserve-size . (nil . t))
  ;;          (window-parameters . ((mode-line-format . none)))
  ;;          (post-command-select-window . t))
  ;;         ("\\*Calendar\\*"
  ;;          (display-buffer-below-selected)
  ;;          (window-height . fit-window-to-buffer))
  ;;         ;; Embark
  ;;         ("\\*Embark Actions\\*"
  ;;          (display-buffer-in-direction)
  ;;          (window-height . fit-window-to-buffer)
  ;;          (direction . above)
  ;;          (window-parameters . ((no-other-window . t)
  ;;                                (mode-line-format . none))))
  ;;
  ;;         ))
  ;; Only one window on startup
  (add-hook 'emacs-startup-hook 'delete-other-windows t)
  )

;;; Winner
;; Restore old window configurations
(use-package winner
  :ensure nil
  :hook (after-init . winner-mode)
  :init (setq winner-boring-buffers '("*Completions*"
                                      "*Compile-Log*"
                                      "*inferior-lisp*"
                                      "*Fuzzy Completions*"
                                      "*Apropos*"
                                      "*Help*"
                                      "*cvs*"
                                      "*Buffer List*"
                                      "*Ibuffer*"
                                      "*esh command on file*")))


;;; Windmove
;; (use-package windmove
;;   :ensure nil
;;   :hook (after-init . windmove-mode)
;;   :bind
;;   ( :map windmove-mode-map
;;      ("C-w h" . windmove-left)
;;      ("C-w l" . windmove-right)
;;      ("C-w j" . windmove-down)
;;      ("C-w k" . windmove-up)
;;      ("C-w <left>" . windmove-left)
;;      ("C-w <right>" . windmove-right)
;;      ("C-w <down>" . windmove-down)
;;      ("C-w <up>" . windmove-up)
;;
;;    )
;; )


;;; Woman
(use-package woman
  :ensure nil
  :defer t
  :hook (woman-mode . olivetti-mode))

;;; Use-package
;; Configure use-package
(use-package use-package
  :ensure nil
  :custom
  (use-package-verbose t)
  (use-package-always-ensure t)  ; :ensure t by default
  (use-package-always-defer nil) ; :defer t by default
  (use-package-expand-minimally t)
  (use-package-enable-imenu-support t))


;;; Xref
(use-package xref
  :ensure nil
  :init
  ;; Use faster search tool
  (when (executable-find "rg")
    (setq xref-search-program 'ripgrep))

  ;; Select from xref candidates in minibuffer
  (setq xref-show-definitions-function #'xref-show-definitions-completing-read
        xref-show-xrefs-function #'xref-show-definitions-completing-read)
  :custom
  (xref-show-definitions-function #'xref-show-definitions-completing-read)
  (xref-show-xrefs-function #'xref-show-definitions-buffer)
  (xref-file-name-display 'project-relative)
  (xref-search-program 'ripgrep)
  (xref-history-storage 'xref-window-local-history) ; Per-window history of `xref-go-*'
  )



(provide 'ef-core)
;;; ef-core.el ends here
