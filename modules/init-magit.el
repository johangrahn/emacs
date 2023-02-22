(use-package magit
  :config
  (global-set-key (kbd "C-x g") 'magit-status)
  (add-hook 'after-save-hook 'magit-after-save-refresh-status t))

(provide 'init-magit)
