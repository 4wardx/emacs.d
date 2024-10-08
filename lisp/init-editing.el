;;; init-editing.el --- Day-to-day editing helpers -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;;; Some basic preferences

(setq-default auto-save-default nil
              case-fold-search t
              column-number-mode t
              create-lockfiles nil
              ediff-split-window-function 'split-window-horizontally
              ediff-window-setup-function 'ediff-setup-windows-plain
              indent-tabs-mode nil
              indicate-buffer-boundaries 'left
              make-backup-files nil
              mouse-yank-at-point t
              save-interprogram-paste-before-kill t
              scroll-preserve-screen-position 'always
              set-mark-command-repeat-pop t
              truncate-lines nil
              truncate-partial-width-windows nil
              use-short-answers t)

;; Don't disable narrowing commands
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'narrow-to-defun 'disabled nil)

;; Don't disable case-change functions
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

(add-hook 'after-init-hook 'delete-selection-mode)
(add-hook 'after-init-hook 'electric-indent-mode)
(add-hook 'after-init-hook 'electric-pair-mode)
(add-hook 'after-init-hook 'global-eldoc-mode)
(add-hook 'after-init-hook 'repeat-mode)
(add-hook 'after-init-hook 'show-paren-mode)
(add-hook 'after-init-hook 'so-long-enable)
(add-hook 'after-init-hook 'transient-mark-mode)

(setq-default display-fill-column-indicator-character ?┊)
(add-hook 'prog-mode-hook 'display-fill-column-indicator-mode)

(setq-default display-line-numbers-width 3)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

(setq auto-revert-verbose nil
      global-auto-revert-non-file-buffers t)
(add-hook 'after-init-hook 'global-auto-revert-mode)

(with-eval-after-load 'autorevert
  (diminish 'auto-revert-mode))

;;; Handle trailing whitespace

(setq-default show-trailing-whitespace nil)

(global-set-key [remap just-one-space] 'cycle-spacing)

(defun sanityinc/show-trailing-whitespace ()
  "Enable display of trailing whitespace in this buffer."
  (setq-local show-trailing-whitespace t))

(dolist (hook '(prog-mode-hook text-mode-hook conf-mode-hook))
  (add-hook hook 'sanityinc/show-trailing-whitespace))

;;; Handy key bindings

;; Zap *up* to char is a handy pair for zap-to-char
(global-set-key (kbd "M-Z") 'zap-up-to-char)

;; M-^ is inconvenient, so also bind M-j
(global-set-key (kbd "M-j") 'join-line)

(global-set-key (kbd "C-.") 'set-mark-command)
(global-set-key (kbd "C-x C-.") 'pop-global-mark)

(defun kill-back-to-indentation ()
  "Kill from point back to the first non-whitespace character on the line."
  (interactive)
  (let ((prev-pos (point)))
    (back-to-indentation)
    (kill-region (point) prev-pos)))
(global-set-key (kbd "C-M-<backspace>") 'kill-back-to-indentation)

(defun sanityinc/newline-at-end-of-line ()
  "Move to end of line, enter a newline, and reindent."
  (interactive)
  (move-end-of-line 1)
  (newline-and-indent))
(global-set-key (kbd "S-<return>") 'sanityinc/newline-at-end-of-line)

;;; Third-Party packages

(require-package 'whitespace-cleanup-mode)
(add-hook 'after-init-hook 'global-whitespace-cleanup-mode)
(with-eval-after-load 'whitespace-cleanup-mode
  (diminish 'whitespace-cleanup-mode))

(require-package 'which-key)
(setq-default which-key-idle-delay 1.5)
(add-hook 'after-init-hook 'which-key-mode)
(with-eval-after-load 'which-key
  (diminish 'which-key-mode))

(when (maybe-require-package 'avy)
  (global-set-key (kbd "C-;") 'avy-goto-char-timer))

;; A simple visible bell which works in all terminal types
(when (maybe-require-package 'mode-line-bell)
  (add-hook 'after-init-hook 'mode-line-bell-mode))

(when (maybe-require-package 'browse-kill-ring)
  (setq browse-kill-ring-separator "\f")
  (global-set-key (kbd "M-Y") 'browse-kill-ring)
  (with-eval-after-load 'browse-kill-ring
    (define-key browse-kill-ring-mode-map (kbd "C-g") 'browse-kill-ring-quit)
    (define-key browse-kill-ring-mode-map (kbd "M-n") 'browse-kill-ring-forward)
    (define-key browse-kill-ring-mode-map (kbd "M-p") 'browse-kill-ring-previous))
  (with-eval-after-load 'page-break-lines
    (add-to-list 'page-break-lines-modes 'browse-kill-ring-mode)))

(when (require-package 'rainbow-delimiters)
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(when (maybe-require-package 'symbol-overlay)
  (dolist (hook '(prog-mode-hook html-mode-hook yaml-mode-hook conf-mode-hook))
    (add-hook hook 'symbol-overlay-mode))
  (with-eval-after-load 'symbol-overlay
    (diminish 'symbol-overlay-mode)
    (define-key symbol-overlay-mode-map (kbd "M-i") 'symbol-overlay-put)
    (define-key symbol-overlay-mode-map (kbd "M-I") 'symbol-overlay-remove-all)
    (define-key symbol-overlay-mode-map (kbd "M-n") 'symbol-overlay-jump-next)
    (define-key symbol-overlay-mode-map (kbd "M-p") 'symbol-overlay-jump-prev)))

;; Page break lines
(when (maybe-require-package 'page-break-lines)
  (add-hook 'after-init-hook 'global-page-break-lines-mode)
  (with-eval-after-load 'page-break-lines
    (diminish 'page-break-lines-mode)))

;; Shift lines up and down with M-up and M-down. When paredit is enabled,
;; it will use those keybindings. For this reason, you might prefer to
;; use M-S-up and M-S-down, which will work even in lisp modes.
(when (maybe-require-package 'move-dup)
  (global-set-key [M-S-up] 'move-dup-move-lines-up)
  (global-set-key [M-S-down] 'move-dup-move-lines-down)
  (global-set-key (kbd "C-c d") 'move-dup-duplicate-down)
  (global-set-key (kbd "C-c u") 'move-dup-duplicate-up))

(provide 'init-editing)
;;; init-editing.el ends here
