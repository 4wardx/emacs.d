;;; init.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;; This file bootstraps the configuration, which is divided into
;; a number of other files.

;;; Code:

;; Produce backtraces when errors occur: can be helpful to diagnose startup issues
;;(setq debug-on-error t)

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; Adjust garbage collection threshold for early startup (see use of gcmh below)
(setq gc-cons-threshold (* 128 1024 1024))

;; Process performance tuning
(setq read-process-output-max (* 4 1024 1024))
(setq process-adaptive-read-buffering nil)

;; Don't mess up `user-init-file'
(setq custom-file (locate-user-emacs-file "custom.el"))

;;; Bootstrap configs

(require 'init-elpa)
(require 'init-frame)
(require 'init-window)
(require 'init-session)

;; General performance tuning
(when (require-package 'gcmh)
  (setq gcmh-high-cons-threshold (* 128 1024 1024))
  (add-hook 'after-init-hook (lambda ()
                               (gcmh-mode)
                               (diminish 'gcmh-mode))))

(setq jit-lock-defer-time 0)

;; Load configs for specific features and modes
(require-package 'diminish)

(require 'init-editing)
(require 'init-hippie-expand)
(require 'init-rime)

(require 'init-dired)
(require 'init-grep)
(require 'init-isearch)
(require 'init-ibuffer)

(require 'init-minibuffer)
(require 'init-corfu)

(require 'init-vc)
(require 'init-git)
(require 'init-compile)
(require 'init-flycheck)
(require 'init-projectile)

(require 'init-markdown)
(require 'init-org)

(require 'init-paredit)
(require 'init-lisp)
(require 'init-scheme)

(require 'init-rust)
(require 'init-zig)
(require 'init-python)
(require 'init-javascript)

(when (and (require 'treesit nil t)
           (fboundp 'treesit-available-p)
           (treesit-available-p))
  (require 'init-treesitter))

;; Variables configured via the interactive `customize' interface
(when (file-exists-p custom-file)
  (load custom-file))

;; Locales (setting them earlier in this file doesn't work in X)
(require 'init-locales)

;; Allow access from emacsclient
(add-hook 'after-init-hook
          (lambda ()
            (require 'server)
            (unless (server-running-p)
              (server-start))))

(provide 'init)

;; Local Variables:
;; coding: utf-8
;; no-byte-compile: t
;; End:

;;; init.el ends here
