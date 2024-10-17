;;; init-lisp.el --- common config for lisps -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(setq-default debugger-bury-or-kill 'kill)

;; {{
(defun my-headerise-elisp ()
  "Add minimal header and footer to an elisp buffer in order to placate flycheck."
  (interactive)
  (let ((fname (if (buffer-file-name)
                   (file-name-nondirectory (buffer-file-name))
                 (error "This buffer is not visiting a file"))))
    (save-excursion
      (goto-char (point-min))
      (insert ";;; " fname " --- Insert description here -*- lexical-binding: t -*-\n"
              ";;; Commentary:\n"
              ";;; Code:\n\n")
      (goto-char (point-max))
      (insert ";;; " fname " ends here\n"))))
;; }}

;; {{ eval
(defun my-eval-last-sexp-or-region (prefix)
  "Eval region from BEG to END if active, otherwise the last sexp."
  (interactive "P")
  (if (and (mark) (use-region-p))
      (eval-region (min (point) (mark)) (max (point) (mark)))
    (pp-eval-last-sexp prefix)))
(global-set-key [remap eval-expression] 'pp-eval-expression)

(with-eval-after-load 'lisp-mode
  (define-key emacs-lisp-mode-map (kbd "C-x C-e") 'my-eval-last-sexp-or-region)
  (define-key emacs-lisp-mode-map (kbd "C-c C-e") 'pp-eval-expression))

(defun my-make-read-only (_expression out-buffer-name &rest _)
  "Enable `view-mode' in the output buffer - if any - so it can be closed with `\"q\"."
  (when (get-buffer out-buffer-name)
    (with-current-buffer out-buffer-name
      (view-mode 1))))
(advice-add 'pp-display-expression :after 'my-make-read-only)

(when (boundp 'eval-expression-minibuffer-setup-hook)
  (add-hook 'eval-expression-minibuffer-setup-hook #'eldoc-mode))
;; }}

;;; Enable desired features for all lisp modes
;;; {{
(require-package 'paredit)

(with-eval-after-load 'paredit
  (diminish 'paredit-mode " Par")

  ;; Suppress certain paredit keybindings to avoid clashes, including
  ;; my global binding of M-?
  (dolist (binding '("RET" "C-<left>" "C-<right>" "C-M-<left>" "C-M-<right>" "M-s" "M-?"))
    (define-key paredit-mode-map (read-kbd-macro binding) nil)))

(defun my-enable-check-parens-on-save ()
  "Run `check-parens' when the current buffer is saved."
  (add-hook 'after-save-hook #'check-parens nil t))

(defvar my-lispy-mode-hook
  '(enable-paredit-mode
    my-enable-check-parens-on-save)
  "Hook run in all Lisp modes.")

(defun my-lisp-setup ()
  "Enable features useful in any Lisp mode."
  (run-hooks 'my-lispy-mode-hook))

(let* ((hooks '(lisp-mode-hook
                inferior-lisp-mode-hook)))
  (dolist (hook hooks)
    (add-hook hook 'my-lisp-setup)))

(defun my-elisp-mode-hook-setup ()
  (my-lisp-setup)
  (checkdoc-minor-mode 1)

  ;; Locally set `hippie-expand' completion functions for use with Emacs Lisp.
  (make-local-variable 'hippie-expand-try-functions-list)
  (push 'try-complete-lisp-symbol hippie-expand-try-functions-list)
  (push 'try-complete-lisp-symbol-partially hippie-expand-try-functions-list))

(add-hook 'emacs-lisp-mode-hook 'my-elisp-mode-hook-setup)
;;; }}

;;; {{
(when (require-package 'macrostep)
  (with-eval-after-load 'lisp-mode
    (define-key emacs-lisp-mode-map (kbd "C-c x") 'macrostep-expand)))

(when (require-package 'aggressive-indent)
  (add-to-list 'my-lispy-mode-hook 'aggressive-indent-mode))

(when (require-package 'elisp-slime-nav)
  (dolist (hook '(emacs-lisp-mode-hook ielm-mode-hook))
    (add-hook hook 'turn-on-elisp-slime-nav-mode)))

(when (require-package 'immortal-scratch)
  (add-hook 'after-init-hook 'immortal-scratch-mode))
;;; }}

(provide 'init-lisp)
;;; init-lisp.el ends here
