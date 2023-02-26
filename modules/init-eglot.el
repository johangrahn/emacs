(use-package eglot 
  :commands eglot
  :hook  
  (elixir-mode . eglot-ensure)
  (before-save . eglot-format-buffer)
  (js2-mode . eglot-ensure)
  :config
  (setq js-indent-level 2)
  (setq js2-basic-offset 2))

(provide 'init-eglot)
