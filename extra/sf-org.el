;; org-mode !
(add-to-list 'load-path "~/.emacs.d/extra/org/lisp")
(add-to-list 'load-path "~/.emacs.d/extra/org/contrib/lisp")
(require 'org-install)

(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(setq org-log-done t)

;; ;; cribbed from: http://orgmode.org/worg/org-configs/org-config-examples.php
;; (add-hook 'org-mode-hook
;;           (lambda ()
;;             ;; yasnippet (allow yasnippet to do it's thing in org files)
;;             (make-variable-buffer-local 'yas/trigger-key)
;;             (setq yas/trigger-key [tab])
;;             (define-key yas/keymap [tab] 'yas/next-field-group)))

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
