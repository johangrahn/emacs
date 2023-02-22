(use-package ripgrep
  :ensure t)

(use-package projectile
  :ensure t

  :bind
  (("C-x f" . projectile-find-file)
  ("C-x s" . projectile-switch-open-project)
  ;;  ("C-x r" . projectile-ripgrep)
  ("C-x r" . counsel-projectile-rg)
  ("C-x p" . projectile-switch-project))
  :config
  (projectile-global-mode)
  (setq projectile-remember-window-configs t))

(use-package counsel-projectile
  :ensure t)
(provide 'init-projectile)
