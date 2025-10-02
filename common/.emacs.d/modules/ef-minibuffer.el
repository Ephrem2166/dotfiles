;;; ef-minibuffer.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:
;;; TODO Completion Preview
(use-package completion-preview
  :ensure nil
  :custom
  (completion-preview-ignore-case t)
  (completion-preview-minimum-symbol-length 3)
  :config
  (completion-preview-mode 1)

  )

;;; icomplete
(use-package icomplete
  :disabled
  :ensure nil
  :config
  (setopt icomplete-delay-completions-threshold 0)
  (setopt icomplete-compute-delay 0)
  (setopt icomplete-show-matches-on-no-input t)
  (setopt icomplete-hide-common-prefix nil)
  (setopt icomplete-prospects-height 10)
  (setopt icomplete-separator " . ")
  (setopt icomplete-with-completion-tables t)
  (setopt icomplete-in-buffer t)
  (setopt icomplete-max-delay-chars 0)
  (setopt icomplete-scroll t)
  (fido-mode 1)
  (fido-vertical-mode 1)
  )

;;; Minibuffer
(use-package minibuffer
  :ensure nil
  :bind (
         :map minibuffer-local-map
         ("C-p" . minibuffer-previous-completion)
         ("C-n" . minibuffer-next-completion)
         )
  :config
  (setopt enable-recursive-minibuffers t)
  (setopt tab-always-indent 'complete)
  (setopt read-buffer-completion-ignore-case t)
  (setopt read-file-name-completion-ignore-case t)
  (setopt completion-auto-help t)
  (setopt completions-detailed t)
  (setopt completion-auto-select 'second-tab)
  (setopt completion-cycle-threshold 5)
  (setopt completions-format 'one-column)
  (setopt completions-sort 'historical)
  (setopt completions-max-height 100)
  (setopt completion-show-help t)
  (setopt completion-ignore-case t)
  (setopt enable-recursive-minibuffers t)
  (setopt completion-styles '(partial-completion flex substring basic initials))
;;;; Keep the cursor out of the read-only portions of the minibuffer
  (setopt minibuffer-prompt-properties
          '( read-only t
             cursor-intangible t
             face minibuffer-prompt))
  )

;;; From Doom Emacs
;; (use-package minibuffer
;;   :ensure nil
;;   :hook ((minibuffer-setup . defer-garbage-collection)
;;          (minibuffer-setup . restore-garbage-collection))
;;
;;   :preface
;;   (defun defer-garbage-collection ()
;;     (setq gc-cons-threshold most-positive-fixnum))
;;
;;   (defvar default-gc-cons-threshold)
;;   (defun restore-garbage-collection ()
;;     ;; Deferred so that commands launched immediately after will enjoy the
;;     ;; benefits.
;;     (run-at-time
;;      1 nil (lambda () (setq gc-cons-threshold default-gc-cons-threshold))))
;;
;;   )

(provide 'ef-minibuffer)
;;; ef-minibuffer.el ends here
