;;; init-locales.el --- Configure default locale -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(set-charset-priority 'unicode)
(setq locale-coding-system 'utf-8)

(prefer-coding-system 'utf-8)
(unless (eq system-type 'windows-nt)
  (set-selection-coding-system 'utf-8))

(provide 'init-locales)
;;; init-locales.el ends here
