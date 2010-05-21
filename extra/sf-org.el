;; org-mode !
(add-to-list 'load-path "~/.emacs.d/sf-lisp/org/lisp")
(add-to-list 'load-path "~/.emacs.d/sf-lisp/org/contrib/lisp")
(require 'org-install)

(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(setq org-log-done t)

;;; mobile org setup
(setq org-directory "~/Notebook/org")
(setq org-mobile-inbox-for-pull "~/Notebook/org/from-mobile.org")
(setq org-mobile-directory "/Volumes/sfalcon/org")

;;; org-babel setup
(require 'org-babel-init)
(require 'org-babel-R)
(require 'org-babel-ruby)
(org-babel-load-library-of-babel)


(provide 'sf-org)
