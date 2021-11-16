(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files
   '("~/Scratches/tmp.org" "/home/awannaphasch2016/org/journal.org" "/home/awannaphasch2016/org/notes.org" "/home/awannaphasch2016/org/todo.org"))
 '(package-selected-packages
   '(org-drill bicycle org-noter-pdftools yasnippet ace-jump-mode dap-mode org-roam-bibtex zotero org-present eimp pkg-info org-web-tools org-sidebar org-roam org-ref org-preview-html org-pdftools org-download org-brain ob-ipython ledger-mode eglot)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; Paste image to orgmode https://stackoverflow.com/questions/17435995/paste-an-image-on-clipboard-to-emacs-org-mode-file-without-saving-it
  (defun my-org-screenshot-this-buffer ()
    "Take a screenshot into a time stamped unique-named file in the
  same directory as the org-buffer and insert a link to this file."
    (interactive)
    (org-display-inline-images)
    (setq filename
          (concat
           (make-temp-name
            (concat (file-name-nondirectory (buffer-file-name))
                    "_imgs/"
                    (format-time-string "%Y%m%d_%H%M%S_")) ) ".png"))
    (unless (file-exists-p (file-name-directory filename))
      (make-directory (file-name-directory filename)))
    ; take screenshot
    (if (eq system-type 'darwin)
        (call-process "screencapture" nil nil nil "-i" filename))
    (if (eq system-type 'gnu/linux)
        (call-process "import" nil nil nil filename))
    ; insert into file if correctly taken
    (if (file-exists-p filename)
      (insert (concat "[[file:" filename "]]"))))

;; org-roam config
(org-roam-db-autosync-mode)
(put 'projectile-ag 'disabled nil)
