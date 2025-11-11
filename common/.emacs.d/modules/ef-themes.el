;;; ef-themes.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:

;;; Doom Themes
(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-nord t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (nerd-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  ;; (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))


;; Modus Theme Modified
;; (use-package modus-themes
;;   :ensure nil
;;   :demand t
;;   :custom
;; ;;  (modus-themes-italic-constructs t)
;;   (modus-themes-bold-constructs t)
;;   (modus-themes-mixed-fonts t)
;;   (modus-themes-prompts '(bold intense))
;;   (modus-themes-org-blocks 'gray-background)
;;   (modus-themes-common-palette-overrides
;;    `(
;;      ;; Colors (Nord)
;;      (my-bg "#2E3440")
;;      (my-bg-alt "#3B4252")
;;      (my-bg-alt-2 "#434C5E")
;;      (my-bg-alt-3 "#4C566A")
;;      (my-bg-alt-4 "#4D576A")
;;      (my-bg-alt-5 "#8892A4")
;;      (my-fg "#D8DEE9")
;;      (my-fg-alt "#E5E9F0")
;;      (my-fg-light "#ECEFF4")
;;
;;      (my-red "#BF616A")
;;      (my-green "#A3BE8C")
;;      (my-blue "#81A1C1")
;;      (my-cyan "#88c0d0")
;;      (my-yellow "#EBCB8B")
;;      (my-purple "#B48EAD")
;;      (my-orange "#D08770")
;;      (my-teal "#8FBCBB")
;;      (my-dark-blue "#5E81AC")
;;      (my-magenta "#5D80AE")
;;      (my-dark-cyan "#507681")
;;
;;      ;; Basics
;;      (bg-main my-bg)
;;      (bg-dim my-bg-alt-2)
;;      (bg-active my-bg-alt-3)
;;      (bg-inactive my-bg)
;;
;;      (fg-main my-fg)
;;      (fg-alt my-fg-alt)
;;      (fg-dim my-fg-light)
;;      (fg-active my-fg)
;;
;;      (border my-bg)
;;
;;      ;; Fringe
;;      (fringe my-bg)
;;
;;      ;; Modeline
;;      (border-mode-line-active my-bg-alt-2)
;;      (border-mode-line-inactive my-bg)
;;
;;      (fg-mode-line-active my-fg-light)
;;      (bg-mode-line-active my-bg-alt-3)
;;
;;      (fg-mode-line-inactive my-fg)
;;      (bg-mode-line-inactive my-bg)
;;      (modeline-err my-red)
;;      (modeline-warning my-yellow)
;;      (modeline-info my-teal)
;;
;;      ;; Tab bar
;;      (bg-tab-bar      my-bg)
;;      (bg-tab-current  my-bg)
;;      (bg-tab-other    my-bg-alt)
;;
;;      ;; Underline
;;      (fg-link my-blue)
;;      (bg-link my-bg)
;;      (underline-link my-blue)
;;
;;      (fg-link-symbolic my-cyan)
;;      (bg-link-symbolic my-bg)
;;      (underline-link-symbolic my-fg)
;;
;;      (fg-link-visited my-purple)
;;      (bg-link-visited my-bg)
;;      (underline-link-visited my-purple)
;;
;;      (underline-err my-red)
;;      (underline-warning my-yellow)
;;      (underline-note my-cyan)
;;
;;      ;; Prominent
;;      (bg-prominent-err my-bg)
;;      (fg-prominent-err my-red)
;;      (bg-prominent-warning my-bg)
;;      (fg-prominent-warning my-yellow)
;;      (bg-prominent-note my-bg)
;;      (fg-prominent-note my-cyan)
;;
;;      (bg-active-value my-bg)
;;      (fg-active-value my-fg-light)
;;      (bg-active-argument my-bg)
;;      (fg-inactive-argument my-fg-light)
;;
;;      ;; Prompt
;;      (fg-prompt my-fg)
;;      (bg-prompt my-bg)
;;
;;      ;; Completion
;;      (bg-hover my-blue)
;;      (bg-hover-secondary my-red)
;;      (bg-hl-line my-bg-alt-2)
;;
;;      (bg-completion my-dark-blue)
;;      (fg-completion my-fg)
;;      (fg-completion-match-0 my-blue)
;;      (fg-completion-match-1 my-magenta)
;;      (fg-completion-match-2 my-cyan)
;;      (fg-completion-match-3 my-yellow)
;;      (bg-completion-match-0 my-bg)
;;      (bg-completion-match-1 my-bg)
;;      (bg-completion-match-2 my-bg)
;;      (bg-completion-match-3 my-bg)
;;
;;
;;      ;; Heading
;;      (fg-heading-1 my-green)
;;      (fg-heading-2 my-purple)
;;      (fg-heading-3 my-cyan)
;;      (fg-heading-4 my-blue)
;;      (fg-heading-5 my-orange)
;;      (bg-heading-1 my-bg)
;;      (bg-heading-2 my-bg)
;;      (bg-heading-3 my-bg)
;;      (bg-heading-4 my-bg)
;;      (bg-heading-5 my-bg)
;;
;;      ;; Mark
;;      (bg-mark-delete my-red)
;;      (fg-mark-delete my-red)
;;      (bg-mark-select my-cyan)
;;      (fg-mark-select my-cyan)
;;      (bg-mark-other my-yellow)
;;      (fg-mark-other my-yellow)
;;
;;      ;; Prose Related (code, verbatim, etc.)
;;      (bg-prose-block-contents my-bg-alt)
;;      (bg-prose-block-delimiter my-bg-alt)
;;      (fg-prose-block-delimiter my-fg-light)
;;
;;      (bg-prose-code my-bg)
;;      (fg-prose-code my-green)
;;
;;      (bg-prose-verbatim my-bg)
;;      (fg-prose-verbatim my-red)
;;
;;      (bg-prose-macro my-bg)
;;      (fg-prose-macro my-fg)
;;
;;      (prose-done my-green)
;;      (prose-todo my-red)
;;
;;
;;      ;; Region
;;      (bg-region my-bg-alt)
;;      (fg-region my-fg)
;;
;;      ;; Do not extend `region' background past the end of the line.
;;      ;; (custom-set-faces
;;      ;; '(region ((t :extend nil))))
;;
;;      ;; Underline
;;      (underline-err my-red)
;;      (underline-warning my-red)
;;      (underline-note my-cyan)
;;
;;      (accent-0 my-purple)
;;      (accent-1 my-cyan)
;;      (accent-2 my-purple)
;;      (accent-3 my-yellow)
;;
;;      ;; Essentials
;;      (bracket my-fg-alt)
;;      (builtin my-dark-blue)
;;      (comment my-bg-alt-5)
;;      (constant my-dark-blue)
;;      (delimiter my-fg)
;;      (docmarkup my-purple)
;;      (doc-comments my-dark-cyan)
;;      (docstring my-cyan)
;;      (fnname my-purple)
;;      (keyword my-blue)
;;      (numbers my-fg)
;;      (operator my-fg)
;;      (preprocessor my-red)
;;      (property my-cyan)
;;      (punctuation my-fg)
;;      (rx-backslash my-purple)
;;      (rx-construct my-purple)
;;      (string my-blue)
;;      (type my-green)
;;      (variable my-cyan)
;;
;;      (highlight my-blue)
;;      (functions my-cyan)
;;      (constant my-blue)
;;      (selection my-dark-blue)
;;      (methods my-cyan)
;;
;;      ;; Paren
;;      (bg-paren-match my-teal)
;;      (fg-paren-match my-fg-light)
;;      (bg-paren-expression my-purple)
;;      ;; (underline-paren-match my-fg)
;;
;;      ;; Line Numbers
;;      (fg-line-number-inactive my-fg-light)
;;      (fg-line-number-active my-fg)
;;      (bg-line-number-inactive my-bg)
;;      (bg-line-number-active my-bg)
;;
;;      ;; Button
;;      (bg-button-active my-bg-alt-2)
;;      (fg-button-active my-fg-alt)
;;      (bg-button-inactive my-bg)
;;      (fg-button-inactive my-fg)
;;
;;      (err my-red)
;;      (warning my-yellow)
;;      (success my-green)
;;      (info my-green)
;;
;;      (cursor my-purple)
;;      (keybind my-orange)
;;      (name my-fg)
;;      (identifier my-fg)
;;
;;      ;; Date
;;      (date-common my-cyan)
;;      (date-deadline my-red)
;;      (date-deadline-subtle my-red)
;;      (date-event my-fg)
;;      (date-holiday my-purple)
;;      (date-holiday-other my-blue)
;;      (date-now my-fg)
;;      (date-range my-fg-alt)
;;      (date-scheduled my-yellow)
;;      (date-scheduled my-yellow)
;;      (date-weekday my-cyan)
;;      (date-weekend my-purple)
;;      ;; Miscellaneous
;;      ;; (bg-hl-line my-blue)
;;
;;      ;; Others
;;      ;; (corfu-default :background my-bg :foreground my-fg)
;;      ;; (corfu-background :background my-bg)
;;      ;; (corfu-current  :foreground my-fg :background my-bg)
;;      ;; (corfu-bar :background my-bg-alt)
;;      ;; (corfu-border :background my-bg)
;;      ;; (corfu-indexed :foreground my-fg :background my-bg)
;;
;;      ;; (default :background my-bg :foreground my-fg)
;;      ;; (cursor :background my-bg)
;;      ;; (region :background my-bg-alt :foreground my-fg)
;;      ;; (secondary-selection :background my-bg :foreground my-fg)
;;      ;; (match my-green)
;;
;;      ;; Rainbow
;;      (rainbow-0 my-fg)
;;      (rainbow-1 my-purple)
;;      (rainbow-2 my-cyan)
;;      (rainbow-3 my-red)
;;      (rainbow-4 my-yellow)
;;      (rainbow-5 my-purple)
;;      (rainbow-6 my-green)
;;      (rainbow-7 my-blue)
;;      (rainbow-8 my-purple)
;;
;;      ;; Search
;;      (bg-search-current my-yellow)
;;      (bg-search-lazy my-cyan)
;;      (bg-search-replace my-red)
;;      (bg-search-rx-group-0 my-blue)
;;      (bg-search-rx-group-1 my-green)
;;      (bg-search-rx-group-2 my-red)
;;      (bg-search-rx-group-3 my-purple)
;;
;;
;;      ))
;;   ;; My Customization
;;
;;   :init
;;   (load-theme 'modus-vivendi-tinted t))

;;; Nano Themes
(use-package nano-theme
:ensure t
:defer t
:config
(setq nano-fonts-family-monospaced “Berkeley Nerd Font”)
(setq nano-font-family-proportional nil)
(setq nano-font-size 14)
)

(provide 'ef-themes)
;;; ef-themes.el ends here
