(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
	:hook (
				 (js-mode . lsp-deferred)
				 (js-mode . lsp-save-hooks))
  :config
  (setq read-process-output-max (* 1024 1024)) ;; 1mb
  :custom
  (typescript-indent-level 2)
  (lsp-file-watch-threshold 10000)
  (lsp-headerline-breadcrumb-enable nil)
  (lsp-lens-enable t)
  (lsp-idle-delay 0.3)
  (lsp-rust-analyzer-server-display-inlay-hints t)
	(lsp-rust-analyzer-cargo-auto-reload t)
  (lsp-enable-which-key-integration t)
	(lsp-eldoc-enable-hover t)
	(lsp-modeline-diagnostics-enable nil)
	(lsp-ui-sideline-enable t)
  (tab-width 2)
  (lsp-restart 'auto-restart))

(defun lsp-save-hooks ()
	(add-hook 'before-save-hook #'lsp-format-buffer t t))

(use-package lsp-ui
  :ensure
  :commands lsp-ui-mode
	:bind (:map lsp-ui-mode-map
         ([remap xref-find-definitions] . lsp-ui-peek-find-definitions)
         ([remap xref-find-references] . lsp-ui-peek-find-references))
  :custom
  ;;(lsp-ui-peek-always-show nil)
	(lsp-ui-peek-enable t)
  (lsp-ui-sideline-show-hover nil)
  (lsp-ui-doc-enable nil)
	(lsp-ui-sideline-show-code-actions t)
	(lsp-ui-sideline-show-diagnostics nil))

(use-package flycheck
	:ensure t)


(provide 'init-lsp)
