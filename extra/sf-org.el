;; org-mode !
(add-to-list 'load-path "~/.emacs.d/extra/org/lisp")
(add-to-list 'load-path "~/.emacs.d/extra/org/contrib/lisp")
(require 'org-install)
(require 'org-velocity)

(global-set-key (kbd "C-c 0") 'org-velocity-read)
(define-key global-map "\C-c1" 'org-capture)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))

(setq
 org-directory "~/Notebook/org"
 org-mobile-inbox-for-pull "~/Notebook/org/from-mobile.org"
 org-mobile-directory "~/Dropbox/MobileOrg"
 org-agenda-files (quote ("~/Notebook/org/seth.org"))
 org-enforce-todo-dependencies t
 org-velocity-bucket "~/Notebook/org/solutions.org"
 org-default-notes-file (concat org-directory "/notes.org")
 org-log-done t)

;; capture setup
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline (concat org-directory "/seth.org") "Next Action")
         "* TODO %?\n  %i\n  %a")
        ("s" "Solution" entry (file+datetree (concat org-directory "/solutions.org"))
         "* %?\nEntered on %U\n  %i\n  %a")
        ("j" "Journal" entry (file+datetree (concat org-directory "/journal.org"))
         "* %?\nEntered on %U\n  %i\n  %a")))

;; where to refile
(setq org-refile-targets
      '((nil . (:level . 1))
        ("solutions.org" . (:level . 1))
        ("seth.org" . (:level . 1))
        ("seth-sometime.org" . (:level . 1))
        ("seth-ref.org" . (:level . 1))))

(setq org-refile-use-outline-path 'file)

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

;;; org-babel setup
;; (require 'org-babel-init)
;; (require 'org-babel-R)
;; (require 'org-babel-ruby)
;; (org-babel-load-library-of-babel)


(provide 'sf-org)
