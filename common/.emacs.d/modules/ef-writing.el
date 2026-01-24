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
         ((org-mode text-mode) . flyspell-mode)
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
  :init
  (setq jinx-languages "en_US")
  :config
  (dolist (hook '(text-mode-hook
                  org-mode-hook
                  markdown-mode-hook))
    (add-hook hook #'jinx-mode)))


;;; Writeroom
;; A distraction-free writing mode
(use-package writeroom-mode
  :ensure t
  :bind (
         :map ef-toggle-keymap
         ("w" . writeroom-mode))
  :defer t
  :hook
  (writeroom-mode-enable . set-buffer-writing-font)
  (writeroom-mode-disable . unset-buffer-writing-font)
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
  (defface my-writing-face
    '((t (:height 1.5 :family "ia Writer Duo S")))
    "A face used for writing")

  (defun set-buffer-writing-font ()
    "Sets font in current buffer"
    (interactive)
    (buffer-face-set 'my-writing-face)
    (setq line-spacing 4))

  (defun unset-buffer-writing-font ()
    "Sets font in current buffer"
    (interactive)
    (buffer-face-set 'default)
    (setq line-spacing nil))
  )


(provide 'ef-writing)
;;; ef-writing.el ends here
