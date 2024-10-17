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
;; {{
(setq read-process-output-max (* 4 1024 1024))
(setq process-adaptive-read-buffering nil)
;; }}

;; Don't mess up `user-init-file'
(setq custom-file (locate-user-emacs-file "custom.el"))

;; {{
(defun my-add-subdirs-to-load-path (lisp-dir)
  "Add sub-directories under LISP-DIR into `load-path'."
  (let* ((default-directory lisp-dir))
    (setq load-path
          (append
           (delq nil
                 (mapcar (lambda (dir)
                           (unless (string-match "^\\." dir)
                             (expand-file-name dir)))
                         (directory-files lisp-dir)))
           load-path))))

(my-add-subdirs-to-load-path (expand-file-name "site-lisp" user-emacs-directory))
;; }}

;;; Bootstrap configs
;;; {{
(require 'init-elpa)
(require 'init-essential)
(require 'init-window)

(require 'init-misc)
(require 'init-dired)

(require 'init-minibuffer)
(require 'init-corfu)

(require 'init-vc)
(require 'init-git)

(require 'init-lisp)
(require 'init-markdown)
(require 'init-org)

(require 'init-python)
(require 'init-javascript)

(when (and (require 'treesit nil t)
           (fboundp 'treesit-available-p)
           (treesit-available-p))
  (require 'init-treesitter))
;;; }}

;; Variables configured via the interactive `customize' interface
(when (file-exists-p custom-file)
  (load custom-file))

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
