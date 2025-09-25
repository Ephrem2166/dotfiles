;; Yasnippet
;; Yet another snippet extension for Emacs
(use-package yasnippet
  :ensure t
  ;; :init
  ;; (yas-global-mode 1)
  :hook (((prog-mode LaTeX-mode org-mode
                     eval-expression-minibuffer-setup)
          . yas-minor-mode))
  :config
  (setq yas-wrap-around-region t)
  (setq yas-verbosity 1)
  (add-to-list 'yas-snippet-dirs (concat user-emacs-directory "/etc/snippets/"))
  ;; to load Yasnippet on a per bxuffer basis
  (yas-reload-all)
  )
;; Yasnippet snippets
(use-package yasnippet-snippets
  :disabled
  :ensure t
  :defer t
  :after (yasnippet)
  )
(provide 'ef-yasnippet)

