;;; ef-setup-font.el  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:
(defvar dashboard-footer-messages)
(defvar wal-default-path)

(defgroup wal-visuals nil
  "Change settings used for visual packages."
  :group 'wal
  :tag "Visuals")

;;;; Customization:

(defcustom wal-transparency 90
  "The default frame transparency."
  :type 'integer
  :group 'wal-visuals)

(defcustom wal-theme nil
  "The theme."
  :type '(choice symbol (const nil))
  :group 'wal-visuals)

(defcustom wal-hidpi nil
  "Whether the display is considered HiDPI."
  :type 'boolean
  :group 'wal-visuals)

(defcustom wal-fixed-fonts
  '("JetBrains Mono"
    "Berkeley Nerd Font"
    "Iosevka"
    "Fira Code"
    "mononoki"
    "Input Mono"
    "Source Code Pro"
    "DejaVu Sans Mono")
  "Fixed fonts ordered by preference."
  :type '(repeat string)
  :group 'wal-visuals)

(defcustom wal-variable-fonts
  '("DeJa Vu Sans"
    "SN Pro"
    "Liberation Serif"
    "Ubuntu")
  "Variable fonts ordered by preference."
  :type '(repeat string)
  :group 'wal-visuals)

(defcustom wal-preferred-fonts nil
  "List of (fixed and variable width) font names that should be preferred."
  :type '(choice (repeat string) (const nil))
  :group 'wal-visuals)

(defcustom wal-fixed-font-height 120
  "The font height for fixed fonts.
The default value is 98."
  :type 'integer
  :group 'wal-visuals)

(defcustom wal-variable-font-height 140
  "The font height for variable fonts.
This has no default value."
  :type 'integer
  :group 'wal-visuals)


(defvar wal-fonts-updated-hook nil
  "Functions to run when fonts were updated.")

(defun wal-font-update (attribute value faces &optional arg)
  "Set ATTRIBUTE to VALUE for FACES.

This returns the made updates. Affects all frames unless ARG is
t."
  (let ((frame (when arg (selected-frame))))

    (mapc (lambda (it)
            (when (internal-lisp-face-p it)
              (set-face-attribute it frame attribute value)))
          faces)

    (run-hooks 'wal-fonts-updated-hook)))

(defun wal-read-sensible-font-height (type)
  "Read a sensible font height for TYPE."
  (let* ((current (face-attribute type :height))
         (num (read-number (format "Set %s font (currently: %s): " type current))))

    (max (min num 300) 80)))

(defun wal-available-fonts (fonts)
  "Filter FONTS down to available fonts."
  (seq-filter (lambda (it) (find-font (font-spec :name it))) fonts))

(defun wal-read-font (type)
  "Read a font for TYPE."
  (let* ((name (intern (format "%s-pitch" type)))
         (prev (face-attribute name :family))
         (fonts (symbol-value (intern (format "wal-%s-fonts" type))))
         (font (completing-read (format "Select %s font (current: %s) " type prev) (wal-available-fonts fonts))))

    font))

(defun wal-select-fixed-font (font)
  "Select fixed (available) FONT."
  (interactive (list (wal-read-font 'fixed)))

  (wal-font-update :font font '(default fixed-pitch)))

(defun wal-select-variable-font (font)
  "Select variable (available) FONT."
  (interactive (list (wal-read-font 'variable)))

  (wal-font-update :font font '(variable-pitch)))

(defun wal-set-fixed-font-height (height &optional arg)
  "Set the HEIGHT for fixed fonts.

Affects all frames unless ARG is t."
  (interactive (list (wal-read-sensible-font-height 'default) current-prefix-arg))

  (setq wal-fixed-font-height height)

  (wal-font-update :height height '(default fixed-pitch) arg))

(defun wal-set-variable-font-height (height &optional arg)
  "Set the HEIGHT for variable fonts.

Affects all frames unless ARG is t."
  (interactive (list (wal-read-sensible-font-height 'variable-pitch) current-prefix-arg))

  (setq wal-variable-font-height height)

  (wal-font-update :height height '(variable-pitch) arg))

(defun wal-preferred-fonts (fonts)
  "Filter FONTS down to preferred fonts."
  (seq-filter (lambda (it) (member it fonts)) wal-preferred-fonts))

(defun wal-fonts-candidate (fonts &optional prefer)
  "Return the first available font from a list of FONTS.
If PREFER is true, variable `wal-preferred-fonts' is not nil and
preferred fonts are available, return the first of those
instead."
  (let* ((available-fonts (wal-available-fonts fonts))
         (preferred (and prefer (wal-preferred-fonts available-fonts))))

    (if preferred
        (car preferred)
      (car available-fonts))))

;; Slanted and enchanted.
(defun wal-font-lock ()
  "Set comment face to italic and keyword face to bold."
  (set-face-attribute 'font-lock-comment-face nil :slant 'italic :weight 'normal)
  (set-face-attribute 'font-lock-keyword-face nil :weight 'bold))
(provide 'ef-setup-font)
;;; ef-setup-font.el ends here
