(use-package icomplete
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


(use-package minibuffer
  :ensure nil
  :bind (
	 :map minibuffer-local-map
	      ("C-p" . minibuffer-previous-completion)
	      ("C-n" . minibuffer-next-completion)
	 )
  :custom
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
)
(provide 'ef-minibuffer)
