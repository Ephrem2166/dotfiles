;;; ef-org-capture.el ---  -*- lexical-binding: t; -*-

;;; Commentary:
;;

;;; Code:
;;; Org Capture
(require 'ef-org)
(defconst ef/capture-dir (expand-file-name "capture/" ef/org-directory))
(make-directory ef/capture-dir t)

(use-package org-capture
  :ensure nil
  :bind ("C-c C-c" . org-capture)
  :config
  ;; Default `org-capture-templates' key to use.
  (setq org-protocol-default-template-key "l")
  (setq org-capture-use-agenda-date t)



  ;; (setq org-capture-templates
  ;;
  ;; 		'(
  ;; 		  ;; Tasks
  ;; 		  ("t" "Task" entry
  ;; 		   (file+headline ,(expand-file-name "tasks.org" ef/capture-dir)"My Tasks")
  ;; 		   "* TODO %^{Task} %^G\n:PROPERTIES:\n:CREATED: %U\n:END:\n\n%?"
  ;;
  ;; 		   )
  ;; 		  ;; Appointments
  ;; 		  ("a" "Appointment" entry
  ;; 		   (file+headline ,(expand-file-name "appt.org" ef/capture-dir) "Appointment")
  ;; 		   "* TODO %^{Appointment} %^g\nSCHEDULED: %^T\n%i"
  ;; 		   :empty-lines 1)
  ;; 		  ;; Links
  ;; 		  ("l" "Link" entry
  ;; 		   (file+headline ,(expand-file-name "links.org" ef/capture-dir) "Links")
  ;; 		   "* READ %^{Title} %^G\n:PROPERTIES:\n:CREATED: %U\n:END:\n\n%^{URL}")
  ;; 	  ;; Notes
  ;; 		  ("n" "Note" entry
  ;; 		   (file+headline ,(expand-file-name "notes.org" ef/capture-dir) "Notes")
  ;; 		   "* %^{Title} %^G\n:PROPERTIES:\n:CREATED: %U\n:END:\n\n%?"
  ;; 		   :empty-lines 1)
  ;; 		  ;; Today
  ;; 		  ("." "Today task" entry
  ;; 		   (file+headline ,(expand-file-name "today.org" ef/capture-dir) "Today's Tasks")
  ;; 		   "* TODO %^{Task}\n:PROPERTIES:\n:CREATED: %U\n:END:\n\n%?")
  ;; 		  ;; Journal
  ;; 		  ("j" "Journal" entry
  ;; 		   (file+olp+datetree ,(expand-file-name "journal.org" ef/capture-dir) "Journal")
  ;; 		   "* %^{Title}%?\n:PROPERTIES:\n:CREATED: %U\n:CUSTOM_ID: h:%(format-time-string \"%Y%m%dT%H%M%S\")\n:END:\n%i"
  ;; 		   :empty-lines-after 1)
  ;; 		  ;; Unprocessed
  ;; 		  ("u" "Unprocessed" entry
  ;; 		   (file+headline ,(expand-file-name "unprocessed.org" ef/capture-dir) "Unprocessed")
  ;; 		   "* %^{Title}\n:PROPERTIES:\n:CAPTURED: %U\n:CUSTOM_ID: h:%(format-time-string \"%Y%m%dT%H%M%S\")\n:END:\n%i\n%?"
  ;; 		   :empty-lines 1)
  ;; 		  ;; Code Snippets
  ;; 		  ("c" "Code snippet" entry
  ;; 		   (file+headline ,(expand-file-name "codes.org" ef/capture-dir) "Snippets")
  ;; 		   "* %?\t%^g\n#+BEGIN_SRC %^{Language}\n\n#+END_SRC")
  ;; 		  ;; Lists
  ;; 		  ("i" "Item"      checkitem (file ,(expand-file-name "lists.org" ef/capture-dir)))
  ;; 		  ("w" "Movie"     checkitem (file+headline ,(expand-file-name "lists.org" ef/capture-dir) "Watchlist"))
  ;; 		  ("r" "Read"      checkitem (file+headline ,(expand-file-name "lists.org" ef/capture-dir) "Reading List"))
  ;; 		  ("g" "Get list"  checkitem (file+headline ,(expand-file-name "lists.org" ef/capture-dir) "Get List"))
  ;; 		  )
  ;; 		)
  (setq org-capture-templates
		'(("t" "Task" entry
		   (file+headline "~/Org/capture/tasks.org" "My tasks")
		   "* TODO %^{Task} %^G\n:PROPERTIES:\n:CREATED: %U\n:END:\n\n%?")

		  ("a" "Appointment" entry
		   (file+headline "~/Org/capture/appt.org" "Appointment")
		   "* TODO %^{Appointment} %^g\nSCHEDULED: %^T\n%i"
		   :empty-lines 1)

		  ("l" "Link" entry
		   (file+headline "~/Org/capture/links.org" "Links")
		   "* READ %^{Title} %^G\n:PROPERTIES:\n:CREATED: %U\n:END:\n\n%^{URL}")

		  ("n" "Note" entry
		   (file+headline "~/Org/capture/notes.org" "Notes")
		   "* %^{Title} %^G\n:PROPERTIES:\n:CREATED: %U\n:END:\n\n%?"
		   :empty-lines 1)

		  ("." "Today task" entry
		   (file+headline "~/Org/capture/today.org" "Today's Tasks")
		   "* TODO %^{Task}\n:PROPERTIES:\n:CREATED: %U\n:END:\n\n%?")

		  ("j" "Journal" entry
		   (file+olp+datetree "~/Org/capture/journal.org" "Journal")
		   "* %^{Title}%?\n:PROPERTIES:\n:CREATED: %U\n:CUSTOM_ID: h:%(format-time-string \"%Y%m%dT%H%M%S\")\n:END:\n%i"
		   :empty-lines-after 1)

		  ("u" "Unprocessed" entry
		   (file+headline "~/Org/capture/unprocessed.org" "Unprocessed")
		   "* %^{Title}\n:PROPERTIES:\n:CAPTURED: %U\n:CUSTOM_ID: h:%(format-time-string \"%Y%m%dT%H%M%S\")\n:END:\n%i\n%?"
		   :empty-lines 1)

		  ("c" "Code snippet" entry
		   (file+headline "~/Org/capture/codes.org" "Snippets")
		   "* %?\t%^g\n#+BEGIN_SRC %^{Language}\n\n#+END_SRC")

		  ("i" "Item"     checkitem (file "~/Org/capture/lists.org"))
		  ("w" "Movie"    checkitem (file+headline "~/Org/capture/lists.org" "Watchlist"))
		  ("r" "Read"     checkitem (file+headline "~/Org/capture/lists.org" "Reading List"))
		  ("g" "Get list" checkitem (file+headline "~/Org/capture/lists.org" "Get List"))))





  ;;   (setq org-capture-templates
  ;; 		'(
  ;; 		  ;; Appointments
  ;; 		  ("a" "Appointment" entry
  ;; 		   (file+headline "~/Org/Capture/appt.org" "Appointment")
  ;; 		   "* TODO %? %^g\n SCHEDULED: <%(org-read-date)>")
  ;; 		  ;; Tasks
  ;; 		  ("t" "Tasks" entry
  ;; 		   (file+headline "~/Org/Capture/tasks.org" "My tasks")
  ;; 		   "* TODO %^{Todo} %^G \n:PROPERTIES:\n:CREATED: %U\n:END:\n\n%?")
  ;; 		  ;; Password
  ;; 		  ("p" "password" entry
  ;; 		   (file+headline "~/Org/Capture/password.org" "Passwords")
  ;; 		   ;; Prompt for name
  ;; 		   "* %^{name}
  ;;    :PROPERTIES:
  ;;    :username: %^{username}
  ;;    :password: %(my/generate-password-non-interactive)
  ;;    :url: %^{url}
  ;;    :END:")
  ;; 		  ;; Links
  ;; 		  ("l" "Link" entry
  ;; 		   (file+headline  "~/Org/Capture/links.org" "Links")
  ;; 		   "* READ %^{Title} %^G\n:PROPERTIES:\n:CREATED: %U\n:END:\n\n%^{Link}")
  ;; 		  ;; Journal
  ;; 		  ("J" "Journal" entry
  ;; 		   (file+olp+datetree "~/Org/Capture/journal.org" "My Journal")
  ;; 		   "* %^{TITLE}%?\n:PROPERTIES:
  ;; :CREATED: %U
  ;; :CUSTOM_ID: h:%(format-time-string \"%Y%m%dT%H%M%S\")
  ;; :END:
  ;; %i%?"
  ;; 		   :empty-lines-after 1 )
  ;; 		  ;; Today
  ;; 		  ("." "Today Tasks" entry
  ;; 		   (file+headline "~/Org/Capture/today.org" "Today's Tasks")
  ;; 		   "* TODO %^{Task}\n
  ;; :PROPERTIES:\n
  ;; :CREATED: %U\n
  ;; :END:\n\n
  ;; %?")
  ;; 		  ;; Notes
  ;; 		  ("n" "Note" entry
  ;; 		   (file+headline "~/Org/Capture/notes.org" "Notes")
  ;; 		   "* %^{Title} %^G \n:PROPERTIES:\n:CREATED: %U\n:END:\n\n%?"
  ;; 		   :empty-lines 1)
  ;; 		  ;; Code Snippets
  ;; 		  ("c" "Code Snippet" entry
  ;; 		   (file+headline "~/Org/Capture/codes.org" "Snippets")
  ;; 		   "* %?\t%^g\n#+BEGIN_SRC %^{language}\n\n#+END_SRC")
  ;;
  ;; 		  )        )
  ;;   ;; Another way to add templates
  ;;   ;; Appointments
  ;;   (add-to-list 'org-capture-templates
  ;; 			   `("A" "New appt" entry
  ;; 				 (file+headline "~/Org/Capture/appt.org" "Events")
  ;; 				 "* %^{Appointment}%?
  ;; %^T
  ;;
  ;; %i"
  ;; 				 :empty-lines 1) :append)
  ;;   ;; New note with timestamps
  ;;   (add-to-list 'org-capture-templates
  ;; 			   `("N" "New quick note (with timestamp)" entry
  ;; 				 (file+headline ,test-file "Notes")
  ;; 				 "* %^{Note}%?\n   CREATED: %U\n  %a\n%i"
  ;; 				 :empty-lines 1) :append)
  ;;
  ;;
  ;;   (add-to-list 'org-capture-templates
  ;; 			   '("h" "Person" entry
  ;; 				 (file+headline "~/Org/Capture/tests.org" "Person ")
  ;; 				 "* %?
  ;; :PROPERTIES:
  ;; :ORG:      ?
  ;; :EMAIL:    ?
  ;; :PHONE:    ?
  ;; :NOTE:     ?
  ;; :ADDRESS:  ?
  ;; :END:"
  ;;
  ;; 				 :empty-lines  2           ):prepend nil)
  ;;
  ;;   (add-to-list 'org-capture-templates
  ;; 			   '("u" "Unprocessed" entry
  ;; 				 (file+headline "~/Org/Capture/unprocessed.org" "Unprocessed")
  ;; 				 "* %^{Title}
  ;; :PROPERTIES:
  ;; :CAPTURED: %U
  ;; :CUSTOM_ID: h:%(format-time-string \"%Y%m%dT%H%M%S\")
  ;; :END:
  ;; %i\%?"
  ;; 				 :empty-lines 1
  ;; 				 ))
  ;;
  ;;   (add-to-list 'org-capture-templates
  ;; 			   '("j" "Journal" plain
  ;; 				 (file+olp+datetree "~/Org/Capture/journal.org" "Journal")
  ;; 				 "%?"
  ;; 				 :empty-lines-after 1
  ;; 				 ))
  ;;
  ;;   ;; CHECK
  ;;   (add-to-list 'org-capture-templates
  ;; 			   '("i" "Items" checkitem
  ;; 				 (file"~/Org/Capture/lists.org")) :prepend)
  ;;   ;; Watch list
  ;;   (add-to-list 'org-capture-templates
  ;; 			   '("w" "Movies" checkitem
  ;; 				 (file+headline "~/Org/Capture/lists.org" "Watchlist")) :append)
  ;;   ;; Reading list
  ;;   (add-to-list 'org-capture-templates
  ;; 			   '("r" "Reading List" checkitem
  ;; 				 (file+headline "~/Org/Capture/lists.org" "Readling List")))
  ;;
  ;;   ;; Get List
  ;;   (add-to-list 'org-capture-templates
  ;; 			   '("g" "Get List" checkitem
  ;; 				 (file+headline "~/Org/Capture/lists.org" "Get List")))

  :config
  (add-hook 'org-capture-after-finalize-hook
			(lambda ()
			  (when (derived-mode-p 'org-agenda-mode)
				(org-agenda-redo))))

  )



(provide 'ef-org-capture)
;;; ef-org-capture.el ends here
