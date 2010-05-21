;; ESS
(add-to-list 'load-path "~/src/ESS/lisp")
(require  'ess-site)
(setq ess-S-assign-key (kbd "C-="))
(ess-toggle-S-assign-key t)             ; enable above key definition
;; leave my underscore key alone!
(ess-toggle-underscore nil)
(setq ess-r-versions '("R-"))
(setq ess-use-inferior-program-name-in-buffer-name t)
(add-to-list 'auto-mode-alist '("\\.Rd\\'" . Rd-mode))
(setq ess-eval-visibly-p nil)
(setq inferior-R-args "--no-save --no-restore -q")

;; ESS
(add-hook 'ess-mode-hook
          (lambda ()
            (ess-set-style 'C++ 'quiet)
            ;; Because
            ;;                                 DEF GNU BSD K&R C++
            ;; ess-indent-level                  2   2   8   5   4
            ;; ess-continued-statement-offset    2   2   8   5   4
            ;; ess-brace-offset                  0   0  -8  -5  -4
            ;; ess-arg-function-offset           2   4   0   0   0
            ;; ess-expression-offset             4   2   8   5   4
            ;; ess-else-offset                   0   0   0   0   0
            ;; ess-close-brace-offset            0   0   0   0   0
            (add-hook 'local-write-file-hooks
                      (lambda ()
                        (ess-nuke-trailing-whitespace)))
            (setq fill-column 72)))
(setq ess-nuke-trailing-whitespace-p 'ask)
;; or even
;; (setq ess-nuke-trailing-whitespace-p t)

;;; Perl
(add-hook 'perl-mode-hook
          (lambda () (setq perl-indent-level 4)))

(provide 'sf-ess)
