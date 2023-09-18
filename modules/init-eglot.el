(use-package eglot 
  :commands eglot
  :hook  
  (elixir-mode . eglot-ensure)
  (before-save . eglot-format-buffer)
  (js2-mode . eglot-ensure)
  (js-ts-mode . eglot-ensure)
  :config
  (setq js-indent-level 2)
  (setq js2-basic-offset 2))
(add-to-list 'auto-mode-alist '("\\.js\\'" . js-ts-mode))

(provide 'init-eglot)
