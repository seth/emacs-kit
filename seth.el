(setq sf-lisp-dir (concat dotfiles-dir "sf-lisp"))
(add-to-list 'load-path sf-lisp-dir)

(setq sf-lisp-subdirs
      '("bdb"))
(mapc (lambda (dir) (add-to-list 'load-path (concat sf-lisp-dir "/" dir)))
      sf-lisp-subdirs)
(setq tool-bar-mode nil
      visible-bell nil
      ring-bell-function '(lambda () nil)
      default-frame-alist '((width . 85) (height . 33)
                            (font
                             .
                             "-apple-monaco-medium-r-normal--18-140-72-72-m-140-mac-roman")))

(require 'sf-org)
(require 'sf-misc)
(require 'sf-email)
(require 'sf-bbdb)
(require 'sf-ess)
(require 'magit)
;(epa-file-enable)
(load "sf-confluence.el")
;; starter kit adds flyspell-mode to text-mode,
;; I've been finding it too slow.
(setq flyspell-delay 6)
(remove-hook 'text-mode-hook 'turn-on-flyspell)


;; ;; emacs-wiki had this:
;; (add-hook 'after-make-frame-functions
;;            (lambda (frame)
;;              (set-variable 'color-theme-is-global nil)
;;              (select-frame frame)
;;              (if window-system
;;                  (color-theme-zenburn)
;;                (color-theme-standard))))

;; This code taken from comments on this post
;; http://emacs-fu.blogspot.com/2009/03/color-theming.html
;; The idea is to customize the colortheme based on whether
;; we are using a frame or a terminal based client.
(defvar after-make-console-frame-hooks '()
  "Hooks to run after creating a new TTY frame")

(defvar after-make-window-system-frame-hooks '()
  "Hooks to run after creating a new window-system frame")

(defun run-after-make-frame-hooks (frame)
  "Selectively run either `after-make-console-frame-hooks' or
`after-make-window-system-frame-hooks'"
  (select-frame frame)
  (run-hooks (if window-system
                 'after-make-window-system-frame-hooks
               'after-make-console-frame-hooks)))

(add-hook 'after-make-frame-functions 'run-after-make-frame-hooks)
(add-hook 'after-init-hook
          (lambda ()
            (run-after-make-frame-hooks (selected-frame))))


(set-variable 'color-theme-is-global nil)
(add-hook 'after-make-window-system-frame-hooks 'color-theme-blackboard)
(add-hook 'after-make-console-frame-hooks 'color-theme-standard)

(server-start)

