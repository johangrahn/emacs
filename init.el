;; Emacs config

(require 'package)
(add-to-list 'package-archives
       '("melpa" . "https://melpa.org/packages/"))

(package-initialize)

(and window-system (server-start))

(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize)

  (setq ns-right-alternate-modifier nil)
  (setq mac-option-key-is-meta nil)
  (setq mac-command-key-is-meta t)
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier nil)

  ;; Set this to be able to use the right alt-key on the OSX keyboard
  ;; (setq mac-option-modifier 'super
  ;;      mac-command-modifier 'meta)
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

(eval-when-compile
  (require 'use-package))
(require 'bind-key)

(set-frame-font "Office Code Pro D 15")

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


(use-package web-mode
       :ensure t
       :mode (("\\.html$" . web-mode)
              ("\\.html\\.erb\\'" . web-mode)
              ("\\.erb\\'" . web-mode)
              ("\\.js\\'" . web-mode))

       :init
       (setq web-mode-markup-indent-offset 2)
       (setq web-mode-code-indent-offset 2)
       (setq web-mode-css-indent-offset 2)
       (setq web-mode-enable-auto-pairing t)
       (setq web-mode-enable-auto-expanding t))

(use-package yasnippet)

(use-package scss-mode
  :hook (scss-mode . flycheck-mode)
  :hook (scss-mode . lsp)
  :config
  (setq css-indent-offset 2))

(use-package rust-mode
  :ensure t
  :hook (rust-mode . lsp)
  :config
  (setq rust-format-on-save t)
  (define-key rust-mode-map (kbd "TAB") #'company-indent-or-complete-common)
  ;; (with-eval-after-load 'rust-mode
  ;;   (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)))
  )


(use-package lsp-ui :commands lsp-ui-mode)

(use-package toml-mode)


(use-package lsp-python-ms
  :ensure t
  :init (setq lsp-python-ms-auto-install-server t)
  :hook (python-mode . (lambda ()
                          (require 'lsp-python-ms)
                          (lsp))))  ; or lsp-deferred


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

(use-package direnv
 :config
 (direnv-mode))

(use-package rspec-mode
  :ensure t)

(use-package crux
  :ensure t
  :config
  (global-set-key (kbd "C-c d") 'crux-duplicate-current-line-or-region)
  ;; (global-set-key (kbd "C-c C-d") 'crux-duplicate-and-comment-current-line-or-region)
  (global-set-key (kbd "C-c C-d") 'crux-duplicate-and-comment-current-line-or-region)
  (global-set-key [remap move-beginning-of-line] #'crux-move-beginning-of-line))

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
  (setq lsp-prefer-flymake nil)
  (setq lsp-solargraph-use-bundler t)
  )

(use-package lsp-ui
  :config
  (setq lsp-ui-doc-enable nil
        lsp-ui-sideline-enable nil
        lsp-ui-flycheck-enable t)
  :after lsp-mode)

;; (use-package inf-ruby
;;   :hook (enh-ruby-mode-hook . inf-ruby-minor-mode)
;;   :config
;;   ;; Enables inf-ruby-mode when encountering e.g. byebug but doesn't
;;   ;; jump to end: https://github.com/nonsequitur/inf-ruby/pull/87
;;   (add-hook 'compilation-filter-hook 'inf-ruby-auto-enter)
;;   (eval-after-load 'rspec-mode
;;     '(define-key rspec-compilation-mode-map (kbd "C-x C-q") (lambda ()
;;                                                               (interactive)
;;                                                               (inf-ruby-switch-from-compilation)
;;                                                               (goto-char (point-max))))))

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

(use-package ruby-mode
  :ensure t
  :mode "\\.rb\\'"
  :mode "Rakefile\\'"
  :mode "Gemfile\\'"
  :mode "Berksfile\\'"
  :mode "Vagrantfile\\'"
  :interpreter "ruby"

  :init
  (setq ruby-indent-level 2
        ruby-indent-tabs-mode nil)

  :config
  ;(setq lsp-ui-doc-enable nil)
  (add-hook 'ruby-mode 'superword-mode)
  ;; (add-hook 'rubocop-mode-hook
  ;;         (lambda ()
  ;;           (make-variable-buffer-local 'flycheck-command-wrapper-function)
  ;;           (setq flycheck-command-wrapper-function
  ;;                 (lambda (command)
  ;;                   (append '("bundle" "exec") command)))))
  :hook (ruby-mode . lsp)
  ; :hook (ruby-mode . rubocop-mode)
  :hook (ruby-mode . flycheck-mode)
  :bind
  (([(meta down)] . ruby-forward-sexp)
   ([(meta up)]   . ruby-backward-sexp)
   (("C-c C-e"    . ruby-send-region))))  ;; Rebind since Rubocop uses C-c C-r

(use-package ivy
  :config
  (ivy-mode 1)
  :bind*
  ("C-r" . ivy-resume))


(use-package lsp-java
  :init
  :config
  ;; Enable dap-java
  ;;(require 'dap-java)
  (add-hook 'java-mode-hook #'lsp))


  ;; Support Lombok in our projects, among other things
   (setq lsp-java-vmargs
         (list "-noverify"
               "-Xmx2G"
               "-XX:+UseG1GC"
               "-XX:+UseStringDeduplication"))
  ;;             (concat "-javaagent:" jmi/lombok-jar)
  ;;             (concat "-Xbootclasspath/a:" jmi/lombok-jar))
  ;;       lsp-file-watch-ignored
  ;;       '(".idea" ".ensime_cache" ".eunit" "node_modules"
  ;;         ".git" ".hg" ".fslckout" "_FOSSIL_"
  ;;         ".bzr" "_darcs" ".tox" ".svn" ".stack-work"
  ;;         "build")

  ;;       lsp-java-import-order '["" "java" "javax" "#"]
  ;;       ;; Don't organize imports on save
  ;;       lsp-java-save-action-organize-imports nil

  ;;       ;; Formatter profile
  ;;       lsp-java-format-settings-url
  ;;       (concat "file://" jmi/java-format-settings-file))

  ;; :hook (java-mode   . jmi/java-mode-config)

  :demand t


;; Set your themes here
(set 'darktheme 'sanityinc-tomorrow-night)
(set 'lightheme 'solarized-light)

(set 'thebeforestate "initial")

(run-with-timer 0 5 (lambda ()
         ;; Get's MacOS dark mode state
         (if (string= (shell-command-to-string "printf %s \"$( osascript -e \'tell application \"System Events\" to tell appearance preferences to return dark mode\' )\"") "true")
             (progn
         (set 'thenowstate t)
         )
           (set 'thenowstate nil)
           )

         ;; Verifies if Darkmode is changed since last checked
         (if (string= thenowstate thebeforestate)
             ;; If nothing is changed
             (progn

         )
           ;; If something is changed

           (if (string= thenowstate "t")
         (progn
           (load-theme darktheme t)
           (disable-theme lightheme)
           )
             (load-theme lightheme t)
             (disable-theme darktheme)
             )
           )
         (set 'thebeforestate thenowstate)
         ))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(ansi-color-names-vector
   (vector "#1d1f21" "#cc6666" "#b5bd68" "#f0c674" "#81a2be" "#b294bb" "#8abeb7" "#c5c8c6"))
 '(beacon-color "#cc6666")
 '(compilation-message-face 'default)
 '(cua-global-mark-cursor-color "#689d6a")
 '(cua-normal-cursor-color "#7c6f64")
 '(cua-overwrite-cursor-color "#b57614")
 '(cua-read-only-cursor-color "#98971a")
 '(custom-safe-themes
   '("e1d09f1b2afc2fed6feb1d672be5ec6ae61f84e058cb757689edb669be926896" "2809bcb77ad21312897b541134981282dc455ccd7c14d74cc333b6e549b824f3" "c433c87bd4b64b8ba9890e8ed64597ea0f8eb0396f4c9a9e01bd20a04d15d358" "830877f4aab227556548dc0a28bf395d0abe0e3a0ab95455731c9ea5ab5fe4e1" "285d1bf306091644fb49993341e0ad8bafe57130d9981b680c1dbd974475c5c7" "7f1d414afda803f3244c6fb4c2c64bea44dac040ed3731ec9d75275b9e831fe5" "0598c6a29e13e7112cfbc2f523e31927ab7dce56ebb2016b567e1eff6dc1fd4f" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" default))
 '(fci-rule-color "#373b41")
 '(flycheck-color-mode-line-face-to-color 'mode-line-buffer-id)
 '(frame-background-mode 'dark)
 '(highlight-changes-colors '("#d3869b" "#8f3f71"))
 '(highlight-symbol-colors
   (--map
    (solarized-color-blend it "#fbf1c7" 0.25)
    '("#b57614" "#689d6a" "#9d0006" "#8f3f71" "#98971a" "#af3a03" "#076678")))
 '(highlight-symbol-foreground-color "#665c54")
 '(highlight-tail-colors
   '(("#ebdbb2" . 0)
     ("#c6c148" . 20)
     ("#82cc73" . 30)
     ("#5b919b" . 50)
     ("#e29a3f" . 60)
     ("#df6835" . 70)
     ("#f598a7" . 85)
     ("#ebdbb2" . 100)))
 '(hl-bg-colors
   '("#e29a3f" "#df6835" "#cf5130" "#f598a7" "#c2608f" "#5b919b" "#82cc73" "#c6c148"))
 '(hl-fg-colors
   '("#fbf1c7" "#fbf1c7" "#fbf1c7" "#fbf1c7" "#fbf1c7" "#fbf1c7" "#fbf1c7" "#fbf1c7"))
 '(hl-paren-colors '("#689d6a" "#b57614" "#076678" "#8f3f71" "#98971a"))
 '(lsp-ui-doc-border "#586e75")
 '(nrepl-message-colors
   '("#9d0006" "#af3a03" "#b57614" "#747400" "#c6c148" "#004858" "#689d6a" "#d3869b" "#8f3f71"))
 '(package-selected-packages
   '(lsp-python-ms dap-mode lsp-javacomp lsp-java emojify company-emoji oer-reveal ox-reveal default-text-scale scss-mode rustic company-lsp smartparens gruvbox-theme wgrep yaml-mode company-racer racer yasnippet toml-mode lsp-ui yafolding web-mode use-package solarized-theme rust-auto-use rubocop rspec-mode rjsx-mode restclient prettier-js multiple-cursors move-text magit lua-mode jsx-mode inf-ruby flycheck-rust eyebrowse exec-path-from-shell duplicate-thing direnv crux counsel-projectile company color-theme-sanityinc-tomorrow cargo ag))
 '(pos-tip-background-color "#ebdbb2")
 '(pos-tip-foreground-color "#665c54")
 '(safe-local-variable-values
   '((eval if
           (string-match ".js$"
                         (buffer-file-name))
           (rjsx-mode))))
 '(smartrep-mode-line-active-bg (solarized-color-blend "#98971a" "#ebdbb2" 0.2))
 '(term-default-bg-color "#fbf1c7")
 '(term-default-fg-color "#7c6f64")
 '(vc-annotate-background nil)
 '(vc-annotate-background-mode nil)
 '(vc-annotate-color-map
   '((20 . "#cc6666")
     (40 . "#de935f")
     (60 . "#f0c674")
     (80 . "#b5bd68")
     (100 . "#8abeb7")
     (120 . "#81a2be")
     (140 . "#b294bb")
     (160 . "#cc6666")
     (180 . "#de935f")
     (200 . "#f0c674")
     (220 . "#b5bd68")
     (240 . "#8abeb7")
     (260 . "#81a2be")
     (280 . "#b294bb")
     (300 . "#cc6666")
     (320 . "#de935f")
     (340 . "#f0c674")
     (360 . "#b5bd68")))
 '(vc-annotate-very-old-color nil)
 '(weechat-color-list
   '(unspecified "#fbf1c7" "#ebdbb2" "#750000" "#9d0006" "#747400" "#98971a" "#8a5100" "#b57614" "#004858" "#076678" "#9f4d64" "#d3869b" "#2e7d33" "#689d6a" "#7c6f64" "#3c3836"))
 '(window-divider-mode nil)
 '(xterm-color-names
   ["#ebdbb2" "#9d0006" "#98971a" "#b57614" "#076678" "#d3869b" "#689d6a" "#32302f"])
 '(xterm-color-names-bright
   ["#fbf1c7" "#af3a03" "#a89984" "#3c3836" "#7c6f64" "#8f3f71" "#665c54" "#282828"]))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
