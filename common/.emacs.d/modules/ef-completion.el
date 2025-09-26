;;; ef-completion.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:

;;;;;;;;;;;;;
;; ;; Cape ;;
;;;;;;;;;;;;;
;; Cape provides Completion At Point Extensions
(use-package cape
  :ensure t
  :after (corfu orderless)
  :bind ("C-c p" . cape-prefix-map
         )

  :init
  ;; (add-hook 'completion-at-point-functions #'cape-elisp-block)
  ;; (add-hook 'completion-at-point-functions #'cape-elisp-symbol) ;; Elisp symbol
  ;; (add-hook 'completion-at-point-functions #'cape-keyword) ;; Programming keywords
  ;; (add-hook 'completion-at-point-functions #'cape-tex)    ;; LaTeX commands
  ;; (add-hook 'completion-at-point-functions #'cape-sgml)   ;; HTML tags
  ;; (add-to-list 'completion-at-point-functions #'cape-abbrev) ;; Abbreviations
  ;; (add-to-list 'completion-at-point-functions #'cape-line)   ;; Complete whole lines
  ;; (add-hook 'completion-at-point-functions #'cape-emoji)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev) ;; Dynamic
  (add-to-list 'completion-at-point-functions #'cape-elisp-block)
  (add-to-list 'completion-at-point-functions #'cape-history) ;; Completion history
  (add-to-list 'completion-at-point-functions #'cape-elisp-symbol)
  (add-to-list 'completion-at-point-functions #'cape-file)   ;; File paths
  (add-to-list 'completion-at-point-functions #'cape-dict) ;; Dict
  (add-to-list 'completion-at-point-functions #'cape-emoji)
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  :config
  (defun my/eglot-capf ()
    (setq-local completion-at-point-functions
                (cons (cape-capf-super
                       #'cape-file
                       #'eglot-completion-at-point
                       #'tempel-complete)
                      completion-at-point-functions)))
  (add-hook 'eglot-managed-mode-hook #'my/eglot-capf)
  ;; Make capfs composable
  (advice-add #'eglot-completion-at-point :around #'cape-wrap-nonexclusive)
  (advice-add #'comint-completion-at-point :around #'cape-wrap-nonexclusive)

  ;; Silence then pcomplete capf, no errors or messages!
  (advice-add 'pcomplete-completions-at-point :around #'cape-wrap-silent)

  ;; Ensure that pcomplete does not write to the buffer
  ;; and behaves as a pure `completion-at-point-function'.
  (advice-add 'pcomplete-completions-at-point :around #'cape-wrap-purify)
  ;; Use Company backends as Capfs.
  (setq-local completion-at-point-functions
              (mapcar #'cape-company-to-capf
                      (list #'company-files #'company-keywords #'company-dabbrev)))
  ;; Merge the dabbrev, dict and keyword capfs, display candidates together.
  (setq-local completion-at-point-functions
              (list (cape-capf-super #'cape-dabbrev #'cape-dict #'cape-keyword)))
  ;; Elisp Completion Setup
  (defun ef-elisp-setup ()
    (setq-local completion-at-point-functions (list (cape-capf-super
                                                     #'elisp-completion-at-point
                                                     #'cape-dabbrev
                                                     #'cape-file
                                                     #'cape-keyword
                                                     )))
    )

  (add-hook 'emacs-lisp-mode #'ef-elisp-setup)

  ;; Tempel
  (defun init-cape-eglot-capf ()
    (setq-local completion-at-point-functions
                (list #'cape-file
                      (cape-capf-super (cape-capf-buster #'eglot-completion-at-point #'string-prefix-p)
                                       :with #'tempel-complete))))
  (add-hook 'eglot-managed-mode #'init-cape-eglot-capf)



  ;; Prog Mode
  (defun ef-setup-completion ()
    (setq-local completion-at-point-functions
                (list (cape-capf-super
                       #'cape-elisp-symbol
                       #'cape-dabbrev
                       #'cape-file))))
  (add-hook 'prog-mode-hook #'ef-setup-completion)

  ;; (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster)
  :custom
  (text-mode-ispell-word-completion nil)
  )

;; Corfu Corfu enhances in-buffer completion with a small complet ion
;; popup.
(use-package corfu
  :ensure t
  ;; Only in GUI mode
  :if (display-graphic-p)
                                        ; :hook
                                        ; ((minibufer-setup . corfu-enable-always-in-minibuffer
                                        ;                   ))
  :config
  (setq text-mode-ispell-word-completion nil)
  (setq read-extended-command-predicate #'command-completion-default-include-p)
  (setq corfu-preview-current nil)
  (setq corfu-min-width 50)
  (setq corfu-max-width corfu-min-width)
  (setq corfu-cycle t
        corfu-auto t
        corfu-auto-prefix 3
        corfu-auto-delay 0.1
        corfu-count 8
        corfu-quit-no-match t
        corfu-preselect 'valid
        corfu-separator ?\s  ;; use space
        corfu-scroll-margin 5
        corfu-on-exact-match 'insert
        corfu-quit-at-boundary 'insert)
  (setq corfu-popupinfo-delay '(0.5 . 0.2))
  (setq corfu-indexed-mode t)
  ;; Enable Corfu in minibufer as long as no other completion UI is active.
  ;; (defun corfu-enable-always-in-minibuffer ()
  ;;   "Enable Corfu in the minibuffer if Vertico/Mct are not active."
  ;;   (unless (or (bound-and-true-p mct--active) ; Useful if I ever use MCT
  ;;               (bound-and-true-p vertico--input))
  ;;     (setq-local corfu-auto nil)       ; Ensure auto completion is disabled
  ;;     (corfu-mode 1)))
                                        ; (add-hook 'minibuffer-setup-hook #'corfu-enable-always-in-minibuffer 1)
  ;; Ensure savehist is on and add corfu-history to it.
  (unless (bound-and-true-p savehist-mode) (savehist-mode 1))
  (add-to-list 'savehist-additional-variables 'corfu-history)
  (add-hook 'corfu-mode-hook
            (lambda ()
              ;; Settings only for Corfu
              (setq-local completion-styles '(basic)
                          completion-category-overrides nil
                          completion-category-defaults nil)))
  ;; Completing in the minibuffer
  (setq global-corfu-minibuffer
        (lambda ()
          (not (or (bound-and-true-p mct--active)
                   (bound-and-true-p vertico--input)
                   (eq (current-local-map) read-passwd-map)))))
  :init
  (global-corfu-mode)
  (corfu-history-mode)
  ;; (corfu-popupinfo-mode)
  (corfu-indexed-mode)
  :bind (:map corfu-map
              ("<tab>" . corfu-complete)
              ("SPC" . corfu-insert-separator)
              ("M-d" . corfu-info-documentation)
              ("<esc>" . corfu-quit)
              )

  )


;; Corfu Info
;; (use-package corfu-info
;;   :ensure nil)

;; Corfu-history
;; Save the history across Emacs sessions
;; (use-package corfu-history
;;   :ensure nil
;;   :hook
;;   (corfu-mode . corfu-history-mode)
;;   ;;  :config
;;   ;; (with-eval-after-load 'savehist
;;   ;;   (add-to-list 'savehist-additional-variables 'corfu-history)))
;;
;;   )

;; Core Popup Info
(use-package corfu-popupinfo
  :ensure nil
  :after corfu
  :hook
  (corfu-mode . corfu-popupinfo-mode)
  :custom
  (corfu-popupinfo-delay '(nil . 0.3))
  (corfu-popupinfo-direction '(right left vertical))
  (corfu-popupinfo-hide t)
  (corfu-popupinfo-resize t)
  (corfu-popupinfo-max-height 20)
  (corfu-popupinfo-max-width 70)
  (corfu-popupinfo-min-height 1)
  (corfu-popupinfo-min-width 30))

;; Corfu Terminal
(use-package corfu-terminal
  :ensure t
  :after corfu
  :config
  (unless (display-graphic-p)
    (corfu-terminal-mode +1))
  )

;; Corfu Prescient
(use-package corfu-prescient
  :ensure t
  :after corfu prescient
  :config
  (setopt corfu-prescient-enable-sorting t)
  (setopt corfu-prescient-override-sorting nil)
  (setopt corfu-prescient-enable-filtering nil)
  (setopt corfu-prescient-completion-style '(prescient flex))
  (setopt corfu-prescient-completion-category-overrides

          '(;; Include `partial-completion' to enable wildcards and partial paths.
            (file (styles partial-completion prescient))
            ;; Eglot forces `flex' by default.
            (eglot (styles prescient flex))))
  :config
  (corfu-prescient-mode 1)
  )


;; Kind Icon
;; Completion kind icons
(use-package kind-icon
  :disabled
  :ensure t
  :after corfu
  :custom
  (kind-icon-default-face 'corfu-default) ;; Use Corfu's default face
  (kind-icon-use-icons t)
  (kind-icon-blend-background nil)
  (kind-icon-blend-frac 0.08)
  (kind-icon-default-style
   '(:padding 0 :stroke 0 :margin 0 :radius 0 :height 0.8 :scale 1.0))
  (kind-icon-mapping
   '((array          "a"   :icon "symbol-array"       :face font-lock-type-face              :collection "nerd-fonts-codicons")
     (boolean        "b"   :icon "symbol-boolean"     :face font-lock-builtin-face           :collection "nerd-fonts-codicons")
     (color          "#"   :icon "symbol-color"       :face success                          :collection "nerd-fonts-codicons")
     (command        "cm"  :icon "chevron-right"      :face default                          :collection "nerd-fonts-codicons")
     (constant       "co"  :icon "symbol-constant"    :face font-lock-constant-face          :collection "nerd-fonts-codicons")
     (class          "c"   :icon "symbol-class"       :face font-lock-type-face              :collection "nerd-fonts-codicons")
     (constructor    "cn"  :icon "symbol-method"      :face font-lock-function-name-face     :collection "nerd-fonts-codicons")
     (enum           "e"   :icon "symbol-enum"        :face font-lock-builtin-face           :collection "nerd-fonts-codicons")
     (enummember     "em"  :icon "symbol-enum-member" :face font-lock-builtin-face           :collection "nerd-fonts-codicons")
     (enum-member    "em"  :icon "symbol-enum-member" :face font-lock-builtin-face           :collection "nerd-fonts-codicons")
     (event          "ev"  :icon "symbol-event"       :face font-lock-warning-face           :collection "nerd-fonts-codicons")
     (field          "fd"  :icon "symbol-field"       :face font-lock-variable-name-face     :collection "nerd-fonts-codicons")
     (file           "f"   :icon "symbol-file"        :face font-lock-string-face            :collection "nerd-fonts-codicons")
     (folder         "d"   :icon "folder"             :face font-lock-doc-face               :collection "nerd-fonts-codicons")
     (function       "f"   :icon "symbol-method"      :face font-lock-function-name-face     :collection "nerd-fonts-codicons")
     (interface      "if"  :icon "symbol-interface"   :face font-lock-type-face              :collection "nerd-fonts-codicons")
     (keyword        "kw"  :icon "symbol-keyword"     :face font-lock-keyword-face           :collection "nerd-fonts-codicons")
     (macro          "mc"  :icon "lambda"             :face font-lock-keyword-face)
     (magic          "ma"  :icon "lightbulb-autofix"  :face font-lock-builtin-face           :collection "nerd-fonts-codicons")
     (method         "m"   :icon "symbol-method"      :face font-lock-function-name-face     :collection "nerd-fonts-codicons")
     (module         "{"   :icon "file-code-outline"  :face font-lock-preprocessor-face)
     (numeric        "nu"  :icon "symbol-numeric"     :face font-lock-builtin-face           :collection "nerd-fonts-codicons")
     (operator       "op"  :icon "symbol-operator"    :face font-lock-comment-delimiter-face :collection "nerd-fonts-codicons")
     (param          "pa"  :icon "gear"               :face default                          :collection "nerd-fonts-codicons")
     (property       "pr"  :icon "symbol-property"    :face font-lock-variable-name-face     :collection "nerd-fonts-codicons")
     (reference      "rf"  :icon "library"            :face font-lock-variable-name-face     :collection "nerd-fonts-codicons")
     (snippet        "S"   :icon "symbol-snippet"     :face font-lock-string-face            :collection "nerd-fonts-codicons")
     (string         "s"   :icon "symbol-string"      :face font-lock-string-face            :collection "nerd-fonts-codicons")
     (struct         "%"   :icon "symbol-structure"   :face font-lock-variable-name-face     :collection "nerd-fonts-codicons")
     (text           "tx"  :icon "symbol-key"         :face font-lock-doc-face               :collection "nerd-fonts-codicons")
     (typeparameter  "tp"  :icon "symbol-parameter"   :face font-lock-type-face              :collection "nerd-fonts-codicons")
     (type-parameter "tp"  :icon "symbol-parameter"   :face font-lock-type-face              :collection "nerd-fonts-codicons")
     (unit           "u"   :icon "symbol-ruler"       :face font-lock-constant-face          :collection "nerd-fonts-codicons")
     (value          "v"   :icon "symbol-enum"        :face font-lock-builtin-face           :collection "nerd-fonts-codicons")
     (variable       "va"  :icon "symbol-variable"    :face font-lock-variable-name-face     :collection "nerd-fonts-codicons")
     (t              "."   :icon "question"           :face font-lock-warning-face           :collection "nerd-fonts-codicons")))
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

;; Nerd Icons Corfu
(use-package nerd-icons-corfu
  :ensure t
  :if (display-graphic-p)
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))


;; Marginalia: adds marginalia to the minibuffer completions.
;; Marginalia are helpful colorful annotations placed at the margin of the
;; minibuffer for your completion candidates.
(use-package marginalia
  :ensure t
  :after vertico
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  :config
  (setq marginalia-annotators '(marginalia-annotators-heavy
                                marginalia-annotators-light
                                nil))
  (setq marginalia-max-relative-age 0)
  ;; Alignment of annotations
  (setq marginalia-align 'right)
  (setq marginalia-field-width 80)
  (setq marginalia-align-offset -2)
  :init
  (marginalia-mode))


;; Orderless
;; It provides an orderless completion style that divides the pattern
;; into space-separated components, and matches candidates that match
;; all of the components in any order
(use-package orderless
  :ensure t
  :config
  (setq orderless-component-separator 'orderless-escapable-split-on-space)
  (setq orderless-matching-styles '(
                                    orderless-prefixes
                                    orderless-regexp
                                    orderless-initialism
                                    orderless-literal))
  (setq completion-styles '(orderless partial-completion basic))
  (setq completion-category-overrides '((file (styles basic partial-completion))))
  ;; General
  (setq completion-ignore-case t)
  (setq read-buffer-completion-ignore-case t)
  (setq-default case-fold-search t)   ; For general regexp
  (setq read-file-name-completion-ignore-case t)
  (setq completion-category-defaults nil)
  (setq  completion-category-overrides
         '((file (styles partial-completion))))
  (setq orderless-style-dispatchers
        '(ef-orderless-literal
          ef-orderless-literal
          ef-orderless-beg-or-end))
  ;; Various Functions
  ;; Style dispatchers
  (defun ef-orderless-literal (word _index _total)
    "Read WORD= as a literal string."
    (when (string-suffix-p "=" word)
      ;; The `orderless-literal' is how this should be treated by
      ;; orderless.  The `substring' form omits the `=' from the
      ;; pattern.
      `(orderless-literal . ,(substring word 0 -1))))

  (defun ef-orderless-file-ext (word _index _total)
    "Expand WORD. to a file suffix when completing file names."
    (when (and minibuffer-completing-file-name
               (string-suffix-p "." word))
      `(orderless-regexp . ,(format "\\.%s\\'" (substring word 0 -1)))))

  (defun ef-orderless-beg-or-end (word _index _total)
    "Expand WORD~ to \\(^WORD\\|WORD$\\)."
    (when-let* (((string-suffix-p "~" word))
                (word (substring word 0 -1)))
      `(orderless-regexp . ,(format "\\(^%s\\|%s$\\)" word word))))
  ;; Orderless with eglot
  (add-to-list 'completion-category-overrides '(eglot (styles . (orderless flex))))

  )

;; Prescient
(use-package prescient
  :ensure t
  :custom
  (prescient-filter-method '(literal initialism regexp))
  (prescient-aggressive-file-save t)
  (prescient-sort-length-enable nil)
  (prescient-sort-full-matches-first t)
  (prescient-history-length 200)
  (prescient-frequency-decay 0.997)
  (prescient-frequency-threshold 0.05)
  :config
  (prescient-persist-mode 1)
  )


;; Tempel
;; Tempo templates/snippets with in-buffer field editing
(use-package tempel
  :ensure t
  :bind
  (
   ("M-+" . tempel-complete)
   ("M-*" . tempel-insert)
   )
  :config
  (setq tempel-path (concat user-emacs-directory "etc/tempel/templates.eld"))
  :init
  (defun tempel-setup-capf ()
    (setq-local completion-at-point-functions
                (cons #'tempel-expand
                      completion-at-point-functions)))

  (add-hook 'conf-mode-hook 'tempel-setup-capf)
  (add-hook 'prog-mode-hook 'tempel-setup-capf)
  (add-hook 'text-mode-hook 'tempel-setup-capf)
  )

;; Vertico
;; Vertico provides a performant and minimalistic vertical completion UI
;; based on the default completion system.
(use-package vertico
  :ensure t
  :bind (:map vertico-map
              ("C-j" . vertico-next)
              ("C-k" . vertico-previous)
              ("C-f" . vertico-exit-input)
              ("C-c v r" . vertico-repeat)
              ("C-c v s" . vertico-suspend)
              :map minibuffer-local-map
              ("M-h" . vertico-directory-up))
  ;;  :demand t
  ;;  :hook (after-init . vertico-mode)
  :config
  (setq vertico-scroll-margin 0)
  (setq vertico-cycle t)
  (setq vertico-count 10)
  (setq vertico-resize 'grow)
  ;; Hide commands that don't match current mode
  (setq read-extended-command-predicate #'command-completion-default-include-p)
  ;; (vertico-multiform-mode)
  ;; Ignore Case
  (setq read-file-name-completion-ignore-case t)
  (setq read-buffer-completion-ignore-case t)
  (setq completion-ignore-case t)
  ;; (setq consult-project-function nil)
  ;; Consult completion (use corfu)
  ;;(setq completion-in-region-function #'consult-completion-in-region)
  :init
  (vertico-mode)
  )

;; Vertico Prescient
(use-package vertico-prescient
  :ensure t
  :after vertico
  :custom
  ;; Sorting
  (vertico-prescient-enable-sorting t)
  (vertico-prescient-override-sorting nil)
  ;; Filtering
  (vertico-prescient-enable-filtering nil)
  ;; Completion
  (vertico-prescient-completion-styles '(prescient flex))
  (vertico-prescient-completion-category-overrides
   '(
     (file (styles partial-completion prescient))
     (eglot (styles prescient flex))
     ))
  :config
  (vertico-prescient-mode 1)
  )

;;;;; Vertico-directory
(use-package vertico-directory
  :after vertico
  :ensure nil
  ;; More convenient directory navigation commands
  :bind
  ( :map vertico-map
    ("RET" . vertico-directory-enter)
    ("DEL" . vertico-directory-delete-char)
    ("M-DEL" . vertico-directory-delete-word))
  ;; Tidy shadowed file names
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

;; Vertico Posframe
;; Using posframe to show Vertico
(use-package vertico-posframe
  :disabled
  :ensure t
  :demand t
  :config
  (vertico-posframe-mode 1)
  (setq vertico-posframe-border-width 2)
  (setq vertico-posframe-parameters '((internal-border-width . 2)))
  )

;;;;; Vertico-buffer
(use-package vertico-buffer
  :requires vertico
  :ensure nil
  ;; :after vertico
  :custom
  (vertico-buffer-hide-prompt nil)
  (vertico-buffer-display-action '(display-buffer-reuse-window)))

(use-package vertico-multiform
  :requires vertico
  :ensure nil
  :after vertico
  :config
  (setq vertico-multiform-categories
        '((file grid)
          (imenu (vertico-count . 14))
          (jinx grid (vertico-grid-annotate . 20))
          ))
  (setq vertico-multiform-commands
        '((consult-line buffer)
          (consult-buffer buffer)
          (consult-org-heading buffer)
          (consult-imenu buffer)
          (consult-project-buffer buffer)
          (consult-project-extra-find buffer)))
  (vertico-multiform-mode 1)
  )



(provide 'ef-completion)
;;; ef-completion.el ends here
