(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files
   '("/home/awannaphasch2016/.doom.d/config.org" "/home/awannaphasch2016/org/PhD.org" "/home/awannaphasch2016/org/diary.org" "/home/awannaphasch2016/org/journal.org" "/home/awannaphasch2016/org/refile.org" "/home/awannaphasch2016/org/todo.org" "/home/awannaphasch2016/org/projects/sideprojects/garun/garun.org" "/home/awannaphasch2016/org/notes/incremental-learning.org" "/home/awannaphasch2016/org/projects/sideprojects/pen.org" "/home/awannaphasch2016/org/GTD.org" "/home/awannaphasch2016/org/notes/articles-to-reads.org" "/home/awannaphasch2016/org/notes/books/books-to-read.org" "/home/awannaphasch2016/org/personal-website.org" "/home/awannaphasch2016/org/school.org" "/home/awannaphasch2016/org/expert-identification.org" "/home/awannaphasch2016/org/life.org" "/home/awannaphasch2016/org/finance/personal-finance.org"))
 '(org-todo-keywords
   '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)" "MAYBE(m)" "VALIDATE(v)")
     (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE" "MEETING")))
 '(org-todo-state-tags-triggers
   '((done
      ("CANCELLED"))
     ("WAITING"
      ("WAITING" . t))
     ("HOLD"
      ("WAITING")
      ("HOLD" . t))
     (done
      ("WAITING")
      ("HOLD"))
     ("TODO"
      ("WAITING")
      ("CANCELLED")
      ("HOLD"))
     ("NEXT"
      ("WAITING")
      ("CANCELLED")
      ("HOLD"))
     ("DONE"
      ("WAITING")
      ("CANCELLED")
      ("HOLD"))))
 '(package-selected-packages
   '(exec-path-from-shell zotero yasnippet pkg-info org-web-tools org-sidebar org-roam org-ref org-preview-html org-present org-noter-pdftools org-drill org-download org-brain ob-ipython ledger-mode key-chord ivy helm-bibtex eimp eglot dap-mode bicycle ace-jump-mode)))
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
(put 'customize-group 'disabled nil)
