;;; init-window.el --- Working with windows within a frame -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; Navigate window layouts with "C-c <left>" and "C-c <right>"
(add-hook 'after-init-hook 'winner-mode)

;; {{ scroll
(setq fast-but-imprecise-scrolling t)

(setq auto-window-vscroll nil
      scroll-conservatively 100000
      scroll-margin 0
      scroll-preserve-screen-position t
      scroll-step 1)

(when (fboundp 'pixel-scroll-precision-mode)
  (pixel-scroll-precision-mode))
;; }}

;; {{
;; When splitting window, show (other-buffer) in the new window
(defun split-window-func-with-other-buffer (split-function)
  (lambda (&optional arg)
    "Split this window and switch to the new window unless ARG is provided."
    (interactive "P")
    (funcall split-function)
    (let ((target-window (next-window)))
      (set-window-buffer target-window (other-buffer))
      (unless arg
        (select-window target-window)))))
(global-set-key (kbd "C-x 2") (split-window-func-with-other-buffer 'split-window-vertically))
(global-set-key (kbd "C-x 3") (split-window-func-with-other-buffer 'split-window-horizontally))

(defun my-toggle-delete-other-windows ()
  "Delete other windows in frame if any, or restore previous window config."
  (interactive)
  (if (and winner-mode
           (equal (selected-window) (next-window)))
      (winner-undo)
    (delete-other-windows)))
(global-set-key (kbd "C-x 1") 'my-toggle-delete-other-windows)
;; }}

;;; {{
(when (require-package 'switch-window)
  (setq-default switch-window-shortcut-style 'qwerty
                switch-window-timeout nil)
  (global-set-key (kbd "C-x o") 'switch-window))

(require-package 'disable-mouse)

(when (require-package 'default-text-scale)
  (add-hook 'after-init-hook 'default-text-scale-mode))
;;; }}

(provide 'init-window)
;;; init-window.el ends here
