;;; ef-comm.el ---  -*- lexical-binding: t; -*-

;;; Commentary:
;;
;;; FIXME:
;;; Code:
(use-package erc
  :ensure nil
  :defer t
  :custom
  (erc-join-buffer 'window)
  (erc-hide-list '("JOIN" "PART" "QUIT"))
  (erc-timestamp-format "[%H:%M]")
  (erc-autojoin-channels-alist '((".*\\.libera\\.chat" "#neovim" "Libera.Chat" "#vim" "#emacs" "#systemcrafters")))
  (erc-server-reconnect-attempts 10)
  (erc-server-reconnect-timeout 3)
  (erc-fill-function 'erc-fill-wrap)
  (erc-log-channels-directory (expand-file-name "cache/erc/logs" user-emacs-directory))
  (erc-log-insert-log-on-open 'erc-log-new-target-buffer-p) ;; EMACS-31 and or needs https://debbugs.gnu.org/cgi/bugreport.cgi?bug=79665 patch
  (erc-save-buffer-on-part t)
  (erc-save-queries-on-quit t)
  (erc-log-write-after-send t)
  (erc-log-write-after-insert t)
  ;; Kill buffers for server messages after quitting the server
  (erc-kill-server-buffer-on-quit t)
  ;; Kill buffers for private queries after quitting the server
  (erc-kill-queries-on-quit t)
  ;; Kill buffers for channels after /part
  (erc-kill-buffer-on-part t)

  :config
  (make-directory (expand-file-name "cache/erc/logs" user-emacs-directory) t)
  (add-to-list 'erc-modules 'log)
  :init
  (with-eval-after-load 'erc

    ;; EMACS-31 (no more dependency between scrolltobottom and erc-fill-wrap THX!!!)
    (when (< emacs-major-version 31)
      (add-to-list 'erc-modules 'scrolltobottom)))

  ;; Connect Erc
  (defun my/erc-connect-libera ()
    (interactive)
    (erc-tls :server "irc.libera.chat" :port "6697"
             :nick "ephrem21"))

  ;; Quit Erc
  (defun my/erc-quit ()
    "Kill ERC buffers and terminate any child processes."
    (interactive)
    (let ((kill-buffer-query-functions nil)
          (erc-buffers (erc-buffer-list)))
      (if (not erc-buffers)
          (message "There are no ERC buffers to kill."))
      (progn
        (dolist (buffer erc-buffers)
          (kill-buffer buffer))
        (message "Killed all ERC buffers."))))

  )

(provide 'ef-comm)
;;; ef-comm.el ends here
