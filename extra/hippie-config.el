;; Bind hippie-expand to something handy.

(require 'hippie-exp)
(require 'bbdb)

;; I don't need this any more because of the superfunky planner-specific
;; hippie-expand stuff below.

;(add-to-list 'hippie-expand-try-functions-list 'sacha/try-expand-emacs-wiki-name)
(defun sacha/try-expand-emacs-wiki-name (old)
  "Expand a wiki name."
  (unless old
    (he-init-string (he-dabbrev-beg) (point))
    (setq he-expand-list
          (if (derived-mode-p 'emacs-wiki-mode)
              (delq nil
                    (mapcar
                     (lambda (item)
                       (when (string-match
                              (concat "^" (regexp-quote he-search-string))
                              (car item))
                         (emacs-wiki-make-link (car item))))
                     (emacs-wiki-file-alist))))))
  (while (and he-expand-list
              (or (not (car he-expand-list))
                  (he-string-member (car he-expand-list) he-tried-table t)))
    (setq he-expand-list (cdr he-expand-list)))
  (if (null he-expand-list)
      (progn
        (if old (he-reset-string))
        nil)
    (progn
      (he-substitute-string (car he-expand-list) t)
      (setq he-expand-list (cdr he-expand-list))
      t)))

;;;_+ Automagic BBDB expansion into Planner annotations

(add-to-list 'hippie-expand-try-functions-list 'sacha/try-expand-planner-bbdb-annotation)
(defun sacha/try-expand-planner-bbdb-annotation (old)
  "Expand from BBDB. If OLD is non-nil, cycle through other possibilities."
  (unless old
    ;; First time, so search through BBDB records for the name
    (he-init-string (he-dabbrev-beg) (point))
    (setq he-expand-list nil)
    (mapcar
     (lambda (item)
       (setq he-expand-list
             (cons (concat "[[bbdb://"
                           (emacs-wiki-replace-regexp-in-string
                            " " "."
                            (bbdb-record-name item))
                           "][" (bbdb-record-name item) "]]")
                   he-expand-list)))
     (bbdb-search (bbdb-records)
                  he-search-string
                  he-search-string
                  he-search-string
                  nil nil)))
  (while (and he-expand-list
              (or (not (car he-expand-list))
                  (he-string-member (car he-expand-list) he-tried-table t)))
    (setq he-expand-list (cdr he-expand-list)))
  (if (null he-expand-list)
      (progn
        (if old (he-reset-string))
        nil)
    (progn
      (he-substitute-string (car he-expand-list) t)
      (setq he-expand-list (cdr he-expand-list))
      t)))

;;;_+ Insanely smart hippie expansion for planner pages

;; Understands:
;; yesterday
;; tomorrow
;; today
;; date shortcut formats from planner-expand-name
;; planner page names (case-insensitive)

(add-to-list 'hippie-expand-try-functions-list 'sacha/try-expand-planner-name)
(defun sacha/try-expand-planner-name (old)
  "Expand from BBDB. If OLD is non-nil, cycle through other possibilities."
  (unless old
    ;; First time, so search through BBDB records for the name
    (he-init-string (he-dabbrev-beg) (point))
    (setq he-expand-list
           (cond
            ((string= he-search-string "yesterday")
             (list
              (concat "[["
                      (planner-calculate-date-from-day-offset (planner-today) -1)
                      "][yesterday]]")))
            ((string= he-search-string "tomorrow")
             (list
              (concat "[["
                      (planner-calculate-date-from-day-offset (planner-today) +1)
                      "][tomorrow]]")))
            ((string= he-search-string "today")
             (list (concat "[[" (planner-today) "][today]]")))
            ((or
              (string-match (concat "^\\([1-9][0-9][0-9][0-9]\\.\\)?"
                                    "\\(\\([0-9]+\\)\\.\\)?"
                                    "\\([0-9]+\\)\\(#.*\\)?$")
                            he-search-string)
              (string-match "^\\([-+]\\)\\s-*\\([0-9]+\\)$"
                            he-search-string)
              (string-match (concat
                             "^\\([-+]\\)\\s-*\\([0-9]*\\)\\s-*\\("
                             (mapconcat 'car planner-expand-name-days-alist "\\|")
                             "\\)\\s-*\\(\\.\\|\\(\\(\\([0-9]+\\.\\)?[0-9]+\\.\\)?[0-9]+\\)\\)?$")
                            he-search-string))
             (list (planner-expand-name he-search-string)))
            (t (let ((case-fold-search t))
                 (delq nil
                       (mapcar
                        (lambda (item)
                          (if (string-match (concat "^" (regexp-quote he-search-string))
                                            (car item))
                              (let ((case-fold-search nil))
                                (planner-make-link (car item)))))
                        (planner-file-alist))))))))
  (while (and he-expand-list
              (or (not (car he-expand-list))
                  (he-string-member (car he-expand-list) he-tried-table t)))
    (setq he-expand-list (cdr he-expand-list)))
  (if (null he-expand-list)
      (progn
        (if old (he-reset-string))
        nil)
    (progn
      (he-substitute-string (car he-expand-list) t)
      (setq he-expand-list (cdr he-expand-list))
      t)))

;; Particularly fun with ERC. I am now a bot!
(defun sacha/try-expand-factoid-from-bbdb (old)
  "Expand from BBDB. If OLD is non-nil, cycle through other possibilities.
Search strings should be of the form bbdb/SEARCHTERM."
  (unless old
      ;; First time, so search through the BBDB records for the factoid.
    (progn
      (he-init-string (he-dabbrev-beg) (point))
      (setq he-expand-list nil)
      (when (string-match "bbdb/\\(.+\\)" he-search-string)
        (setq he-search-string (match-string 1 he-search-string))
        (mapcar
         (lambda (item)
           (setq he-expand-list
                 (append (list
                          (bbdb-record-getprop item 'blog)
                          (bbdb-record-getprop item 'web))
                         (bbdb-record-net item)
                         (list (bbdb-record-getprop item 'notes))
                         he-expand-list)))
         (let ((notes (cons '* he-search-string)))
           (bbdb-search (bbdb-records)
                        he-search-string he-search-string he-search-string
                        notes nil)))
        (setq he-expand-list (delq nil he-expand-list)))))
  (while (and he-expand-list
              (or (not (car he-expand-list))
                  (he-string-member (car he-expand-list) he-tried-table t)))
    (setq he-expand-list (cdr he-expand-list)))
  (if (null he-expand-list)
      (progn
        (if old (he-reset-string))
        nil)
    (progn
      (he-substitute-string (car he-expand-list) t)
      (setq he-expand-list (cdr he-expand-list))
      t)))

;; My default hippie config
(setq hippie-expand-try-functions-list
      '(sacha/try-expand-planner-bbdb-annotation
        sacha/try-expand-planner-name
        try-expand-line
        try-complete-file-name
        try-expand-dabbrev
        try-expand-line-all-buffers
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill
        sacha/try-expand-factoid-from-bbdb))
