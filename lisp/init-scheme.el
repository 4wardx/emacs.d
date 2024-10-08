;;; init-scheme.el --- Scheme support -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(with-eval-after-load 'scheme
  (add-hook 'scheme-mode-hook 'sanityinc/lisp-setup))

(when (maybe-require-package 'geiser)
  (when (executable-find "guile")
    (maybe-require-package 'geiser-guile))

  (when (executable-find "chez")
    (maybe-require-package 'geiser-chez))

  (when (maybe-require-package 'macrostep-geiser)
    (with-eval-after-load 'geiser-mode
      (add-hook 'geiser-mode-hook 'macrostep-geiser-setup))
    (with-eval-after-load 'geiser-repl
      (add-hook 'geiser-repl-mode-hook 'macrostep-geiser-setup))))

(provide 'init-scheme)
;;; init-scheme.el ends here
