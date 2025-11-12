;; ef-fonts.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:

;;; Maximum decoration level for fontification.
(setq font-lock-maximum-decoration t)

;;; Change Font Functions
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
  (my/available-font
   "Triplicate A"
   "SN Pro"
   "Atkinson Hyperlegible"
   "Iosevka Aile"
   "PragmataPro"
   "Avenir" "Iosevka Nerd Font" "PragmataPro Nerd Font" "Sans")
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

;;; Set Default Font
(when my/available-mono-font
  (set-face-attribute
   'default nil
   :family my/available-mono-font
   ;; Height = point size x 10 = 12 x 10 = 120
   :height 110
   :weight 'regular))

;;; Set Fixed Font
(when my/available-mono-font
  (set-face-attribute
   'fixed-pitch nil
   :family my/available-mono-font
   :height 110
   :weight 'regular))

;;; Set Variable Font
(when my/available-variable-font
  (set-face-attribute
   'variable-pitch nil
   :family my/available-variable-font
   :height 120
   :weight 'regular))

;;; Modeline
(set-face-attribute 'mode-line nil :family "Berkeley Nerd Font 9" :weight 'bold)
(set-face-attribute 'mode-line-inactive nil :family "Berkeley Nerd Font 9" :weight 'bold)

;;; Minibuffer
(set-face-attribute 'minibuffer-prompt nil :family "Berkeley Nerd Font 9" :weight 'regular)


;;; Debugging
;; To show during startup
;; (message "🧱 Default mono font: %s" my/available-mono-font)
;; (message "🎨 Variable-pitch font: %s" my/available-variable-font)

;;; Change Fonts Interactively
;; (defvar font-list '(
;;                     ("Berkeley Nerd Font" . 11)
;;                     ("JetBrainsMono Nerd Font" . 12.5)
;;                     ("PragmataProMono Nerd Font" . 13)
;;                     ("Input" . 11)
;;                     ("Hack" . 12)
;;                     ("Consolas" . 12)
;;                     ("UbuntuMono Nerd Font" . 12.5)
;;                     ("Iosevka Nerd Font" . 11)
;;
;;                     ;; Variable Fonts
;;                     ("SN Pro" . 10)
;;                     ("Atkinson Hyperlegible" . 11)
;;                     ("Verdana" . 12)
;;                     ("Avenir" . 12)
;;                     ("Aporetic Sans" . 11)
;;                     ("Aporetic Serif" . 12)
;;
;;                     )
;;   "List of fonts and sizes.  The first one available will be used.")
;;
;; (defun get-available-fonts ()
;;   "Get list of available fonts from font-list."
;;   (let (available-fonts)
;;     (dolist (font font-list (nreverse available-fonts))
;;       (when (member (car font) (font-family-list))
;;         (push font available-fonts)))))
;;
;; (defun change-font ()
;;   "Interactively change a font from a list a available fonts."
;;   (interactive)
;;   (let* ((available-fonts (get-available-fonts))
;;          font-name font-size font-setting)
;;     (if (not available-fonts)
;;         (message "No fonts from the chosen set are available")
;;       (if (called-interactively-p 'interactive)
;;           (let* ((chosen (assoc-string (completing-read "What font to use? " available-fonts nil t) available-fonts)))
;;             (setq font-name (car chosen) font-size (read-number "Font size: " (cdr chosen))))
;;         (setq font-name (caar available-fonts) font-size (cdar available-fonts)))
;;       (setq font-setting (format "%s-%d" font-name font-size))
;;       (set-frame-font font-setting nil t)
;;       (add-to-list 'default-frame-alist (cons 'font font-setting)))))
;;
;; ;; To automatically change fonts
;; ;; (when (display-graphic-p)
;; ;;   (change-font))
;; ;;; List Available Fonts on a new buffer
;; (defun my/list-available-fonts ()
;;   "Display a list of available fonts in a new buffer."
;;   (interactive)
;;   (let ((font-list (sort (font-family-list) 'string<))
;;         (buffer-name "*Available Fonts*"))
;;     (with-output-to-temp-buffer buffer-name
;;       (with-current-buffer buffer-name
;;         (dolist (font font-list)
;;           (insert font "\n"))
;;         (special-mode)))
;;     (pop-to-buffer buffer-name)))
;;
;; ;;; Adjust the font size of a region
;; (defun my/adjust-region-font-size (b e)
;;   (interactive "r")
;;   (let* ((ov (or (seq-find
;;                   (lambda (ov) (overlay-get ov 'adjust-font-size))
;;                   (overlays-at b))
;;                  (make-overlay b e)))
;;          (face (overlay-get ov 'face))
;;          (height (or (plist-get face :height) 1.0)))
;;     (deactivate-mark)
;;     (overlay-put ov 'adjust-font-size t)
;;     (while (pcase (read-key (format "Type ↑ ↓ to adjust font size %f: " height))
;;              ('up (cl-incf height 0.2))
;;              ('down (cl-decf height 0.2))
;;              ;; Quit
;;              (_ nil))
;;       (overlay-put ov 'face (plist-put face :height height))
;;       (force-window-update))))

;;; Better Way to Change Fonts Dynamically
(defun my-system-fonts ()
  "List of system fonts."
  (x-list-fonts "*"))
;; Set Default Face
(defun my/set-default-face ()
  "Set the default font and height interactively."
  (interactive)
  (let* ((selected-font
          (completing-read "Select default font: "
                           (my-system-fonts)))

         (selected-size
          (read-number "Select default font size: " 12)))

    (set-face-attribute 'default nil :font selected-font )
    (set-face-attribute 'default nil :height (* 10 selected-size))))



;;; Better Describe Font
(defun my/what-font ()
  "Show the name/details for the current font in use."
  (interactive)
  (message "%s" (face-attribute 'default :font)))

(provide 'ef-fonts)
;;; ef-fonts.el ends here
