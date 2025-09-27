;;; ef-evil.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:
;; Evil
;; Extensible evil layer
;; evil-want-keybinding must be declared before Evil and Evil Collection
(setq evil-want-keybinding nil)
(use-package evil
  :ensure t
  :demand t
  :init
  (setq evil-want-keybinding nil)
  (setq evil-overriding-maps nil)
  (setq evil-intercept-maps nil)
  (setq evil-insert-state-bindings nil)
  ;; Basics
  (setq evil-want-integration t)
  (setq evil-search-module 'isearch)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-d-scroll t)
  (setq evil-want-C-i-jump nil)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  (setq evil-undo-system 'undo-redo)
  (setq evil-respect-visual-line-mode t)
  (setq evil-want-C-i-jump nil)
  (setq evil-want-Y-yank-to-eol t)
  ;; Undo with u and redo with C-r
  (setq evil-undo-system 'undo-redo)
  ;; prevent esc-key from translating to meta-key in terminal mode
  (setq evil-esc-delay 0)
  ;;Colors
  (setq evil-mode-line-format nil)
  (setq evil-normal-state-cursor '(box "#C678DD"))
  (setq evil-normal-state-cursor '(box "#DFDFDF"))
  (setq evil-motion-state-cursor '(box "#98BE65"))
  (setq evil-insert-state-cursor '(bar "#51AFEf"))
  (setq evil-emacs-state-cursor '(bar "#FF6C68"))
  (setq evil-visual-state-cursor '(box "#DA854B"))
  :config
  ;; (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-mode 1))


;; Evil Collection
;; A set of keybindings for evil mode
(use-package evil-collection
  :after evil
  :ensure t
  :init
  (setq evil-collection-key-blacklist '("C-n"))
  (setq evil-collection-outline-bind-tab-p t)
  :config
  (evil-collection-init))

;; Evil Surround
;; Emulate surround.vim
(use-package evil-surround
  :ensure t
  :after evil
  :defer t
  :custom
  (evil-surround-pairs-alist
   '((?\( . ("(" . ")"))
     (?\[ . ("[" . "]"))
     (?\{ . ("{" . "}"))

     (?\) . ("(" . ")"))
     (?\] . ("[" . "]"))
     (?\} . ("{" . "}"))

     (?< . ("<" . ">"))
     (?> . ("<" . ">"))))

  :hook (after-init . global-evil-surround-mode)
  )


;; Evil Commentary
;; Comment stuff out.
;; A Port of vim-commentary.
(use-package evil-commentary
  :after evil
  :config
  (evil-commentary-mode)) ;; globally enable evil-commentary

;; Evil Commentary Alternative
;; (with-eval-after-load "evil"
;;   (evil-define-operator my-evil-comment-or-uncomment (beg end)
;;     "Toggle comment for the region between BEG and END."
;;     (interactive "<r>")
;;     (comment-or-uncomment-region beg end))
;;   (evil-define-key 'normal 'global (kbd "gc") 'my-evil-comment-or-uncomment))

;; Evil Goggles
;; Add a visual hint to evil operations
(use-package evil-goggles
  :ensure t
  :config
  (evil-goggles-mode)
  (evil-goggles-use-diff-faces))

;; Evil  Org
;; Evil keybindings for org-mode
(use-package evil-org
  :ensure t
  :after (evil org)
  :hook (org-mode . (lambda () evil-org-mode))
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys)
  (evil-org-set-key-theme '(navigation todo insert textobjects additional))
  ;; For Terminal
  (setq evil-want-C-i-jump nil)
  )

;; Evil Visualizer
;; Starts a * or # search from the visual selection
(use-package evil-visualstar
  :after evil
  :ensure t
  :defer t
  :commands global-evil-visualstar-mode
  :hook (after-init . global-evil-visualstar-mode))

;; Evil Snipe
;; Emulate vim-sneak & vim-seek
(use-package evil-snipe
  :ensure t
  :defer t
  :commands evil-snipe-mode
  :hook (after-init . evil-snipe-mode)
  :custom
  (evil-snipe-scope 'buffer)
  (evil-snipe-repeat-scope 'buffer)
  (evil-snipe-repeat-keys nil)
  (evil-snipe-enable-highlight nil)
  (evil-snipe-enable-incremental-highlight t)
  (evil-snipe-skip-leading-whitespace t)
  (evil-snipe-smart-case t)
  (evil-snipe-tab-increment t)
  (evil-snipe-override-evil-repeat-keys nil)
  (evil-snipe-auto-disable-substitute nil)
  )

;; Evil Matchit
;; Vim matchit ported to Evil
(use-package evil-matchit
  :ensure t
  :after (evil evil-collection)
  :config
  (global-evil-matchit-mode 1))
(provide 'ef-evil)
;;; ef-evil.el ends here
