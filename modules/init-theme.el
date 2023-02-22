(use-package github-theme
  :ensure t
  :config
  (setq custom-safe-themes t)
  (load-theme 'github t))

(use-package github-dark-vscode-theme
  :ensure t
  :config
  (setq custom-safe-themes t))

(use-package noctilux-theme
	:config
  (setq custom-safe-themes t))

(defun my/apply-theme (appearance)
  "Load theme, taking current system APPEARANCE into consideration."
  (mapc #'disable-theme custom-enabled-themes)
  (pcase appearance
    ('light (load-theme 'github t))
    ('dark (load-theme 'noctilux t))))

(add-hook 'ns-system-appearance-change-functions #'my/apply-theme)

(provide 'init-theme)