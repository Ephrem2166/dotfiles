;;; ef-experiment.el ---  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:

;;; Better Help Using <f1>
(global-set-key (kbd "<f1>") #'info)
(defun my/describe-elisp-symbol-at-point ()
  "Get help for the symbol at point."
  (interactive)
  (let ((sym (intern-soft (current-word))))
    (unless
        (cond ((null sym))
              ((not (eq t (help-function-arglist sym)))
               (describe-function sym))
              ((boundp sym)
               (describe-variable sym)))
      (message "[nothing]"))))

(global-set-key (kbd "<f1>") #'my/describe-elisp-symbol-at-point)



;;; Auto Indent On Paste
;; Auto-indentation of pasted code in programming modes,
;; but not in Makefile modes.
;; (fall back to default, non-indented, yanking by preceding the yanking
;; command `C-y' with `C-u').
(dolist (command '(yank yank-pop))
  (advice-add command :after
              (lambda (&rest _)
                "Indent yanked text in programming mode (unless prefix arg or in Makefile mode)."
                (when (and (not current-prefix-arg)
                           (derived-mode-p 'prog-mode)
                           (not (derived-mode-p 'makefile-mode)))
                  (let ((mark-even-if-inactive t))
                    (indent-region (region-beginning) (region-end) nil))))))


;;; Cursor customization based on buffer state.
;; (defun my/update-cursor-appearance ()
;;   "Update cursor color and shape based on buffer state (read-only, overwrite, or insert)."
;;   (let* ((is-light-theme (eq (frame-parameter nil 'background-mode) 'light))
;;          (cursor-colors `((read-only . "red")
;;                           (overwrite . "lightblue")
;;                           (default . ,(if is-light-theme "black" "white"))))
;;          current-color
;;          current-type)
;;     (setq current-color
;;           (cond (buffer-read-only
;;                  (cdr (assoc 'read-only cursor-colors)))
;;                 (overwrite-mode
;;                  (cdr (assoc 'overwrite cursor-colors)))
;;                 (t
;;                  (cdr (assoc 'default cursor-colors)))))
;;     (setq current-type (if overwrite-mode 'box 'bar))
;;     (when (color-defined-p current-color)
;;       (set-cursor-color current-color))
;;     (setq cursor-type current-type)))
;;
;; ;; Update cursor on every command.
;; (add-hook 'post-command-hook #'my/update-cursor-appearance)


;;; Performance
;; revert buffers when their files/state have changed
(defun my-visible-buffers (&optional buffer-list all-frames)
  "Return a list of visible buffers (i.e. not buried)."
  (let ((buffers
         (delete-dups
          (cl-loop for frame in (if all-frames (visible-frame-list) (list (selected-frame)))
                   if (window-list frame)
                   nconc (mapcar #'window-buffer it)))))
    (if buffer-list
        (cl-loop for buf in buffers
                 unless (memq buf buffer-list)
                 collect buffers)
      buffers)))
(defun my/auto-revert-buffer-h ()
  "Auto revert current buffer, if necessary."
  (unless (or auto-revert-mode
              (active-minibuffer-window)
              (and buffer-file-name
                   auto-revert-remote-files
                   (file-remote-p buffer-file-name nil t)))
    (let ((auto-revert-mode t))
      (auto-revert-handler))))

(defun my/auto-revert-buffers-h ()
  "Auto revert stale buffers in visible windows, if necessary."
  (dolist (buf (my-visible-buffers))
    (with-current-buffer buf
      (my/auto-revert-buffer-h))))
(add-hook 'after-save-hook #'my/auto-revert-buffers-h)




(provide 'ef-experiment)
;;; ef-experiment.el ends here
