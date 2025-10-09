;;; ef-package.el  -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:

(setq package-vc-register-as-project nil)

(add-hook 'package-menu-mode-hook #'hl-line-mode)

(setq package-archives
      '(("gnu-elpa"  . "https://elpa.gnu.org/packages/")
        ("gnu-devel" . "https://elpa.gnu.org/devel/")
        ("nongnu"    . "https://elpa.nongnu.org/nongnu/")
        ("melpa"     . "https://melpa.org/packages/")))

;; -----------------------------------------------------------------------------
;; please suggest packages to be upgraded (via the package archive)
(setq package-install-upgrade-built-in t)

;; -----------------------------------------------------------------------------
;; initialize and refresh package contents if needed
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; -----------------------------------------------------------------------------
;; Install use-package if necessary
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; -----------------------------------------------------------------------------
;; The `:ensure-system-package` keyword allows you to ensure system
;; binaries exist alongside your `use-package` declarations.  Using it
;; requires the `system-packages' package to be installed
(use-package use-package-ensure-system-package)
(use-package system-packages
  :ensure t)

;; -----------------------------------------------------------------------------
;; Ensure use-package is available at compile time
(eval-when-compile
  (require 'use-package))

;; -----------------------------------------------------------------------------
;; bump up the number of bindings / unwind-protects
(setq max-lisp-eval-depth 2000)

;; -----------------------------------------------------------------------------
;; want to see loading time of each package during startup ? here is
;; how:
;;    - uncomment '(setq use-package-compute-statistics t)' below,
;;    - restart emacs, and then
;;    - M-x use-package-report
;; (setq use-package-compute-statistics t)

(provide 'ef-package)
;;; ef-package.el ends here
