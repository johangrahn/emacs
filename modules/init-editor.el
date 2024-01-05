(when (memq window-system '(mac ns x))
  (use-package exec-path-from-shell
    :ensure t)
  (exec-path-from-shell-initialize)

  (setq ns-right-alternate-modifier nil)
  (setq mac-option-key-is-meta nil)
  (setq mac-command-key-is-meta t)
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier nil)

  (setq frame-resize-pixelwise t)
  (add-to-list 'default-frame-alist '(ns-appearance . dark))
  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))

  (set-frame-font "Hack 13")
  ;; (set-frame-font "Monaspace Neon 13")
  ;; (set-frame-font "Roboto 13")
  ;; (set-frame-font "Inconsolata 15")
  ;; (set-face-attribute 'default nil :height 140)
  ;; (set-face-attribute 'default nil :font "Inconsolata-14")
  (prettify-symbols-mode t)
	(setq split-height-threshold nil) ;; prefer splitting vertically
	(setq split-width-threshold 0))

(use-package move-text
   :ensure t
   :bind
   ("M-n" . move-text-down)
   ("M-p" . move-text-up)
   :config
   (move-text-default-bindings))

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package expand-region
  :ensure t
  :bind ("C-=" . er/expand-region))


(use-package yasnippet
  :diminish yas-minor-mode
  :hook (prog-mode . yas-minor-mode)
  :config
  (yas-reload-all))

(use-package smartparens
  :ensure t
  :config
  (smartparens-global-mode))

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

(use-package multiple-cursors
  :bind
  ("C->" . 'mc/mark-next-like-this)
  ("C-<" . 'mc/mark-previous-like-this)
  ("C-c C-<" . 'mc/mark-all-like-this))

(use-package yafolding
  :ensure t
  :hook (
         (js-mode . yafolding-mode)
         (js2-mode . yafolding-mode)
         (rustic-mode . yafolding-mode)
         (rust-mode . yafolding-mode)))

(setq-default indent-level 2)
(setq-default js-indent-level 2)	      
(setq-default indent-tabs-mode nil)

(defun duplicate-line()
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (open-line 1)
  (next-line 1)
  (yank)
)
(global-set-key (kbd "C-c d") 'duplicate-line)

(provide 'init-editor)
