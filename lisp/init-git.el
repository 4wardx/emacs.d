;;; init-git.el --- Git SCM support -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; TODO: link commits from vc-log to magit-show-commit
;; TODO: smerge-mode
(require-package 'git-modes)

(when (require-package 'git-timemachine)
  (global-set-key (kbd "C-x v t") 'git-timemachine-toggle))

(require-package 'git-link)
(require-package 'magit-todos)

(when (require-package 'magit)
  (setq-default magit-diff-refine-hunk 'all)

  ;; Hint: customize `magit-repository-directories' so that you can use C-u M-F12 to
  ;; quickly open magit on any one of your projects.
  (global-set-key [(meta f12)] 'magit-status)
  (global-set-key (kbd "C-x g") 'magit-status)
  (global-set-key (kbd "C-x M-g") 'magit-dispatch)

  (defun my-magit-or-vc-log-file (&optional prompt)
    (interactive "P")
    (if (and (buffer-file-name)
             (eq 'Git (vc-backend (buffer-file-name))))
        (if prompt
            (magit-log-buffer-file-popup)
          (magit-log-buffer-file t))
      (vc-print-log)))

  (with-eval-after-load 'vc
    (define-key vc-prefix-map (kbd "l") 'my-magit-or-vc-log-file)))

(with-eval-after-load 'magit
  (define-key magit-status-mode-map (kbd "C-M-<up>") 'magit-section-up))

(add-hook 'git-commit-mode-hook 'goto-address-mode)

(provide 'init-git)
;;; init-git.el ends here
