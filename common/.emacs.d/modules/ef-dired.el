;;; ef-dired.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:
;;; Dired
(use-package dired
  :ensure nil
  :bind
  ("C-x d" . list-directory)
  :hook (
         (dired-mode . dired-hide-details-mode)
         (dired-mode . hl-line-mode)
         )
  :config
  (setq dired-deletion-confirmer 'y-or-n-p)
  ;; (setq dired-recursive-copies 'always)
  (setq dired-create-destination-dirs 'ask)
  (setq dired-dwim-target t)
  (setq delete-by-moving-to-trash t)
  (setq dired-omit-files "^\\.[^.]\\|$Rhistory\\|$RData\\|__pycache__")
  (setq dired-omit-verbose nil)
  (setq dired-dwim-target 'dired-dwim-target-next)
  (setq dired-hide-details-hide-symlink-targets nil)
  (setq dired-kill-when-opening-new-dired-buffer t)
  (setq dired-create-destination-dirs 'ask)
  (setq dired-omit-verbose nil)
  (setq dired-listing-switches
        "-AGFhlv --group-directories-first --time-style=long-iso")
  (setq dired-auto-revert-buffer #'dired-directory-changed-p) ; also see `dired-do-revert-buffer'
  (setq dired-make-directory-clickable t) ; Emacs 29.1
  (setq dired-guess-shell-alist-user
        (list
         (list "\\.pptx?$" "libreoffice &")
         (list "\\.odf$" "libreoffice &")
         (list "\\.odt$" "libreoffice &")
         (list "\\.odt$" "libreoffice &")
         (list "\\.svg$" "gimp")
         (list "\\.csv$" "libreoffice &")
         (list "\\.sla$" "scribus")
         (list "\\.od[sgpt]$" "libreoffice &")
         (list "\\.xls$" "libreoffice &")
         (list "\\.xlsx$" "libreoffice &")
         (list "\\.jpe?g$" "sxiv")
         (list "\\.png$" "sxiv")
         (list "\\.gif$" "sxiv")
         (list "\\.psd$" "gimp")
         (list "\\.xcf" "gimp")
         (list "\\.3gp$" "vlc")
         (list "\\.mp3$" "vlc")
         (list "\\.flac$" "vlc")
         (list "\\.avi$" "vlc")
         ;; (list "\\.og[av]$" "vlc")
         (list "\\.wm[va]$" "vlc")
         (list "\\.flv$" "vlc")
         (list "\\.mov$" "vlc")
         (list "\\.divx$" "vlc")
         (list "\\.mp4$" "vlc")
         (list "\\.webm$" "vlc")
         (list "\\.mkv$" "vlc")
         (list "\\.mpe?g$" "vlc")
         (list "\\.m4[av]$" "vlc")
         (list "\\.mp2$" "vlc")
         (list "\\.pp[st]$" "libreoffice &")
         (list "\\.ogg$" "vlc")
         (list "\\.ogv$" "vlc")
         (list "\\.rtf$" "libreoffice &")
         (list "\\.mp3$" "play")
         (list "\\.wav$" "vlc")
         ))
  (setq dired-free-space nil)
  (setq dired-vc-rename-file t)
  (setq dired-clean-confirm-killing-deleted-buffers nil)
  (setq dired-mouse-drag-files t)
  ;;; Function
  (defun my/dired-mode-hook ()
    (setq-local truncate-lines t))
  (add-hook 'dired-mode-hook #'my/dired-mode-hook)
  )


;;; Dired-git
;; Git Integration for dired
;; Show git info in dired
(use-package dired-git
  :disabled
  :hook
  (dired-mode . dired-git-mode)
  :custom
  (dired-git-disable-dirs '("~/"))
  (dired-git-parallel 7))               ; Number of parallel processes

;;; Diredfil
;; Extra font lock rules for a more colorful dired
;; Colorful dired
(use-package diredfl
  :hook (dired-mode . diredfl-mode))

;;; Dired-subtree
;; Insert subdirectories in a tree like fashion
;; toggle subtree visibility with 'TAB'
;; makes dired a much more pleasant file manager
(use-package dired-subtree
  :ensure t
  ;; :demand t
  :after dired
  :bind (
         :map dired-mode-map
         ("TAB" . dired-subtree-toggle))
  :config
  (advice-add 'dired-subtree-toggle
              :after (lambda () (interactive)
                       (when all-the-icons-dired-mode
                         (revert-buffer))))
  )


;;; Wdired (Writable dired
(use-package wdired
  :ensure nil
  :commands (wdired-change-to-wdired-mode)
  :config
  (setq wdired-allow-to-change-permissions t)
  (setq wdired-create-parent-directories t))

;;; Dired Open
;;Open Files from dired using custom actions
(use-package dired-open
  :ensure t
  :after dired
  :config
  (setq dired-open-extensions '(
                                ("gif" . "sxiv")
                                ("jpg" . "sxiv")
                                ("png" . "sxiv")
                                ("mp3" . "vlc")
                                ("mkv" . "mpv")
                                ("mp4" . "mpv"))))

;;; Dired Filter
;; Ibuffer like filtering for dired
;; (use-package dired-filter
;;   :ensure nil
;;   :after dired)

;;; Dired Aux
(use-package dired-aux
  :ensure nil
  ;; :disabled
  :defer
  :after dired
  :bind
  ( :map dired-mode-map
    ("C-+" . dired-create-empty-file)
    ("M-s f" . nil)
    ("C-<return>" . dired-do-open) ; Emacs 30
    ("C-x v v" . dired-vc-next-action)) ; Emacs 28
  :config
  (setq dired-isearch-filenames 'dwim)
  (setq dired-create-destination-dirs 'ask) ; Emacs 27
  (setq dired-vc-rename-file t)             ; Emacs 27
  (setq dired-do-revert-buffer (lambda (dir) (not ))) ; Emacs 28
  (setq dired-create-destination-dirs-on-trailing-dirsep t)) ; Emacs 29

;;; Dired-x
(use-package dired-x
  :ensure nil
  :after dired
  :bind
  ( :map dired-mode-map
    ("I" . dired-info))
  :config
  (setq dired-clean-up-buffers-too t)
  (setq dired-clean-confirm-killing-deleted-buffers t)
  (setq dired-x-hands-off-my-keys t)    ; easier to show the keys I use

  (setq dired-bind-man nil)
  (setq dired-bind-info nil))

;;; Image Dired
(use-package image-dired
  :ensure nil
  :commands (image-dired)
  :bind
  ( :map image-dired-thumbnail-mode-map
    ("<return>" . image-dired-thumbnail-display-external))
  :config
  (setq image-dired-thumbnail-storage 'standard)
  (setq image-dired-external-viewer "xdg-open")
  (setq image-dired-thumb-size 80)
  (setq image-dired-thumb-margin 2)
  (setq image-dired-thumb-relief 0)
  (setq image-dired-thumbs-per-row 4))

;;; Peep-dired
;; Peep at files in another window from dired buffers
;; Preview files before loading them.
(use-package peep-dired
  :ensure t
  :defer t
  )

;;; Trashed
;; Viewing/editing system trash can
(use-package trashed
  :ensure t
  :commands (trashed)
  :config
  (setq trashed-action-confirmer 'y-or-n-p)
  (setq trashed-use-header-line t)
  (setq trashed-sort-key '("Date deleted" . t))
  (setq trashed-date-format "%Y-%m-%d %H:%M:%S"))

;;; Dirvish
;; A modern file manager based on dired mode
(use-package dirvish
  :disabled
  :ensure t
  :init (dirvish-override-dired-mode)
  ;; :bind
  ;; (("C-c f" . dirvish)
  ;;  :map dirvish-mode-map          ; Dirvish inherits `dired-mode-map'
  ;;  ("?"   . dirvish-dispatch)     ; contains most of sub-menus in dirvish extensions
  ;;  ("a"   . dirvish-quick-access)
  ;;  ("f"   . dirvish-file-info-menu)
  ;;  ("y"   . dirvish-yank-menu)
  ;;  ("N"   . dirvish-narrow)
  ;;  ("^"   . dirvish-history-last)
  ;;  ("h"   . dirvish-history-jump) ; remapped `describe-mode'
  ;;  ("s"   . dirvish-quicksort)    ; remapped `dired-sort-toggle-or-edit'
  ;;  ("v"   . dirvish-vc-menu)      ; remapped `dired-view-file'
  ;;  ("TAB" . dirvish-subtree-toggle)
  ;;  ("M-f" . dirvish-history-go-forward)
  ;;  ("M-b" . dirvish-history-go-backward)
  ;;  ("M-l" . dirvish-ls-switches-menu)
  ;;  ("M-m" . dirvish-mark-menu)
  ;;  ("M-t" . dirvish-layout-toggle)
  ;;  ("M-s" . dirvish-setup-menu)
  ;;  ("M-e" . dirvish-emerge-menu)
  ;;  ("M-j" . dirvish-fd-jump))
  :custom
  (dirvish-quick-access-entries
   '(("h" "~/" "Home")
     ("d" "~/Downloads/" "Downloads")
     ("c" "~/org/config" "Config")
     ("m" "/mnt/"                       "Drives")
     ("t" "~/.local/share/Trash/files/" "TrashCan")))
  :config
  ;;  (setq dired-mouse-drag-files t)                   ; added in Emacs 29
  ;;  (setq mouse-drag-and-drop-region-cross-program t) ; added in Emacs 29
  ;; (dirvish-peek-mode)
  ;; Option 1
  (setq  dirvish-mode-line-format
         '(:left
           (" " file-modes " " file-link-number " " file-user ":" file-group " "
            symlink omit vc-info)
           :right
           (sort yank index)))
  ;; Option 2
  ;; (setq dirvish-mode-line-format
  ;; '(:left (sort file-time "" file-size symlink) :right (omit yank index)))
  (setq dirvish-attributes
        '(nerd-icons file-time file-size collapse subtree-state vc-state git-msg)
        dirvish-side-attributes
        '(vc-state file-size nerd-icons collapse))
  ;; (setq dirvish-attributes '(all-the-icons file-size collapse subtree-state vc-state git-msg))
  (setq dirvish-yank-new-name-style 'append-to-filename)
  (setq dirvish-header-line-format
        '(:left
          (path symlink)
          :right
          (free-space)))
  (setq  dirvish-layout-recipes
         (list '(0 0 0.8)
               '(0 0 0.4)
               dirvish-default-layout))
  (setq dirvish-mode-line-position 'global)
  (setq delete-by-moving-to-trash t)
  (setq dired-listing-switches
        "-l --almost-all --human-readable --group-directories-first --no-group")
  (setq dirvish-yank-overwrite-existing-files 'never)
  (setq dired-dwim-target         t
        dired-recursive-copies    'always
        dired-recursive-deletes   'top
        delete-by-moving-to-trash t
        dirvish-preview-dispatchers (cl-substitute 'pdf-preface 'pdf dirvish-preview-dispatchers))

  )

;;; Dired Keybindings
(use-package dired
  :ensure nil
  :bind (
         :map dired-mode-map
         ("<backspace>" . dired-up-directory)
         ("." . dired-find-file)
         ("c" . dired-create-directory)
         ("d" . dired-do-delete)
         ("i" . dired-info)
         ("r" . dired-do-rename)
         ))

;; (define-key dired-mode-map (kbd "<backspace>") 'dired-up-directory)

;; (define-key python-mode-map (kbd "C-c p") 'python-shell-switch-to-shell)

;; Enable mouse support in Dired
(put 'dired-find-alternate-file 'disabled nil)


(provide 'ef-dired)
;;; ef-dired.el ends here
