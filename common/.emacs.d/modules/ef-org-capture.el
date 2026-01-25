;;; ef-org-capture.el ---  -*- lexical-binding: t; -*-

;;; Commentary:
;;

;;; Code:
;;; Org Capture
(defvar test-file "~/Org/Capture/tests.org" )
(use-package org-capture
  :ensure nil
  :bind ("C-c C-c" . org-capture)
  :config
  ;; Default `org-capture-templates' key to use.
  (setq org-protocol-default-template-key "w")
  (setq org-capture-templates
        '(
          ;; Appointments
          ("a" "Appointment" entry
           (file+headline "~/Org/Capture/appt.org" "Appointment")
           "* TODO %? %^g\n SCHEDULED: <%(org-read-date)>")
          ;; Tasks
          ("t" "Tasks" entry
           (file+headline "~/Org/Capture/tasks.org" "My tasks")
           "* TODO %^{Todo} %^G \n:PROPERTIES:\n:CREATED: %U\n:END:\n\n%?")
          ;; Password
          ("p" "password" entry
           (file+headline "~/Org/Capture/password" "Passwords")
           ;; Prompt for name
           "* %^{name}
   :PROPERTIES:
   :username: %^{username}
   :password: %(my/generate-password-non-interactive)
   :url: %^{url}
   :END:")
          ;; Links
          ("l" "Link" entry
           (file+headline  "~/Org/Capture/links.org" "Links")
           "* READ %^{Title} %^G\n:PROPERTIES:\n:CREATED: %U\n:END:\n\n%^{Link}L")
          ;; Journal
          ("J" "Journal" entry
           (file+olp+datetree "~/Org/Capture/journal.org" "My Journal")
           "* %^{TITLE}%?\n
:PROPERTIES:
:CREATED: %U
:CUSTOM_ID: h:%(format-time-string \"%Y%m%dT%H%M%S\")
:END:
%i%?"
           :empty-lines-after 1 )
          ;; Today
          ("." "Today Tasks" entry
           (file+headline "~/Org/Capture/today.org" "Today's Tasks")
           "* TODO %^{Task} \n
:PROPERTIES:\n
:CREATED: %U\n
:END:\n\n
%?")
          ;; Notes
          ("n" "Note" entry
           (file+headline "~/Org/Capture/notes.org" "Notes")
           "* %^{Title} %^G \n:PROPERTIES:\n:CREATED: %U\n:END:\n\n%?"
           :empty-lines 1)
          ;; Code Snippets
          ("c" "Code Snippet" entry
           (file+headline "~/Org/Capture/codes.org" "Snippets")
           "* %?\t%^g\n#+BEGIN_SRC %^{language}\n\n#+END_SRC")

          )        )
  ;; Another way to add templates
  ;; Appointments
  (add-to-list 'org-capture-templates
               `("A" "New appt" entry
                 (file+headline "~/Org/Capture/appt.org" "Events")
                 "* %^{Appointment}%?
%^T

%i"
                 :empty-lines 1) :append)
  ;; New note with timestamps
  (add-to-list 'org-capture-templates
               `("N" "New quick note (with timestamp)" entry
                 (file+headline ,test-file "Notes")
                 "* %^{Note}%?\n   CREATED: %U\n  %a\n%i"
                 :empty-lines 1) :append)


  (add-to-list 'org-capture-templates
               '("h" "Person" entry
                 (file+headline "~/Org/Capture/tests.org" "Person ")
                 "* %?
:PROPERTIES:
:ORG:      ?
:EMAIL:    ?
:PHONE:    ?
:NOTE:     ?
:ADDRESS:  ?
:END:"

                 :empty-lines  2           ):prepend nil)

  (add-to-list 'org-capture-templates
               '("u" "Unprocessed" entry
                 (file+headline "~/Org/Capture/unprocessed.org" "Unprocessed")
                 "* %^{Title}
:PROPERTIES:
:CAPTURED: %U
:CUSTOM_ID: h:%(format-time-string \"%Y%m%dT%H%M%S\")
:END:
%i\%?"
                 :empty-lines 1
                 ))

  (add-to-list 'org-capture-templates
               '("j" "Journal" plain
                 (file+olp+datetree "~/Org/Capture/journal.org" "Journal")
                 "%?"
                 :empty-lines-after 1
                 ))

  ;; CHECK
  (add-to-list 'org-capture-templates
               '("i" "Items" checkitem
                 (file"~/Org/Capture/lists.org")) :prepend)
  ;; Watch list
  (add-to-list 'org-capture-templates
               '("w" "Movies" checkitem
                 (file+headline "~/Org/Capture/lists.org" "Watchlist")) :append)
  ;; Reading list
  (add-to-list 'org-capture-templates
               '("r" "Reading List" checkitem
                 (file+headline "~/Org/Capture/lists.org" "Readling List")))

  ;; Get List
  (add-to-list 'org-capture-templates
               '("g" "Get List" checkitem
                 (file+headline "~/Org/Capture/lists.org" "Get List")))

  )



(provide 'ef-org-capture)
;;; ef-org-capture.el ends here
