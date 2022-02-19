;; [[file:config.org::*Uncategorized Configuration][Uncategorized Configuration:1]]
;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
;;;
;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Anak Wannaphaschaiyong"
      user-mail-address "awannaphasch2016@fau.edu")

;; Doom exposes five (optional) variables f)or controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


;; Anak's configuration
;; (require 'org-habit)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((ipython . t)
   (jupyter . t)
   (scala . t)
   (go . t  )
   (python . t)
   (julia . t)))

(defun bh/hide-other ()
  (interactive)
  (save-excursion
    (org-back-to-heading 'invisible-ok)
    (hide-other)
    (org-cycle)
    (org-cycle)
    (org-cycle)))

(defun bh/set-truncate-lines ()
  "Toggle value of truncate-lines and refresh window display."
  (interactive)
  (setq truncate-lines (not truncate-lines))
  ;; now refresh window display (an idiom from simple.el):
  (save-excursion
    (set-window-start (selected-window)
                      (window-start (selected-window)))))

(defun bh/make-org-scratch ()
  (interactive)
  (find-file "/tmp/publish/scratch.org")
  (gnus-make-directory "/tmp/publish"))

(defun bh/switch-to-scratch ()
  (interactive)
  (switch-to-buffer "*scratch*"))

;; org-todo
(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)" "VALIDATE(v)")
              (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE" "MEETING"))))

(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "red" :weight bold)
              ("NEXT" :foreground "blue" :weight bold)
              ("DONE" :foreground "forest green" :weight bold)
              ("WAITING" :foreground "orange" :weight bold)
              ("HOLD" :foreground "magenta" :weight bold)
              ("CANCELLED" :foreground "forest green" :weight bold)
              ("MEETING" :foreground "forest green" :weight bold)
              ("PHONE" :foreground "forest green" :weight bold))))

;; Capture templates for: TODO tasks, Notes, appointments, phone calls, meetings, and org-protocol
(setq org-capture-templates
      (quote (("t" "todo" entry (file "~/org/refile.org")
               "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
              ("r" "respond" entry (file "~/org/refile.org")
               "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
              ("n" "note" entry (file "~/org/refile.org")
               "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
              ("j" "Journal" entry (file+datetree "~/org/diary.org")
               "* %?\n%U\n" :clock-in t :clock-resume t)
              ("w" "org-protocol" entry (file "~/org/refile.org")
               "* TODO Review %c\n%U\n" :immediate-finish t)
              ("m" "Meeting" entry (file "~/org/refile.org")
               "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t)
              ("p" "Phone call" entry (file "~/org/refile.org")
               "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
              ("h" "Habit" entry (file "~/org/refile.org")
               "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+1d/3d>>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n"))))

;; Do not dim blocked tasks
(setq org-agenda-dim-blocked-tasks nil)

;; Compact the block agenda view
(setq org-agenda-compact-blocks t)

;; Custom agenda command definitions
(setq org-agenda-custom-commands
      (quote (("N" "Notes" tags "NOTE"
               ((org-agenda-overriding-header "Notes")
                (org-tags-match-list-sublevels t)))
              ("h" "Habits" tags-todo "STYLE=\"habit\""
               ((org-agenda-overriding-header "Habits")
                (org-agenda-sorting-strategy
                 '(todo-state-down effort-up category-keep))))
              (" " "Agenda"
               ((agenda "" nil)
                (tags "REFILE"
                      ((org-agenda-overriding-header "Tasks to Refile")
                       (org-tags-match-list-sublevels nil)))
                (tags-todo "-CANCELLED/!"
                           ((org-agenda-overriding-header "Stuck Projects")
                            (org-agenda-skip-function 'bh/skip-non-stuck-projects)
                            (org-agenda-sorting-strategy
                             '(category-keep))))
                (tags-todo "-HOLD-CANCELLED/!"
                           ((org-agenda-overriding-header "Projects")
                            (org-agenda-skip-function 'bh/skip-non-projects)
                            (org-tags-match-list-sublevels 'indented)
                            (org-agenda-sorting-strategy
                             '(category-keep))))
                (tags-todo "-CANCELLED/!NEXT"
                           ((org-agenda-overriding-header (concat "Project Next Tasks"
                                                                  (if bh/hide-scheduled-and-waiting-next-tasks
                                                                      ""
                                                                    " (including WAITING and SCHEDULED tasks)")))
                            (org-agenda-skip-function 'bh/skip-projects-and-habits-and-single-tasks)
                            (org-tags-match-list-sublevels t)
                            (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-sorting-strategy
                             '(todo-state-down effort-up category-keep))))
                (tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
                           ((org-agenda-overriding-header (concat "Project Subtasks"
                                                                  (if bh/hide-scheduled-and-waiting-next-tasks
                                                                      ""
                                                                    " (including WAITING and SCHEDULED tasks)")))
                            (org-agenda-skip-function 'bh/skip-non-project-tasks)
                            (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-sorting-strategy
                             '(category-keep))))
                (tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
                           ((org-agenda-overriding-header (concat "Standalone Tasks"
                                                                  (if bh/hide-scheduled-and-waiting-next-tasks
                                                                      ""
                                                                    " (including WAITING and SCHEDULED tasks)")))
                            (org-agenda-skip-function 'bh/skip-project-tasks)
                            (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-sorting-strategy
                             '(category-keep))))
                (tags-todo "-CANCELLED+WAITING|HOLD/!"
                           ((org-agenda-overriding-header (concat "Waiting and Postponed Tasks"
                                                                  (if bh/hide-scheduled-and-waiting-next-tasks
                                                                      ""
                                                                    " (including WAITING and SCHEDULED tasks)")))
                            (org-agenda-skip-function 'bh/skip-non-tasks)
                            (org-tags-match-list-sublevels nil)
                            (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)))
                (tags "-REFILE/"
                      ((org-agenda-overriding-header "Tasks to Archive")
                       (org-agenda-skip-function 'bh/skip-non-archivable-tasks)
                       (org-tags-match-list-sublevels nil))))
))))

;; clockin setup url:http://doc.norang.ca/org-mode.html
;; Resume clocking task when emacs is restarted
(org-clock-persistence-insinuate)
;;
;; Show lot of clocking history so it's easy to pick items off the C-F11 list
(setq org-clock-history-length 23)
;; Resume clocking task on clock-in if the clock is open
(setq org-clock-in-resume t)
;; Change tasks to NEXT when clocking in
(setq org-clock-in-switch-to-state 'bh/clock-in-to-next)
;; Separate drawers for clocking and logs
(setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))
;; Save clock data and state changes and notes in the LOGBOOK drawer
(setq org-clock-into-drawer t)
;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)
;; Clock out when moving task to a done state
(setq org-clock-out-when-done t)
;; Save the running clock and all clock history when exiting Emacs, load it on startup
(setq org-clock-persist t)
;; Do not prompt to resume an active clock
(setq org-clock-persist-query-resume nil)
;; Enable auto clock resolution for finding open clocks
(setq org-clock-auto-clock-resolution (quote when-no-clock-is-running))
;; Include current clocking task in clock reports
(setq org-clock-report-include-clocking-task t)

(setq bh/keep-clock-running nil)

(defun bh/clock-in-to-next (kw)
  "Switch a task from TODO to NEXT when clocking in.
Skips capture tasks, projects, and subprojects.
Switch projects and subprojects from NEXT back to TODO"
  (when (not (and (boundp 'org-capture-mode) org-capture-mode))
    (cond
     ((and (member (org-get-todo-state) (list "TODO"))
           (bh/is-task-p))
      "NEXT")
     ((and (member (org-get-todo-state) (list "NEXT"))
           (bh/is-project-p))
      "TODO"))))

(defun bh/find-project-task ()
  "Move point to the parent (project) task if any"
  (save-restriction
    (widen)
    (let ((parent-task (save-excursion (org-back-to-heading 'invisible-ok) (point))))
      (while (org-up-heading-safe)
        (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
          (setq parent-task (point))))
      (goto-char parent-task)
      parent-task)))

(defun bh/punch-in (arg)
  "Start continuous clocking and set the default task to the
selected task.  If no task is selected set the Organization task
as the default task."
  (interactive "p")
  (setq bh/keep-clock-running t)
  (if (equal major-mode 'org-agenda-mode)
      ;;
      ;; We're in the agenda
      ;;
      (let* ((marker (org-get-at-bol 'org-hd-marker))
             (tags (org-with-point-at marker (org-get-tags-at))))
        (if (and (eq arg 4) tags)
            (org-agenda-clock-in '(16))
          (bh/clock-in-organization-task-as-default)))
    ;;
    ;; We are not in the agenda
    ;;
    (save-restriction
      (widen)
      ; Find the tags on the current task
      (if (and (equal major-mode 'org-mode) (not (org-before-first-heading-p)) (eq arg 4))
          (org-clock-in '(16))
        (bh/clock-in-organization-task-as-default)))))

(defun bh/punch-out ()
  (interactive)
  (setq bh/keep-clock-running nil)
  (when (org-clock-is-active)
    (org-clock-out))
  (org-agenda-remove-restriction-lock))

(defun bh/clock-in-default-task ()
  (save-excursion
    (org-with-point-at org-clock-default-task
      (org-clock-in))))

(defun bh/clock-in-parent-task ()
  "Move point to the parent (project) task if any and clock in"
  (let ((parent-task))
    (save-excursion
      (save-restriction
        (widen)
        (while (and (not parent-task) (org-up-heading-safe))
          (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
            (setq parent-task (point))))
        (if parent-task
            (org-with-point-at parent-task
              (org-clock-in))
          (when bh/keep-clock-running
            (bh/clock-in-default-task)))))))

(defvar bh/organization-task-id "eb155a82-92b2-4f25-a3c6-0304591af2f9")

(defun bh/clock-in-organization-task-as-default ()
  (interactive)
  (org-with-point-at (org-id-find bh/organization-task-id 'marker)
    (org-clock-in '(16))))

(defun bh/clock-out-maybe ()
  (when (and bh/keep-clock-running
             (not org-clock-clocking-in)
             (marker-buffer org-clock-default-task)
             (not org-clock-resolving-clocks-due-to-idleness))
    (bh/clock-in-parent-task)))

(add-hook 'org-clock-out-hook 'bh/clock-out-maybe 'append)

;; url: http://doc.norang.ca/org-mode.html#GettingStarted
;; Custom Key Bindings
(global-set-key (kbd "<f12>") 'org-agenda)
(global-set-key (kbd "<f5>") 'bh/org-todo)
(global-set-key (kbd "<S-f5>") 'bh/widen)
(global-set-key (kbd "<f7>") 'bh/set-truncate-lines)
(global-set-key (kbd "<f8>") 'org-cycle-agenda-files)
(global-set-key (kbd "<f9> <f9>") 'bh/show-org-agenda)
(global-set-key (kbd "<f9> b") 'bbdb)
(global-set-key (kbd "<f9> c") 'calendar)
(global-set-key (kbd "<f9> f") 'boxquote-insert-file)
(global-set-key (kbd "<f9> g") 'gnus)
(global-set-key (kbd "<f9> h") 'bh/hide-other)
(global-set-key (kbd "<f9> n") 'bh/toggle-next-task-display)

(global-set-key (kbd "<f9> I") 'bh/punch-in)
(global-set-key (kbd "<f9> O") 'bh/punch-out)

(global-set-key (kbd "<f9> o") 'bh/make-org-scratch)

(global-set-key (kbd "<f9> r") 'boxquote-region)
(global-set-key (kbd "<f9> s") 'bh/switch-to-scratch)

(global-set-key (kbd "<f9> t") 'bh/insert-inactive-timestamp)
(global-set-key (kbd "<f9> T") 'bh/toggle-insert-inactive-timestamp)

(global-set-key (kbd "<f9> v") 'visible-mode)
(global-set-key (kbd "<f9> l") 'org-toggle-link-display)
(global-set-key (kbd "<f9> SPC") 'bh/clock-in-last-task)
(global-set-key (kbd "C-<f9>") 'previous-buffer)
(global-set-key (kbd "M-<f9>") 'org-toggle-inline-images)
(global-set-key (kbd "C-x n r") 'narrow-to-region)
(global-set-key (kbd "C-<f10>") 'next-buffer)
(global-set-key (kbd "<f11>") 'org-clock-goto)
(global-set-key (kbd "C-<f11>") 'org-clock-in)
(global-set-key (kbd "C-s-<f12>") 'bh/save-then-publish)
(global-set-key (kbd "C-c c") 'org-capture)

(setq org-time-stamp-rounding-minutes (quote (1 1)))
;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)
; Set default column view headings: Task Effort Clock_Summary
(setq org-columns-default-format "%50ITEM(Task) %10Effort(Effort){:} %10CLOCKSUM")
; global Effort estimate values
; global STYLE property values for completion
(setq org-global-properties (quote (("Effort_ALL" . "0:15 0:30 0:45 1:00 2:00 3:00 4:00 5:00 6:00 0:00")
                                    ("STYLE_ALL" . "habit"))))
; Tags with fast selection keys
(setq org-tag-alist (quote ((:startgroup)
                            ("@errand" . ?e)
                            ("@office" . ?o)
                            ("@home" . ?H)
                            (:endgroup)
                            ("WAITING" . ?w)
                            ("HOLD" . ?h)
                            ("PERSONAL" . ?P)
                            ("WORK" . ?W)
                            ("ORG" . ?O)
                            ("NORANG" . ?N)
                            ("crypt" . ?E)
                            ("NOTE" . ?n)
                            ("CANCELLED" . ?c)
                            ("FLAGGED" . ??))))
(setq org-stuck-projects (quote ("" nil nil "")))

(defun bh/is-project-p ()
  "Any task with a todo keyword subtask"
  (save-restriction
    (widen)
    (let ((has-subtask)
          (subtree-end (save-excursion (org-end-of-subtree t)))
          (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
      (save-excursion
        (forward-line 1)
        (while (and (not has-subtask)
                    (< (point) subtree-end)
                    (re-search-forward "^\*+ " subtree-end t))
          (when (member (org-get-todo-state) org-todo-keywords-1)
            (setq has-subtask t))))
      (and is-a-task has-subtask))))

(defun bh/is-project-subtree-p ()
  "Any task with a todo keyword that is in a project subtree.
Callers of this function already widen the buffer view."
  (let ((task (save-excursion (org-back-to-heading 'invisible-ok)
                              (point))))
    (save-excursion
      (bh/find-project-task)
      (if (equal (point) task)
          nil
        t))))

(defun bh/is-task-p ()
  "Any task with a todo keyword and no subtask"
  (save-restriction
    (widen)
    (let ((has-subtask)
          (subtree-end (save-excursion (org-end-of-subtree t)))
          (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
      (save-excursion
        (forward-line 1)
        (while (and (not has-subtask)
                    (< (point) subtree-end)
                    (re-search-forward "^\*+ " subtree-end t))
          (when (member (org-get-todo-state) org-todo-keywords-1)
            (setq has-subtask t))))
      (and is-a-task (not has-subtask)))))

(defun bh/is-subproject-p ()
  "Any task which is a subtask of another project"
  (let ((is-subproject)
        (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
    (save-excursion
      (while (and (not is-subproject) (org-up-heading-safe))
        (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
          (setq is-subproject t))))
    (and is-a-task is-subproject)))

(defun bh/list-sublevels-for-projects-indented ()
  "Set org-tags-match-list-sublevels so when restricted to a subtree we list all subtasks.
  This is normally used by skipping functions where this variable is already local to the agenda."
  (if (marker-buffer org-agenda-restrict-begin)
      (setq org-tags-match-list-sublevels 'indented)
    (setq org-tags-match-list-sublevels nil))
  nil)

(defun bh/list-sublevels-for-projects ()
  "Set org-tags-match-list-sublevels so when restricted to a subtree we list all subtasks.
  This is normally used by skipping functions where this variable is already local to the agenda."
  (if (marker-buffer org-agenda-restrict-begin)
      (setq org-tags-match-list-sublevels t)
    (setq org-tags-match-list-sublevels nil))
  nil)

(defvar bh/hide-scheduled-and-waiting-next-tasks t)

(defun bh/toggle-next-task-display ()
  (interactive)
  (setq bh/hide-scheduled-and-waiting-next-tasks (not bh/hide-scheduled-and-waiting-next-tasks))
  (when  (equal major-mode 'org-agenda-mode)
    (org-agenda-redo))
  (message "%s WAITING and SCHEDULED NEXT Tasks" (if bh/hide-scheduled-and-waiting-next-tasks "Hide" "Show")))

(defun bh/skip-stuck-projects ()
  "Skip trees that are not stuck projects"
  (save-restriction
    (widen)
    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
      (if (bh/is-project-p)
          (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
                 (has-next ))
            (save-excursion
              (forward-line 1)
              (while (and (not has-next) (< (point) subtree-end) (re-search-forward "^\\*+ NEXT " subtree-end t))
                (unless (member "WAITING" (org-get-tags-at))
                  (setq has-next t))))
            (if has-next
                nil
              next-headline)) ; a stuck project, has subtasks but no next task
        nil))))

(defun bh/skip-non-stuck-projects ()
  "Skip trees that are not stuck projects"
  ;; (bh/list-sublevels-for-projects-indented)
  (save-restriction
    (widen)
    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
      (if (bh/is-project-p)
          (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
                 (has-next ))
            (save-excursion
              (forward-line 1)
              (while (and (not has-next) (< (point) subtree-end) (re-search-forward "^\\*+ NEXT " subtree-end t))
                (unless (member "WAITING" (org-get-tags-at))
                  (setq has-next t))))
            (if has-next
                next-headline
              nil)) ; a stuck project, has subtasks but no next task
        next-headline))))

(defun bh/skip-non-projects ()
  "Skip trees that are not projects"
  ;; (bh/list-sublevels-for-projects-indented)
  (if (save-excursion (bh/skip-non-stuck-projects))
      (save-restriction
        (widen)
        (let ((subtree-end (save-excursion (org-end-of-subtree t))))
          (cond
           ((bh/is-project-p)
            nil)
           ((and (bh/is-project-subtree-p) (not (bh/is-task-p)))
            nil)
           (t
            subtree-end))))
    (save-excursion (org-end-of-subtree t))))

(defun bh/skip-non-tasks ()
  "Show non-project tasks.
Skip project and sub-project tasks, habits, and project related tasks."
  (save-restriction
    (widen)
    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
      (cond
       ((bh/is-task-p)
        nil)
       (t
        next-headline)))))

(defun bh/skip-project-trees-and-habits ()
  "Skip trees that are projects"
  (save-restriction
    (widen)
    (let ((subtree-end (save-excursion (org-end-of-subtree t))))
      (cond
       ((bh/is-project-p)
        subtree-end)
       ((org-is-habit-p)
        subtree-end)
       (t
        nil)))))

(defun bh/skip-projects-and-habits-and-single-tasks ()
  "Skip trees that are projects, tasks that are habits, single non-project tasks"
  (save-restriction
    (widen)
    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
      (cond
       ((org-is-habit-p)
        next-headline)
       ((and bh/hide-scheduled-and-waiting-next-tasks
             (member "WAITING" (org-get-tags-at)))
        next-headline)
       ((bh/is-project-p)
        next-headline)
       ((and (bh/is-task-p) (not (bh/is-project-subtree-p)))
        next-headline)
       (t
        nil)))))

(defun bh/skip-project-tasks-maybe ()
  "Show tasks related to the current restriction.
When restricted to a project, skip project and sub project tasks, habits, NEXT tasks, and loose tasks.
When not restricted, skip project and sub-project tasks, habits, and project related tasks."
  (save-restriction
    (widen)
    (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
           (next-headline (save-excursion (or (outline-next-heading) (point-max))))
           (limit-to-project (marker-buffer org-agenda-restrict-begin)))
      (cond
       ((bh/is-project-p)
        next-headline)
       ((org-is-habit-p)
        subtree-end)
       ((and (not limit-to-project)
             (bh/is-project-subtree-p))
        subtree-end)
       ((and limit-to-project
             (bh/is-project-subtree-p)
             (member (org-get-todo-state) (list "NEXT")))
        subtree-end)
       (t
        nil)))))

(defun bh/skip-project-tasks ()
  "Show non-project tasks.
Skip project and sub-project tasks, habits, and project related tasks."
  (save-restriction
    (widen)
    (let* ((subtree-end (save-excursion (org-end-of-subtree t))))
      (cond
       ((bh/is-project-p)
        subtree-end)
       ((org-is-habit-p)
        subtree-end)
       ((bh/is-project-subtree-p)
        subtree-end)
       (t
        nil)))))

(defun bh/skip-non-project-tasks ()
  "Show project tasks.
Skip project and sub-project tasks, habits, and loose non-project tasks."
  (save-restriction
    (widen)
    (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
           (next-headline (save-excursion (or (outline-next-heading) (point-max)))))
      (cond
       ((bh/is-project-p)
        next-headline)
       ((org-is-habit-p)
        subtree-end)
       ((and (bh/is-project-subtree-p)
             (member (org-get-todo-state) (list "NEXT")))
        subtree-end)
       ((not (bh/is-project-subtree-p))
        subtree-end)
       (t
        nil)))))

(defun bh/skip-projects-and-habits ()
  "Skip trees that are projects and tasks that are habits"
  (save-restriction
    (widen)
    (let ((subtree-end (save-excursion (org-end-of-subtree t))))
      (cond
       ((bh/is-project-p)
        subtree-end)
       ((org-is-habit-p)
        subtree-end)
       (t
        nil)))))

(defun bh/skip-non-subprojects ()
  "Skip trees that are not projects"
  (let ((next-headline (save-excursion (outline-next-heading))))
    (if (bh/is-subproject-p)
        nil
      next-headline)))

(setq org-roam-v2-ack t)

;; org-roam
(global-set-key (kbd "C-c r t") 'org-roam-buffer-toggle)
(global-set-key (kbd "C-c r f") 'org-roam-node-find)
(global-set-key (kbd "C-c r i") 'org-roam-node-insert)

;; org-roam binding already exist prefix = spc m m
;; (map! :leader "n r t" #'org-roam-buffer-toggle)
;; (map! :leader "n r f" #'org-roam-node-find)
;; (map! :leader "n r i" #'org-roam-node-insert)
;; (map! :leader "n r c" #'org-roam-capture)
;; (map! :leader "n r a" #'org-id-get-create)
;; (map! :leader "n r d" #'org-roam-buffer-display-dedicated)

(setq org-roam-complete-everywhere t)
(setq
   org_notes (concat (getenv "HOME") "/org-roam/")
   zot_bib (concat (getenv "HOME") "/main.bib")
   org-directory org_notes
   deft-directory org_notes
   org-roam-directory org_notes
   )

;; helm-bibtex url: https://rgoswami.me/posts/org-note-workflow/#indexing-notes
(setq
 ;; bibtex-completion-notes-path '("/home/awannaphasch2016/Documents/MyNotes/" "/home/awannaphasch2016/org-roam/")
 bibtex-completion-notes-path "/home/awannaphasch2016/org-roam/"
 bibtex-completion-bibliography '("/home/awannaphasch2016/main.bib" "/home/awannaphasch2016/Documents/MyPapers/Paper-Covid19TrendPredictionSurvey/references.bib")
 bibtex-completion-pdf-field "file"
 bibtex-completion-notes-template-multiple-files
 (concat
  "#+TITLE: ${title}\n"
  "#+ROAM_KEY: cite:$
{=key=}\n"
  "* TODO Notes\n"
  ":PROPERTIES:\n"
 ":Custom_ID: ${=key=}\n"
  ":NOTER_DOCUMENT: %(orb-process-file-field \"${=key=}\")\n"
  ":AUTHOR: ${author-abbrev}\n"
  ":JOURNAL: ${journaltitle}\n"
  ":DATE: ${date}\n"
  ":YEAR: ${year}\n"
  ":DOI: ${doi}\n"
  ":URL: ${url}\n"
  ":END:\n\n"
  )
 )
;; org-ref
(setq
         org-ref-completion-library 'org-ref-ivy-cite
         org-ref-get-pdf-filename-function 'org-ref-get-pdf-filename-helm-bibtex
         org-ref-default-bibliography (list "/home/awannaphasch2016/main.bib" "/home/awannaphasch2016/Documents/MyPapers/Paper-Covid19TrendPredictionSurvey/references.bib")
         org-ref-bibliography-notes "/home/haozeke/Git/Gitlab/Mine/Notes/bibnotes.org"
         org-ref-note-title-format "* TODO %y - %t\n :PROPERTIES:\n  :Custom_ID: %k\n  :NOTER_DOCUMENT: %F\n :ROAM_KEY: cite:%k\n  :AUTHOR: %9a\n  :JOURNAL: %j\n  :YEAR: %y\n  :VOLUME: %v\n  :PAGES: %p\n  :DOI: %D\n  :URL: %U\n :END:\n\n"
         org-ref-notes-directory "/home/awannaphasch2016/org-roam/"
         org-ref-notes-function 'orb-edit-notes
    )


;; org-roam
(setq org-roam-directory (expand-file-name (or org-roam-directory "roam")
                                             org-directory)
        org-roam-verbose nil  ; https://youtu.be/fn4jIlFwuLU
        org-roam-buffer-no-delete-other-windows t ; make org-roam buffer sticky
        org-roam-completion-system 'default
)

;;org-roam-protocol
;; Since the org module lazy loads org-protocol (waits until an org URL is
;; detected), we can safely chain `org-roam-protocol' to it.
(use-package! org-roam-protocol
  :after org-protocol)

(desktop-save-mode 1)



;; (use-package python-mode
;;   :ensure t
;;   :hook (python-mode . lsp-deffered)
;;   :custom
;;   (python-shell-interpreter "python3")
;;   (dap-python-executable "python3")
;;   (dap-python-debugger 'debugpy)
;;   :config
;;   (require 'dap-python)
;; )

;; ;; ace-jump
;; (global-set-key (kbd "M-s a") 'evil-ace-jump-char-mode)

;; org-drill
(add-to-list 'load-path "~/org/space-repetition/")

;; org-tree-slide
(defun efs/presentation-setup ()
  (setq text-scale-mode-amount 3)
  (org-display-inline-images)
  (text-scale-mode 1))

(defun efs/presentation-end ()
  (text-scale-mode 0))

(use-package! org-tree-slide
  :hook ((org-tree-slide-play . efs/presentation-setup)
         (org-tree-slide-stop . efs/presentation-end))
  :custom
  (org-tree-slide-slide-in-effect t)
  (org-tree-slide-activate-message "Presentation started!")
  (org-tree-slide-deactivate-message "Presenatation finished!")
  (org-tree-slide-header t)
  (org-tree-slide-breadcrumbs " // ")
  (org-image-actual-width nil))

;; org-bullets
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

;; mu4e
; make sure emacs finds applications in /usr/local/bin
(setq exec-path (cons "/usr/local/bin" exec-path))

; require mu4e
(require 'mu4e)

; tell mu4e where my Maildir is
(setq mu4e-maildir "~/Mails")
; tell mu4e how to sync email
(setq mu4e-get-mail-command "/usr/bin/mbsync -a")
; tell mu4e to use w3m for html rendering
(setq mu4e-html2text-command "/usr/bin/w3m -T text/html")

; taken from mu4e page to define bookmarks
(add-to-list 'mu4e-bookmarks
            '("size:5M..500M"       "Big messages"     ?b))

; mu4e requires to specify drafts, sent, and trash dirs
; a smarter configuration allows to select directories according to the account (see mu4e page)
(setq mu4e-drafts-folder "/drafts")
(setq mu4e-sent-folder "/sent")
(setq mu4e-trash-folder "/trash")

; use msmtp
(setq message-send-mail-function 'message-send-mail-with-sendmail)
(setq sendmail-program "/usr/bin/msmtp")
; tell msmtp to choose the SMTP server according to the from field in the outgoing email
(setq message-sendmail-extra-arguments '("--read-envelope-from"))
(setq message-sendmail-f-is-evil 't)


;; ox-reveal
(require 'ox-reveal)

;; avy
(map! :n "g s l" #'avy-goto-line)

;; search + find + filter
(map! :leader "s F" #'find-name-dired)


;; Since note taking with emacs are still hard to integrate with the outside world.
;; I am moving on from any thing text related within emacs, and I don't mind
;; using closed source software inplace of rss emacs features.
;; ;; el-feed
;; (required 'elfeed-goodies)
;; (elfeed-goodies/setup)
;; ;; (setq elfeed-goodies/entry-pane-size 0.5)
;; (evil-define-key 'normal elfeed-show-mode-map
;;   (kbd "J") 'elfeed-goodies/split-show-next
;;   (kbd "K") 'elfeed-goodies/split-show-prev)
;; (evil-define-key 'normal elfeed-search-mode-map
;;   (kbd "J") 'elfeed-goodies/split-show-next
;;   (kbd "K") 'elfeed-goodies/split-show-prev)
;; (setq elfeed-feeds (quote
;;                     (("https://www.reddit.com/emacs.rss" emacs )
;;                      ;; ("https://hackaday.com/blog/feed/" hackaday linux)
;;                      ("https://www.reddit.com/PKMS.rss" PKM )
;;                      ("https://www.reddit.com/Zettelkasten.rss" PKM zettelkasten)
;;                      ("https://www.reddit.com/HowToHack.rss" hack )
;;                      ("https://aws.amazon.com/blogs/machine-learning/feed/" AWS amazon machine-learning)
;;                      ("https://machinelearningmastery.com/blog/feed/" machine-learning )
;;                      ("https://www.youtube.com/feeds/videos.xml?channel_id=UCHB9VepY6kYvZjj0Bgxnpbw" video machine-learning)
;;                      ("https://www.youtube.com/feeds/videos.xml?channel_id=UCZHmQk67mSJgfCCTn7xBfew" video machine-learning)
;;                      ("https://appdevelopermagazine.com/RSS" developer blockchain machine-learning open-source)
;;                      ("https://developer-tech.com/feed/" developer blockchain)
;;                      ("https://news.bitcoin.com/feed/" blockchain DeFi)
;;                      ("https://cointelegraph.com/rss" blockchain DeFi)
;;                      ("https://www.reddit.com/logseq.rss" logseq PKM )
;;                      )))

;; leetcode
(setq leetcode-prefer-language "python3")
(setq leetcode-save-solutions t)
(setq leetcode-directory "~/leetcode")

;; set pdf-view-mode as default
(add-to-list 'auto-mode-alist '("\\.pdf\\'" . pdf-view-mode))
(add-to-list 'auto-mode-alist '("\\.mermaid\\'" . mermaid-mode))
;; Uncategorized Configuration:1 ends here

;; [[file:config.org::*highlighting words and symbols][highlighting words and symbols:1]]
;; unhighlight all highlight that is highlighted by hi-lock
;; ref: https://emacs.stackexchange.com/questions/19861/how-to-unhighlight-symbol-highlighted-with-highlight-symbol-at-point
(defun anak/unhighlight-all-in-buffer ()
  "Remove all highlights made by `hi-lock' from the current buffer.
The same result can also be be achieved by \\[universal-argument] \\[unhighlight-regexp]."
  (interactive)
  (unhighlight-regexp t))
;; highlighting words and symbols:1 ends here

;; [[file:config.org::*main highlight-indentation code][main highlight-indentation code:1]]
;;; highlight-indentation.el --- Minor modes for highlighting indentation
;; Author: Anton Johansson <anton.johansson@gmail.com> - http://antonj.se
;; Created: Dec 15 23:42:04 2010
;; Version: 0.7.0
;; URL: https://github.com/antonj/Highlight-Indentation-for-Emacs
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2 of
;; the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be
;; useful, but WITHOUT ANY WARRANTY; without even the implied
;; warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
;; PURPOSE.  See the GNU General Public License for more details.
;;
;;; Commentary:
;; Customize `highlight-indentation-face', and
;; `highlight-indentation-current-column-face' to suit your theme.

;;; Code:

(defgroup highlight-indentation nil
  "Highlight Indentation"
  :prefix "highlight-indentation-"
  :group 'basic-faces)

(defface highlight-indentation-face
  ;; Fringe has non intrusive color in most color-themes
  '((t :inherit fringe))
  "Basic face for highlighting indentation guides."
  :group 'highlight-indentation)

(defcustom highlight-indentation-offset
  (if (and (boundp 'standard-indent) standard-indent) standard-indent 2)
  "Default indentation offset, used if no other can be found from
  major mode. This value is always used by
  `highlight-indentation-mode' if set buffer local. Set buffer
  local with `highlight-indentation-set-offset'"
  :type 'integer
  :group 'highlight-indentation)

(defcustom highlight-indentation-blank-lines nil
  "Show indentation guides on blank lines.  Experimental.

Known issues:
- Doesn't work well with completion popups that use overlays
- Overlays on blank lines sometimes aren't cleaned up or updated perfectly
  Can be refreshed by scrolling
- Not yet implemented for highlight-indentation-current-column-mode
- May not work perfectly near the bottom of the screen
- Point appears after indent guides on blank lines"
  :type 'boolean
  :group 'highlight-indentation)

(defvar highlight-indentation-overlay-priority 1)
(defvar highlight-indentation-current-column-overlay-priority 2)

(defconst highlight-indentation-hooks
  '((after-change-functions (lambda (start end length)
                              (highlight-indentation-redraw-region
                               start end
                               'highlight-indentation-overlay
                               'highlight-indentation-put-overlays-region))
                            t t)
    (window-scroll-functions (lambda (win start)
                               (highlight-indentation-redraw-window
                                win
                                'highlight-indentation-overlay
                                'highlight-indentation-put-overlays-region
                                start))
                             nil t)))

(defun highlight-indentation-get-buffer-windows (&optional all-frames)
  "Return a list of windows displaying the current buffer."
  (get-buffer-window-list (current-buffer) 'no-minibuf all-frames))

(defun highlight-indentation-delete-overlays-buffer (overlay)
  "Delete all overlays in the current buffer."
  (save-restriction
    (widen)
    (highlight-indentation-delete-overlays-region (point-min) (point-max) overlay)))

(defun highlight-indentation-delete-overlays-region (start end overlay)
  "Delete overlays between START and END."
  (mapc #'(lambda (o)
            (if (overlay-get o overlay) (delete-overlay o)))
        (overlays-in start end)))

(defun highlight-indentation-redraw-window (win overlay func &optional start)
  "Redraw win starting from START."
  (highlight-indentation-redraw-region (or start (window-start win)) (window-end win t) overlay func))

(defun highlight-indentation-redraw-region (start end overlay func)
  "Erase and read overlays between START and END."
  (save-match-data
    (save-excursion
      (let ((inhibit-point-motion-hooks t)
            (start (save-excursion (goto-char start) (beginning-of-line) (point)))

            (end (save-excursion (goto-char end) (line-beginning-position 2))))
        (highlight-indentation-delete-overlays-region start end overlay)
        (funcall func start end overlay)))))

(defun highlight-indentation-redraw-all-windows (overlay func &optional all-frames)
  "Redraw the all windows showing the current buffer."
  (dolist (win (highlight-indentation-get-buffer-windows all-frames))
    (highlight-indentation-redraw-window win overlay func)))

(defun highlight-indentation-put-overlays-region (start end overlay)
  "Place overlays between START and END."
  (goto-char end)
  (let (o ;; overlay
        (last-indent 0)
        (last-char 0)
        (pos (point))
        (loop t))
    (while (and loop
                (>= pos start))
      (save-excursion
        (beginning-of-line)
        (let ((c 0)
              (cur-column (current-column)))
          (while (and (setq c (char-after))
                      (integerp c)
                      (not (= 10 c)) ;; newline
                      (= 32 c)) ;; space
            (when (= 0 (% cur-column highlight-indentation-offset))
              (let ((p (point)))
                (setq o (make-overlay p (+ p 1))))
              (overlay-put o overlay t)
              (overlay-put o 'priority highlight-indentation-overlay-priority)
              (overlay-put o 'face 'highlight-indentation-face))
            (forward-char)
            (setq cur-column (current-column)))
          (when (and highlight-indentation-blank-lines
                     (integerp c)
                     (or (= 10 c)
                         (= 13 c)))
            (when (< cur-column last-indent)
              (let ((column cur-column)
                    (s nil)
                    (show t)
                    num-spaces)
                (while (< column last-indent)
                  (if (>= 0
                          (setq num-spaces
                                (%
                                 (- last-indent column)
                                 highlight-indentation-offset)))
                      (progn
                        (setq num-spaces (1- highlight-indentation-offset))
                        (setq show t))
                    (setq show nil))
                  (setq s (cons (concat
                                 (if show
                                     (propertize " "
                                                 'face
                                                 'highlight-indentation-face)
                                   "")
                                 (make-string num-spaces 32))
                                s))
                  (setq column (+ column num-spaces (if show 1 0))))
                (setq s (apply 'concat (reverse s)))
                (let ((p (point)))
                  (setq o (make-overlay p p)))
                (overlay-put o overlay t)
                (overlay-put o 'priority highlight-indentation-overlay-priority)
                (overlay-put o 'after-string s))
              (setq cur-column last-indent)))
          (setq last-indent (* highlight-indentation-offset
                               (ceiling (/ (float cur-column)
                                           highlight-indentation-offset))))))
      (when (= pos start)
        (setq loop nil))
      (forward-line -1) ;; previous line
      (setq pos (point)))))

(defun highlight-indentation-guess-offset ()
  "Get indentation offset of current buffer."
  (cond ((and (eq major-mode 'python-mode) (boundp 'python-indent))
         python-indent)
        ((and (eq major-mode 'python-mode) (boundp 'py-indent-offset))
         py-indent-offset)
        ((and (eq major-mode 'python-mode) (boundp 'python-indent-offset))
         python-indent-offset)
        ((and (eq major-mode 'ruby-mode) (boundp 'ruby-indent-level))
         ruby-indent-level)
        ((and (eq major-mode 'scala-mode) (boundp 'scala-indent:step))
         scala-indent:step)
        ((and (eq major-mode 'scala-mode) (boundp 'scala-mode-indent:step))
         scala-mode-indent:step)
        ((and (or (eq major-mode 'scss-mode) (eq major-mode 'css-mode)) (boundp 'css-indent-offset))
         css-indent-offset)
        ((and (eq major-mode 'nxml-mode) (boundp 'nxml-child-indent))
         nxml-child-indent)
        ((and (eq major-mode 'coffee-mode) (boundp 'coffee-tab-width))
         coffee-tab-width)
        ((and (eq major-mode 'js-mode) (boundp 'js-indent-level))
         js-indent-level)
        ((and (eq major-mode 'js2-mode) (boundp 'js2-basic-offset))
         js2-basic-offset)
        ((and (fboundp 'derived-mode-class) (eq (derived-mode-class major-mode) 'sws-mode) (boundp 'sws-tab-width))
         sws-tab-width)
        ((and (eq major-mode 'web-mode) (boundp 'web-mode-markup-indent-offset))
         web-mode-markup-indent-offset) ; other similar vars: web-mode-{css-indent,scripts}-offset
        ((and (eq major-mode 'web-mode) (boundp 'web-mode-html-offset)) ; old var
         web-mode-html-offset)
        ((and (local-variable-p 'c-basic-offset) (boundp 'c-basic-offset))
         c-basic-offset)
        ((and (eq major-mode 'yaml-mode) (boundp 'yaml-indent-offset))
         yaml-indent-offset)
        ((and (eq major-mode 'elixir-mode) (boundp 'elixir-smie-indent-basic))
         elixir-smie-indent-basic)
        (t
         (default-value 'highlight-indentation-offset))))

;;;###autoload
(define-minor-mode highlight-indentation-mode
  "Highlight indentation minor mode highlights indentation based on spaces"
  :lighter " ||"
  (when (not highlight-indentation-mode) ;; OFF
    (highlight-indentation-delete-overlays-buffer 'highlight-indentation-overlay)
    (dolist (hook highlight-indentation-hooks)
      (remove-hook (car hook) (nth 1 hook) (nth 3 hook))))

  (when highlight-indentation-mode ;; ON
    (when (not (local-variable-p 'highlight-indentation-offset))
      (set (make-local-variable 'highlight-indentation-offset)
           (highlight-indentation-guess-offset)))

    ;; Setup hooks
    (dolist (hook highlight-indentation-hooks)
      (apply 'add-hook hook))
    (highlight-indentation-redraw-all-windows 'highlight-indentation-overlay
                                              'highlight-indentation-put-overlays-region)))

;;;###autoload
(defun highlight-indentation-set-offset (offset)
  "Set indentation offset locally in buffer, will prevent
highlight-indentation from trying to guess indentation offset
from major mode"
  (interactive
   (if (and current-prefix-arg (not (consp current-prefix-arg)))
       (list (prefix-numeric-value current-prefix-arg))
     (list (read-number "Indentation offset: "))))
  (set (make-local-variable 'highlight-indentation-offset) offset)
  (when highlight-indentation-mode
    (highlight-indentation-mode)))

;;; This minor mode will highlight the indentation of the current line
;;; as a vertical bar (grey background color) aligned with the column of the
;;; first character of the current line.
(defface highlight-indentation-current-column-face
  ;; Fringe has non intrusive color in most color-themes
  '((t (:background "black")))
  "Basic face for highlighting indentation guides."
  :group 'highlight-indentation)

(defconst highlight-indentation-current-column-hooks
  '((post-command-hook (lambda ()
                         (highlight-indentation-redraw-all-windows 'highlight-indentation-current-column-overlay
                                                                   'highlight-indentation-current-column-put-overlays-region)) nil t)))

(defun highlight-indentation-current-column-put-overlays-region (start end overlay)
  "Place overlays between START and END."
  (let (o ;; overlay
        (last-indent 0)
        (indent (save-excursion (back-to-indentation) (current-column)))
        (pos start))
    (goto-char start)
    ;; (message "doing it %d" indent)
    (while (< pos end)
      (beginning-of-line)
      (while (and (integerp (char-after))
                  (not (= 10 (char-after))) ;; newline
                  (= 32 (char-after))) ;; space
        (when (= (current-column) indent)
          (setq pos (point)
                last-indent pos
                o (make-overlay pos (+ pos 1)))
          (overlay-put o overlay t)
          (overlay-put o 'priority highlight-indentation-current-column-overlay-priority)
          (overlay-put o 'face 'highlight-indentation-current-column-face))
        (forward-char))
      (forward-line) ;; Next line
      (setq pos (point)))))

;;;###autoload
(define-minor-mode highlight-indentation-current-column-mode
  "Highlight Indentation minor mode displays a vertical bar
corresponding to the indentation of the current line"
  :lighter " |"

  (when (not highlight-indentation-current-column-mode) ;; OFF
    (highlight-indentation-delete-overlays-buffer 'highlight-indentation-current-column-overlay)
    (dolist (hook highlight-indentation-current-column-hooks)
      (remove-hook (car hook) (nth 1 hook) (nth 3 hook))))

  (when highlight-indentation-current-column-mode ;; ON
    (when (not (local-variable-p 'highlight-indentation-offset))
      (set (make-local-variable 'highlight-indentation-offset)
           (highlight-indentation-guess-offset)))

    ;; Setup hooks
    (dolist (hook highlight-indentation-current-column-hooks)
      (apply 'add-hook hook))
    (highlight-indentation-redraw-all-windows 'highlight-indentation-current-column-overlay
                                              'highlight-indentation-current-column-put-overlays-region)))

;; (provide 'highlight-indentation)

;;; highlight-indentation.el ends here
;; main highlight-indentation code:1 ends here

;; [[file:config.org::*toggle folds based on indentation levels][toggle folds based on indentation levels:1]]
(defun anak/toggle-fold ()
  "Toggle fold all lines larger than indentation on current line"
  (interactive)
  (let ((col 1))
    (save-excursion
      (back-to-indentation)
      (setq col (+ 1 (current-column)))
      (set-selective-display
       (if selective-display nil (or col 1))))))
;; (global-set-key [(M C i)] 'aj-toggle-fold)
;; (global-set-key (kbd "z a") 'anak/toggle-fold)
(map! :n "z a" #'anak/toggle-fold)
;; toggle folds based on indentation levels:1 ends here

;; [[file:config.org::*insert current date][insert current date:1]]
;; ref: https://www.emacswiki.org/emacs/InsertingTodaysDate
;; inserting todays date using shell
(defun anak/insert-current-date ()
  (interactive)
  (insert (calendar-date-string (calendar-current-date) nil t)))
;; insert current date:1 ends here

;; [[file:config.org::*benchmarking][benchmarking:1]]

;; benchmarking:1 ends here

;; [[file:config.org::*basic configuration][basic configuration:1]]
(setq desktop-save-mode nil)
(setq load-prefer-newer t)
(setq which-function-mode t)
;; basic configuration:1 ends here

;; [[file:config.org::*configuration to increase ease of editing.][configuration to increase ease of editing.:1]]
;; recommended by https://dr-knz.net/a-tour-of-emacs-as-go-editor.html
(global-visual-line-mode 1)
(global-hl-line-mode 1)
(show-paren-mode 1)
;; configuration to increase ease of editing.:1 ends here

;; [[file:config.org::*configuration to encourage code formating syle][configuration to encourage code formating syle:1]]
;; recommended by https://dr-knz.net/a-tour-of-emacs-as-go-editor.html
(global-whitespace-mode 1)
;; see the apropos entry for whitespace-style
(setq
   whitespace-style
   '(face ; viz via faces
     trailing ; trailing blanks visualized
     ;; tabs
     ;; tab-mark
     ;; indentation::tab
     ; lines-tail ; lines beyond
                ; whitespace-line-column
     space-before-tab
     space-after-tab
     newline ; lines with only blanks
     indentation ; spaces used for indent
                 ; when config wants tabs
     empty ; empty lines at beginning or end
     )
   whitespace-line-column 100 ; column at which
        ; whitespace-mode says the line is too long
)

(add-to-list 'browse-url-filename-alist '("^~+" . "file:///home/awannaphasch2016"))
;; configuration to encourage code formating syle:1 ends here

;; [[file:config.org::*Using exec-path-from-shell][Using exec-path-from-shell:1]]
;; ;; If you launch Emacs as a daemon from systemd or similar, you might like to use the following snippet:
;; (when (daemonp)
;;   (exec-path-from-shell-initialize))

;; ;; Below is used when you execute in a GUI frame on OS X and linux. This sets $MANPATH, $PATH and exec-path from your shell.
;; (when (memq window-system '(mac ns x))
;;   (exec-path-from-shell-initialize))
;; Using exec-path-from-shell:1 ends here

;; [[file:config.org::*Python Environment][Python Environment:1]]
;; (setenv "WORKON_HOME" "~/anaconda3/envs/" )
;; (pyvenv-mode 1)
;; Python Environment:1 ends here

;; [[file:config.org::*simple-httpd][simple-httpd:1]]
(use-package! simple-httpd)
;; simple-httpd:1 ends here

;; [[file:config.org::*Bookmark][Bookmark:1]]
;; (use-package bookmark+
;;                 :quelpa (bookmark+ :fetcher wiki
;;                                 :files
;;                                 ("bookmark+.el"
;;                                     "bookmark+-mac.el"
;;                                     "bookmark+-bmu.el"
;;                                     "bookmark+-1.el"
;;                                     "bookmark+-key.el"
;;                                     "bookmark+-lit.el"
;;                                     "bookmark+-doc.el"
;;                                     "bookmark+-chg.el"))
;;                 :defer 2)
;; Bookmark:1 ends here

;; [[file:config.org::*ERC (IRC client)][ERC (IRC client):1]]
(setq erc-server "irc.libera.chat"
      erc-nick "Garun"
      erc-user-full-name "Anak Wannaphaschaiyong"
      erc-track-shorten-start 8 ; limit chars in mode line
      erc-autojoin-channels-alist '(("irc.libera.chat" "#systemcrafters" "#emacs")) erc-kill-buffer-on-part t
      erc-auto-query 'bury)
;; ERC (IRC client):1 ends here

;; [[file:config.org::*Emacs Tree Sitter][Emacs Tree Sitter:1]]
;; ref: https://emacs-tree-sitter.github.io/syntax-highlighting/
(global-tree-sitter-mode)
;; (add-hook 'rustic-mode-hook #'tree-sitter-hl-mode)
;; (add-hook 'python-mode-hook #'tree-sitter-hl-mode)
(add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode) ;; enable whenever possible
;; Emacs Tree Sitter:1 ends here

;; [[file:config.org::*Windows][Windows:1]]
(map! :leader "w a" #'ace-window)
(map! :leader "w 0" #'+workspace/close-window-or-workspace)
(map! :leader "w 1" #'delete-other-windows)
(map! :leader "w r" #'winner-redo)
(map! :leader "w f" #'find-file-other-window)
;; Windows:1 ends here

;; [[file:config.org::*Python Modes][Python Modes:1]]
;; (add-to-list 'exec-path "~/anaconda3/envs/py38/lib/python3.8/site-packages/") ;; may not need it
(add-hook 'python-mode-hook 'highlight-indentation-mode)
;; Python Modes:1 ends here

;; [[file:config.org::*TLA+ Mode][TLA+ Mode:1]]
(add-to-list 'load-path "~/.emacs.d/manual-install/tlamode/lisp/")
(require 'tla+-mode)
(setq tla+-tlatools-path "~/.emacs.d/manual-install/tlamode/")
;; TLA+ Mode:1 ends here

;; [[file:config.org::*Go Mode][Go Mode:1]]
;; get the PATH environment
(defun set-exec-path-from-shell-PATH ()
  (let ((path-from-shell (replace-regexp-in-string
                          "[ \t\n]*$"
                          ""
                          (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq eshell-path-env path-from-shell) ; for eshell users
    (setq exec-path (split-string path-from-shell path-separator))))

(when window-system (set-exec-path-from-shell-PATH))
;; Go Mode:1 ends here

;; [[file:config.org::*Go Mode][Go Mode:2]]
;; (setenv "GOPATH" "/home/awannaphasch2016/org/projects/sideprojects/blockchains/go")
;; Go Mode:2 ends here

;; [[file:config.org::*Go Mode][Go Mode:3]]
;; (add-to-list 'exec-path "/usr/local/go/bin/")
;; (add-hook 'before-save-hook 'gofmt-before-save)
;; Go Mode:3 ends here

;; [[file:config.org::*Go Mode][Go Mode:4]]
(add-hook 'go-mode-hook (lambda ()
                               (setq tab-width 4)))
;; Go Mode:4 ends here

;; [[file:config.org::*Web Mode][Web Mode:1]]
(map! :leader "m e j" #'web-mode-element-sibling-next)
(map! :leader "m e k" #'web-mode-element-sibling-previous)
(eval-after-load 'web-mode
  '(define-key web-mode-map (kbd "C-c b") 'web-beautify-html))
;; Web Mode:1 ends here

;; [[file:config.org::*lispy][lispy:1]]
(use-package lispy
    :custom
    (map! ";" #'lispy-comment)
  )
;; lispy:1 ends here

;; [[file:config.org::*lispyville][lispyville:1]]
;; (add-hook 'emacs-lisp-mode-hook #'lispyville-mode)
;; lispyville:1 ends here

;; [[file:config.org::*Scala Mode][Scala Mode:1]]
;; ref: https://ag91.github.io/blog/2020/10/16/my-emacs-setup-for-scala-development/
(use-package scala-mode
  :mode "\\.s\\(cala\\|bt\\)$"
  :config
    (load-file "~/.emacs.d/.local/straight/repos/org/lisp/ob-scala.el"))
;; Scala Mode:1 ends here

;; [[file:config.org::*cfn lint][cfn lint:1]]
;; Set up a mode for JSON based templates

(define-derived-mode cfn-json-mode js-mode
    "CFN-JSON"
    "Simple mode to edit CloudFormation template in JSON format."
    (setq js-indent-level 2))

(add-to-list 'magic-mode-alist
             '("\\({\n *\\)? *[\"']AWSTemplateFormatVersion" . cfn-json-mode))

;; Set up a mode for YAML based templates if yaml-mode is installed
;; Get yaml-mode here https://github.com/yoshiki/yaml-mode
(when (featurep 'yaml-mode)

  (define-derived-mode cfn-yaml-mode yaml-mode
    "CFN-YAML"
    "Simple mode to edit CloudFormation template in YAML format.")

  (add-to-list 'magic-mode-alist
               '("\\(---\n\\)?AWSTemplateFormatVersion:" . cfn-yaml-mode)))

;; Set up cfn-lint integration if flycheck is installed
;; Get flycheck here https://www.flycheck.org/
(when (featurep 'flycheck)
  (flycheck-define-checker cfn-lint
    "AWS CloudFormation linter using cfn-lint.

Install cfn-lint first: pip install cfn-lint

See `https://github.com/aws-cloudformation/cfn-python-lint'."

    :command ("cfn-lint" "-f" "parseable" source)
    :error-patterns ((warning line-start (file-name) ":" line ":" column
                              ":" (one-or-more digit) ":" (one-or-more digit) ":"
                              (id "W" (one-or-more digit)) ":" (message) line-end)
                     (error line-start (file-name) ":" line ":" column
                            ":" (one-or-more digit) ":" (one-or-more digit) ":"
                            (id "E" (one-or-more digit)) ":" (message) line-end))
    :modes (cfn-json-mode cfn-yaml-mode))

  (add-to-list 'flycheck-checkers 'cfn-lint)
  (add-hook 'cfn-json-mode-hook 'flycheck-mode)
  (add-hook 'cfn-yaml-mode-hook 'flycheck-mode))
;; cfn lint:1 ends here

;; [[file:config.org::*Dap Mode][Dap Mode:1]]
;; dap-mode
(require 'dap-mode)
(require 'dap-ui)
;; (require 'dap-lldb)
(require 'dap-cpptools)
(require 'dap-gdb-lldb)
(require 'dap-python)

(map! :leader "d d" #'dap-debug) ;; d for debug
(map! :leader "d r" #'dap-debug-last) ;; r for repeat
(map! :leader "d l" #'dap-ui-breakpoints-list) ;; l for repeat
(map! :leader "d m" #'dap-breakpoint-log-message) ;; l for repeat
(map! :leader "d q" #'dap-disconnect)
(map! :leader "d a" #'dap-breakpoint-add)
(map! :leader "d t" #'dap-breakpoint-toggle)
(map! :leader "d e" #'dap-debug-edit-template)
(map! :leader "d n" #'dap-next)
(map! :leader "d c" #'dap-continue)
(map! :leader "d ." #'dap-ui-repl)
(map! :leader "d i" #'dap-step-in)
(map! :leader "d u a" #'dap-ui-expressions-add)
(map! :leader "d u r" #'dap-ui-expressions-remove)
(map! :leader "d u l" #'dap-ui-locals)
(map! :leader "d u e" #'dap-ui-expressions)
(map! :leader "d u s" #'dap-ui-sessions)
;; Enabling only some features
(setq dap-auto-configure-features '(sessions locals controls expressions tooltip))
(setq dap-python-debugger 'debugpy)
;; Dap Mode:1 ends here

;; [[file:config.org::*LSP-mode][LSP-mode:1]]
;; ref: https://scalameta.org/metals/docs/editors/emacs/
(use-package lsp-mode
  ;; Optional - enable lsp-mode automatically in scala files
  :hook  (scala-mode . lsp)
         ;; (lsp-mode . lsp-lens-mode)
  :config
  ;; Uncomment following section if you would like to tune lsp-mode performance according to
  ;; https://emacs-lsp.github.io/lsp-mode/page/performance/
  ;;       (setq gc-cons-threshold 100000000) ;; 100mb
  ;;       (setq read-process-output-max (* 1024 1024)) ;; 1mb
  ;;       (setq lsp-idle-delay 0.500)
  ;;       (setq lsp-log-io nil)
  ;;       (setq lsp-completion-provider :capf)
  (setq lsp-prefer-flymake nil))

(require 'lsp-mode)
;; enable lsp breadcrumb on headline
(setq lsp-headerline-breadcrumb-enable t)
(setq lsp-headerline-breadcrumb-segments '(project file symbols))
(setq lsp-headerline-breadcrumb-icons-enable t)
;; disable mspyls client for python mode
;; lsp is too goddamn slow for python-mode, so I turn disable all of them.
;; (setq lsp-disabled-clients '((python-mode . mspyls) (python-mode . pyls) (python-mode . pylsp)))
(setq lsp-disabled-clients '((python-mode . mspyls) (python-mode . pyls) (python-mode . pylsp)))
;; (setq lsp-disabled-clients '((python-mode . mspyls) (python-mode . pyls)))
;; (setq lsp-disabled-clients '((go-mode . gopls)))
;; (+lsp/switch-client pyls) ; this doesn't work.
;; LSP-mode:1 ends here

;; [[file:config.org::*pyright setup][pyright setup:1]]
;; ref: https://github.com/emacs-lsp/lsp-pyright
(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp))))  ; or lsp-deferred
;; pyright setup:1 ends here

;; [[file:config.org::*pylsp setup][pylsp setup:1]]
(setq lsp-pylsp-plugins-flake8-enabled nil)
;; pylsp setup:1 ends here

;; [[file:config.org::*lsp for Go][lsp for Go:1]]
;; (add-hook 'go-mode-hook #'lsp)
(add-hook 'go-mode-hook #'lsp-deferred)

;; config below is obtained from https://github.com/golang/tools/blob/master/gopls/doc/emacs.md#configuring-lsp-mode
;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.
;; (defun lsp-go-install-save-hooks ()
;;   (add-hook 'before-save-hook #'lsp-format-buffer t t)
;;   (add-hook 'before-save-hook #'lsp-organize-imports t t))
;; (add-hook 'go-mode-hook #'lsp-go-install-save-hooks)
;; lsp for Go:1 ends here

;; [[file:config.org::*lsp for Go][lsp for Go:2]]
(lsp-register-custom-settings
 '(("gopls.completeUnimported" t t)
   ("gopls.staticcheck" t t)))
;; lsp for Go:2 ends here

;; [[file:config.org::*lsp for Go][lsp for Go:3]]
;; (add-to-list 'exec-path "/usr/local/go/bin")
;; (add-to-list 'exec-path "/usr/local/go/bin/go")
;; (add-to-list 'exec-path "/home/awannaphasch2016/go/bin")
;; (add-to-list 'exec-path "/home/awannaphasch2016/go/bin/go")
;; (add-to-list 'exec-path "/home/awannaphasch2016/go/bin/gopls")
;; lsp for Go:3 ends here

;; [[file:config.org::*lsp for scala][lsp for scala:1]]
(use-package! lsp-metals
  ;; :custom
  ;; ;; Metals claims to support range formatting by default but it supports range
  ;; ;; formatting of multiline strings only. You might want to disable it so that
  ;; ;; emacs can use indentation provided by scala-mode.
  ;; (lsp-metals-server-args '("-J-Dmetals.allow-multiline-string-formatting=off"))
  :hook (scala-mode . lsp))
;; lsp for scala:1 ends here

;; [[file:config.org::*lsp for C language family][lsp for C language family:1]]
;; config is taken from ~/.emacs.d/modules/lang/cc/README.org
(setq lsp-clients-clangd-args '("-j=3"
                                "--background-index"
                                "--clang-tidy"
                                "--completion-style=detailed"
                                "--header-insertion=never"
                                "--header-insertion-decorators=0"))
(after! lsp-clangd (set-lsp-priority! 'clangd 2))
;; lsp for C language family:1 ends here

;; [[file:config.org::*evil-paredit][evil-paredit:1]]
;; (add-hook 'emacs-lisp-mode-hook 'evil-paredit-mode)
;; evil-paredit:1 ends here

;; [[file:config.org::*paredit-everywhere][paredit-everywhere:1]]
;; (add-hook 'prog-mode-hook 'paredit-everywhere-mode)
;; paredit-everywhere:1 ends here

;; [[file:config.org::*Semantic mode][Semantic mode:1]]
;; (advice-add 'semantic-idle-scheduler-function :around #'ignore) ;; keep it uncomment  I never use it, but put it here for context.
;; Semantic mode:1 ends here

;; [[file:config.org::*Semantic Stickyfunc mode][Semantic Stickyfunc mode:1]]
;; ref: https://emacs.stackexchange.com/questions/3145/display-the-beginning-of-a-scope-when-it-is-out-of-screen
;; (add-to-list 'semantic-default-submodes 'global-semantic-stickyfunc-mode)
;; (semantic-mode 1)
;; (require 'stickyfunc-enhance)
;; Semantic Stickyfunc mode:1 ends here

;; [[file:config.org::*format-all][format-all:1]]
(setq +format-on-save-enabled-modes '(not emacs-lisp-mode sql-mode tex-mode latex-mode org-msg-edit-mode python-mode))
;; format-all:1 ends here

;; [[file:config.org::*flycheck][flycheck:1]]
;; (setq flycheck-global-modes '(not python-mode))
;; flycheck:1 ends here

;; [[file:config.org::*Helm][Helm:1]]
;; conduct search on symbol (it can be used in complementary to M-x consult-imenu. They suppose to do the same thing, but differ in few important aspect.)
(map! :leader "s h" #'helm-semantic-or-imenu)
;; Helm:1 ends here

;; [[file:config.org::*Dap Mode =debug.el= Configuration][Dap Mode =debug.el= Configuration:1]]
(dap-register-debug-template
  "Python :: Run file (preprocess expert labels)"
  (list :type "python"
        :name "gdb::run with arguments"
        ;; :argument "-d reddit --use_memory --prefix tgn-attn-reddit --n_runs=10"
        :args (list "--data" "reddit_with_expert_labels_10000" "--bipartite")
        ;; :args (list "-d" "reddit --use_memory --prefix tgn-attn-reddit --n_runs=10")
        :cwd "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/"
        :module nil
        :program "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/utils/preprocess_data.py"
        :request "launch"))

;; train_self_supervised (aka link prediction)

(dap-register-debug-template
 "Python :: Run file (train_self_supervised + tuning)"
  (list :type "python"
        :name "gdb::run with arguments"
        ;; :args (list "-d" "reddit_10000" "--use_memory" "--n_runs" "1" "--n_epoch" "5" "--bs" "200" "--run_tuning" "--n_tuning_samples" "4")
        :args (list "-d" "reddit_10000" "--use_memory" "--n_runs" "1" "--run_tuning" "--n_tuning_samples" "4")
        ;; :args (list "-d" "reddit --use_memory --prefix tgn-attn-reddit --n_runs=10")
        :cwd "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/"
        :module nil
        :program "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/train_self_supervised.py"
        :request "launch"))

(dap-register-debug-template
  "Python :: Run train_self_supervised (buffer)"
  (list :type "python"
        :name "gdb::run with arguments"
        ;; :argument "-d reddit --use_memory --prefix tgn-attn-reddit --n_runs=10"
        :args (list "-d" "reddit" "--use_memory" "--n_runs" "5")
        ;; :args (list "-d" "reddit --use_memory --prefix tgn-attn-reddit --n_runs=10")
        :cwd nil
        :module nil
        :program "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/train_self_supervised.py"
        :request "launch"))

(dap-register-debug-template
  "Python :: Run file (train_self_supervised with 10000 expert labels + update memory at the end)"
  (list :type "python"
        :name "gdb::run with arguments"
        ;; :argument "-d reddit --use_memory --prefix tgn-attn-reddit --n_runs=10"
        ;; :args (list "-d" "reddit_user_id_item_id_relative_freq_and_eq_value_with_label" "--use_memory" "--prefix" "tgn-attn-reddi" "--n_runs" "10"
        :args (list "-d" "reddit_with_expert_labels_10000" "--use_memory" "--n_runs" "10" "--n_epoch" "5" "--memory_update_at_end")
        ;; :args (list "-d" "reddit --use_memory --prefix tgn-attn-reddit --n_runs=10")
        :cwd "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/"
        :module nil
        :program "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/train_self_supervised.py"
        :request "launch"))

(dap-register-debug-template
  "Python :: Run file (train_self_supervised with 10000 labels)"
  (list :type "python"
        :name "gdb::run with arguments"
        ;; :argument "-d reddit --use_memory --prefix tgn-attn-reddit --n_runs=10"
        ;; :args (list "-d" "reddit_user_id_item_id_relative_freq_and_eq_value_with_label" "--use_memory" "--prefix" "tgn-attn-reddi" "--n_runs" "10"
        :args (list "-d" "reddit_with_expert_labels_10000" "--use_memory" "--n_runs" "1" "--n_epoch" "5")
        :args (list "-d" "wikipedia_10000" "--use_memory" "--n_runs" "10" "--n_epoch" "5" "--bs" "1000" "--ws_multiplier" "1" "--use_ef_iwf_weight" "--custom_prefix" "tmp" "--ws_framework" "forward" "--use_time_decay")
        ;; :args (list "-d" "reddit --use_memory --prefix tgn-attn-reddit --n_runs=10")
        :cwd "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/"
        :module nil
        :program "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/train_self_supervised.py"
        :request "launch"))

(dap-register-debug-template
  "Python :: Run file (train_self_supervised with 10000 expert labels + use_ef_iwf_weight)"
  (list :type "python"
        :name "gdb::run with arguments"
        ;; :argument "-d reddit --use_memory --prefix tgn-attn-reddit --n_runs=10"
        ;; :args (list "-d" "reddit_user_id_item_id_relative_freq_and_eq_value_with_label" "--use_memory" "--prefix" "tgn-attn-reddi" "--n_runs" "10"
        :args (list "-d" "reddit_with_expert_labels_10000" "--use_memory" "--n_runs" "1" "--n_epoch" "5" "--use_ef_iwf_weight")
        ;; :args (list "-d" "reddit --use_memory --prefix tgn-attn-reddit --n_runs=10")
        :cwd "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/"
        :module nil
        :program "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/train_self_supervised.py"
        :request "launch"))

(dap-register-debug-template
  "Python :: Run file (train_self_supervised with 10000 instances + use_nf_iwf_neg_sampling)"
  (list :type "python"
        :name "gdb::run with arguments"
        :args (list "-d" "reddit_10000" "--use_memory"  "--n_runs" "1" "--n_epoch" "5" "--use_nf_iwf_neg_sampling")
        ;; :args (list "-d" "reddit --use_memory --prefix tgn-attn-reddit --n_runs=10")
        :cwd "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/"
        :module nil
        :program "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/train_self_supervised.py"
        :request "launch"))

(dap-register-debug-template
  "Python :: Run file (train_self_supervised with 10000 instances + use_sigmoid_ef_iwf_weight)"
  (list :type "python"
        :name "gdb::run with arguments"
        :args (list "-d" "reddit_10000" "--use_memory" "--n_runs" "1" "--n_epoch" "5" "--use_sigmoid_ef_iwf_weight")
        ;; :args (list "-d" "reddit --use_memory --prefix tgn-attn-reddit --n_runs=10")
        :cwd "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/"
        :module nil
        :program "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/train_self_supervised.py"
        :request "launch"))

(dap-register-debug-template
  "Python :: Run file (train_self_supervised with 100000 instances + use_ef_iwf_weight)"
  (list :type "python"
        :name "gdb::run with arguments"
        :args (list "-d" "reddit_100000" "--use_memory" "--n_runs" "1" "--n_epoch" "5" "--use_ef_iwf_weight")
        ;; :args (list "-d" "reddit --use_memory --prefix tgn-attn-reddit --n_runs=10")
        :cwd "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/"
        :module nil
        :program "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/train_self_supervised.py"
        :request "launch"))

(dap-register-debug-template
  "Python :: Run file (train_self_supervised + 10k instances + use_ef_weight)"
  (list :type "python"
        :name "gdb::run with arguments"
        ;; :args (list "-d" "reddit_10000" "--use_memory" "--n_runs" "1" "--n_epoch" "1" "--bs" "1000" "--ws_multiplier" "1" "--custom_prefix" "tmp" "--ws_framework" "forward" "")
        :args (list "-d" "reddit_10000" "--use_memory" "--n_runs" "1" "--n_epoch" "1" "--bs" "1000" "--ws_multiplier" "1" "--custom_prefix" "tmp" "--ws_framework" "forward" "--use_ef_weight")
        ;; :args (list "-d" "reddit --use_memory --prefix tgn-attn-reddit --n_runs=10")
        :cwd "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/"
        :module nil
        :program "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/train_self_supervised.py"
        :request "launch"))

(dap-register-debug-template
  "Python :: Run file (train_self_supervised testing args)"
  (list :type "python"
        :name "gdb::run with arguments"
        ;; :args (list "-d" "reddit_10000" "--use_memory" "--n_runs" "1" "--n_epoch" "5" "--bs" "1000" "--ws_multiplier" "1" "--custom_prefix" "tmp" "--ws_framework" "forward"  "--keep_last_n_window_as_window_slides" "3" "--window_stride_multiplier" "2" "--use_nf_weight" "--window_idx_to_start_with" "3" "--disable_cuda")
        ;; :args (list "-d" "reddit_10000" "--use_memory" "--n_runs" "1" "--n_epoch" "2" "--bs" "1000" "--ws_multiplier" "1" "--custom_prefix" "tmp" "--ws_framework" "forward" "--window_stride_multiplier" "1" "--use_nf_weight" "--disable_cuda")
        :args (list "-d" "reddit_10000" "--use_memory" "--n_runs" "1" "--n_epoch" "5" "--bs" "200" "--ws_multiplier" "1" "--custom_prefix" "tmp" "--ws_framework" "ensemble" "--disable_cuda")
        :cwd "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/"
        :module nil
        :program "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/train_self_supervised.py"
        :request "launch"))

(dap-register-debug-template
  "Python :: Run file (train_self_supervised testing args 1)"
  (list :type "python"
        :name "gdb::run with arguments"
        ;; :args (list "-d" "reddit_10000" "--use_memory" "--n_runs" "1" "--n_epoch" "5" "--bs" "200" "--use_random_weight_to_benchmark_ef_iwf_1")
        :args (list "-d" "mooc_10000" "--use_memory" "--n_runs" "5" "--n_epoch" "3" "--bs" "1000" "--ws_multiplier" "1" "--use_ef_iwf_weight" "--custom_prefix" "tmp" "--ws_framework" "forward")
        ;; :args (list "-d" "reddit --use_memory --prefix tgn-attn-reddit --n_runs=10")
        :cwd "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/"
        :module nil
        :program "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/train_self_supervised.py"
        :request "launch"))

(dap-register-debug-template
  "Python :: Run file (train_self_supervised testing args 2)"
  (list :type "python"
        :name "gdb::run with arguments"
        ;; :args (list "-d" "reddit_10000" "--use_memory" "--n_runs" "1" "--n_epoch" "5" "--bs" "200" "--use_random_weight_to_benchmark_ef_iwf_1")
        :args (list "-d" "reddit_10000" "--use_memory" "--n_runs" "1" "--n_epoch" "5" "--bs" "1000" "--ws_multiplier" "1" "--use_ef_iwf_weight" "--custom_prefix" "tmp" "--ws_framework" "forward" "--use_time_decay")
        ;; :args (list "-d" "reddit --use_memory --prefix tgn-attn-reddit --n_runs=10")
        :cwd "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/"
        :module nil
        :program "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/train_self_supervised.py"
        :request "launch"))

(dap-register-debug-template
  "Python :: Run file (train_self_supervised with 10000 instances + wikipedia_10000)"
  (list :type "python"
        :name "gdb::run with arguments"
        ;; :args (list "-d" "reddit_10000" "--use_memory"  "--n_runs" "1" "--n_epoch" "5" "--use_nf_iwf_neg_sampling")
        :args (list "-d" "wikipedia_10000" "--use_memory" "--n_runs" "1" "--n_epoch" "5" "--bs" "1000" "--ws_multiplier" "2"  "--custom_prefix" "tmp" "--ws_framework" "ensemble")
        ;; :args (list "-d" "reddit --use_memory --prefix tgn-attn-reddit --n_runs=10")
        :cwd "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/"
        :module nil
        :program "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/train_self_supervised.py"
        :request "launch"))

(dap-register-debug-template
  "Python :: Run file (train_self_supervised with 10000 instances + lastfm_10000)"
  (list :type "python"
        :name "gdb::run with arguments"
        ;; :args (list "-d" "reddit_10000" "--use_memory"  "--n_runs" "1" "--n_epoch" "5" "--use_nf_iwf_neg_sampling")
        :args (list "-d" "lastfm_10000" "--use_memory" "--n_runs" "1" "--n_epoch" "5" "--bs" "1000" "--ws_multiplier" "2"  "--custom_prefix" "tmp" "--ws_framework" "ensemble")
        ;; :args (list "-d" "reddit --use_memory --prefix tgn-attn-reddit --n_runs=10")
        :cwd "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/"
       :module nil
        :program "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/train_self_supervised.py"
        :request "launch"))

(dap-register-debug-template
  "Python :: Run file (train_self_supervised with 10000 instances + mooc_10000)"
  (list :type "python"
        :name "gdb::run with arguments"
        ;; :args (list "-d" "reddit_10000" "--use_memory"  "--n_runs" "1" "--n_epoch" "5" "--use_nf_iwf_neg_sampling")
        :args (list "-d" "mooc_10000" "--use_memory" "--n_runs" "1" "--n_epoch" "5" "--bs" "1000" "--ws_multiplier" "2"  "--custom_prefix" "tmp" "--ws_framework" "ensemble")
        ;; :args (list "-d" "reddit --use_memory --prefix tgn-attn-reddit --n_runs=10")
        :cwd "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/"
        :module nil
        :program "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/train_self_supervised.py"
        :request "launch"))

;; train_supervised (aka node classification)

(dap-register-debug-template
  "Python :: Run file (train_supervised testing args)"
  (list :type "python"
        :name "gdb::run with arguments"
        :args (list "-d" "reddit_with_expert_labels_10000" "--use_memory" "--n_runs" "1" "--n_epoch" "5" "--bs" "200" "--use_nf_iwf_weight")
        ;; :args (list "-d" "reddit --use_memory --prefix tgn-attn-reddit --n_runs=10")
        :cwd "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/"
        :module nil
        :program "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/train_supervised.py"
        :request "launch"))

(dap-register-debug-template
  "Python :: Run file (train_supervised with expert labels)"
  (list :type "python"
        :name "gdb::run with arguments"
        ;; :argument "-d reddit --use_memory --prefix tgn-attn-reddit --n_runs=10"
        ;; :args (list "-d" "reddit_user_id_item_id_relative_freq_and_eq_value_with_label" "--use_memory" "--prefix" "tgn-attn-reddi" "--n_runs" "10")
        ;; :args (list "-d" "reddit_with_expert_labels" "--use_memory" "--prefix" "tgn-attn-reddi" "--n_runs" "1" "--n_epoch" "10" "--bs" "5000")
        :args (list "-d" "reddit_with_expert_labels" "--use_memory" "--n_runs" "1" "--n_epoch" "5")
        ;; :args (list "-d" "reddit --use_memory --prefix tgn-attn-reddit --n_runs=10")
        :cwd "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/"
        :module nil
        :program "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/train_supervised.py"
        :request "launch"))

(dap-register-debug-template
  "Python :: Run file (train_supervised with 100000 expert labels)"
  (list :type "python"
        :name "gdb::run with arguments"
        ;; :argument "-d reddit --use_memory --prefix tgn-attn-reddit --n_runs=10"
        ;; :args (list "-d" "reddit_user_id_item_id_relative_freq_and_eq_value_with_label" "--use_memory" "--prefix" "tgn-attn-reddi" "--n_runs" "10"
        :args (list "-d" "reddit_with_expert_labels_100000" "--use_memory" "--prefix" "tgn-attn-reddi" "--n_runs" "1" "--n_epoch" "5")
        ;; :args (list "-d" "reddit --use_memory --prefix tgn-attn-reddit --n_runs=10")
        :cwd "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/"
        :module nil
        :program "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/train_supervised.py"
        :request "launch"))

(dap-register-debug-template
  "Python :: Run file (train_supervised with 10000 expert labels)"
  (list :type "python"
        :name "gdb::run with arguments"
        ;; :argument "-d reddit --use_memory --prefix tgn-attn-reddit --n_runs=10"
        ;; :args (list "-d" "reddit_user_id_item_id_relative_freq_and_eq_value_with_label" "--use_memory" "--prefix" "tgn-attn-reddi" "--n_runs" "10"
        :args (list "-d" "reddit_with_expert_labels_10000" "--use_memory" "--prefix" "tgn-attn-reddi" "--n_runs" "10" "--n_epoch" "5")
        ;; :args (list "-d" "reddit --use_memory --prefix tgn-attn-reddit --n_runs=10")
        :cwd "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/"
        :module nil
        :program "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/train_supervised.py"
        :request "launch"))

(dap-register-debug-template
  "Python :: Run file (train_supervised with 10000 expert labels + update memory at the end)"
  (list :type "python"
        :name "gdb::run with arguments"
        ;; :argument "-d reddit --use_memory --prefix tgn-attn-reddit --n_runs=10"
        ;; :args (list "-d" "reddit_user_id_item_id_relative_freq_and_eq_value_with_label" "--use_memory" "--prefix" "tgn-attn-reddi" "--n_runs" "10"
        :args (list "-d" "reddit_with_expert_labels_10000" "--use_memory" "--prefix" "tgn-attn-reddi" "--n_runs" "10" "--n_epoch" "5" "--memory_update_at_end")
        ;; :args (list "-d" "reddit --use_memory --prefix tgn-attn-reddit --n_runs=10")
        :cwd "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/"
        :module nil
        :program "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/train_supervised.py"
        :request "launch"))

(dap-register-debug-template
  "Python :: Run file (train_supervised with 10000 expert labels)"
  (list :type "python"
        :name "gdb::run with arguments"
        ;; :argument "-d reddit --use_memory --prefix tgn-attn-reddit --n_runs=10"
        ;; :args (list "-d" "reddit_user_id_item_id_relative_freq_and_eq_value_with_label" "--use_memory" "--prefix" "tgn-attn-reddi" "--n_runs" "10"
        :args (list "-d" "reddit_with_expert_labels_10000" "--use_memory" "--n_runs" "10" "--n_epoch" "5")
        ;; :args (list "-d" "reddit --use_memory --prefix tgn-attn-reddit --n_runs=10")
        :cwd "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/"
        :module nil
        :program "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/train_supervised.py"
        :request "launch"))

(dap-register-debug-template
  "Python :: Run file (train_supervised with 10000 expert labels + random weight)"
  (list :type "python"
        :name "gdb::run with arguments"
        ;; :argument "-d reddit --use_memory --prefix tgn-attn-reddit --n_runs=10"
        ;; :args (list "-d" "reddit_user_id_item_id_relative_freq_and_eq_value_with_label" "--use_memory" "--prefix" "tgn-attn-reddi" "--n_runs" "10"
        :args (list "-d" "reddit_with_expert_labels_10000" "--use_memory" "--prefix" "tgn-attn-reddi" "--n_runs" "10" "--n_epoch" "5" "--use_random_weight_to_benchmark_nf_iwf")
        ;; :args (list "-d" "reddit --use_memory --prefix tgn-attn-reddit --n_runs=10")
        :cwd "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/"
        :module nil
        :program "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/train_supervised.py"
        :request "launch"))

(dap-register-debug-template
  "Python :: Run file (train_supervised with 10000 expert labels + share_selected_random_weight_per_window)"
  (list :type "python"
        :name "gdb::run with arguments"
        ;; :argument "-d reddit --use_memory --prefix tgn-attn-reddit --n_runs=10"
        ;; :args (list "-d" "reddit_user_id_item_id_relative_freq_and_eq_value_with_label" "--use_memory" "--prefix" "tgn-attn-reddi" "--n_runs" "10"
        :args (list "-d" "reddit_with_expert_labels_10000" "--use_memory" "--n_runs" "10" "--n_epoch" "5" "--use_random_weight_to_benchmark_nf_iwf_1")
        ;; :args (list "-d" "reddit --use_memory --prefix tgn-attn-reddit --n_runs=10")
        :cwd "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/"
        :module nil
        :program "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/train_supervised.py"
        :request "launch"))

(dap-register-debug-template
  "Python :: Run file (train_supervised testing args 1)"
  (list :type "python"
        ;; :args (list "-d" "reddit_10000" "--use_memory" "--n_runs" "1" "--n_epoch" "5" "--bs" "200" "--use_random_weight_to_benchmark_ef_iwf_1")
        :name "gdb::run with arguments"
        :args (list "-d" "reddit_with_expert_labels_10000" "--use_memory" "--n_runs" "1" "--n_epoch" "5" "--bs" "1000" "--ws_multiplier" "2" "--custom_prefix" "tmp" "--ws_framework" "forward")
        :cwd "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/"
        :module nil
        :program "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/tmp.py"
        :request "launch"))

;; others
(dap-register-debug-template
  "Python :: Run buffer (relative to project dir)"
  (list :type "python"
        :name "gdb::run with arguments"
        :cwd "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/"
        ;; :program "/mnt/c/Users/terng/OneDrive/Documents/Working/tgn/scripts/retrieve_data_from_link_prediction.py"
        :request "launch"))
;; Dap Mode =debug.el= Configuration:1 ends here

;; [[file:config.org::*Edebug][Edebug:1]]
(set-fringe-style (quote (12 . 8)))
;; Edebug:1 ends here

;; [[file:config.org::*Garbage colection][Garbage colection:1]]
;; ref: https://akrl.sdf.org/
(setq gc-cons-threshold #x40000000)

;; (defun k-time ()
;;   (- (current-time) ))

(defvar k-gc-timer
  (run-with-idle-timer 15 t
                       (lambda () (message "Garbage Collector has run for %.0bfsec"
                                           (k-time (garbage-collect))))))
;; Garbage colection:1 ends here

;; [[file:config.org::*Startup time Optimization][Startup time Optimization:1]]
(defun anak/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections"
           (format "%s seconds" (float-time (time-subtract after-init-time before-init-time)))
           gcs-done))

(add-hook 'emacs-startup-hook #'anak/display-startup-time)
;; Startup time Optimization:1 ends here

;; [[file:config.org::*Emacs-Jupyter][Emacs-Jupyter:1]]
(require 'jupyter)
(require 'ob-jupyter)
;; Emacs-Jupyter:1 ends here

;; [[file:config.org::*mermaid][mermaid:1]]
;; (setq ob-mermaid-cli-path "/usr/local/bin/mmdc")
;; mermaid:1 ends here

;; [[file:config.org::*Org Mode][Org Mode:1]]

;; Org Mode:1 ends here

;; [[file:config.org::*Org Notes and PDF Tools][Org Notes and PDF Tools:1]]
;; ;; org-noter
;;  (use-package! org-noter
;;   :after (:any org pdf-view)
;;   :config
;;   (setq
;;    ;; The WM can handle splits
;;    org-noter-notes-window-location 'other-frame
;;    ;; Please stop opening frames
;;    org-noter-always-create-frame nil
;;    ;; I want to see the whole file
;;    org-noter-hide-other nil
;;    ;; Everything is relative to the main notes file
;;    org-noter-notes-search-path (list org_notes))
;;    (require 'org-noter-pdftools)
;;   )

;; ;; I am not sure what this do exactly. What even is the differences between pdf-tools and org-pdf-tools
;; ;; pdf-tools
;; (use-package pdf-tools
;;    :pin manual
;;    :config
;;    (pdf-tools-install)
;;    (setq-default pdf-view-display-size 'fit-width)
;;    (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward)
;;    :custom
;;    (pdf-annot-activate-created-annotations t "automatically annotate highlights"))

;; (setq TeX-view-program-selection '((output-pdf "PDF Tools"))
;;       TeX-view-program-list '(("PDF Tools" TeX-pdf-tools-sync-view))
;;       TeX-source-correlate-start-server t)

;; (add-hook 'TeX-after-compilation-finished-functions
;;           #'TeX-revert-document-buffer)

;; ;; org-pdftools
;; (use-package! org-pdftools
;;   :hook (org-mode . org-pdftools-setup-link))

;; ;;org-noter-pdftools
;; (use-package! org-noter-pdftools
;;   :after org-noter
;;   :config
;;   ;; Add a function to ensure precise note is inserted
;;   (defun org-noter-pdftools-insert-precise-note (&optional toggle-no-questions)
;;     (interactive "P")
;;     (org-noter--with-valid-session
;;      (let ((org-noter-insert-note-no-questions (if toggle-no-questions
;;                                                    (not org-noter-insert-note-no-questions)
;;                                                  org-noter-insert-note-no-questions))
;;            (org-pdftools-use-isearch-link t)
;;            (org-pdftools-use-freestyle-annot t))
;;        (org-noter-insert-note (org-noter--get-precise-info)))))

;;   ;; fix https://github.com/weirdNox/org-noter/pull/93/commits/f8349ae7575e599f375de1be6be2d0d5de4e6cbf
;;   (defun org-noter-set-start-location (&optional arg)
;;     "When opening a session with this document, go to the current location.
;; With a prefix ARG, remove start location."
;;     (interactive "P")
;;     (org-noter--with-valid-session
;;      (let ((inhibit-read-only t)
;;            (ast (org-noter--parse-root))
;;            (location (org-noter--doc-approx-location (when (called-interactively-p 'any) 'interactive))))
;;        (with-current-buffer (org-noter--session-notes-buffer session)
;;          (org-with-wide-buffer
;;           (goto-char (org-element-property :begin ast))
;;           (if arg
;;               (org-entry-delete nil org-noter-property-note-location)
;;             (org-entry-put nil org-noter-property-note-location
;;                            (org-noter--pretty-print-location location))))))))
;;   (with-eval-after-load 'pdf-annot
;;     (add-hook 'pdf-annot-activate-handler-functions #'org-noter-pdftools-jump-to-note)))
;; Org Notes and PDF Tools:1 ends here

;; [[file:config.org::*Org babel][Org babel:1]]
(org-babel-lob-ingest "~/org/org-babel-library/library-of-babel.org")
;; Org babel:1 ends here

;; [[file:config.org::*Org babel][Org babel:2]]
;; set up recommended by John Kitchin
;; ref: https://www.youtube.com/watch?v=RD0o2pkJBaI&t=638s&ab_channel=JohnKitchin
(setq org-babel-default-header-args '((:session . "jupyter-python")
                                      (:results . "both")
                                      (:exports . "both")
                                      (:cache . "no")
                                      (:noweb . "no")
                                      (:hlines . "no")
                                      (:tangle . "no")
                                      (:eval . "never-export")
                                      (:kernel . "python3")
                                      (:pandoc . "t")))
;; Org babel:2 ends here

;; [[file:config.org::*Org roam bibtex][Org roam bibtex:1]]
;; org-roam-bibtex
 (use-package! org-roam-bibtex
  :after (org-roam)
  :hook (org-roam-mode . org-roam-bibtex-mode)
  :config
  (require 'org-ref)
  (setq org-roam-bibtex-preformat-keywords
   '("=key=" "title" "url" "file" "author-or-editor" "keywords"))
  (setq orb-templates
        '(("r" "ref" plain (function org-roam-capture--get-point)
           ""
           :file-name "${slug}"
           :head "#+TITLE: ${=key=}: ${title}\n#+ROAM_KEY: ${ref}

- tags ::
- keywords :: ${keywords}

\n* ${title}\n  :PROPERTIES:\n  :Custom_ID: ${=key=}\n  :URL: ${url}\n  :AUTHOR: ${author-or-editor}\n  :NOTER_DOCUMENT: %(orb-process-file-field \"${=key=}\")\n  :NOTER_PAGE: \n  :END:\n\n"

           :unnarrowed t))))
;; Org roam bibtex:1 ends here
