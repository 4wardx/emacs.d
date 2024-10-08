;;; init-session.el --- Save and restore editor sessions between restarts -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(setq-default recentf-max-saved-items 1000
              recentf-exclude `("/tmp/" "/ssh:" ,(concat package-user-dir "/.*-autoloads\\.el\\'")))
(add-hook 'after-init-hook 'recentf-mode)

;; Restore histories and registers after saving
(setq-default history-length 1000)
(add-hook 'after-init-hook 'savehist-mode)

;; Save a list of open files in ~/.emacs.d/.emacs.desktop
(setq desktop-auto-save-timeout 600
      desktop-path (list user-emacs-directory)
      desktop-globals-to-save
      '((comint-input-ring        . 50)
        (compile-history          . 30)
        desktop-missing-file-warning
        (dired-regexp-history     . 20)
        (extended-command-history . 30)
        (face-name-history        . 20)
        (file-name-history        . 100)
        (grep-find-history        . 30)
        (grep-history             . 30)
        (ivy-history              . 100)
        (magit-revision-history   . 50)
        (minibuffer-history       . 50)
        (org-clock-history        . 50)
        (org-refile-history       . 50)
        (org-tags-history         . 50)
        (query-replace-history    . 60)
        (read-expression-history  . 60)
        (regexp-history           . 60)
        (regexp-search-ring       . 20)
        register-alist
        (search-ring              . 20)
        (shell-command-history    . 50)
        tags-file-name
        tags-table-list))

(desktop-save-mode 1)

;;; Third-Party packages

;; Save variables, registers and buffer places
(require-package 'session)
(setq session-save-file (locate-user-emacs-file ".session")
      session-name-disable-regexp "\\(?:\\`'/tmp\\|\\.git/[A-Z_]+\\'\\)"
      session-save-file-coding-system 'utf-8)
(add-hook 'after-init-hook 'session-initialize)

(provide 'init-session)
;;; init-session.el ends here
