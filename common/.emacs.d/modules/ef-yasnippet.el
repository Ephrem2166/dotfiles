;;; ef-yasnippet.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:

;;; Yasnippet
;; Yet another snippet extension for Emacs
(use-package yasnippet
  :ensure t
  ;; :preface
  ;; ;; Allow yasnippet and org mode expansion to work together
  ;; (defun yas-org-very-safe-expand ()
  ;;   "Expand the snippet at point and copy the expansion to the clipboard safely in org-mode."
  ;;   (let ((yas-fallback-behavior 'return-nil))
  ;;     (yas-expand)))
  ;; ;
  ;; :init
  ;; (yas-global-mode 1)
  :hook (((prog-mode LaTeX-mode org-mode
                     eval-expression-minibuffer-setup)
          . yas-minor-mode))
  :config
  ;; (setq yas-trigger-symbol "<tab>")
  (setq yas-wrap-around-region t)
  (setq yas-verbosity 1)
  (setq yas-snippet-dirs '("~/dotfiles/common/.emacs.d/etc/snippets/"))
  ;; (add-to-list 'yas-snippet-dirs (concat user-emacs-directory "etc/snippets/"))
  ;; to load Yasnippet on a per bxuffer basis
  (yas-reload-all)
  :delight "Y"
  )
;;; Yasnippet snippets
(use-package yasnippet-snippets
  :disabled
  :ensure t
  :defer t
  :after (yasnippet)
  )


;;; FIXME: Function to create snippets interactively
;; (defvar snippets-dir "~/dotfiles/common/.emacs.d/etc/snippets/")

;; (defun new-yasnippet ()
;;   "Create a new Org-mode snippet file."
;;   (interactive)
;;   (let ((snippet-dir (concat user-emacs-directory "/etc/snippets/"))
;;         (snippet-name (read-string "Snippet name: "))
;;         (snippet-key (read-string "Snippet key: "))
;;         full-path)
;;
;;     ;; Construct the full file path
;;     (setq full-path (concat snippet-dir snippet-name ""))
;;
;;     ;; Ensure the snippet directory exists
;;     (unless (file-exists-p snippet-dir)
;;       (make-directory snippet-dir t))
;;
;;     ;; Check if the file already exists
;;     (if (file-exists-p full-path)
;;         (if (yes-or-no-p "Snippet file already exists. Overwrite? ")
;;             (create-and-insert-snippet full-path snippet-name snippet-key)
;;           (message "Snippet creation canceled."))
;;       (create-and-insert-snippet full-path snippet-name snippet-key))))
;;
;; (defun create-and-insert-snippet (full-path snippet-name snippet-key)
;;   "Helper function to create and insert snippet content."
;;   ;; Create and open the new snippet file
;;   (find-file full-path)
;;   ;; Insert the snippet structure
;;   (insert "# -*- mode: snippet -*-\n")
;;   (insert "# name: " snippet-name "\n")
;;   (insert "# key: " snippet-key "\n")
;;   (insert "# --\n")
;;   (insert "$0\n"))


(provide 'ef-yasnippet)
;;; ef-yasnippet.el ends here
