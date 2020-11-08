(require 'package)
(add-to-list 'package-archives
       '("melpa" . "https://melpa.org/packages/"))


(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize)

  (setq ns-right-alternate-modifier nil)
  (setq mac-option-key-is-meta nil)
  (setq mac-command-key-is-meta t)
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier nil)

)



(setq make-backup-files nil) ; stop creating backup~ files
(setq auto-save-default nil) ; stop creating #autosave# files

(setq confirm-kill-emacs 'y-or-n-p)

(if (display-graphic-p)
    (progn
      (toggle-scroll-bar -1)
      (scroll-bar-mode -1)
      ))


(menu-bar-mode -1)
(tool-bar-mode 0)
(blink-cursor-mode 0)
(global-linum-mode)
(delete-selection-mode 1)
(setq inhibit-splash-screen t) ;; no splash screen

(when (memq window-system '(mac ns x))
   (add-to-list 'default-frame-alist '(ns-appearance . dark))
   (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t)))

;; disable beep sound
(setq ring-bell-function 'ignore)

;; getting rid of the "yes or no" prompt and replace it with "y or n"
(defalias 'yes-or-no-p 'y-or-n-p)

;; display column number in mode line
(column-number-mode 1)

(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)

;; making tooltips appear in the echo area
(tooltip-mode 0)

(setq fill-column 80) ;; M-q should fill at 80 chars, not 75
(global-hl-line-mode +1)

(show-paren-mode 1)

(add-hook 'before-save-hook 'whitespace-cleanup)

(set-frame-font "Office Code Pro D Light 13")

(eval-when-compile
  (require 'use-package))
(require 'bind-key)


;; Keybindings
(global-unset-key (kbd "<left>"))
(global-unset-key (kbd "<right>"))
(global-unset-key (kbd "<up>"))
(global-unset-key (kbd "<down>"))
(global-unset-key (kbd "<C-left>"))
(global-unset-key (kbd "<C-right>"))
(global-unset-key (kbd "<C-up>"))
(global-unset-key (kbd "<C-down>"))
(global-unset-key (kbd "<M-left>"))
(global-unset-key (kbd "<M-right>"))
(global-unset-key (kbd "<M-up>"))
(global-unset-key (kbd "<M-down>"))


(bind-key* "<C-tab>" (lambda () (interactive) (other-window 1)))
(bind-key* "<C-S-tab>" (lambda () (interactive) (other-window -1)))

(defun split-and-follow-horizontally ()
  (interactive)
  (split-window-below)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 2") 'split-and-follow-horizontally)

(defun split-and-follow-vertically ()
  (interactive)
  (split-window-right)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 3") 'split-and-follow-vertically)

(setq split-height-threshold nil) ;; prefer splitting vertically
(setq split-width-threshold 0)

(load-theme 'sanityinc-tomorrow-night t)

;; unset C- and M- digit keys
(dotimes (n 10)
  (global-unset-key (kbd (format "C-%d" n)))
  (global-unset-key (kbd (format "M-%d" n)))
  )

(setq ruby-insert-encoding-magic-comment nil)

(global-set-key (kbd "C-c n") 'simple-clean-region-or-buffer)

(defun simple-clean-buffer ()
  "Indent the currently visited buffer."
  (interactive)
  (indent-region (point-min) (point-max)))

(defun simple-clean-region-or-buffer ()
  "Cleans a region if selected, otherwise the whole buffer."
  (interactive)
  (save-excursion
    (if (region-active-p)
        (progn
          (indent-region (region-beginning) (region-end))
          (whitespace-cleanup)
          (message "Cleaned selected region"))
      (progn
        (simple-clean-buffer)
        (whitespace-cleanup)
        (message "Cleaned buffer")))))

(setq js-indent-level 2)

;; Add keybindings for interacting with Cargo
(use-package cargo
  :hook (rust-mode . cargo-minor-mode))

(use-package flycheck-rust
  :config (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

(use-package racer
  :hook (rust-mode . flycheck-mode)
  :config
  (add-hook 'rust-mode-hook #'racer-mode)
  (add-hook 'racer-mode-hook #'eldoc-mode)
  )
(use-package multiple-cursors
  :ensure t
  :config
  (global-set-key (kbd "C->") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
  (global-set-key (kbd "C-c C-<") 'mc/mark-all-dwim)
  )

(use-package eyebrowse
  :ensure t
  :diminish eyebrowse-mode
  :config (progn
            (define-key eyebrowse-mode-map (kbd "M-1") 'eyebrowse-switch-to-window-config-1)
            (define-key eyebrowse-mode-map (kbd "M-2") 'eyebrowse-switch-to-window-config-2)
            (define-key eyebrowse-mode-map (kbd "M-3") 'eyebrowse-switch-to-window-config-3)
            (define-key eyebrowse-mode-map (kbd "M-4") 'eyebrowse-switch-to-window-config-4)
            (eyebrowse-mode t)
            (setq eyebrowse-new-workspace t)))

(use-package ag
  :ensure t
  :bind
  ("C-M-s" . counsel-ag))

(use-package crux
  :ensure t
  :config
  (global-set-key (kbd "C-c d") 'crux-duplicate-current-line-or-region)
  ;; (global-set-key (kbd "C-c C-d") 'crux-duplicate-and-comment-current-line-or-region)
  (global-set-key (kbd "C-c C-d") 'crux-duplicate-and-comment-current-line-or-region)
  (global-set-key [remap move-beginning-of-line] #'crux-move-beginning-of-line))

(use-package rust-mode
  :ensure t
  :hook (rust-mode . lsp)
  :config
  (setq rust-format-on-save t)
  (setq rustic-lsp-server 'rust-analyzer)
  (define-key rust-mode-map (kbd "TAB") #'company-indent-or-complete-common)
   (with-eval-after-load 'rust-mode
     (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))
  )
(use-package ag
  :ensure t
  :bind
  ("C-M-s" . counsel-ag))


(use-package yafolding
  :ensure t
  :config
  (add-hook 'ruby-mode-hook 'yafolding-mode)
  (global-set-key (kbd "M-RET")   'yafolding-toggle-element))

(use-package swiper
       :config
       (global-set-key "\C-s" 'swiper))

(use-package counsel
       :ensure t
       :bind
       ("M-x" . counsel-M-x))

(use-package flycheck
  :ensure t
  :config

  (flycheck-add-mode 'javascript-eslint 'web-mode)
  (progn
  (setq-default flycheck-emacs-lisp-initialize-packages t
                flycheck-highlighting-mode 'lines
                flycheck-check-syntax-automatically '(save)
                flycheck-disabled-checkers '(c/c++-clang c/c++-gcc sass)))
  (defun my/use-eslint-from-node-modules ()
    (let* ((root (locate-dominating-file
                  (or (buffer-file-name) default-directory)
                  "node_modules"))
           (eslint (and root
                        (expand-file-name "node_modules/eslint/bin/eslint.js"
                                          root))))
      (when (and eslint (file-executable-p eslint))
        (setq-local flycheck-javascript-eslint-executable eslint))))
  (add-hook 'flycheck-mode-hook #'my/use-eslint-from-node-modules))

(use-package smartparens
  :init
  (progn
    (smartparens-global-mode 1)
    )
  )

(use-package ivy
  :config
  (ivy-mode 1)
  :bind*
  ("C-r" . ivy-resume))

;; magit
(use-package magit
  :ensure t
  :bind
  ("C-x g" . magit-status)
  :config
  (setq magit-completing-read-function 'ivy-completing-read)
  (setq magit-bury-buffer-function 'quit-window)
  (add-hook 'after-save-hook 'magit-after-save-refresh-status)
  :diminish auto-revert-mode)

;; company
(use-package company
  :ensure t
  :diminish company-mode
  :init
  (add-hook 'after-init-hook 'global-company-mode)
  ;; :bind
  :hook (prog-mode . company-mode)
  ;; ("M-/" . company-complete-common)
   :config
   (setq company-dabbrev-downcase nil)
   (setq company-idle-delay 0)
   (setq company-minimum-prefix-length 1)
   (define-key company-mode-map [remap indent-for-tab-command] #'company-indent-or-complete-common)
   (setq company-dabbrev-code-modes nil)
   (setq company-selection-wrap-around t)
   (setq company-tooltip-align-annotations t)
   (with-eval-after-load 'company
    (define-key company-active-map (kbd "M-n") nil)
    (define-key company-active-map (kbd "M-p") nil)
    (define-key company-active-map (kbd "C-n") #'company-select-next)
     (define-key company-active-map (kbd "C-p") #'company-select-previous)))

(use-package move-text
  :ensure t
  :bind
  ("M-n" . move-text-down)
  ("M-p" . move-text-up)
  :config
  (move-text-default-bindings))


(use-package lsp-mode
  :config
  (setenv "JAVA_HOME" "/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home")
  (setq lsp-java-configuration-runtimes '[(:name "JavaSE-8"
                                                 :path "/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home/bin/java"
                                                 :default t)])
  (setq lsp-java-java-path "/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home/bin/java")
  (setq lsp-log-io t)
  (setq lsp-java-jdt-download-url  "https://download.eclipse.org/jdtls/milestones/0.57.0/jdt-language-server-0.57.0-202006172108.tar.gz")
  (setq lsp-print-io t)
  (setq lsp-java-trace-server t)
  (setq lsp-java-progress-report t)
  (setq lsp-prefer-flymake nil)
  (setq lsp-solargraph-use-bundler t)
  (setq lsp-rust-server 'rust-analyzer)
  (setq lsp-enable-file-watchers nil)
  (setq lsp-file-watch-ignored
        '(".idea" ".ensime_cache" ".eunit" "node_modules"
          ".git" ".hg" ".fslckout" "_FOSSIL_"
          ".bzr" "_darcs" ".tox" ".svn" ".stack-work"
          "build"))
  (add-hook 'java-mode-hook #'lsp)

)

(use-package lsp-ui
  :config
  (setq lsp-ui-doc-enable nil
        lsp-ui-sideline-enable nil
        lsp-ui-flycheck-enable t)
  :after lsp-mode)

(use-package lsp-java
  :init
  :config
  (setenv "JAVA_HOME" "/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home")
  (setq lsp-java-configuration-runtimes '[(:name "JavaSE-8"
                                                 :path "/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home/bin/java"
                                                 :default t)])
  (setq lsp-java-java-path "/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home/bin/java")
  (setq lsp-log-io t)
  (setq lsp-print-io t)
  (setq lsp-java-trace-server t)
  (setq lsp-java-progress-report t)
  (add-hook 'java-mode-hook #'lsp))

(use-package yafolding
  :ensure t
  :config
  (add-hook 'ruby-mode-hook 'yafolding-mode)
  (global-set-key (kbd "M-RET")   'yafolding-toggle-element))

;; projectile
(use-package projectile
  :ensure t
  :bind
  (("C-x f" . counsel-projectile-find-file)
  ("C-x s" . projectile-switch-open-project)
  ("C-x p" . projectile-switch-project))
  :config
  (projectile-global-mode)
  (setq projectile-remember-window-configs t)
  (setq projectile-completion-system 'ivy))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("830877f4aab227556548dc0a28bf395d0abe0e3a0ab95455731c9ea5ab5fe4e1" "2809bcb77ad21312897b541134981282dc455ccd7c14d74cc333b6e549b824f3" "c433c87bd4b64b8ba9890e8ed64597ea0f8eb0396f4c9a9e01bd20a04d15d358" "285d1bf306091644fb49993341e0ad8bafe57130d9981b680c1dbd974475c5c7" "82d2cac368ccdec2fcc7573f24c3f79654b78bf133096f9b40c20d97ec1d8016" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" default))
 '(package-selected-packages
   '(lsp-javacomp yasnippet solarized-theme lsp-java color-theme-sanityinc-tomorrow cargo company-lsp counsel-projectile lsp-ui lsp-mode smartparens swiper-helm flycheck-rust move-text company magit flycheck counsel yafolding rust-mode crux ag eyebrowse multiple-cursors use-package exec-path-from-shell)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
