(add-to-list 'auto-mode-alist '("log4j" . conf-javaprop-mode))

(put 'narrow-to-region 'disabled nil)
(setq-default indent-tabs-mode nil)
(setq-default column-number-mode t)

;;; I've been getting a weird error
;;   debug(error (wrong-number-of-arguments (lambda (arg) "Fill paragraph at or after point.  Prefix arg means justify as well.

;; (This function has been overloaded with the `filladapt' version.)

;; If `sentence-end-double-space' is non-nil, then period followed by one
;; space does not end a sentence, so don't break a line there.
;;   debug(error (wrong-number-of-arguments (lambda (arg) "Fill paragraph at or after point.  Prefix arg means justify as well.

;; (This function has been overloaded with the `filladapt' version.)

;; If `sentence-end-double-space' is non-nil, then period followed by one
;; space does not end a sentence, so don't break a line there.

;; (require 'filladapt)
;; (setq-default filladapt-mode t)
;; ; make it shorter
;; (setq filladapt-mode-line-string " FA")
;; (defun enable-filladapt-mode ()
;;   (filladapt-mode 1))

(defun unfill-paragraph ()
  "Pull this whole paragraph up onto one line."
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))

;; restructured text
(require 'rst)
(add-to-list 'auto-mode-alist '("\\.rst$" . rst-mode))
(add-to-list 'auto-mode-alist '("wiki.fhcrc.org.*\\.txt$" . rst-mode))

;;; javascript
(autoload #'espresso-mode "espresso" "Start espresso-mode" t)
(add-to-list 'auto-mode-alist '("\\.js$" . espresso-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . espresso-mode))

;;; markdown
(autoload 'markdown-mode "markdown-mode.el"
  "Major mode for editing Markdown files" t)
(setq auto-mode-alist
      (cons '("\\.md" . markdown-mode) auto-mode-alist))

;; FIXME: move to separate Erlang config file
;; (add-to-list 'load-path "~/src/erlware-mode")
(add-to-list 'load-path "/usr/local/lib/erlang/lib/tools-2.6.6.4/emacs")
(setq erlang-man-root-dir "/usr/local/share/man"
      exec-path (cons "/usr/local/lib/erlang/bin" exec-path))
(require 'erlang-start)

;; wrangler Erlang code refactor tool
(add-to-list 'load-path "/usr/local/share/wrangler/elisp")
(require 'wrangler)

(defvar activity-log-file-prefix "~/ACTILOG"
  "prefix for file containing activity log")

(defun actilog (log)
       (interactive "sLog: ")
       (save-excursion
        (set-buffer (find-file-noselect 
                     (format "%s-%s" activity-log-file-prefix 
                             (format-time-string "%m-%d"))))
        (goto-char (point-max))
        (insert (format "%s %s\n" (format-time-string "[%H:%M]") log))
        (save-buffer)))

(global-set-key [f12] 'actilog)

;;; yasnippet config
(require 'yasnippet-bundle)
;; (yas/initialize)
(setq yas/root-directory "~/.emacs.d/extra/snippets")
(yas/load-directory yas/root-directory)

(defun yas/advise-indent-function (function-symbol)
  (eval `(defadvice ,function-symbol (around yas/try-expand-first activate)
           ,(format
             "Try to expand a snippet before point, then call `%s' as usual"
             function-symbol)
           (let ((yas/fallback-behavior nil))
             (unless (and (interactive-p)
                          (yas/expand))
               ad-do-it)))))

(yas/advise-indent-function 'noweb-indent-line)

;; cucumber mode
(require 'feature-mode)
(add-to-list 'auto-mode-alist '("\.feature$" . feature-mode))

;; textmate and peep open
(require 'textmate)
(require 'peepopen)
(setq ns-pop-up-frames nil)
(textmate-mode)
;; (textmate-mode)
;; (textmate-mode)
(require 'rspec-mode)

;; lua!
(setq auto-mode-alist (cons '("\\.lua$" . lua-mode) auto-mode-alist))
(autoload 'lua-mode "lua-mode" "Lua editing mode." t)

;; http-twiddle
(require 'http-twiddle)

(defun chomp (str)
      "Chomp leading and tailing whitespace from STR."
      (let ((s (if (symbolp str) (symbol-name str) str)))
        (replace-regexp-in-string
         "\\(^[[:space:]\n]*\\|[[:space:]\n]*$\\)" "" s)))

(provide 'sf-misc)
