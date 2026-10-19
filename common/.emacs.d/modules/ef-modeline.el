;;; ef-modeline.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:
(require 'nerd-icons nil t)
(setq nerd-icons-font-family "Berkeley Nerd Font")
(setq mode-line-default-help-echo nil
	  show-help-function nil)
(defvar ef/mode-line-cleaner-alist
  '(
	;; ─── Completion / editing ───
	(corfu-mode         . " ")   ; key icon
	(yas-minor-mode     . " ")   ; snippet icon
	(abbrev-mode        . " ")   ; abbreviation/cog
	(subword-mode       . " ")   ; font/case icon
	(eldoc-mode         . "󰙎 ")   ; info icon
	(rainbow-mode       . " ")   ; tint/droplet
	(valign-mode        . "󰑭 ")   ; ruler/align
	(hs-minor-mode      . " ")   ; fold/compress
	(outline-minor-mode . " ")   ; list tree
	(visual-line-mode   . " ")   ; paragraph/wrap
	(auto-revert-mode   . " ")   ; refresh

	;; ─── Evil ───
	(evil-snipe-local-mode           . " ")   ; search
	(evil-goggles-mode               . "󰈈 ")   ; eye
	(evil-commentary-mode            . "󰅺 ")   ; comment
	(evil-collection-unimpaired-mode . " ")   ; operator/cogs

	;; ─── Development ───
	(flymake-mode       . " ")   ; check-circle
	(flyspell-mode      . " ")   ; spell-check
	(which-key-mode     . "󰌌 ")   ; keyboard
	(gcmh-mode          . " ")   ; memory/chip
	(apheleia-mode      . " ")   ; wand/magic
	(org-indent-mode    . " ")   ; indent
	(winner-mode        . "󰋚 ")   ; history
	(so-long-mode       . " ")   ; warning triangle

	;; ─── Major modes ───
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
	(gitignore-mode        . " ")
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
  "Alist of (MODE . LIGHTER) replacements for `mode-name' and minor-mode lighters.")

(defun ef/clean-mode-line ()
  "Replace minor-mode lighters and major-mode name per `ef/mode-line-cleaner-alist'."
  (dolist (entry ef/mode-line-cleaner-alist)
	(let ((mode (car entry))
		  (mode-str (cdr entry)))
	  ;; Major mode name.
	  (when (eq mode major-mode)
		(setq mode-name mode-str))
	  ;; Minor mode lighter (only if it's a mutable list).
	  (when-let* ((lighter (cdr (assq mode minor-mode-alist)))
				  ((consp lighter))
				  ((not (eq (car-safe lighter) :eval))))
		(setcar lighter mode-str)))))

;; 📎 NOTE:: It runs everytime a new buffer is opened
;; (add-hook 'after-change-major-mode-hook #'ef/clean-mode-line)
(add-hook 'emacs-startup-hook #'ef/clean-mode-line)
(add-hook 'after-change-major-mode-hook #'ef/clean-mode-line)
;; Also call once now, in case buffers exist before emacs-startup-hook:
(ef/clean-mode-line)



(setq mode-line-compact nil)
(setq mode-line-right-align-edge 'right-fringe)
;; Position
(setq mode-line-position-column-line-format '(" L%l:C%C"))
(setq mode-line-percent-position nil)
;; (column-number-mode 1)
;; (line-number-mode 1)

;; Date and Time
(setq display-time-format " %a, %b %e 󰥔 %R"
	  battery-mode-line-format "󰁹 %p%%%")

(setq mode-line-end-spaces
	  '(:eval
		(list
		 (propertize " " 'display
					 `(space :align-to
							 (- right
								,(+ (string-width (or battery-mode-line-string ""))
									(string-width (or display-time-string ""))
									2))))
		 battery-mode-line-string
		 " "
		 display-time-string)))

(display-time-mode 1)
;; (display-time-update)

;; Battery
(display-battery-mode)


;; Mode Line Right
(defvar mode-line-right-format nil
  "The mode line to display on the right side.")

(defun mode-line-right ()
  "Render the `mode-line-right-format'."
  (let ((formatted-line (format-mode-line mode-line-right-format)))
	(list
	 (propertize
	  " "
	  'display
	  `(space :align-to (- (+ right right-fringe right-margin) ,(string-width formatted-line))))
	 formatted-line)))

;; Major Mode
;; (defvar mode-line-major-mode
;;   `(:propertize ("" mode-name)
;; 				help-echo "Major mode\n\
;; mouse-1: Display major mode menu\n\
;; mouse-2: Show help for major mode\n\
;; mouse-3: Toggle minor modes"
;; 				mouse-face mode-line-highlight
;; 				local-map ,mode-line-major-mode-keymap))
(defvar mode-line-major-mode
  '(:propertize ("" mode-name)
				;; help-echo "Major mode\nmouse-1: Display major mode menu\nmouse-2: Show help for major mode"
				;; mouse-face mode-line-highlight
				local-map mode-line-major-mode-keymap))

(setq mode-line-right-format
	  (list '(:eval mode-line-mule-info)
			"  "
			mode-line-major-mode))


(column-number-mode 1)
(line-number-mode 1)


;; Modified Icons
;; (defun ef/mode-line-modified-icons ()
;;   "Icon representation of `mode-line-modified'."
;;   (when (fboundp 'all-the-icons-octicon)
;; 	(cond (buffer-read-only
;; 		   (concat (all-the-icons-octicon "lock" :v-adjust -0.05) " "))
;; 		  ((buffer-modified-p)
;; 		   (concat (all-the-icons-faicon "floppy-o" :v-adjust -0.05) " "))
;; 		  ((and buffer-file-name
;; 				(not (file-exists-p buffer-file-name)))
;; 		   (concat (all-the-icons-octicon "circle-slash" :v-adjust -0.05) " ")))))
(defun ef/mode-line-modified-icons ()
  "Icon representing modification state, or nil."
  (when (fboundp 'nerd-icons-octicon)
	(cond (buffer-read-only
		   (concat (nerd-icons-octicon "nf-oct-lock" :v-adjust -0.05) " "))
		  ((buffer-modified-p)
		   (concat (nerd-icons-faicon "nf-fa-floppy_o" :v-adjust -0.05) " "))
		  ((and buffer-file-name
				(not (file-exists-p buffer-file-name)))
		   (concat (nerd-icons-faicon "nf-fa-ban" :v-adjust -0.05) " ")))))


(setq-default mode-line-modified '((:eval (ef/mode-line-modified-icons))))


;; Remote
;; (defun ef/mode-line-remote-icons ()
;;   "Icon representation of `mode-line-remote'."
;;   (when (and buffer-file-name
;; 			 (file-remote-p buffer-file-name))
;; 	(concat (all-the-icons-octicon "radio-tower" :v-adjust -0.02) " ")))

(defun ef/mode-line-remote-icons ()
  "Icon indicating remote buffer, or nil."
  (when (and (fboundp 'nerd-icons-faicon)
			 buffer-file-name
			 (file-remote-p buffer-file-name))
	(concat (nerd-icons-faicon "nf-fa-rss" :v-adjust -0.02) " ")))

(setq-default mode-line-remote   '((:eval (ef/mode-line-remote-icons))))

;; VCS
;; (defun ef/vc-git-mode-line-shorten (string)
;;   "Shorten `version-control' STRING in the mode line and add icon."
;;   (if (not (and (fboundp 'all-the-icons-octicon)
;; 				(stringp string)
;; 				(string-prefix-p "Git" string)))
;; 	  string
;; 	(let* ((icon  (all-the-icons-octicon "git-branch" :v-adjust -0.05))
;; 		   (rest  (string-trim-left (substring string 3) "[:/ ]")))
;; 	  (concat icon " "
;; 			  (if (> (length rest) 25)
;; 				  (concat (substring-no-properties rest 0 25) "…")
;; 				(substring-no-properties rest))))))
(defun ef/vc-git-mode-line-shorten (string)
  "Shorten `vc-git-mode-line-string' STRING and prepend a git icon."
  (if (not (and (fboundp 'nerd-icons-octicon)
				(stringp string)
				(string-prefix-p "Git" string)))
	  string
	(let* ((icon (nerd-icons-octicon "nf-oct-git_branch" :v-adjust -0.05))
		   (rest (string-trim-left (substring string 3) "[:/ ]")))
	  (concat icon " "
			  (if (> (length rest) 25)
				  (concat (substring-no-properties rest 0 25) "…")
				(substring-no-properties rest))))))

(advice-add 'vc-git-mode-line-string :filter-return #'ef/vc-git-mode-line-shorten)


(defun ef/mode-line-buffer-name ()
  "Buffer name, with modified/read-only styling."
  (let ((name (format-mode-line "%b")))
	(propertize name 'face
				(cond ((and buffer-file-name (not (file-exists-p buffer-file-name)))
					   'error)
					  (buffer-read-only 'mode-line-buffer-id)
					  ((buffer-modified-p) 'bold)
					  (t 'mode-line-buffer-id)))))

;; Coding System
(setq eol-mnemonic-unix ""
	  eol-mnemonic-dos (propertize "[CR+LF]" 'face 'warning)
	  eol-mnemonic-mac (propertize "[CR]" 'face 'warning)
	  eol-mnemonic-undecided (propertize "[?]" 'face 'error))

(setq-default mode-line-mule-info
			  '(""
				(:eval
				 (when (bound-and-true-p buffer-file-coding-system)
				   (let ((mnemonic (format-mode-line "%z")))
					 (unless (string-equal mnemonic "U")
					   (propertize (format "[%s]" mnemonic) 'face 'warning)))))))


;; (setq-default mode-line-modes
;; 			  '("%["
;; 				" "
;; 				(:propertize ("" mode-name)
;; 							 face mode-line-buffer-id
;; 							 help-echo "Major mode\nmouse-1: Major mode menu\nmouse-2: Help\nmouse-3: Toggle"
;; 							 mouse-face mode-line-highlight
;; 							 local-map mode-line-major-mode-keymap)
;; 				(:propertize (" " mode-line-process)
;; 							 face font-lock-warning-face)
;; 				(:propertize ("" minor-mode-alist)
;; 							 face shadow
;; 							 help-echo "Minor modes\nmouse-1: Toggle minor modes"
;; 							 mouse-face mode-line-highlight
;; 							 local-map mode-line-minor-mode-keymap)
;; 				"%]"))

(setq-default mode-line-modes
			  '((:propertize ("" mode-name)
							 face font-lock-keyword-face
							 help-echo "Major mode\nmouse-1: Menu\nmouse-2: Help"
							 mouse-face mode-line-highlight
							 local-map mode-line-major-mode-keymap)

				(:propertize mode-line-process face font-lock-warning-face)
				))


;; (setq-default mode-line-modes
;; 			  '("%["
;; 				" "
;; 				mode-line-major-mode
;; 				(:propertize (" " mode-line-process)
;; 							 face font-lock-warning-face)
;; 				(:propertize ("" minor-mode-alist)
;; 							 face shadow
;; 							 help-echo "Minor modes\nmouse-1: Toggle minor modes"
;; 							 mouse-face mode-line-highlight
;; 							 local-map mode-line-minor-mode-keymap)
;; 				"%]"))

;; In ef-modeline.el, replacing the current mode-line-misc-info setup:
(setq mode-line-misc-info
	  '((:eval
		 (when-let ((visible (seq-remove
							  (lambda (x)
								(memq x '(display-time-string
										  battery-mode-line-string)))
							  global-mode-string)))
		   (format-mode-line visible)))))

(setq-default mode-line-format
			  '("%e" ; print error message about full memory.
				"%["
				" "
				(:propertize " " display (raise +0.4)) ;; Top padding
				(:propertize " " display (raise -0.4)) ;; Bottom padding
				(:propertize "λ " face font-lock-keyword-face)
				;; mode-line-front-space
				;; mode-line-mule-info
				;; mode-line-client
				mode-line-modified
				;; mode-line-remote
				;; mode-line-frame-identification
				mode-line-buffer-identification
				;; Buffer Name
				;; (:eval
				;; (concat (format-mode-line "%b")
				;; Narrowing indicator
				;; (if (buffer-narrowed-p) "  Narrow" "")))
				" "
				;; mode-line-format-right-align
				;; (vc-mode vc-mode)
				;; "  "
				;; " "
				mode-line-position
				" "
				;; (:propertize "%4l:%c" face mode-line-buffer-id)
				mode-line-misc-info
				;; mode-line-major-mode
				mode-line-modes
				;; (:eval (mode-line-right))
				;; battery-mode-line-string
				;; mode-line-right
				mode-line-end-spaces
				"%]"))

(provide 'ef-modeline)
;;; ef-modeline.el ends here
