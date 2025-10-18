;;; ef-general.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:

;; General Keybinding
(use-package general
  :ensure t
  :demand t
  :after evil
  :config
  (general-evil-setup)
  ;; Set up 'SPC' as the global leader key
  (general-create-definer ef/leader-keys
                          :states '(normal insert visual emacs)
                          :keymaps 'override
                          :prefix "SPC" ;; set leader
                          :global-prefix "M-SPC") ;; access leader in insert mode

  ;; Set up ',' as the local leader key
  (general-create-definer ef/local-leader-keys
                          :states '(normal insert visual emacs)
                          :keymaps 'override
                          :prefix "," ;; set local leader
                          :global-prefix "M-,") ;; access local leader in insert mode
  ;; To undefine keybindings
  (general-unbind
   "C-x C-r"
   "C-x C-z"
   )
  ;; Undefine some evil keys
  (general-define-key
   :keymaps 'evil-insert-state-map
   "U"   nil
   "C-k" nil
   "C-a" nil
   "C-y" nil
   "C-e" nil)

  ;; exit emacs state with ESC (in GUI emacs)
  (general-def 'emacs "<escape>" #'evil-normal-state)
  ;; make home and end act on visual lines
  (general-def '(insert normal)
               "<home>" #'evil-beginning-of-visual-line
               "<end>" #'evil-end-of-visual-line)
  (general-def
   "C-y" #'yank
   "M-y" #'yank-pop)



  ;; Example
  ;; How to define different keybindings for
  ;; different states
  ;; (general-def '(normal visual)
  ;;   ":" #'eval-expression)

  ;; (general-def '(insert normal)
  ;;   "C-;" #'eval-expression)


  ;; My Keybindings
  (ef/leader-keys
   "SPC" '(execute-extended-command :wk "Execute Command")
   "." '(find-file :wk "Find File")
   )
  ;; Buffers
  (ef/leader-keys
   "b" '(:ignore t :which-key "buffers")
   "bb" '(switch-to-buffer :which-key "switch buffer")
   "bd" '(kill-this-buffer :which-key "kill current buffer")
   "bD" '(kill-buffer :which-key "kill buffer")
   "bs" '(save-buffer :which-key "save buffer")
   "bu" '(revert-buffer :which-key "revert buffer")
   "bn" '(next-buffer :which-key "next buffer")
   "bp" '(previous-buffer :which-key "previous buffer")
   "bl" '(list-buffers :which-key "list buffers")
   "br" '(rename-buffer :which-key "rename buffer")
   "b." '(buffer-menu :which-key "buffer menu")
   "bi" '(ibuffer :which-key "ibuffer")
   "bz" '(kill-matching-buffers :which-key "kill matching buffers")
   "bx" '(kill-current-buffer :which-key "kill current buffer")
   "b <delete>"  '(kill-buffer-and-window :which-key "kill buffer and window")
   ;; Popper
   "b0" '(popper-cycle t :which-key "popper cycle")
   "bt" '(popper-toggle-type t :which-key "popper toggle type")
   "be" '(popper-toggle-latest t :which-key "popper toggle latest")
   "bq" '(popper-kill-latest-popup t :which-key "popper kill latest")
   )


  ;; Consult
  (ef/leader-keys
   "c" '(:ignore t :wk "consult")
   "cb" '(consult-buffer :wk "consult buffer")
   "cB" '(consult-bookmark :wk "consult bookmark")
   "cc" '(consult-org-heading :wk "consult org heading")
   "cd" '(consult-denote-find :wk "consult denote find")
   "ca" '(consult-denote-grep :wk "consult denote grep")
   "ct" '(consult-theme :wk "consult theme")
   "cr" '(consult-ripgrep :wk "consult rg")
   "cg" '(consult-grep :wk "consult grep")
   "cG" '(consult-git-grep :wk "consult git grep")
   "cf" '(consult-find :wk "consult find")
   "cF" '(consult-locate :wk "consult locate")
   "cl" '(consult-line :wk "consult line")
   "cy" '(consult-yank-from-kill-ring :wk "consult yank from kill ring")
   "ci" '(consult-imenu :wk "consult imenu")
   "cs" '(consult-isearch :wk "isearch")
   "ca" '(consult-flymake :wk "consult flymake")
   "cr" '(consult-recent-file :wk "consult recent file")
   "cL" '(consult-goto-line :wk "consult goto line")
   "ch" '(consult-history :wk "consult history")
   "cR" '(consult-register :wk "consult register")
   "co" '(consult-outline :wk "consult outline")
   "ch" '(consult-org-heading :wk "consult org heading")
   "cu" '(consult-focus-lines :wk "consult focus lines")
   "cp" '(consult-project-imenu :wk "consult project imenu")
   "ce" '(consult-compile-error :wk "consult error")
   "ch" '(consult-info :wk "consult info")
   "cm" '(consult-man :wk "consult man")
   "cM" '(consult-mark :wk "consult mark")
   "cS" '(consult-global-mark :wk "consult global mark")
   "z." '(consult-find-file :wk "consult find file"))
  ;;  Dired
  (ef/leader-keys
   "d" '(:ignore t :wk "dired")
   "d." '(dired :wk "dired open")
   )
  ;; Function for marking (selecting files in dired mode)
  (defun ef-dired-toggle-mark ()
    "Toggle marking the file at point.
If a region is active, toggle marking all files in the region."
    (interactive)
    (save-restriction
      (unless (region-active-p)
        (narrow-to-region (point-at-bol) (point-at-eol)))
      (dired-toggle-marks))
    (call-interactively #'dired-next-line))
  ;; Keybindings
  (general-def 'normal dired-mode-map
               ;; "d" #'dired-create-directory
               "f" #'dired-create-file
               "q" #'quit-window
               "r" #'dired-do-rename
               "." #'find-file
               "c" #'dired-do-chmod
               "o" #'dired-do-chown
               "p" #'dired-do-chgrp
               "x" #'dired-do-delete
               "<TAB>" #'dired-hide-details-mode
               ;; "<delete>" #'trashed
               "<backspace>" #'dired-up-directory
               "n" #'dired-next-line
               "e" #'dired-previous-line
               "i" #'dired-find-alternate-file

               "," #'ef-dired-toggle-mark
               "\"" #'dired-mark-files-regexp
               "v" #'dired-toggle-marks
               ;; ";" #'dired-unmark
               "<esc>" #'dired-unmark-all-marks

               )
  ;; Dirvish
  ;; (general-def 'normal 'dired-mode-map
  ;;   "q" #'dirvish-quit
  ;;   "." #'dired-find-file
  ;;   "?" #'dirvish-dispatch
  ;;   "m" #'dirvish-layout-switch
  ;;   "z" #'dirvish-setup-menu

  ;;   ;; "yp" #'dirvish-copy-file-path
  ;;   ;; "yn" #'dirvish-copy-file-name
  ;;   ;; "yd" #'dirvish-copy-file-directory

  ;;   "p" #'dirvish-yank
  ;;   "m" #'dirvish-move
  ;;   ;; "pl" #'dirvish-symlink
  ;;   ;; "pL" #'dirvish-relative-symlink
  ;;   ;; "ph" #'dirvish-hardlink

  ;;   "o" #'dirvish-quicksort

  ;;   "s" #'dirvish-total-file-size
  ;;     )
  ;; ;; Eval
  (ef/leader-keys
   "e" '(:ignore t :which-key "evaluate")
   "e." '(eval-last-sexp :which-key "evaluate last expression")
   "eb" '(eval-buffer :which-key "eval buffer")
   "er" '(eval-region :which-key "eval region")
   "ef" '(eval-defun :which-key "eval defun")
   "ee" '(eval-expression :which-key "eval expression")
   "ep" '(pp-eval-expression :which-key "pretty print eval")
   "em" '(macrostep-expand :which-key "macrostep expand")
   "el" '(load-file :which-key "load file")
   "ei" '(ielm :which-key "interactive lisp REPL"))

  ;; Files
  (ef/leader-keys
   "f" '(:ignore t :which-key "files")
   "ff" '(find-file :which-key "find file")
   "fr" '(recentf-open-files :which-key "recent files")
   "fs" '(save-buffer :which-key "save file")
   "fS" '(write-file :which-key "save as")
   "fD" '(delete-file :which-key "delete file")
   "fy" '(copy-file :which-key "copy file")
   "fr" '(rename-file :which-key "rename file")
   "fc" '(find-file-at-point :which-key "find file at point")
   "fl" '(locate :which-key "locate file")
   "fo" '(find-file-other-window :which-key "find file in other window"))
  ;; Corfu



  ;; Help
  (ef/leader-keys
   "h" '(:ignore t :wk "Help/Helpful")
   "h." '(helpful-at-point :wk "At Point")
   "ha" '(apropos-command :wk "apropos command")
   "hc" '(helpful-command :wk "Command")
   "hC" '(helpful-callable :wk "Callable")
   "hd" '(apropos-documentation :wk "Apropos Documentation")
   "hb" '(describe-bindings :wk "Bindings")
   "hz" '(describe-char :wk "Char")
   "hf" '(describe-function :wk "Function")
   "hF" '(describe-face :wk "Face")
   "hk" '(describe-key :wk "Key")
   "hK" '(describe-keymap :wk "Keymap")
   "hm" '(describe-mode :wk "Mode")
   "hp" '(describe-package :wk "Package")
   "hs" '(describe-symbol :wk "Symbol")
   "ht" '(describe-theme :wk "Theme")
   "hf" '(helpful-function :wk "Function")
   "hh" '(display-local-help :wk "Local Help")
   "hi" '(info-emacs-manual :wk "Info Manual")
   "hI" '(info-display-manual :wk "Display Manual")
   "hm" '(helpful-mode :wk "Mode")
   "hN" '(view-emacs-news :wk "News")
   "hP" '(view-emacs-problems :wk "Problems")
   "hs" '(helpful-symbol :wk "Symbol")
   "hv" '(helpful-variable :wk "helpful variable")
   "hV" '(apropos-variable :wk "apropos variable")
   "ho" '(info-apropos :wk "info apropos")
   "hj" '(apropos-value :wk "apropos value")
   "hl" '(apropos-library :wk "apropos library")
   "hu" '(apropos-user-option :wk "apropos user option")
   )
  ;; Press help to access it
  (general-def help-map
               "c" #'describe-coding-system
               "k" #'describe-key-briefly)

  (general-def 'normal help-mode-map
               "q" #'quit-window
               "ESC" #'quit-window)

  ;; System Settings
  (ef/leader-keys
   "q" '(:ignore t :wk "Quit")
   "qa" '(reload-config :wk "Reload Config")
   "qd" '(restart-emacs-debug-init :wk "Restart Debug Init")
   "qf" '(delete-frame :wk "Delete Frame")
   "qk" '(save-buffers-kill-emacs :wk "Kill Emacs")
   "qq" '(save-buffers-kill-terminal :wk "Kill Terminal")
   "qr" '(restart-emacs :wk "Restart Emacs")
   "qR" '(restart-emacs-without-desktop :wk "Restart w/o Desktop")
   "qs" '(server-shutdown :wk "Server Shutdown")
   "qQ" '(kill-emacs :wk "Kill Emacs"))


  ;; Search
  (ef/leader-keys
   "s" '(:ignore t :wk "Search")
   "s/" '(isearch-complete :wk "Search Complete")
   "sa" '(isearch-forward-regexp :wk "Regex Forward")
   "sb" '(consult-line :wk "Buffer Line")
   "sd" '(isearch-backward-regexp :wk "Regex Backward")
   "se" '(isearch-complete-edit :wk "Edit Complete")
   "sf" '(find-dired :wk "Find Dired")
   "sF" '(find-grep-dired :wk "Find Grep")
   "sg" '(rgrep :wk "Recursive Grep")
   "sh" '(isearch-forward :wk "Forward")
   "sl" '(isearch-backward :wk "Backward")
   "so" '(:ignore t :wk "Occur")
   "so." '(occur :wk "Occur")
   "soe" '(occur-edit-mode :wk "Edit Mode")
   "sor" '(occur-rename-buffer :wk "Rename Buffer")
   "sog" '(occur-mode-goto-occurrence :wk "Goto Occurrence")
   "soG" '(occur-mode-goto-occurrence-other-window :wk "Goto Other Window")
   "sol" '(occur-mode-display-occurrence :wk "Display Occurrence")
   "soq" '(occur-cease-edit :wk "Cease Edit")
   "sr" '(query-replace :wk "Query Replace")
   "sR" '(query-replace-regexp :wk "Regex Replace")
   "ss" '(deadgrep :wk "Deadgrep")
   "st" '(toggle-truncate-lines :wk "Truncate Lines")
   "sS" '(wgrep-save-all-buffers :wk "Save All Buffers")
   "sx" '(wgrep-finish-edit :wk "Finish Edit")
   "s." '(wgrep-change-to-wgrep-mode :wk "Wgrep Mode")
   "sy" '(isearch-yank-word-or-char :wk "Yank Word")
   "sY" '(isearch-yank-word-or-char :wk "Yank Char"))

  ;; Toggle
  (ef/leader-keys
   "t" '(:ignore t :which-key "toggle")
   "td" '(toggle-debug-on-error :wk "toggle debug on error")
   "tq" '(toggle-debug-on-quit :wk "toggle debug on quit")
   )
  ;; Package Management
  (ef/leader-keys
   "p" '(:ignore t :which-key "package management")
   "p." '(elpaca-manager :which-key "Elpaca Manager")
   "pb" '(elpaca-browse :which-key "Browse")
   "pf" '(elpaca-fetch :which-key "Fetch")
   "PF" '(elpaca-fetch-all :which-key "Fetch All")
   "pu" '(elpaca-update :which-key "Update")
   "pU" '(elpaca-update-all :which-key "Update All")
   "pl" '(elpaca-log :which-key "Elpaca Log")
   "pd" '(elpaca-delete :which-key "Elpaca Delete")
   "pi" '(elpaca-info :which-key "Elpaca Info")
   )

  ;; Windows
  (ef/leader-keys
   "w" '(:ignore t :which-key "windows")
   "ws" '(split-window-below :which-key "split horizontal")
   "wv" '(split-window-right :which-key "split vertical")
   "wd" '(delete-window :which-key "delete window")
   "wo" '(delete-other-windows :which-key "maximize window")
   "w=" '(balance-windows :which-key "balance windows")
   "ww" '(other-window :which-key "switch window")
   "wh" '(windmove-left :which-key "move left")
   "wl" '(windmove-right :which-key "move right")
   "wk" '(windmove-up :which-key "move up")
   "wj" '(windmove-down :which-key "move down")
   "w <left>" '(windmove-left :which-key "move left")
   "w <right>" '(windmove-right :which-key "move right")
   "w <up>" '(windmove-up :which-key "move up")
   "w <down>" '(windmove-down :which-key "move down")
   "wt" '(toggle-window-split :which-key "toggle split")
   "wr" '(rotate-windows :which-key "rotate windows")
   "wm" '(maximize-window :which-key "maximize current"))
  ;; vundo forces emacs state
  (general-def '(normal nil) vundo-mode-map
               "q" #'vundo-quit
               "h" #'vundo-backward
               "l" #'vundo-forward
               "n" #'vundo-next
               "p" #'vundo-previous
               "u" #'vundo-stem-root
               "y" #'vundo-stem-end
               "RET" #'vundo-confirm)

  ;; Different minibuffers symbols defined as a
  ;; constant variable
  (defconst my-minibuffer-maps
    '(minibuffer-local-map
      minibuffer-local-ns-map
      minibuffer-local-completion-map
      minibuffer-local-must-match-map
      minibuffer-local-isearch-map
      evil-ex-completion-map)
    "List of minibuffer keymaps.")
  (general-def :keymaps my-minibuffer-maps
               "<escape>" #'keyboard-escape-quit)

  ;; Various Mode Keymaps
  ;; Info
  (general-def 'normal 'Info-mode-map
               "q" #'quit-window
               "RET" #'Info-follow-nearest-node
               ;; "h" #'Info-prev
               ;; "i" #'Info-next
               ;; can go through entire manual with these (will have to use `Info-up' if
               ;; using above keybindings)
               "h" #'Info-backward-node
               "i" #'Info-forward-node
               ;; not every manual has index
               "I" #'Info-index
               "l" #'Info-history
               "<tab>" #'Info-next-reference
               "S-<tab>" #'Info-prev-reference
               "u" #'Info-up
               "U" #'Info-top-node
               "d" #'Info-directory
               "gt" 'Info-toc
               ;; TODO vs `Info-goto-node'? vs `Info-follow-reference'
               [remap consult-imenu] #'Info-menu
               "g?" #'Info-summary)


  )


(provide 'ef-general)
;;; ef-general.el ends here
