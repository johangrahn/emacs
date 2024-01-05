(use-package eglot
  :ensure t
  :commands eglot
  :bind (:map eglot-mode-map
              ("C-c C-d" . eldoc)
              ("C-c C-e" . eglot-rename)
              ("C-c C-f" . eglot-format-buffer))
  :hook  
  (elixir-mode . eglot-ensure)
  (before-save . eglot-format-buffer)
  (js-mode . eglot-ensure)
  (javascript-mode . eglot-ensure)
  (js-ts-mode . eglot-ensure)
  (eglot-managed-mode . me/flymake-eslint-enable-maybe)

  :config
  (setq js-indent-level 2)

  (add-hook 'eglot-managed-mode-hook
            (lambda ()
              ;; Show flymake diagnostics first.
              (setq eldoc-documentation-functions
                    (cons #'flymake-eldoc-function
                          (remove #'flymake-eldoc-function eldoc-documentation-functions)))
              ;; Show all eldoc feedback.
  ;;            (setq eldoc-documentation-strategy #'eldoc-documentation-compose)))
  )))

(use-package sideline-flymake
    :custom
    (sideline-flymake-display-mode 'line))

(use-package sideline
  :init
  (setq sideline-backends-right '(sideline-flymake))
  (global-sideline-mode))


(add-to-list 'auto-mode-alist '("\\.js\\'" . js-ts-mode))

(use-package flymake
  :ensure nil
  :custom
  (flymake-fringe-indicator-position nil))

(use-package flymake-eslint
  :functions flymake-eslint-enable
  :preface
  (defun me/flymake-eslint-enable-maybe ()
    "Enable `flymake-eslint' based on the project configuration.
Search for the project ESLint configuration to determine whether the buffer
should be checked."
    (when-let* ((root (locate-dominating-file (buffer-file-name) "package.json"))
                (rc (locate-file ".eslintrc" (list root) '(".js" ".json"))))
      (make-local-variable 'exec-path)
      (push (file-name-concat root "node_modules" ".bin") exec-path)
      (flymake-eslint-enable))))


;; (use-package flycheck-eglot
;;   :ensure t
;;   :after (flycheck eglot)
;;   :config
;;   (global-flycheck-eglot-mode 1))

(provide 'init-eglot)
