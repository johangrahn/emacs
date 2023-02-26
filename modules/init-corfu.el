(use-package corfu
  :init (global-corfu-mode)
  :config
  (setq corfu-cycle t)
  (setq corfu-auto t)
  (setq corfu-auto-delay 0.1)
  :bind
  (:map corfu-map
        ("TAB" . corfu-next)
        ([tab] . corfu-next)
        ("S-TAB" . corfu-previous)
        ([backtab] . corfu-previous))
  :custom
   ;; (corfu-min-width 80)
  ;; (corfu-max-width corfu-min-width)     ; Always have the same width
  (corfu-count 14)
  (corfu-scroll-margin 4)
  (corfu-cycle nil)

      ;; (corfu-echo-documentation nil)        ; Already use corfu-doc
  (corfu-separator ?\s)                 ; Necessary for use with orderless
  (corfu-quit-no-match 'separator)

  (corfu-preview-current 'insert)       ; Preview current candidate?
  (corfu-preselect-first t)             ; Preselect first candidate?
)

(defun corfu-move-to-minibuffer ()
    "Move \"popup\" completion candidates to minibuffer.

  Useful if you want a more robust view into the recommend candidates."
    (interactive)
    (let (completion-cycle-threshold completion-cycling)
      (apply #'consult-completion-in-region completion-in-region--data)))
(define-key corfu-map "\M-m" #'corfu-move-to-minibuffer)

(use-package kind-icon
    :after corfu
    :custom
    (kind-icon-use-icons t)
    (kind-icon-default-face 'corfu-default) ; Have background color be the same as `corfu' face background
    (kind-icon-blend-background nil)  ; Use midpoint color between foreground and background colors ("blended")?
    (kind-icon-blend-frac 0.08)

    ;; NOTE 2022-02-05: `kind-icon' depends `svg-lib' which creates a cache
    ;; directory that defaults to the `user-emacs-directory'. Here, I change that
    ;; directory to a location appropriate to `no-littering' conventions, a
    ;; package which moves directories of other packages to sane locations.
    ;; (svg-lib-icons-dir (no-littering-expand-var-file-name "svg-lib/cache/")) ; Change cache dir
    :config
    (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter) ; Enable `kind-icon'

    ;; Add hook to reset cache so the icon colors match my theme
    ;; NOTE 2022-02-05: This is a hook which resets the cache whenever I switch
    ;; the theme using my custom defined command for switching themes. If I don't
    ;; do this, then the backgound color will remain the same, meaning it will not
    ;; match the background color corresponding to the current theme. Important
    ;; since I have a light theme and dark theme I switch between. This has no
    ;; function unless you use something similar
    (add-hook 'kb/themes-hooks #'(lambda () (interactive) (kind-icon-reset-cache))))
(provide 'init-corfu)
