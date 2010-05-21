;;; Carbon Emacs specific settings
(if (and (equal system-type 'darwin) (not (boundp 'aquamacs-version)))
    (progn
      (set-frame-font
       "-apple-monaco-medium-r-normal--18-140-72-72-m-140-mac-roman")
      (set-default-font
       "-apple-monaco-medium-r-normal--18-140-72-72-m-140-mac-roman")
      (setq-default cursor-type t)))
(provide 'sf-carbon-emacs)
