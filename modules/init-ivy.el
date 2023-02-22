(use-package counsel
  :after ivy
  :ensure t
  :config (counsel-mode))

(use-package flx
  :ensure t)

(use-package ivy
  :diminish
  :ensure t
  :bind
     ("C-M-s" . counsel-ag)
  :config
  (setq ivy-re-builders-alist
        '((t . ivy--regex-fuzzy)))
  (setq ivy-use-selectable-prompt t)  
  (ivy-mode))

(use-package swiper
  :ensure t
  :after ivy
  :bind ("C-s" . swiper))

(provide 'init-ivy)
