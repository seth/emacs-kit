;; org-mode !
(add-to-list 'load-path "~/.emacs.d/extra/org/lisp")
(add-to-list 'load-path "~/.emacs.d/extra/org/contrib/lisp")
(require 'org-install)
(require 'org-velocity)
(global-set-key (kbd "C-c 0") 'org-velocity-read)

(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(setq org-log-done t)

;; http://orgmode.org/worg/org-faq.php#YASnippet
(defun yas/org-very-safe-expand ()
  (let ((yas/fallback-behavior 'return-nil)) (yas/expand)))

(add-hook 'org-mode-hook
          (lambda ()
            ;; yasnippet (using the new org-cycle hooks)
            (make-variable-buffer-local 'yas/trigger-key)
            (setq yas/trigger-key [tab])
            (add-to-list 'org-tab-first-hook 'yas/org-very-safe-expand)
            (define-key yas/keymap [tab] 'yas/next-field)))


;;; mobile org setup
(setq org-directory "~/Notebook/org")
(setq org-mobile-inbox-for-pull "~/Notebook/org/from-mobile.org")
;;(setq org-mobile-directory "/Volumes/sfalcon/org")
(setq org-mobile-directory "~/Dropbox/MobileOrg")

;;; org-babel setup
;; (require 'org-babel-init)
;; (require 'org-babel-R)
;; (require 'org-babel-ruby)
;; (org-babel-load-library-of-babel)


(provide 'sf-org)
