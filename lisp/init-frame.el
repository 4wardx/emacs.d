;;; init-frame.el --- Top-level Emacs display element -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; More natural behavior
(add-hook 'tty-setup-hook 'xterm-mouse-mode)

;; Suppress GUI features
(setq inhibit-startup-screen t
      use-dialog-box nil
      use-file-dialog nil)

;;; Window size and features

(setq-default frame-resize-pixelwise t
              window-resize-pixelwise t)

(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'set-scroll-bar-mode)
  (set-scroll-bar-mode nil))

(menu-bar-mode -1)

(when (fboundp 'pixel-scroll-precision-mode)
  (pixel-scroll-precision-mode))

(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))

(defun sanityinc/display-buffer-full-frame (buffer alist)
  "If it's not visible, display buffer full-frame, saving the prior window config.
The saved config will be restored when the window is quit later.
BUFFER and ALIST are as for `display-buffer-full-frame'."
  (let ((initial-window-configuration (current-window-configuration)))
    (or (display-buffer-reuse-window buffer alist)
        (let ((full-window (display-buffer-full-frame buffer alist)))
          (prog1
              full-window
            (set-window-parameter full-window 'sanityinc/previous-config initial-window-configuration))))))

(defun sanityinc/maybe-restore-window-configuration (orig &optional kill window)
  (let* ((window  (or window (selected-window)))
         (to-restore (window-parameter window 'sanityinc/previous-config)))
    (set-window-parameter window 'sanityinc/previous-config nil)
    (funcall orig kill window)
    (when to-restore
      (set-window-configuration to-restore))))
(advice-add 'quit-window :around 'sanityinc/maybe-restore-window-configuration)

(defmacro sanityinc/fullframe-mode (mode)
  "Configure buffers that open in MODE to display in full-frame."
  `(add-to-list 'display-buffer-alist
                (cons (cons 'major-mode ,mode)
                      (list 'sanityinc/display-buffer-full-frame))))

(sanityinc/fullframe-mode 'package-menu-mode)

;; Like diminish, but for major modes
(defun sanityinc/set-major-mode-name (name)
  "Override the major mode NAME in this buffer."
  (setq-local mode-name name))

(defun sanityinc/major-mode-lighter (mode name)
  (add-hook (derived-mode-hook-name mode)
            (apply-partially 'sanityinc/set-major-mode-name name)))

;;; Third-Party packages

(maybe-require-package 'disable-mouse)

(when (maybe-require-package 'default-text-scale)
  (add-hook 'after-init-hook 'default-text-scale-mode))

(provide 'init-frame)
;;; init-frame.el ends here
