;; ef-fonts.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:

;;; Change Font Functions
(defun my/font-available-p (font-name)
  "Return non-nil if FONT-NAME is available in the current Emacs session."
  (and (stringp font-name)
	   (member font-name (font-family-list))))

(defun my/available-font (&rest fonts)
  "Return available fonts"
  (seq-find #'my/font-available-p fonts))

;;; Font Lists
(defgroup my/fonts nil
  "Fonts, sizes, and interactive font-change commands."
  :group 'my)

;; (defvar my/available-mono-font
;;   (my/available-font "Berkeley Nerd Font"
;; 					 "PragmataProMono Nerd Font"
;; 					 "PragmataPro Mono"
;; 					 "Iosevka Nerd Font Mono"
;; 					 "JetBrains Nerd Font"
;; 					 "Ubuntu Mono Nerd Font"
;; 					 "Menlo"
;; 					 "Monaco"
;; 					 "Monospace")
;;   "Primary monospaced fonts"
;;   )
(defcustom my/mono-font-preferences
  '("Berkeley Nerd Font"
	"JetBrains Nerd Font"
	"Iosevka Nerd Font Mono"
	"PragmataPro Mono"
	"PragmataProMono Nerd Font"
	"Fira Code"
	"mononoki"
	"Input Mono"
	"Source Code Pro"
	"Ubuntu Mono Nerd Font"
	"DejaVu Sans Mono"
	"Menlo"
	"Monaco"
	"Monospace")
  "Monospaced font families in preference order.
The first installed family is used for `default' and `fixed-pitch'."
  :type '(repeat string)
  :group 'my/fonts)



;; (defvar my/available-variable-font
;;   (my/available-font
;;    "Iosevka Aile"
;;    "DejaVu Sans"
;;    "Atkinson Hyperlegible Next"
;;    "Triplicate A"
;;    "SN Pro"
;;    "Atkinson Hyperlegible"
;;    "PragmataPro"
;;    "Avenir"
;;    "Iosevka Nerd Font"
;;    "PragmataPro Nerd Font"
;;    "Sans")
;;   "Primary Variable Fonts")

(defcustom my/variable-font-preferences
  '("Iosevka Aile"
	"SN Pro"
	"Atkinson Hyperlegible Next"
	"Atkinson Hyperlegible"
	"Triplicate A"
	"DejaVu Sans"
	"Avenir"
	"PragmataPro"
	"Iosevka Nerd Font"
	"PragmataPro Nerd Font"
	"Liberation Serif"
	"Ubuntu"
	"Sans")
  "Proportional font families in preference order.
The first installed family is used for `variable-pitch'."
  :type '(repeat string)
  :group 'my/fonts)

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

;; (set-frame-font "Berkeley Nerd Font 10")


(defcustom my/preferred-fonts nil
  "Fonts to prioritize even if they appear later in the preference list.
If non-nil and any of these fonts are installed, `my/fonts-candidate'
returns one of them instead of the first available font."
  :type '(repeat string)
  :group 'my/fonts)

(defvar my/available-mono-font
  (apply #'my/available-font my/mono-font-preferences)
  "First installed monospaced font, resolved at load time.")

(defvar my/available-variable-font
  (apply #'my/available-font my/variable-font-preferences)
  "First installed proportional font, resolved at load time.")

(defun my/filter-preferred-fonts (fonts)
  "Return the subset of FONTS that appears in `my/preferred-fonts'."
  (seq-filter (lambda (f) (member f my/preferred-fonts)) fonts))

(defun my/fonts-candidate (fonts &optional prefer)
  "Return the first installed font from FONTS.
When PREFER is non-nil, `my/preferred-fonts' and any of those
fonts are installed, return the first preferred font instead."
  (let* ((available (my/available-fonts fonts))
		 (preferred (and prefer (my/filter-preferred-fonts available))))
	(or (car preferred) (car available))))


;;; Heights
(defcustom my/default-font-height 110
  "Default face height in tenths of a point (110 = 11 pt)."
  :type 'integer
  :group 'my/fonts)

(defcustom my/variable-font-height 110
  "Height for `variable-pitch' in tenths of a point."
  :type 'integer
  :group 'my/fonts)

(defcustom my/mode-line-font-height 90
  "Height for `mode-line' and `minibuffer-prompt' in tenths of a point."
  :type 'integer
  :group 'my/fonts)


;;; Font Application
(defvar my/fonts-updated-hook nil
  "Functions run after fonts have been updated interactively.")

(defun my/font-update (attribute value faces &optional all-frames)
  "Set ATTRIBUTE to VALUE for FACES.
Without ALL-FRAMES, apply only to the current frame.
With ALL-FRAMES (via \\[universal-argument]), apply to all frames."
  (let ((frame (unless all-frames (selected-frame))))
	(dolist (face faces)
	  (when (internal-lisp-face-p face)
		(set-face-attribute face frame attribute value)))
	(run-hooks 'my/fonts-updated-hook)))

(defun my/apply-fonts ()
  "Apply `my/available-mono-font' and `my/available-variable-font' to faces."
  (when my/available-mono-font
	(set-face-attribute 'default nil
						:family my/available-mono-font
						:height my/default-font-height
						:weight 'regular)
	(set-face-attribute 'fixed-pitch nil
						:family my/available-mono-font
						:height my/default-font-height
						:weight 'regular)
	(set-face-attribute 'mode-line nil
						:family my/available-mono-font
						:height my/mode-line-font-height
						:weight 'bold)
	(set-face-attribute 'mode-line-inactive nil
						:family my/available-mono-font
						:height my/mode-line-font-height
						:weight 'bold)
	(set-face-attribute 'minibuffer-prompt nil
						:family my/available-mono-font
						:height my/mode-line-font-height
						:weight 'regular))
  (when my/available-variable-font
	(set-face-attribute 'variable-pitch nil
						:family my/available-variable-font
						:height my/variable-font-height
						:weight 'regular)))


;;; Interactive commands
(defun my/read-sensible-font-height (face)
  "Prompt for a font height for FACE, clamped to [80, 300]."
  (let ((current (or (and (numberp (face-attribute face :height))
						  (face-attribute face :height))
					 my/default-font-height)))
	(max (min (read-number (format "Set %s height (currently: %s): "
								   face current))
			  300)
		 80)))

(defun my/read-font (type)
  "Read a font of TYPE (`fixed' or `variable') from available families."
  (let* ((face (if (eq type 'fixed) 'fixed-pitch 'variable-pitch))
		 (prev (or (face-attribute face :family)
				   (face-attribute 'default :family)))
		 (prefs (if (eq type 'fixed)
					my/mono-font-preferences
				  my/variable-font-preferences))
		 (available (my/available-fonts prefs))
		 (all-installed (font-family-list)))
	(completing-read
	 (format "Select %s font (current: %s): " type prev)
	 ;; Prefer the shortlist, but offer every installed family as fallback.
	 (append available (seq-difference all-installed available)))))

(defun my/select-fixed-font (font)
  "Select fixed FONT for `default' and `fixed-pitch'."
  (interactive (list (my/read-font 'fixed)))
  (my/font-update :family font '(default fixed-pitch)))

(defun my/select-variable-font (font)
  "Select variable FONT for `variable-pitch'."
  (interactive (list (my/read-font 'variable)))
  (my/font-update :family font '(variable-pitch)))

(defun my/set-fixed-font-height (height &optional all-frames)
  "Set HEIGHT for `default' and `fixed-pitch'.
With ALL-FRAMES, apply to every frame."
  (interactive (list (my/read-sensible-font-height 'default)
					 current-prefix-arg))
  (setq my/default-font-height height)
  (my/font-update :height height '(default fixed-pitch) all-frames))

(defun my/set-variable-font-height (height &optional all-frames)
  "Set HEIGHT for `variable-pitch'.
With ALL-FRAMES, apply to every frame."
  (interactive (list (my/read-sensible-font-height 'variable-pitch)
					 current-prefix-arg))
  (setq my/variable-font-height height)
  (my/font-update :height height '(variable-pitch) all-frames))

(defun my/set-default-face ()
  "Set the default font and height interactively from all installed fonts."
  (interactive)
  (let ((selected-font (completing-read "Select default font: "
										(font-family-list)))
		(selected-size (read-number "Select default font size: " 11)))
	(set-face-attribute 'default nil
						:family selected-font
						:height (* 10 selected-size))
	(add-to-list 'default-frame-alist (cons 'font selected-font))))

(defun my/what-font ()
  "Show the current default font specification."
  (interactive)
  (message "%s" (face-attribute 'default :font)))

;;; Font Lock Styling
(defun my/font-lock-styling ()
  "Set comment face italic and keyword face bold."
  (set-face-attribute 'font-lock-comment-face nil :slant 'italic :weight 'normal)
  (set-face-attribute 'font-lock-keyword-face nil :weight 'bold))

(add-hook 'enable-theme-functions
		  (lambda (_theme) (my/font-lock-styling)))

;;; Apply at load
(my/apply-fonts)
(my/font-lock-styling)


;;; Set Default Font
;; (when my/available-mono-font
;;   (set-face-attribute
;;    'default nil
;;    :family my/available-mono-font
;;    ;; Height = point size x 10 = 12 x 10 = 120
;;    :height 110
;;    :weight 'regular))
;;
;; ;;; Set Fixed Font
;; (when my/available-mono-font
;;   (set-face-attribute
;;    'fixed-pitch nil
;;    :family my/available-mono-font
;;    :height 110
;;    :weight 'regular))
;;
;; ;;; Set Variable Font
;; (when my/available-variable-font
;;   (set-face-attribute
;;    'variable-pitch nil
;;    :family my/available-variable-font
;;    :height 110
;;    :weight 'regular))

;;; Modeline
;; (set-face-attribute 'mode-line nil :family "Berkeley Nerd Font 9" :weight 'bold)
;; (set-face-attribute 'mode-line-inactive nil :family "Berkeley Nerd Font 9" :weight 'bold)

;;; Minibuffer
;; (set-face-attribute 'minibuffer-prompt nil :family "Berkeley Nerd Font 9" :weight 'regular)

;; (set-face-attribute 'mode-line          nil :family my/available-mono-font :height 90 :weight 'bold)
;; (set-face-attribute 'mode-line-inactive nil :family my/available-mono-font :height 90 :weight 'bold)
;; (set-face-attribute 'minibuffer-prompt  nil :family my/available-mono-font :height 90 :weight 'regular)
;;
;; ;
;; Debugging
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
;; (defun my/setup-fonts ()
;;   "List of system fonts."
;;   (x-list-fonts "*"))
;; Set Default Face
(defun my/set-default-face ()
  "Set the default font and height interactively."
  (interactive)
  (let* ((selected-font
		  (completing-read "Select default font: " (font-family-list)))
		 (selected-size
		  (read-number "Select default font size: " 12)))
	;; (set-face-attribute 'default nil :family selected-font)
	;; (set-face-attribute 'default nil :height (* 10 selected-size))
	(set-face-attribute 'default nil :family selected-font :height (* 10 selected-size))

	))


;; ;;; Better Describe Font
;; (defun my/what-font ()
;;   "Show the name/details for the current font in use."
;;   (interactive)
;;   (message "%s" (face-attribute 'default :font)))
;;
;;
;; ;;; Better Font Changer
;; (defun my/font-changer ()
;;   (interactive)
;;   (let ((font-name (completing-read "Select font:"
;; 									(font-family-list))))
;; 	(if (member font-name (font-family-list))
;; 		(set-face-attribute 'default nil :font font-name)
;; 	  (add-to-list 'default-frame-alist (cons 'font font-name))
;; 	  (error "'%s' font not found" font-name))))


;;; Troubleshooting (uncomment during font troubleshooting)
;; (message "Mono:     %s" my/available-mono-font)
;; (message "Variable: %s" my/available-variable-font)
;; (message "Default:  %s" (face-attribute 'default :font))

(provide 'ef-fonts)
;;; ef-fonts.el ends here
