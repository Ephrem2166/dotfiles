;;; ef-fonts.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:

;; Maximum decoration level for fontification.
(setq font-lock-maximum-decoration t)

(defun my/font-available-p (font-name)
  " Check for available fonts"
  (when (stringp font-name)
    (member font-name (font-family-list))))

(defun my/available-font (&rest fonts)
  "Return available fonts"
  (seq-find #'my/font-available-p fonts))

(defvar my/available-mono-font
  (my/available-font "Berkeley Nerd Font" "PragmataProMono Nerd Font" "PragmataPro Mono" "Iosevka Nerd Font Mono" "JetBrains Nerd Font" "Ubuntu Mono Nerd Font" "Monospace")
  "Primary monospaced fonts"
  )


(defvar my/available-variable-font
  (my/available-font "Atkinson Hyperlegible" "Avenir" "PragmataPro" "Iosevka Nerd Font" "PragmataPro Nerd Font" "Sans")
  "Primary Variable Fonts")


;; (when my/available-mono-font
;;   (set-face-attribute 'default nil
;;                       :font (font-spec :family my/available-mono-font :size 16.0 :weight 'regular))
;;   (set-face-attribute 'fixed-pitch nil
;;                       :font (font-spec :family my/available-mono-font :size 16.0 :weight 'regular)))
;;
;;
;; (when my/available-variable-font
;;   (set-face-attribute 'variable-pitch nil
;;                       :font (font-spec :family my/available-variable-font :size 16.0 :weight 'regular)))


(set-frame-font "Berkeley Nerd Font 10")

;; ;; Default Font

(when my/available-mono-font
  (set-face-attribute
   'default nil
   :family my/available-mono-font
   ;; Height = point size x 10 = 12 x 10 = 120
   :height 110
   :weight 'regular))
;;
;; ;; Fixed Font
(when my/available-mono-font
  (set-face-attribute
   'fixed-pitch nil
   :family my/available-mono-font
   :height 110
   :weight 'regular))
;;
;; ;; Variable Font
(when my/available-variable-font
  (set-face-attribute
   'variable-pitch nil
   :family my/available-variable-font
   :height 110
   :weight 'regular))


;; Modeline
(set-face-attribute 'mode-line nil :family "Berkeley Nerd Font 9" :weight 'bold)
(set-face-attribute 'mode-line-inactive nil :family "Berkeley Nerd Font 9" :weight 'bold)

;; Minibuffer
(set-face-attribute 'minibuffer-prompt nil :family "Berkeley Nerd Font 9" :weight 'regular)


;; Debugging
;; To show during startup
;; (message "🧱 Default mono font: %s" my/available-mono-font)
;; (message "🎨 Variable-pitch font: %s" my/available-variable-font)




(provide 'ef-fonts)
;;; ef-fonts.el ends here
