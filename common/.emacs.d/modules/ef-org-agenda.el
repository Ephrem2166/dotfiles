;;; ef-org-agenda.el ---  -*- lexical-binding: t; -*-

;;; Commentary:
;;

;;; Code:
;;; Org Agenda
(use-package org-agenda
  :ensure nil
  :after irg
  :bind ("C-c C-a" . org-agenda)
  :config
  (setopt org-deadline-warning-days 3)
  (setopt org-agenda-inhibit-startup t)
  ;; (setopt org-agenda-files (list org-directory))
  (setq org-agenda-files
        (list
         "~/Org/Capture/appt.org"
         "~/Org/Capture/links.org"
         "~/Org/Capture/today.org"
         "~/Org/Capture/links.org"
         "~/Org/Capture/tasks.org"
         "~/Org/Capture/notes.org"
         "~/Org/Capture/journal.org"))
  ;; (setopt org-agenda-files (list my-org-todos))
  ;; (setopt org-agenda-files '(
  ;; "~/Documents/Notes/Org Notes/Agenda/tasks.org"
  ;; "~/Documents/Notes/Org Notes/Agenda/links.org"
  ;; "~/Documents/Notes/Org Notes/Agenda/codes.org"
  ;; "~/Documents/Notes/Org Notes/Agenda/journal.org"
  ;; "~/Documents/Notes/Org Notes/Agenda/notes.org"
  ;; ))
  (setopt org-agenda-remove-tags t)
  (setopt org-agenda-restore-windows-after-quit t)
  (setopt org-agenda-show-inherited-tags nil)
  (setopt org-agenda-skip-deadline-if-done t)
  (setopt org-agenda-skip-scheduled-if-done t)
  (setopt org-agenda-skip-timestamp-if-done t)
  (setopt org-agenda-sorting-strategy
          '((agenda time-up deadline-up scheduled-up todo-state-up priority-down)
            (todo todo-state-up priority-down deadline-up)
            (tags todo-state-up priority-down deadline-up)
            (search todo-state-up priority-down deadline-up)))
  (setopt org-agenda-tags-todo-honor-ignore-options t)
  (setopt org-agenda-use-tag-inheritance nil)
  (setopt org-agenda-window-frame-fractions '(0.0 . 0.5))
  ;; From protesilaos
  (setopt org-agenda-span 'week)
  (setopt org-agenda-start-on-weekday 1)
  (setopt org-agenda-confirm-kill t)
  (setopt org-agenda-show-all-dates t)
  (setopt org-agenda-show-outline-path nil)
  (setopt org-agenda-window-setup 'current-window)
  (setopt org-agenda-skip-comment-trees t)
  (setopt org-agenda-menu-show-matcher t)
  (setopt org-agenda-menu-two-columns nil)
  (setopt org-agenda-sticky nil)
  (setopt org-agenda-custom-commands-contexts nil)
  (setopt org-agenda-max-entries nil)
  (setopt org-agenda-max-todos nil)
  (setopt org-agenda-max-tags nil)
  (setopt org-agenda-max-effort nil)
  (setopt org-agenda-prefix-format
          '((agenda . " %i %-12:c%?-12t% s")
            (todo . " %i %-12:c")
            (tags . " %i %-12:c")
            (search . " %i %-12:c")))
  (setopt org-agenda-breadcrumbs-separator "->")
  (setopt org-agenda-todo-keyword-format "%-1s")
  (setopt org-agenda-fontify-priorities 'cookies)
  (setopt org-agenda-category-icon-alist nil)
  (setopt org-agenda-remove-times-when-in-prefix nil)
  (setopt org-agenda-remove-timeranges-from-blocks nil)
  (setopt org-agenda-compact-blocks nil)
  (setopt org-agenda-block-separator ?-)
  ;; Agenda marks
  (setopt org-agenda-bulk-mark-char "#")
  (setopt org-agenda-persistent-marks nil)

  ;; Agenda follow mode
  (setopt org-agenda-start-with-follow-mode nil)
  (setopt org-agenda-follow-indirect t)

  ;; Deadline and Schedule Timestamps
  (setopt org-agenda-include-deadlines t)
  (setopt org-deadline-warning-days 0)
  (setopt org-agenda-skip-scheduled-if-done nil)
  (setopt org-agenda-skip-scheduled-if-deadline-is-shown t)
  (setopt org-agenda-skip-timestamp-if-deadline-is-shown t)
  (setopt org-agenda-skip-deadline-if-done nil)
  (setopt org-agenda-skip-deadline-prewarning-if-scheduled 1)
  (setopt org-agenda-skip-scheduled-delay-if-deadline nil)
  (setopt org-agenda-skip-additional-timestamps-same-entry nil)
  (setopt org-agenda-skip-timestamp-if-done nil)
  (setopt org-agenda-search-headline-for-time nil)
  (setopt org-scheduled-past-days 365)
  (setopt org-deadline-past-days 365)
  (setopt org-agenda-move-date-from-past-immediately-to-today t)
  (setopt org-agenda-show-future-repeats t)
  (setopt org-agenda-prefer-last-repeat nil)
  (setopt org-agenda-timerange-leaders
          '("" "(%d/%d): "))
  (setopt org-agenda-scheduled-leaders
          '("Scheduled: " "Sched.%2dx: "))
  (setopt org-agenda-inactive-leader "[")
  (setopt org-agenda-deadline-leaders
          '("Deadline:  " "In %3d d.: " "%2d d. ago: "))

  ;; Time Grid
  (setopt org-agenda-time-leading-zero t)
  (setopt org-agenda-timegrid-use-ampm nil)
  (setopt org-agenda-use-time-grid t)
  (setopt org-agenda-show-current-time-in-grid t)
  (setopt org-agenda-current-time-string (concat "Now " (make-string 70 ?.)))
  (setopt org-agenda-time-grid
          '((daily today require-timed)
            ( 0500 0600 0700 0800 0900 1000
              1100 1200 1300 1400 1500 1600
              1700 1800 1900 2000 2100 2200)
            "" ""))
  (setopt org-agenda-default-appointment-duration nil)

  ;; Agenda global to-do list
  (setopt org-agenda-todo-ignore-with-date t)
  ;; (setopt org-agenda-todo-ignore-timestamp t)
  (setopt org-agenda-todo-ignore-scheduled t)
  (setopt org-agenda-todo-ignore-deadlines t)
  (setopt org-agenda-todo-ignore-time-comparison-use-seconds t)
  (setopt org-agenda-tags-todo-honor-ignore-options nil)

  ;; Agenda Tagged Items
  (setopt org-agenda-show-inherited-tags t)
  (setopt org-agenda-use-tag-inheritance
          '(todo search agenda))
  (setopt org-agenda-hide-tags-regexp nil)
  (setopt org-agenda-remove-tags nil)
  (setopt org-agenda-tags-column 0)

  )

;;; Performance Tweaks for Org Agenda
(use-package org-agenda
  :ensure nil
  :after org
  :config
  (setq org-agenda-inhibit-startup t)
  (setq org-agenda-use-tag-inheritance nil)
  (add-hook 'after-init-hook                ;;   then revert after-init
            #'(lambda () (setq org-agenda-show-inherited-tags 'always)))
  (setq-default org-agenda-skip-scheduled-if-deadline-is-shown 'not-today)
  )

;;; Org Log
(use-package org
  :ensure nil
  :config
  (setopt org-log-done 'time)
  (setopt org-log-into-drawer t)
  (setopt org-log-note-clock-out nil)
  (setopt org-log-redeadline 'time)
  (setopt org-log-reschedule 'time)
  )



;;; Org Agenda Custom Commands
(use-package org
  :ensure nil
  :config
  (setq org-agenda-custom-commands
        '(
          ;; Remove
          ("#" " To remove"
           ((todo "DONE|SKIP"))
           ((org-agenda-overriding-header "Items to remove (use C-k)")
            (org-agenda-include-diary nil)))
          ;; Next Week Scheduled
          ("H" " Next week scheduled/deadline"
           agenda ""
           ((org-agenda-overriding-header "Next week scheduled/deadline items")
            (org-agenda-entry-types '(:deadline :scheduled))
            (org-agenda-span 'week)
            (org-deadline-warning-days 1)
            (org-agenda-include-diary nil)))

          ) ))

;;; Org Clock
(use-package org
  :ensure nil
  :custom
  (org-clock-clocked-in-display nil)
  (org-clock-idle-time 10)
  (org-clock-in-resume t)
  (org-clock-in-switch-to-state "DOING")
  (org-clock-into-drawer "LOGBOOK")
  (org-clock-mode-line-total 'current)
  (org-clock-out-remove-zero-time-clocks t)
  (org-clock-out-switch-to-state nil)
  ;; (org-clock-persist t)
  ;; (org-clock-persist-file (user-data "org-clock-save.el"))
  (org-clock-resolve-expert t)
  )


(provide 'ef-org-agenda)
;;; ef-org-agenda.el ends here
