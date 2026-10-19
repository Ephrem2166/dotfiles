;;; ef-writing.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:

;;; Flyspell
;; Builtin Alternative
(use-package flyspell
  :disabled
  :after aspell
  :ensure nil
  :defer t
  :commands (flyspell-mode flyspell-prog-mode)
  :hook (
		 (prog-mode . flyspell-prog-mode)
;;		 ((org-mode text-mode markdown-mode) . flyspell-mode)
		 )
  :bind ("C-c C-;" . flyspell-auto-correct-word)
  :config
  ;; Don't consider that a word repeated twice is an error.
  (setq flyspell-mark-duplication-flag nil)

  ;; Dash character (`-') is considered as a word delimiter.
  (setq-default flyspell-consider-dash-as-word-delimiter-flag t)
  (setq ispell-program-name (s-trim (shell-command-to-string "which aspell")))
  (setq ispell-dictionary "en_US")
  (eval-after-load "flyspell"
	' (progn
		(define-key flyspell-mouse-map [down-mouse-3] #'flyspell-correct-word)
		(define-key flyspell-mouse-map [mouse-3] #'undefined)))
  (global-font-lock-mode t)
  (custom-set-faces '(flyspell-incorrect ((t (:inverse-video t)))))
  (setq ispell-silently-savep t)
  (setq flyspell-abbrev-p nil)
  (setq flyspell-use-meta-tab nil)
  )


;;; Jinx
;; JIT spell checker that uses `enchant'.
;; Enchant
;; Enchant is a library (and command-line program) that wraps
;; a number of different spelling libraries and programs with
;; a consistent interface.
;; Install from here https://github.com/rrthomas/enchant to use with Jinx
(use-package jinx
  :ensure t
  ;; :hook (org-mode . global-jinx-mode)
  ;; :hook
  ;; (org-mode . jinx-mode)
  :bind (("C-c j ." . jinx-correct)
		 ("C-c j a" . jinx-correct-all)
		 ("C-c j w" . jinx-correct-word)
		 ("C-c j /" . jinx-correct-nearest)
		 ("C-c j ," . jinx-languages))
  :hook ((text-mode     . jinx-mode)
		 (org-mode      . jinx-mode)
		 (markdown-mode . jinx-mode))
  :custom
  (jinx-languages "en_US")

  (set-face-attribute 'jinx-misspelled nil :underline '(:style wave :color "orange red"))
  )


;;; Writeroom
;; A distraction-free writing mode
;; Writerroom with Org-Mode
(defun my/writeroom-org-prose-setup ()
  "Adjust Org settings for a distraction-free prose experience."
  (when (eq major-mode 'org-mode)
	;; 1. Disable visual clutter
	(display-line-numbers-mode -1)
	(org-indent-mode -1) ; Optional: turns off indentation for a more "flat" look

	;; 2. Adjust text width (visual-fill-column is used by writeroom internally)
	(setq-local visual-fill-column-width 70) ; A comfortable width for reading

	;; 3. (Optional) Tweak org-modern if you use it
	(when (featurep 'org-modern)
	  (setq-local org-modern-hide-stars t)
	  (org-modern-mode -1)
	  (org-modern-mode 1))))

(defun my/writeroom-org-prose-teardown ()
  "Restore Org settings after exiting writeroom."
  (when (eq major-mode 'org-mode)
	;; Restore original settings. You may want to save the previous state.
	(display-line-numbers-mode 1)
	(org-indent-mode 1)
	;; Note: org-modern will be restored by its own global mode
	))
(use-package writeroom-mode
  :ensure t
  :bind (
		 :map ef-toggle-keymap
		 ("w" . writeroom-mode))
  :hook (
		 (writeroom-mode-enable . my/writeroom-org-prose-setup)
		 (writeroom-mode-disable . my/writeroom-org-prose-teardown)
		 (writeroom-mode . my/writeroom-toggle-font))
  :custom
  (writeroom-width 80)
  (writeroom-maximize-window nil)
  (writeroom-fullscreen-effect 'maximized)
  (writeroom-global-effects
   '(
	 writeroom-set-alpha
	 ;; writeroom-set-fullscreen
	 writeroom-set-vertical-scroll-bars
	 writeroom-set-bottom-divider-width
	 )
   )
  :preface
  (defvar-local my/writeroom-saved-line-spacing nil
	"Line spacing before writeroom-mode was enabled.")

  (defface my-writing-face
	`((t (:height 1.5 :family
				  ,(or (when (find-font (font-spec :family "ia Writer Duo S"))
						 "ia Writer Duo S")
					   (and (boundp 'my/available-variable-font)
							my/available-variable-font)
					   "Sans"))))
	"Face for distraction-free writing.")

  (defun my/writeroom-toggle-font ()
	"Apply or remove the writing face and line spacing.
Bound to `writeroom-mode-hook', checks `writeroom-mode' to decide direction."
	(if writeroom-mode
		(progn
		  (setq-local my/writeroom-saved-line-spacing line-spacing)
		  (buffer-face-set 'my-writing-face)
		  (setq-local line-spacing 4))
	  (buffer-face-set 'default)
	  (setq-local line-spacing my/writeroom-saved-line-spacing)))

  )


(provide 'ef-writing)
;;; ef-writing.el ends here
