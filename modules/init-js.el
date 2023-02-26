(use-package js2-mode
  :mode "\\.js\\'"
  :custom
  (js-indent-level 2)
  (js2-basic-offset 2)
  :config
  (setq js2-indent-level 2)
  (setq js2-basic-offset 2)
  (setq js2-ignored-warnings '("msg.extra.trailing.comma")))

(provide 'init-js)
