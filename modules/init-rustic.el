(use-package rustic
  :ensure t
  :config
  (setq rustic-lsp-client 'eglot)
  (setq eglot-inlay-hints-mode nil))
(provide 'init-rustic)
