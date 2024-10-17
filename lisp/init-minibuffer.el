;;; init-minibuffer.el --- Config for minibuffer completion -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(when (require-package 'vertico)
  (add-hook 'after-init-hook 'vertico-mode)

  (with-eval-after-load 'vertico
    (define-key vertico-map (kbd "RET") 'vertico-directory-enter)
    (define-key vertico-map (kbd "DEL") 'vertico-directory-delete-char)
    (define-key vertico-map (kbd "M-DEL") 'vertico-directory-delete-word))

  (when (require-package 'embark)
    (with-eval-after-load 'vertico
      (define-key vertico-map (kbd "C-c C-o") 'embark-export)
      (define-key vertico-map (kbd "C-c C-c") 'embark-act)))

  (when (require-package 'consult)
    (defmacro my-no-consult-preview (&rest cmds)
      `(with-eval-after-load 'consult
         (consult-customize ,@cmds :preview-key "M-P")))

    (my-no-consult-preview
     consult-ripgrep
     consult-git-grep consult-grep
     consult-bookmark consult-recent-file consult-xref
     consult--source-recent-file consult--source-project-recent-file consult--source-bookmark)

    (when (and (executable-find "rg"))
      (defun my-consult-ripgrep-at-point (&optional dir initial)
        (interactive (list prefix-arg (when-let ((s (symbol-at-point)))
                                        (symbol-name s))))
        (consult-ripgrep dir initial))
      (my-no-consult-preview my-consult-ripgrep-at-point)
      (global-set-key (kbd "M-?") 'my-consult-ripgrep-at-point))

    (global-set-key [remap switch-to-buffer] 'consult-buffer)
    (global-set-key [remap switch-to-buffer-other-window] 'consult-buffer-other-window)
    (global-set-key [remap switch-to-buffer-other-frame] 'consult-buffer-other-frame)
    (global-set-key [remap goto-line] 'consult-goto-line)

    (when (require-package 'embark-consult)
      (with-eval-after-load 'embark
        (require 'embark-consult)
        (add-hook 'embark-collect-mode-hook 'embark-consult-preview-minor-mode)))))

(when (require-package 'marginalia)
  (add-hook 'after-init-hook 'marginalia-mode))

(provide 'init-minibuffer)
;;; init-minibuffer.el ends here
