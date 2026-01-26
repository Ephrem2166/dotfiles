;;; ef-core.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:
;;; Wrapper
(defun inhibit-messages-wrapper! (func &rest args)
  (let ((inhibit-message t))
    (apply func args)))

;;; Alias
;; Text Manipulation
(defalias 'rs 'replace-string)
(defalias 'al 'align-regexp)
(defalias 'sl 'sort-lines)
(defalias 'rr 'reverse-region)
(defalias 'wc 'whitespace-cleanup)

(defalias 'lml 'list-matching-lines)
(defalias 'dml 'delete-matching-lines)
(defalias 'dnml 'delete-non-matching-lines)
(defalias 'dtw 'delete-trailing-whitespace)

;; Buffer Manipulation
(defalias 'rb 'revert-buffer)

;; Emacs Lisp
(defalias 'eb 'eval-buffer)
(defalias 'er 'eval-region)
(defalias 'ed 'eval-defun)
(defalias 'eis 'elisp-index-search)
(defalias 'lf 'load-file)

;; Dired
(defalias 'wd 'wdired-change-to-wdired-mode)

;; Modes
(defalias 'sh 'shell-script-mode)
;; Alias man to woman globally
(defalias 'man 'woman)

;;; Abbrev
(use-package abbrev
  :ensure nil
  :custom
  (abbrev-file-name (expand-file-name "etc/abbrev.el" user-emacs-directory))
  (save-abbrevs 'silently)
  (abbrev-suggest t)
  (abbrev-suggest-hint-threshold 2)
  (setq-default abbrev-mode t)
  :config
  (define-abbrev-table 'global-abbrev-table
    '(

      ("todo"  "👷 TODO:")
      ("fixme" "🔥 FIXME:")
      ("note"  "📎 NOTE:")
      ("hack"  "👾 HACK:")

      )
    )

  )


;;; Auto-revert
;;;; Auto-Revert Mode is a minor mode that affects only the current
;;;; buffer.  When enabled, it reverts the buffer when the file on
;;;; disk changes.
(use-package autorevert
  :ensure nil
  :custom
  (auto-revert-interval 3)
  (auto-revert-avoid-polling t)
  (auto-revert-check-vc-info t)
  (auto-revert-verbose nil)
  (global-auto-revert-non-file-buffers t)
  (auto-revert-use-notify nil)
  (auto-revert-avoid-polling t)
  (auto-revert-stop-on-user-input nil)
  ;; (setq global-auto-revert-ignore-modes '(Buffer-menu-mode))
  :config
  ;; (quiet! (auto-revert-mode +1))

  ;; (global-auto-revert-mode)
  ;; Performance
  (defun my/visible-buffers (&optional buffer-list all-frames)
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


  (defun my/auto-revert-current-buffer-h ()
    (unless (or auto-revert-mode
                (active-minibuffer-window)
                ;; Skip non-file buffers
                (not (buffer-file-name))
                ;; Skip temporary/internal buffers
                (string-prefix-p " " (buffer-name)))
      (let ((auto-revert-mode t))
        (auto-revert-handler))))

  (defun my/auto-revert-visible-buffers-h ()
    "Auto revert stale buffers in visible windows, if necessary."
    (dolist (buf (my/visible-buffers))
      (with-current-buffer buf
        (my/auto-revert-current-buffer-h))))
  :hook
  (after-save-hook . my/auto-revert-visible-buffers-h)
  (after-change-major-mode-hook . my/auto-revert-current-buffer-h)
  )

;;; Auto Insert
(use-package autoinsert
  :ensure nil
  :init
  (setq auto-insert-query nil)
  :config
  (auto-insert-mode 1)
  (define-auto-insert
    "\\.el\\'"
    '(
      "Emacs Lisp header"
      ";;; " (file-name-nondirectory (buffer-file-name)) " --- " _ " -*- lexical-binding: t; -*-\n\n"
      ";;; Commentary:\n"
      ";; \n\n"
      ";;; Code:\n\n\n"
      ;; ";;; Code Ends Here"
      "(provide '" (file-name-base) ")\n"
      ";;; " (file-name-nondirectory (buffer-file-name)) " ends here\n"
      )))


;;; Bookmarks
(use-package bookmark
  :ensure nil
  :custom
  (bookmark-set-fring-mark nil)
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
;; To avoid using custom.el forever
;; (setq-default custom-file "/dev/null")
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

   (text-mode .display-line-numbers-mode)
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
  (fset 'yes-or-no-p 'y-or-n-p)
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
  (setopt text-quoting-style 'straight)
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
  (setq-default fill-column 85)
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
  ;; Truncate lines in all buffers
  (setq-default global-visual-line-mode t)

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

;;; Emacs: Prettify Symbols
(use-package emacs
  :ensure nil
  :config
  (setq prettify-symbols-unprettify-at-point 'right-edge)
  (setq-default prettify-symbols-alist
                '(("<-" . ?←)
                  ("->" . ?→)
                  ("->>" . ?↠)
                  ("=>" . ?⇒)
                  ;; ("/=" . ?≠)
                  ;; ("!=" . ?≠)
                  ;; ("==" . ?≡)
                  ;; ("<=" . ?≤)
                  ;; (">=" . ?≥)
                  ("=<<" . (?= (Br . Bl) ?≪))
                  (">>=" . (?≫ (Br . Bl) ?=))
                  ("<=<" . ?↢)
                  (">=>" . ?↣)
                  ("lambda" . 955)
                  ("delta" . 120517)
                  ("epsilon" . 120518)
                  ;; ("<" . 10216)
                  (">" . 10217)
                  ;; ("[" . 10214)
                  ;; ("]" . 10215)
                  ("<<" . 10218)
                  (">>" . 10219)
                  ))
  )

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
  ;; (electric-quote-mode 1)
  (electric-indent-mode -1)
  (setq electric-pair-pairs '(
                              (?\{ . ?\})
                              (?\[ . ?\])
                              ))
  ;; disable auto pairing for <  >
  (add-function :before-until electric-pair-inhibit-predicate
                (lambda (c) (eq c ?<   ;; >
                           )))
  ;; Better Electric Pair
  (defun my/electric-pair-conservative-inhibit (char)
    (or
     ;; I find it more often preferable not to pair when the
     ;; same char is next.
     (eq char (char-after))
     ;; Don't pair up when we insert the second of "" or of ((.
     (and (eq char (char-before))
          (eq char (char-before (1- (point)))))
     ;; I also find it often preferable not to pair next to a word.
     (eq (char-syntax (following-char)) ?w)
     ;; Don't pair at the end of a word, unless parens.
     (and
      (eq (char-syntax (char-before (1- (point)))) ?w)
      (eq (preceding-char) char)
      (not (eq (char-syntax (preceding-char)) ?\()))))
  (setq electric-pair-inhibit-predicate 'my/electric-pair-conservative-inhibit)
  )

;;; FFAP: Find File At Point
;; Command find-file-at-point replaces find-file.
(use-package ffap
  :ensure nil
  :hook (on-first-input . ffap-bindings))

;;; Face Remap
;; Variable Pitch Mode Setup
;; (use-package face-remap
;;   :ensure nil
;;   :bind (:map ef-toggle-keymap
;;               ("v" . variable-pitch-mode))
;;   :hook ((text-mode org-mode) . my/enable-variable-pitch)
;;   :config
;;   (defun my/enable-variable-pitch ()
;;     (unless (derived-mode-p 'mhtml-mode 'prog-mode 'nxml-mode 'org-mode 'yaml-mode)
;;       (variable-pitch-mode 1))))

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
  (setq view-read-only t)
  (setq write-file-functions '(my/maybe-check-parens))
  ;;; Check Parens in Emacs Mode Before Closing
  (defun my/maybe-check-parens ()
    "If derived-mode is Lisp data, check for parenthesis correcteness."
    (if (derived-mode-p 'lisp-data-mode) (check-parens)))

  )

;;; Frame
(use-package frame
  :ensure nil
  :config
  ;; Blink cursor
  (setopt blink-cursor-blinks 0)
  (setopt window-divider-default-bottom-width 1)
  (setopt window-divider-default-places t)
  (setopt window-divider-default-right-width 1)
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
  ;; Show help on point
  ;; (help-at-pt-display-when-idle t)
  ;; (help-at-pt-set-timer)
  (describe-bindings-outline t)
  (describe-bindings-show-prefix-commands t)
  :config
  ;; stop repeating the same message please
  (advice-add 'help-window-display-message :around #'ignore)
  )

;;; Hideshow
(use-package hideshow
  :ensure nil
  :hook (prog-mode . hs-minor-mode)
  :bind (:map hs-minor-mode-map
              ([C-tab] . hs-toggle-hiding))
  ;; :bind ("C-c C-h" . my/hideshow-toggle)
  :config
  ;; Unfold code when searching
  (setq hs-isearch-open t)
  (setq hs-hide-comments-when-hiding-all nil)
  ;; (setq hs-set-up-overlay #'hideshow-set-up-overlay-fn)
  ;; (add-hook 'prog-mode-hook  #'hs-minor-mode)
  :preface
  (defun my/hideshow-toggle (column)
    "Toggle hiding/showing blocks via hs-mode."
    (interactive "P")
    (condition-case nil
        (hs-toggle-hiding)
      (error (hs-show-all))
      )
    )
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
          try-expand-dabbrev
          try-expand-dabbrev-all-buffers
          try-expand-dabbrev-visible
          try-expand-dabbrev-from-kill
          try-complete-file-name-partially
          try-complete-file-name
          try-expand-all-abbrevs
          try-complete-lisp-symbol-partially
          try-complete-lisp-symbol
          try-expand-list
          try-expand-whole-kill
          try-expand-line
          ))
  )

;;; hl-line-mode
;; Highlight Line in a Terminal
(use-package hl-line-mode
  :ensure nil
  :defer t
  :hook ((text-mode . hl-line-mode)
         (org-mode . hl-line-mode)
         ( prog-mode . hl-line-mode))
  ;; :custom
  ;; (hl-line-sticky-flag nil "only highlight line in active mode")
  )

;;; Hi-lock
;; minor mode for interactive automatic highlighting
(use-package hi-lock
  :ensure nil
  :config
  (add-hook 'prog-mode-hook
            (defun emphasize-comments-starting-with-! ()
              (highlight-lines-matching-regexp ".*\\*.*!.*" 'hi-red-b)
              (highlight-lines-matching-regexp ".*//!.*" 'hi-red-b)
              (highlight-lines-matching-regexp ";;!.*" 'hi-red-b)))

  ;; (global-hi-lock-mode)
  )


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
  :init
  (my/protected-buffers)
  (add-hook 'ibuffer-mode-hook
            (lambda ()
              (ibuffer-switch-to-saved-filter-groups "default")))
  :hook
  (ibuffer-mode . ibuffer-auto-mode)
  :bind
  ;; ("C-c i" . ibuffer)
  ([remap list-buffers] . ibuffer)
  :custom
  (ibuffer-filter-group-name-face '(:inherit (font-lock-string-face bold)))
  (ibuffer-title-face '(:inherit (font-lock-type-face)))
  (ibuffer-never-show-predicates (list (rx bol " " (* any))))

  :config
  ;; Modify the default ibuffer formats
  (setq ibuffer-formats
        '((mark modified read-only vc-status-mini " "
                (name 18 18 :left :elide)
                " "
                (size 9 -1 :right)
                " "
                (mode 16 16 :left :elide)
                " "
                (vc-status 16 16 :left)
                " "
                filename-and-process)))
  (setq ibuffer-save-with-custom nil)
  (setq ibuffer-default-sorting-mode 'recency)
  (setq ibuffer-eliding-string "…")
  (setq ibuffer-jump-offer-only-visible-buffers t)
  (setq ibuffer-old-time 48)
  (setq ibuffer-expert nil)
  ;; (setq ibuffer-display-summary nil)
  (setq ibuffer-use-other-window t)
  (setq ibuffer-show-empty-filter-groups nil)
  (setq ibuffer-shrink-to-minimum-size  t)
  (setq ibuffer-filter-group-name-face '(:inherit (success bold)))
  (setq ibuffer-default-display-maybe-show-predicates t)
  ;; Kill ibuffer after quit
  (defadvice ibuffer-quit (after kill-ibuffer activate)
    "Kill the ibuffer buffer on exit."
    (kill-buffer "*Ibuffer*"))

  (setq ibuffer-saved-filter-groups
        '(("default"
           ("Magit"
            (or
             (mode . magit-status-mode)
             (mode . magit-log-mode)
             (name . "\\*magit")
             (name . "magit-")
             (name . "git-monitor")
             ))
           ("Commands"
            (or
             (mode . shell-mode)
             (mode . eshell-mode)
             (mode . term-mode)
             (mode . compilation-mode)))

           ("Dired"
            (mode . dired-mode))
           ("Help"    (or
                       (name . "^\\*Help\\*$")
                       (name . "^\\*info\\*$")))
           ("Org"
            (or
             (name . "^\\*Calendar\\*$")
             (name . "^\\*Org Agenda")
             (name . "^\\*Org Src")
             (name . "^ \\*Agenda")
             (mode . org-agenda-mode)
             (mode . org-mode)))
           ("Emacs"
            (or
             (name . "^\\*scratch\\*$")
             (name . "^\\*Messages\\*$")
             (name . "^\\*Warnings\\*$")
             (name . "^\\*Shell Command Output\\*$")
             (name . "^\\*Async-native-compile-log\\*$")
             (name . "^\\*\\(Customize\\|Help\\)")
             (name . "\\*\\(Echo\\|Minibuf\\)")))

           ("Code" (or (mode . emacs-lisp-mode)
                       (mode . cperl-mode)
                       (mode . c-mode)
                       (mode . java-mode)
                       (mode . idl-mode)
                       (mode . web-mode)
                       (mode . lisp-mode)
                       (mode . js2-mode)
                       (mode . c++-mode)
                       (mode . lua-mode)
                       (mode . cmake-mode)
                       (mode . ruby-mode)
                       (mode . css-mode)
                       (mode . objc-mode)
                       (mode . sql-mode)
                       (mode . python-mode)
                       (mode . php-mode)
                       (mode . sh-mode)
                       (mode . json-mode)
                       (mode . scala-mode)
                       (mode . go-mode)
                       (mode . typescript-mode)
                       (mode . javascript-mode)
                       (mode . js-mode)
                       (mode . jsx-mode)
                       (mode . js2-mode)
                       (mode . json-mode)
                       (name . "\\*js\\*")
                       (mode . nodejs-repl-mode)
                       (mode . erlang-mode)
                       (mode . html-mode)
                       (mode . web-mode)
                       (name . "\\.yml$")
                       ))
           ("Magit" (name . "^\\*magit.*$"))
           ("Markdown" (or
                        (name . "*.md$")
                        (mode . markdown-mode)))
           ("LaTeX" (or (mode . latex-mode)
                        (name . "*.tex$")))
           ("IRC" (or
                   (mode . erc-mode)
                   (mode . rcirc-mode)))

           )))
  ;; Auto-update ibuffer
  (add-hook 'ibuffer-mode-hook
            (lambda ()
              ;; (ibuffer-auto-mode 1)
              (ibuffer-switch-to-saved-filter-groups "default")))
  ;; recycle move cursor
  (defun ibuffer-previous-line ()
    (interactive) (previous-line)
    (if (<= (line-number-at-pos) 2)
        (goto-line (- (count-lines (point-min) (point-max)) 2))))
  (defun ibuffer-next-line ()
    (interactive) (next-line)
    (if (>= (line-number-at-pos) (- (count-lines (point-min) (point-max)) 1))
        (goto-line 3)))
  (define-key ibuffer-mode-map (kbd "<up>") 'ibuffer-previous-line)
  (define-key ibuffer-mode-map (kbd "<down>") 'ibuffer-next-line)

  )

;;; imenu
;; Jump to a place in the buffer chosen using a buffer menu or mouse menu.
(use-package imenu
  :ensure nil
  :config
  (defun my/imenu-setup ()
    "Set up the imenu customization. Use in hooks."
    (ignore-errors
      (imenu-add-menubar-index)
      (setq-local imenu-auto-rescan t)
      (when (derived-mode-p 'prog-mode)
        (setq-local imenu-sort-function 'imenu--sort-by-name))))
  (setq imenu-use-markers t)
  (setq org-imenu-depth 7)
  (setq imenu-auto-rescan t)
  (setq use-package-enable-imenu-support t)
  (setq imenu-flatten 'group)
  (dolist (imenu-modes '(org-mode markdown-mode text-mode prog-mode)
                       )
    (add-hook 'imenu-modes #'my/imenu-setup)

    )


  )


;;; `Info
(use-package info
  :ensure nil
  :hook (Info-Mode . my/info-buffer-setup)
  :custom
  (Info-isearch-search nil)

  :config
  (defun my/info-buffer-setup ()
    (hl-line-mode)
    (when (fboundp 'visual-line-fill-column-mode)
      (setq-local visual-fill-column-width 80)
      (visual-line-fill-column-mode))
    (face-remap-set-base 'default `(:height 1.0))

    )
  )

;;; Info Look
;; (use-package info-look
;;   :commands (info-lookup-symbol
;;              info-lookup-maybe-add-help)
;;   :config
;;   ;; (add-to-list 'Info-directory-list "~/.emacs.d/info")

;;   (defun my/format-info-mode ()
;;     "Opening .info files does not automatically set things up. Give it a little help."
;;     (interactive)
;;     (let ((file-name (buffer-file-name)))
;;       (kill-buffer (current-buffer))
;;       (info file-name))))

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
  ;; Search under the cursor
  (defun my/isearch-yank-symbol ()
    "*Put symbol at current point into search string."
    (interactive)
    (let ((sym (thing-at-point 'symbol)))
      (if sym
          (progn
            (setq isearch-regexp t
                  isearch-string (concat "\\_<" (regexp-quote sym) "\\_>")
                  isearch-message (mapconcat 'isearch-text-char-description isearch-string "")
                  isearch-yank-flag t))
        (ding)))
    (isearch-search-and-update))
  ;; Mark active region and added it to search string
  (defun my/isearch-mode-setup ()
    "If the region is on, use it as initial search string.
Intended to be added to `isearch-mode-hook'."
    ;; Note that the text of the region can be an invalid regexp
    (when (use-region-p)
      (let ((beg (region-beginning))
            (end (region-end)))
        (deactivate-mark)
        (goto-char beg)
        (isearch-yank-internal (lambda () end)))))

  (add-hook 'isearch-mode-hook #'my/isearch-mode-setup)
  ;; (define-key ef-file-keymap (kbd "s") #'my/isearch-yank-symbol)
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
  ;; Smart Comment Advice
  (defun my/comment-advice (orig-fun &rest args)
    "Comment or uncomment lines intelligently.

  When called interactively with no active region, comment a single
  line instead."
    (if (or (use-region-p) (not (called-interactively-p 'any)))
        (apply orig-fun args)
      (comment-or-uncomment-region (line-beginning-position)
                                   (line-end-position))
      (message "[Commented line]")))

  (advice-add 'comment-dwim :around #'my/comment-advice)
  )


;;; Outline Mode
(use-package outline
  :ensure nil
  :hook ((prog-mode conf-mode text-mode) . my/prog-outline)
  :bind ((:map ef-toggle-keymap
               ("o" . outline-toggle-children))
         :map outline-minor-mode-map
         ("TAB" . my/outline-cycle)
         ("<tab>" . my/outline-cycle)
         ("<backtab>" . outline-cycle-buffer)
         )
  :custom
  (outline-minor-mode-highlight t)
  (outline-minor-mode-cycle t)
  (outline-minor-mode-cycle-filter nil)
  (outline-minor-mode-highlight 'append)
  (outline-blank-line t)
  (outline-minor-mode-use-buttons nil)
  (outline-minor-mode-use-margins nil)
  :config


  ;; Outline headings
  (defun my/outline-cycle ()
    (interactive)
    (if (save-excursion (forward-line 0)
                        (looking-at-p outline-regexp))
        (call-interactively #'outline-cycle)
      (let* ((outline-minor-mode nil)
             (cmd (or (key-binding (this-command-keys-vector))
                      (key-binding (key-parse "TAB")))))
        (when cmd
          (setq this-command cmd)
          (call-interactively cmd)))))
  (defun my/prog-outline ()
    (outline-minor-mode 1)
    (outline-hide-sublevels 1))
  (add-hook 'outline-minor-mode-hook
            (lambda ()
              (when (and outline-minor-mode (derived-mode-p 'emacs-lisp-mode))
                (hide-sublevels 1000))))
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
  (setopt scroll-conservatively 101
          scroll-error-top-bottom nil
          scroll-preserve-screen-position t
          next-screen-context-lines 4
          scroll-minibuffer-conservatively t
          scroll-up-aggressively nil
          scroll-down-aggressively nil
          scroll-margin 2
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
  (:map applications-map
        ("p" . proced))
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
  :hook
  (after-init . recentf-mode)
  :custom
  (recentf-max-saved-items 300)
  (recentf-max-menu-items 25)
  (recentf-save-file-modes nil)
  (recentf-keep nil)
  (recentf-case-fold-search t)
  (recentf-initialize-file-name-history nil)
  (recentf-filename-handlers nil)
  (recentf-show-file-shortcuts-flag nil)
  :config
  (advice-add 'recentf-load-list :around #'inhibit-messages-wrapper!)
  ;; (quiet! (recentf-mode 1))
  (setq recentf-exclude
        '("\\.?cache"
          "~$"
          ".cask"
          "url"
          "COMMIT_EDITMSG\\'"
          "bookmarks"
          "\\.\\(?:gz\\|gif\\|svg\\|png\\|jpe?g\\|bmp\\|xpm\\)$"
          "\\.?ido\\.last$" "\\.revive$" "/G?TAGS$" "/.elfeed/"
          "^/tmp/" "^/var/folders/.+$" "^/ssh:" "/persp-confs/"
          (lambda (file) (file-in-directory-p file package-user-dir))))
  (push (expand-file-name recentf-save-file) recentf-exclude)
  ;; When to cleanup recentf
  (setq recentf-auto-cleanup 'never)
  ;; (setq recentf-auto-cleanup (if (daemonp) 300))
  ;; (add-hook 'kill-emacs-hook #'my/recentf-cleanup)
  (setq recentf-save-file (concat user-emacs-directory "etc/recentf"))
  ;; Anything in runtime folders
  (add-to-list 'recentf-exclude
               (concat "^" (regexp-quote (or (getenv "XDG_RUNTIME_DIR")
                                             "/run"))))
  ;; Quiet Recentf
  ;; (defun my/recentf-quiet ()
  ;;   "Wrapper for `recentf-save-list' with no message."
  ;;   (let ((inhibit-message t))
  ;;     (recentf-save-list))
  ;;   )
  ;; (run-at-time 60 (* 5 60) #'my/recentf-quiet)
  ;; Remove non-existent files from the recent files list automatically.
  (defun my/recentf-cleanup ()
    "Clean up recentf list by removing non-existent files."
    (interactive)
    (setq recentf-list (cl-remove-if-not 'file-exists-p recentf-list))
    (recentf-cleanup))
  ;; Advice recentf-load-list to perform cleanup after loading the recentf
  ;; list.
  (advice-add 'recentf-load-list :after #'my/recentf-cleanup)
  ;; For perfromance
  (add-to-list 'recentf-filename-handlers #'substring-no-properties)
  ;;  (advice-add #'recentf-load-list :around #'doom-shut-up-a)
  :preface
  (defun my/recentf-add-dired-directory ()
    "Add directories visit by dired into recentf."
    (if (and dired-directory
             (stringp dired-directory)
             (file-directory-p dired-directory)
             (not (string= "/" dired-directory)))
        (let ((last-idx (1- (length dired-directory))))
          (recentf-add-file
           (if (= ?/ (aref dired-directory last-idx))
               (substring dired-directory 0 last-idx)
             dired-directory)))))
  (add-hook 'dired-mode #'my/recentf-add-dired-directory)
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
  :disabled
  :ensure nil
  :hook (after-init . repeat-mode)
  :config
  (setq repeat-on-final-keystroke t)
  (setq repeat-mode t)
  (setq repeat-exit-timeout 5)
  (setq repeat-check-key t)
  (setq repeat-echo-function 'ignore)
  (setq repeat-exit-key (kbd "<escape>"))
  )


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
                                        extended-command-history))


  )

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
(use-package server
  :if (display-graphic-p)
  :ensure nil
  ;;:if (display-graphic-p)
  :init
  (setq server-client-instructions nil)
  :config
  ;; Start the server if it's not running
  (unless (or (daemonp) (server-running-p))
    (server-start)))


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

  ;; Performance: Remove text properties for kill ring entries
  (defun unpropertize-kill-ring ()
    (setq kill-ring (mapcar 'substring-no-properties kill-ring)))
  (add-hook 'kill-emacs-hook #'unpropertize-kill-ring)
  )

;;; Speedbar
;; Quick access to files and tags in a frame
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


;;; FIXME: So long
(use-package so-long
  :ensure nil
  :hook (after-init-hook . global-so-long-mode)
  )


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


;;; Tab bar
(use-package tab-bar
  :ensure nil
  :preface
  (defun my/tab-bar-new (name &optional bff)
    "Create a new tab with a NAME.
With a non-nil IFF, call IFF as a function or switch
to the IFF buffer or  the files listed."
    (interactive "sWorkspace Name: ")
    (tab-bar-switch-to-tab name)
    (when bff
      (cond
       ((listp bff) (find-file (car bff))
        (dolist (f (cdr bff))
          (split-window-right)
          (find-file f)))
       ((fboundp bff) (call-interactively bff))
       ((bufferp bff) (switch-to-buffer bff)))))
  :config
  (setq tab-bar-new-button-show nil)
  (setq tab-bar-close-button-show nil)
  (setq tab-bar-new-tab-choice "*scratch*")
  (setq tab-bar-tab-hints t)
  (setq tab-bar-button-margin '(40 . 1))
  (setq tab-bar-button-relief 0)
  (setq tab-bar-show 1)
  )

;;; FIXME Text Mode
(use-package text-mode
  :ensure nil
  :defer t
  :mode "\\`\\(README\\|CHANGELOG\\|COPYING\\|LICENSE\\)\\'"
  :hook
  ((text-mode . turn-on-auto-fill)
   (text-mode . visual-line-mode)
   (prog-mode . (lambda () (setq-local sentence-end-double-space t)))
   )
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
  :disabled
  :ensure nil
  :when (>= emacs-major-version 30)
  :hook ((prog-mode conf-mode org-mode) . visual-wrap-prefix-mode))

;;; Warning
;; Feature `warnings' allows us to enable and disable warnings.
(use-package warnings
  :ensure nil
  :config

  ;; Ignore the warning we get when a huge buffer is reverted and the
  ;; undo information is too large to be recorded.
  (add-to-list 'warning-suppress-log-types '(undo discard-info)))
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
  ;; Remove trailing whitespace before saving, with exceptions.
  (add-hook 'before-save-hook
            (lambda ()
              "Remove trailing whitespace before save, skipping message-mode and diff-mode."
              (let ((buffer-undo-list buffer-undo-list))
                (unless (or (derived-mode-p 'message-mode)
                            (derived-mode-p 'markdown-mode)
                            (derived-mode-p 'org-mode)
                            (derived-mode-p 'diff-mode))
                  (delete-trailing-whitespace)))))
  )


;;; FIXME: Window
(use-package window
  :ensure nil
  :defer t
  :config
  (setq recenter-positions '(0.50 0.07 0.93)) ;default: '(middle top bottom)
  ;; Windows: Prefer verticl splitting
  (setq split-width-threshold 170)
  (setq split-height-threshold 80)
  (setq window-sides-vertical t)
  (setq window-resize-pixelwise t)
  (setq window-combination-resize t)
  (setq fit-window-to-buffer-horizontally t)
  (setq switch-to-buffer-obey-display-actions t)
  (setq switch-to-buffer-in-dedicated-window 'pop)
  (setq display-buffer-alist
        '(("\\*\\(Backtrace\\|Warnings\\|Compile-Log\\|Messages\\|Bookmark List\\|Occur\\|eldoc\\)\\*"
           (display-buffer-in-side-window)
           (window-height . 0.25)
           (side . bottom)
           (slot . 0))
          ;; Diff Mode
          ((major-mode . diff-mode)
           (display-buffer-same-window))
          ("\\*\\([Hh]elp\\)\\*"
           (display-buffer-in-side-window)
           (window-width . 75)
           (side . right)
           (slot . 0))
          ("\\*\\(Ibuffer\\)\\*"
           ;; (display-buffer-in-side-window)
           (display-buffer-in-new-tab)
           (window-width . 100)
           (side . right)
           (slot . 1))
          ("\\*\\(Flymake diagnostics\\|xref\\|Completions\\)"
           (display-buffer-in-side-window)
           (window-height . 0.25)
           (side . bottom)
           (slot . 1))
          ("\\*\\(grep\\|find\\)\\*"
           (display-buffer-in-side-window)
           (window-height . 0.25)
           (side . bottom)
           (slot . 2))
          ("\\*\\(M3U Playlist\\)"
           (display-buffer-in-side-window)
           (window-height . 0.25)
           (side . bottom)
           (slot . 3))
          ;; Denote
          ((major-mode . denote-interface-mode)
           (display-buffer-same-window))
          ;; Occur
          ("\\*Occur"
           (display-buffer-reuse-mode-window display-buffer-pop-up-window display-buffer-below-selected)
           (window-height . fit-window-to-buffer)
           (post-command-select-window . t))
          ;; Embark
          ("\\*Embark Actions\\*"
           (display-buffer-in-direction)
           (window-height . fit-window-to-buffer)
           (direction . above)
           (window-parameters . ((no-other-window . t)
                                 (mode-line-format . none))))
          ;; Help Mode Alternative
          ((major-mode . help-mode)
           (display-buffer-reuse-window display-buffer-pop-up-window display-buffer-below-selected)
           (window-height . shrink-window-if-larger-than-buffer))
          ;; Eldoc
          ("^\\*eldoc"
           (display-buffer-at-bottom)
           (post-command-select-window . t)
           (window-height . shrink-window-if-larger-than-buffer)
           (window-parameters . ((mode-line-format . none))))
          ;; Org and calendar
          ("\\*\\(?:Org Select\\|Agenda Commands\\)\\*"
           (display-buffer-in-side-window)
           (window-height . fit-window-to-buffer)
           (side . top)
           (slot . -2)
           (preserve-size . (nil . t))
           (window-parameters . ((mode-line-format . none)))
           (post-command-select-window . t))
          ("\\*Calendar\\*"
           (display-buffer-below-selected)
           (window-height . fit-window-to-buffer))
          ;; Embark
          ("\\*Embark Actions\\*"
           (display-buffer-in-direction)
           (window-height . fit-window-to-buffer)
           (direction . above)
           (window-parameters . ((no-other-window . t)
                                 (mode-line-format . none))))

          ))
  ;; Set up the display buffer alist for a select window.
  (defun my/give-buffer-focus (window)
    "Select WINDOW for 'display-buffer-alist'."
    (select-window window))
  ;; window-height seems to have no effect. it's always huge.
  (setq display-buffer-alist
        '((;;"\\*Occur\\*"
           (or . ((derived-mode . occur-mode)))
         ;;; placement functions
           (display-buffer-reuse-mode-window
            display-buffer-below-selected)
         ;;; Parameters
           (body-function . my/give-buffer-focus)
           ;;(window-height . 10)
           (window-height . fit-window-to-buffer)
           (dedicated . t)
           )))

  ;; Don't create new frames
  ;; (setq display-buffer-alist (quote (("" ignore (nil . reusable-frames)))))

  (add-to-list 'display-buffer-alist
               '("\\`\\*\\(Warnings\\|Compile-Log\\)\\*\\'"
                 (display-buffer-same-window)
                 (dedicated . t)))

  (add-to-list 'display-buffer-alist '("\\*shell\\*"
                                       display-buffer-same-window))

  ;; FIXME: Reuse Help Windows
  (setq display-buffer-alist
        `((,(rx bos (or "*Apropos*" "*Help*" "*helpful" "*info*" "*Summary*")
                (0+ not-newline))
           (display-buffer-reuse-mode-window display-buffer-below-selected)
           (window-height . 0.33)
           (mode apropos-mode help-mode helpful-mode Info-mode Man-mode))))

  ;; Only one window on startup
  (add-hook 'emacs-startup-hook 'delete-other-windows t)

  ;; Helper Function
  ;; push and pop window configuration
  (eval-and-compile
    (defvar saved-window-configuration nil)

    (defun push-window-configuration ()
      (interactive)
      (push (current-window-configuration) saved-window-configuration))

    (defun my/pop-window-configuration ()
      (interactive)
      (let ((config (pop saved-window-configuration)))
        (if config
            (set-window-configuration config)
          (if (> (length (window-list)) 1)
              (delete-window)
            (bury-buffer))))))
  ;; (define-key dired-mode-map "z" 'my/pop-window-configuration)
  ;; (define-key Info-mode-map "z" 'my/pop-window-configuration)
  (setq same-window-buffer-names
        '( "*eshell*"
           "*shell*"
           "*mail*"
           "*inferior-lisp*"
           "*ielm*"
           "*scheme*"           ))
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
  :hook (woman-mode . olivetti-mode)
  :config
  (setq woman-imenu t)
  )


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
