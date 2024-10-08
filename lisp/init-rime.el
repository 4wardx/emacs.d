;;; init-rime.el --- Rime Input Method for Emacs -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(when (maybe-require-package 'rime)
  (setq default-input-method "rime")

  (setq rime-user-data-dir "~/.config/fcitx/rime/"
        rime-inline-predicates '(rime-predicate-space-after-cc-p))

  (with-eval-after-load 'rime
    (define-key rime-mode-map (kbd "C-`") 'rime-send-keybinding)
    (define-key rime-active-mode-map (kbd "TAB") 'rime-inline-ascii)

    (add-hook 'kill-emacs-hook
              (lambda () (ignore-errors (rime-lib-finalize))))))

(provide 'init-rime)
;;; init-rime.el ends here
