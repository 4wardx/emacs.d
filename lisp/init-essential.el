;;; init-essential.el --- Essential for Emacs -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(setq-default initial-scratch-message
              (concat ";; Happy hacking, " user-login-name " - Emacs ♥ you!\n\n"))

(setq use-short-answers t)

;; Load .el if newer than corresponding .elc
(setq load-prefer-newer t)

;; {{ locale
(when (fboundp 'set-charset-priority)
  (set-charset-priority 'unicode))
(prefer-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)
(unless (eq system-type 'windows-nt)
  (set-selection-coding-system 'utf-8))
;; }}

;;; Top-level display
;;; {{
;; Inhibit resizing frame
(setq frame-inhibit-implied-resize t
      frame-resize-pixelwise t)

;; More natural behavior
(add-hook 'tty-setup-hook 'xterm-mouse-mode)

;; Suppress GUI features
(setq use-file-dialog nil)
(setq use-dialog-box nil)

;; window size and features
(setq-default frame-resize-pixelwise t
              window-resize-pixelwise t)

(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'set-scroll-bar-mode)
  (set-scroll-bar-mode nil))

(menu-bar-mode -1)

(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))
;;; }}

;; Like diminish, but for major modes
;; {{
(defun my-set-major-mode-name (name)
  "Override the major mode NAME in this buffer."
  (setq-local mode-name name))

(defun my-major-mode-lighter (mode name)
  (add-hook (derived-mode-hook-name mode)
            (apply-partially 'my-set-major-mode-name name)))
;; }}

;; General performance tuning
;; {{
(setq jit-lock-defer-time 0)

(when (require-package 'gcmh)
  (setq gcmh-high-cons-threshold (* 128 1024 1024))
  (add-hook 'after-init-hook (lambda ()
                               (gcmh-mode)
                               (diminish 'gcmh-mode))))
;; }}

;; Ensure following packages are installed
;; {{
(require-package 'diminish)
(require-package 'lsp-mode)
;; }}

(provide 'init-essential)
;;; init-essential.el ends here
