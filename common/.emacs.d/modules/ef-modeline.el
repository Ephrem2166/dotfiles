;;; ef-modeline.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:
(setq mode-line-compact nil)
(setq mode-line-right-align-edge 'right-fringe)
(setq-default mode-line-format
              '("%e" ; print error message about full memory.
                " "
                mode-line-front-space
                (:propertize "λ " face font-lock-keyword-face)
                ;; mode-line-mule-info
                ;; mode-line-client
                mode-line-modified
                ;; mode-line-remote
                ;; mode-line-frame-identification
                mode-line-buffer-identification
                ;; " "
                ;; mode-line-format-right-align
                ;; (vc-mode vc-mode)
                ;; "  "
                ;; " "
                ;; mode-line-misc-info
                mode-line-position
                mode-line-modes
                ;; (:eval (mode-line-right))
                battery-mode-line-string
                mode-line-end-spaces))

;; Date and Time
;; (setq display-time-format "%a, %b %e %R"
;;       battery-mode-line-format "%p%%"  ; Default: "[%b%p%%]"
;;       global-mode-string   (remove 'display-time-string global-mode-string)
;;       mode-line-end-spaces (list (propertize " "
;;                                              'display '(space :align-to (- right 20)))
;;                                  'display-time-string))
(display-time-mode 1)
(display-time-update)

;; Battery
(display-battery-mode)


;; Mode Line Right
(defvar mode-line-right-format nil
  "The mode line to display on the right side.")

(defun mode-line-right ()
  "Render the `mode-line-right-format'."
  (let ((formatted-line (format-mode-line mode-line-right-format)))
    (list
     (propertize
      " "
      'display
      `(space :align-to (- (+ right right-fringe right-margin) ,(string-width formatted-line))))
     formatted-line)))

;; Major Mode
(defvar mode-line-major-mode
  `(:propertize ("" mode-name)
                help-echo "Major mode\n\
mouse-1: Display major mode menu\n\
mouse-2: Show help for major mode\n\
mouse-3: Toggle minor modes"
                mouse-face mode-line-highlight
                local-map ,mode-line-major-mode-keymap))


(setq mode-line-right-format
      (list '(:eval mode-line-mule-info)
            "  "
            mode-line-major-mode))

;; Position
(setq mode-line-position-column-line-format '(" L%l:C%C"))
(setq mode-line-percent-position nil)
(column-number-mode 1)
(line-number-mode 1)


;; Modified Icons
(defun mode-line-modified-icons ()
  "Icon representation of `mode-line-modified'."
  (cond (buffer-read-only
         (concat (all-the-icons-octicon "lock" :v-adjust -0.05) " "))
        ((buffer-modified-p)
         (concat (all-the-icons-faicon "floppy-o" :v-adjust -0.05) " "))
        ((and buffer-file-name
              (not (file-exists-p buffer-file-name)))
         (concat (all-the-icons-octicon "circle-slash" :v-adjust -0.05) " "))))

(setq-default mode-line-modified '((:eval (mode-line-modified-icons))))


;; Remote
(defun mode-line-remote-icons ()
  "Icon representation of `mode-line-remote'."
  (when (and buffer-file-name
             (file-remote-p buffer-file-name))
    (concat (all-the-icons-octicon "radio-tower" :v-adjust -0.02) " ")))

(setq-default mode-line-remote   '((:eval (mode-line-remote-icons))))

;; VCS
(defun vc-git-mode-line-shorten (string)
  "Shorten `version-control' STRING in mode-line and add icon."
  (cond
   ((string-prefix-p "Git" string)
    (concat (all-the-icons-octicon "git-branch" :v-adjust -0.05)
            " "
            (if (> (length string) 30)
                (concat (substring-no-properties string 4 30) "…")
              (substring-no-properties string 4))))
   (t
    string)))
(advice-add 'vc-git-mode-line-string :filter-return #'vc-git-mode-line-shorten)

;; Coding System
(setq eol-mnemonic-unix ""
      eol-mnemonic-dos (propertize "[CR+LF]" 'face 'warning)
      eol-mnemonic-mac (propertize "[CR]" 'face 'warning)
      eol-mnemonic-undecided (propertize "[?]" 'face 'error))

(let ((coding (nthcdr 2 mode-line-mule-info)))
  (setcar coding '(:eval (if (string-equal "U" (format-mode-line "%z"))
                             ""
                           (propertize "[%z]" 'face 'warning))))
  coding)


(provide 'ef-modeline)
;;; ef-modeline.el ends here
