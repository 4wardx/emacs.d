;;; init-paredit.el --- Configure paredit structured editing -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(require-package 'paredit)

(defun sanityinc/maybe-map-paredit-newline ()
  (unless (or (derived-mode-p 'inferior-emacs-lisp-mode 'cider-repl-mode)
              (minibufferp))
    (local-set-key (kbd "RET") 'paredit-newline)))
(add-hook 'paredit-mode-hook 'sanityinc/maybe-map-paredit-newline)

(with-eval-after-load 'paredit
  (diminish 'paredit-mode " Par")
  ;; Suppress certain paredit keybindings to avoid clashes, including
  ;; my global binding of M-?
  (dolist (binding '("RET" "C-<left>" "C-<right>" "C-M-<left>" "C-M-<right>" "M-s" "M-?"))
    (define-key paredit-mode-map (read-kbd-macro binding) nil))
  (define-key paredit-mode-map (kbd "M-<up>") 'paredit-splice-sexp-killing-backward))

(add-hook 'sanityinc/lispy-modes-hook 'enable-paredit-mode)

(when (maybe-require-package 'puni)
  ;;(add-hook 'prog-mode-hook 'puni-mode)
  (add-hook 'sanityinc/lispy-modes-hook (lambda () (puni-mode -1)))
  (with-eval-after-load 'puni
    (define-key puni-mode-map (kbd "M-(") 'puni-wrap-round)
    (define-key puni-mode-map (kbd "C-(") 'puni-slurp-backward)
    (define-key puni-mode-map (kbd "C-)") 'puni-slurp-forward)
    (define-key puni-mode-map (kbd "C-}") 'puni-barf-forward)
    (define-key puni-mode-map (kbd "C-{") 'puni-barf-backward)
    (define-key puni-mode-map (kbd "M-<up>") 'puni-splice-killing-backward)
    (define-key puni-mode-map (kbd "C-w") nil)))

(provide 'init-paredit)
;;; init-paredit.el ends here
