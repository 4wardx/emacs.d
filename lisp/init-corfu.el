;;; init-corfu.el --- Interactive completion in buffers -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(setq tab-always-indent 'complete)

(when (require-package 'orderless)
  (with-eval-after-load 'vertico
    (require 'orderless)
    (setq completion-styles '(orderless basic))))
(setq completion-category-defaults nil
      completion-category-overrides nil)
(setq completion-cycle-threshold 4)

(when (require-package 'corfu)
  (setq-default corfu-auto t
                corfu-auto-prefix 2)
  (with-eval-after-load 'eshell
    (add-hook 'eshell-mode-hook (lambda () (setq-local corfu-auto nil))))
  (setq-default corfu-quit-no-match 'separator)
  (add-hook 'after-init-hook 'global-corfu-mode)

  (with-eval-after-load 'corfu
    (corfu-popupinfo-mode))

  ;; Make Corfu also work in terminals, without disturbing usual behaviour in GUI
  (when (require-package 'corfu-terminal)
    (with-eval-after-load 'corfu
      (corfu-terminal-mode))))

(provide 'init-corfu)
;;; init-corfu.el ends here
