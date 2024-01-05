(require 'package)
(add-to-list 'package-archives '("gnu"   . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))

; Fix for all native compile warnings
(when (eq system-type 'darwin) (customize-set-variable 'native-comp-driver-options '("-Wl,-w")))
(setq native-comp-async-report-warnings-errors nil)

(setq make-backup-files nil) ; stop creating backup~ files
(setq auto-save-default nil) ; stop creating #autosave# files

(setq confirm-kill-emacs 'y-or-n-p)

(if (display-graphic-p)
    (progn
      (toggle-scroll-bar -1)
      (scroll-bar-mode -1)
      (menu-bar-mode -1)
      (tool-bar-mode 0)
      ))

(delete-selection-mode 1)
(setq inhibit-splash-screen t) ;; no splash screen
(setq initial-scratch-message nil)

;; display column number in mode line
(column-number-mode 1)

(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)
(setq-default js-indent-level 2)
(setq-default standard-indent 2) ;; For eglot to behave properly with indent

(setq mode-require-final-newline t)
(display-line-numbers-mode t)
(setq-default fill-column 80) ;; M-q should fill at 80 chars, not 75
(global-visual-line-mode t)
(setq-default word-wrap t)

;; indentation
(setq-default indent-tabs-mode nil)
(setq-default default-tab-width 2)

(setq custom-file (locate-user-emacs-file "custom.el"))

(add-to-list 'load-path (expand-file-name "modules" user-emacs-directory))
(require 'init-editor)
(require 'init-theme)
(require 'init-vertico)
(require 'init-project)
(require 'init-rustic)
(require 'init-magit)
(require 'init-eglot)
(require 'init-corfu)
(require 'init-js)

;;(require 'init-autocomplete)
(provide 'init)
