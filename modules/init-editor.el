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

  (set-frame-font "Office Code Pro D Light 15")
)

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

(provide 'init-editor)
