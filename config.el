;; [[file:config.org::*Doom Default configuration][Doom Default configuration:1]]
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
;; Doom Default configuration:1 ends here

;; [[file:config.org::*My custom functions][My custom functions:1]]
(defun my/anak-yank-dir-path ()
  (interactive)
  (message "Copy to clipboard: %s"
           (kill-new (s-join "/"  (butlast (split-string default-directory "/") 1)))))
;; My custom functions:1 ends here

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

;; [[file:config.org::*searching the most published MELPA Authors][searching the most published MELPA Authors:1]]
;; https://www.reddit.com/r/emacs/comments/t9qs6h/need_help_listing_all_emacs_super_developers/
(require 'url)
(require 'cl-lib)
(defvar url-http-end-of-headers)
(defvar smelpa-json nil "Melpa recipe JSON data.")

(defun smelpa-json ()
  "Return an alist of MELPA recipe metadata."
  (or smelpa-json
      (setq smelpa-json
            (with-current-buffer (url-retrieve-synchronously "https://melpa.org/archive.json")
              (goto-char url-http-end-of-headers)
              (json-read)))))
(defun smelpa-packages-by-author ()
  "Return alist of form: ((author . (package-url...)))."
  (let (authors)
    (cl-loop for (_ . data) in (smelpa-json)
             do (when-let ((props     (alist-get 'props data))
                           (url       (alist-get 'url props))
                           (parsed    (url-generic-parse-url url))
                           (filename  (url-filename parsed))
                           (tokens    (split-string filename "/" 'omit-nulls))
                           (author    (intern (car tokens))))
                  (if (alist-get author authors)
                      (push url (alist-get author authors))
                    (push (cons author (list url)) authors))))
    authors))
(defun smelpa-most-published-authors (n)
  "Return alist of form ((author . (url...))) for top N published MELPA authors."
  (let ((authors (smelpa-packages-by-author)))
    (cl-subseq
     (cl-sort authors #'>
              :key (lambda (cell) (length (cdr cell))))
     0 (min n (length authors)))))
;; searching the most published MELPA Authors:1 ends here

;; [[file:config.org::*Org tree slide helper][Org tree slide helper:1]]
;; org-tree-slide
(defun efs/presentation-setup ()
  (setq text-scale-mode-amount 3)
  (org-display-inline-images)
  (text-scale-mode 1))

(defun efs/presentation-end ()
  (text-scale-mode 0))
;; Org tree slide helper:1 ends here

;; [[file:config.org::*uncategorized][uncategorized:1]]
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

(setq bh/keep-clock-running nil)
;; uncategorized:1 ends here

;; [[file:config.org::*Defining project][Defining project:1]]
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
;; Defining project:1 ends here

;; [[file:config.org::*Defining task][Defining task:1]]
(defun bh/mark-next-parent-tasks-todo ()
  "Visit each parent task and change NEXT states to TODO"
  (let ((mystate (or (and (fboundp 'org-state)
                          state)
                     (nth 2 (org-heading-components)))))
    (when mystate
      (save-excursion
        (while (org-up-heading-safe)
          (when (member (nth 2 (org-heading-components)) (list "NEXT"))
            (org-todo "TODO")))))))

(add-hook 'org-after-todo-state-change-hook 'bh/mark-next-parent-tasks-todo 'append)
(add-hook 'org-clock-in-hook 'bh/mark-next-parent-tasks-todo 'append)
;; Defining task:1 ends here

;; [[file:config.org::*for refiling][for refiling:1]]
(defun bh/verify-refile-target ()
    "Exclude todo keywords with a done state from refile targets"
    (not (member (nth 2 (org-heading-components)) org-done-keywords)))
;; for refiling:1 ends here

;; [[file:config.org::*for tags filtering][for tags filtering:1]]
(defun bh/org-auto-exclude-function (tag)
  "Automatic task exclusion in the agenda with / RET"
  (and (cond
        ((string= tag "hold")
         t)
        ((string= tag "waiting")
         t))
       (concat "-" tag)))
(setq org-agenda-auto-exclude-function 'bh/org-auto-exclude-function)
;; for tags filtering:1 ends here

;; [[file:config.org::*For clocking][For clocking:1]]
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

(defvar bh/organization-task-id "46615078-5777-4487-8197-b1c6fd8641a0")

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

(require 'org-id)
(defun bh/clock-in-task-by-id (id)
  "Clock in a task by id"
  (org-with-point-at (org-id-find id 'marker)
    (org-clock-in nil)))
(defun bh/clock-in-last-task (arg)
  "Clock in the interrupted task if there is one
Skip the default task and get the next one.
A prefix arg forces clock in of the default task."
  (interactive "p")
  (let ((clock-in-to-task
         (cond
          ((eq arg 4) org-clock-default-task)
          ((and (org-clock-is-active)
                (equal org-clock-default-task (cadr org-clock-history)))
           (caddr org-clock-history))
          ((org-clock-is-active) (cadr org-clock-history))
          ((equal org-clock-default-task (car org-clock-history)) (cadr org-clock-history))
          (t (car org-clock-history)))))
    (widen)
    (org-with-point-at clock-in-to-task
      (org-clock-in nil))))
;; For clocking:1 ends here

;; [[file:config.org::*For bbdb (phone call)][For bbdb (phone call):1]]
;; (require 'bbdb)
;; (require 'bbdb-com)

;; ;; Phone capture template handling with BBDB lookup
;; ;; Adapted from code by Gregory J. Grubbs
;; (defun bh/phone-call ()
;;   "Return name and company info for caller from bbdb lookup"
;;   (interactive)
;;   (let* (name rec caller)
;;     (setq name (completing-read "Who is calling? "
;;                                 (bbdb-hashtable)
;;                                 'bbdb-completion-predicate
;;                                 'confirm))
;;     (when (> (length name) 0)
;;                                         ; Something was supplied - look it up in bbdb
;;       (setq rec
;;             (or (first
;;                  (or (bbdb-search (bbdb-records) name nil nil)
;;                      (bbdb-search (bbdb-records) nil name nil)))
;;                 name)))
;;                                         ; Build the bbdb link if we have a bbdb record, otherwise just return the name
;;     (setq caller (cond ((and rec (vectorp rec))
;;                         (let ((name (bbdb-record-name rec))
;;                               (company (bbdb-record-company rec)))
;;                           (concat "[[bbdb:"
;;                                   name "]["
;;                                   name "]]"
;;                                   (when company
;;                                     (concat " - " company)))))
;;                        (rec)
;;                        (t "NameOfCaller")))
;;     (insert caller)))
;; For bbdb (phone call):1 ends here

;; [[file:config.org::*For archive][For archive:1]]
(setq org-archive-mark-done nil)
(setq org-archive-location "%s_archive::* Archived Tasks")

(defun bh/skip-non-archivable-tasks ()
  "Skip trees that are not available for archiving"
  (save-restriction
    (widen)
    ;; Consider only tasks with done todo headings as archivable candidates
    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max))))
          (subtree-end (save-excursion (org-end-of-subtree t))))
      (if (member (org-get-todo-state) org-todo-keywords-1)
          (if (member (org-get-todo-state) org-done-keywords)
              (let* ((daynr (string-to-number (format-time-string "%d" (current-time))))
                     (a-month-ago (* 60 60 24 (+ daynr 1)))
                     (last-month (format-time-string "%Y-%m-" (time-subtract (current-time) (seconds-to-time a-month-ago))))
                     (this-month (format-time-string "%Y-%m-" (current-time)))
                     (subtree-is-current (save-excursion
                                           (forward-line 1)
                                           (and (< (point) subtree-end)
                                                (re-search-forward (concat last-month "\\|" this-month) subtree-end t)))))
                (if subtree-is-current
                    subtree-end ; Has a date in this month or last month, skip it
                  nil))  ; available to archive
            (or subtree-end (point-max)))
        next-headline))))
;; For archive:1 ends here

;; [[file:config.org::*For reminder][For reminder:1]]
; Erase all reminders and rebuilt reminders for today from the agenda
(defun bh/org-agenda-to-appt ()
  (interactive)
  (setq appt-time-msg-list nil)
  (org-agenda-to-appt))
;; For reminder:1 ends here

;; [[file:config.org::*Key binding configuration][Key binding configuration:1]]
;; url: http://doc.norang.ca/org-mode.html#GettingStarted
;; Custom Key Bindings
(global-set-key (kbd "<f12>") 'org-agenda)
(global-set-key (kbd "<f5>") 'bh/org-todo)
(global-set-key (kbd "<S-f5>") 'bh/widen)
(global-set-key (kbd "<f7>") 'bh/set-truncate-lines)
;; (global-set-key (kbd "<f8>") 'org-cycle-agenda-files)
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
(global-set-key (kbd "<f9> p") 'bh/phone-call)

;; search + find + filter
(map! :leader "s F" #'find-name-dired)

(map! :leader "m s c" #'org-copy-subtree)
(map! :leader "m s C" #'org-clone-subtree-with-time-shift)

(map! :leader "f ." #'my/anak-yank-dir-path)
(define-key treemacs-mode-map (kbd "M-h") 'treemacs-goto-parent-node)
;; Key binding configuration:1 ends here

;; [[file:config.org::*basic configuration][basic configuration:1]]
(setq desktop-save-mode nil)
;; (desktop-save-mode 1)
(setq load-prefer-newer t)
(setq which-function-mode t)
(require 'ol-info) ;; this allow one to link a page to emacs internal manual.
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
;; (add-to-list 'browse-url-filename-alist '("^~+" . "file:///home/awannaphasch2016"))
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

;; [[file:config.org::*org-bookmark-heading][org-bookmark-heading:1]]
(require 'org-bookmark-heading)
;; org-bookmark-heading:1 ends here

;; [[file:config.org::*Bookmark+][Bookmark+:1]]
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
;; Bookmark+:1 ends here

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
;; (use-package! lispy
;;     :custom
;;     (map! ";" #'lispy-comment)
;;     (map! "D" #'lispy-delete)
;;     (map! "y" #'lispy-new-copy))
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

;; [[file:config.org::*evil mode][evil mode:1]]
 (with-eval-after-load 'edebug
   (evil-make-overriding-map edebug-mode-map '(normal motion))
   (add-hook 'edebug-mode-hook 'evil-normalize-keymaps) )
;; evil mode:1 ends here

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

;; [[file:config.org::*LSP-mode][LSP-mode:2]]
;; How do I force lsp-mode to forget the workspace folders for multi root#
;; ref: https://emacs-lsp.github.io/lsp-mode/page/faq/#how-do-i-force-lsp-mode-to-forget-the-workspace-folders-for-multi-root
(advice-add 'lsp
            :before (lambda (&rest _args)
                      (eval '(setf (lsp-session-server-id->folders (lsp-session))
                                   (ht)))))
;; LSP-mode:2 ends here

;; [[file:config.org::*pyright setup][pyright setup:1]]
;; ref: https://github.com/emacs-lsp/lsp-pyright
(use-package lsp-pyright
  ;; :ensure t
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

;; [[file:config.org::*Helm Bibtex][Helm Bibtex:1]]
;; ;; helm-bibtex url: https://rgoswami.me/posts/org-note-workflow/#indexing-notes
  (setq
   bibtex-completion-library-path "/home/awannaphasch2016/org/papers"
   bibtex-completion-notes-path "/home/awannaphasch2016/org/org-roam/"
   bibtex-completion-bibliography '(
                                    ;; "/home/awannaphasch2016/org/main.bib"
                                    ;; "/home/awannaphasch2016/Documents/MyPapers/Paper-Covid19TrendPredictionSurvey/references.bib"
                                    "/home/awannaphasch2016/org/papers/zotero-bib.bib"
                                    "/home/awannaphasch2016/org/papers/org-mode-bibtex.bib")
   bibtex-completion-pdf-field "file"
    bibtex-completion-notes-template-multiple-files
 (concat
  "#+TITLE: ${title}\n"
  "#+FILETAGS: \n"
  "#+ROAM_KEY: cite:&${=key=} \n"
  "* ${title}\n"
  ":PROPERTIES:\n"
  ":Custom_ID: ${=key=}\n"
  ":END:\n\n"
  ))
;; Helm Bibtex:1 ends here

;; [[file:config.org::*citar][citar:1]]
(setq citar-bibliography '("/home/awannaphasch2016/org/papers/zotero-bib.bib"))
(setq citar-library-paths '("/home/awannaphasch2016/org/papers/"))
(setq citar-notes-paths '("/home/awannaphasch2016/org/org-roam/"))
;; citar:1 ends here

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
        :args (list "-d" "reddit_10000" "--use_memory" "--n_runs" "1" "--n_epoch" "5" "--bs" "200" "--ws_multiplier" "1" "--custom_prefix" "tmp" "--ws_framework" "forward"  "--keep_last_n_window_as_window_slides" "1" "--window_stride_multiplier" "1" "--init_n_instances_as_multiple_of_ws" "5" "--disable_cuda")
        ;; :args (list "-d" "reddit_10000" "--use_memory" "--n_runs" "1" "--n_epoch" "5" "--bs" "200" "--ws_multiplier" "1" "--custom_prefix" "tmp" "--ws_framework" "ensemble" "--window_stride_multiplier" "1" "--disable_cuda" "--init_n_instances_as_multiple_of_ws" "5")
        ;; :args (list "-d" "reddit_10000" "--use_memory" "--n_runs" "1" "--n_epoch" "5" "--bs" "200" "--ws_multiplier" "1" "--custom_prefix" "tmp" "--ws_framework" "ensemble" "--disable_cuda" "--init_n_instances_as_multiple_of_ws" "6" "--fix_begin_data_ind_of_models_in_ensemble")
        ;; :args (list "-d" "reddit_100000" "--use_memory" "--n_runs" "1" "--n_epoch" "5" "--bs" "1000" "--ws_multiplier" "1" "--custom_prefix" "tmp" "--ws_framework" "ensemble" "--disable_cuda" "--fix_begin_data_ind_of_models_in_ensemble" "--init_n_instances_as_multiple_of_ws" "5" "--keep_last_n_window_as_window_slides" "1")
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

(defmacro k-time (&rest body)
  "Measure and return the time it takes evaluating BODY."
  `(let ((time (current-time)))
     ,@body
     (float-time (time-since time))))

;; ;; I have to disable it because I can't read echo line when I debug. garbage-collect constantly produce echo.
;; (defvar k-gc-timer
;;   (run-with-idle-timer 15 t
;;                        ;; (lambda () (message "Garbage Collector has run for %.0bfsec"
;;                        ;;                     (k-time (garbage-collect))))
;;                        (lambda () (k-time (garbage-collect)))))
;; Garbage colection:1 ends here

;; [[file:config.org::*Startup time Optimization][Startup time Optimization:1]]
(defun anak/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections"
           (format "%s seconds" (float-time (time-subtract after-init-time before-init-time)))
           gcs-done))

(add-hook 'emacs-startup-hook #'anak/display-startup-time)
;; Startup time Optimization:1 ends here

;; [[file:config.org::*Emacs-Jupyter][Emacs-Jupyter:1]]
(message "====================loads Emacs-jupyter===================================")
;; Emacs-Jupyter:1 ends here

;; [[file:config.org::*Emacs-Jupyter][Emacs-Jupyter:2]]
(require 'jupyter)
(require 'ob-jupyter)
;; Emacs-Jupyter:2 ends here

;; [[file:config.org::*Diagrams][Diagrams:1]]
(message "====================loads Diagrams===================================")
;; Diagrams:1 ends here

;; [[file:config.org::*mermaid][mermaid:1]]
;; (setq ob-mermaid-cli-path "/usr/local/bin/mmdc")
(add-to-list 'auto-mode-alist '("\\.mermaid\\'" . mermaid-mode))
;; mermaid:1 ends here

;; [[file:config.org::*ditaa][ditaa:1]]
;; (setq org-ditaa-jar-path "~/git/org-mode/contrib/scripts/ditaa.jar")
;; ditaa:1 ends here

;; [[file:config.org::*Org Mode][Org Mode:1]]
;; (add-to-list 'org-modules 'org-habit)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "/home/awannaphasch2016/org/") ;

;; Separate drawers for clocking and logs
(setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))
; Tags with fast selection keys
(setq org-tag-alist (quote ((:startgroup)
                            ("@errand" . ?e)
                            ("@sideproject" . ?p)
                            ("@home" . ?h)
                            ("@school" . ?s)
                            ("@PhD" . ?P)
                            ;; ("@life" . ?l)
                            (:endgroup)
                            ("WAITING" . ?w)
                            ("HOLD" . ?H)
                            ("PERSONAL" . ?P)
                            ("garun" . ?g)
                            ("pen" . ?p)
                            ("gtd" . ?t)
                            ("WORK" . ?W)
                            ("emacs" . ?m)
                            ("crypt" . ?E)
                            ("NOTE" . ?N)
                            ("CANCELLED" . ?C)
                            ("FLAGGED" . ?F)
                            ("LEARN" . ?L)
                            ("mywebsite" . ?M)
                            ("EI" . ?i) ;; EI stands for expert-identification
                            )))

(setq org-stuck-projects (quote ("" nil nil "")))

;; ref:http://doc.norang.ca/org-mode.html
(run-at-time "00:59" 3600 'org-save-all-org-buffers)

;; specify what to log and where to place the logs (relative to drawer)
(setq org-log-done (quote time))
(setq org-log-into-drawer t)
(setq org-log-state-notes-insert-after-drawers nil)
;; Org Mode:1 ends here

;; [[file:config.org::*Org bullets][Org bullets:1]]
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
;; Org bullets:1 ends here

;; [[file:config.org::*Org ref][Org ref:1]]
;; org-ref
;; (setq
;;          org-ref-completion-library 'org-ref-ivy-cite
;;          org-ref-get-pdf-filename-function 'org-ref-get-pdf-filename-helm-bibtex
;;          org-ref-default-bibliography (list
;;                                        ;; "/home/awannaphasch2016/org/main.bib"
;;                                        ;; "/home/awannaphasch2016/Documents/MyPapers/Paper-Covid19TrendPredictionSurvey/references.bib"
;;                                        "/home/awannaphasch2016/org/papers/zotero-bib.bib")
;;          ;; org-ref-bibliography-notes "/home/haozeke/Git/Gitlab/Mine/Notes/bibnotes.org"
;;          org-ref-note-title-format "* TODO %y - %t\n :PROPERTIES:\n  :Custom_ID: %k\n  :NOTER_DOCUMENT: %F\n :ROAM_KEY: cite:%k\n  :AUTHOR: %9a\n  :JOURNAL: %j\n  :YEAR: %y\n  :VOLUME: %v\n  :PAGES: %p\n  :DOI: %D\n  :URL: %U\n :END:\n\n"
;;          org-ref-notes-directory "/home/awannaphasch2016/org/"
;;          org-ref-notes-function 'orb-edit-notes
;;     )
;; Org ref:1 ends here

;; [[file:config.org::*Org ref][Org ref:2]]
;; (setq org-ref-open-pdf-function 'my/org-ref-open-pdf-at-point)

;; (defun my/org-ref-open-pdf-at-point ()
;;   "Open the pdf for bibtex key under point if it exists."
;;   (interactive)
;;   (let* ((results (org-ref-get-bibtex-key-and-file))
;;          (key (car results))
;;          (pdf-file (funcall org-ref-get-pdf-filename-function key))
;;      (pdf-other (bibtex-completion-find-pdf key)))
;;     (cond ((file-exists-p pdf-file)
;;        (org-open-file pdf-file))
;;       (pdf-other
;;        (org-open-file pdf-other))
;;       (message "No PDF found for %s" key))))

;; (defun my/org-ref-open-pdf-at-point ()
;;   "Open the pdf for bibtex key under point if it exists."
;;   (interactive)
;;   (let* ((results (org-ref-get-bibtex-key-and-file))
;;          (key (car results))
;;          (pdf-file (funcall org-ref-get-pdf-filename-function key))
;;      (pdf-other (car (helm-bibtex-find-pdf-in-library key))))
;;     (cond ((file-exists-p pdf-file)
;;        (org-open-file pdf-file))
;;       (helm-bibtex-pdf-field
;;        (funcall helm-bibtex-pdf-open-function
;;             (helm-bibtex-find-pdf-in-field key)))
;;       ((file-exists-p pdf-other)
;;        (funcall helm-bibtex-pdf-open-function pdf-other))
;;       (message "No PDF found for %s" key))))
;; Org ref:2 ends here

;; [[file:config.org::*Org roam][Org roam:1]]
(setq org-roam-v2-ack t)
(setq org-roam-complete-everywhere t)

(setq
 org_notes (concat (getenv "HOME")
                   "/org/org-roam/"
                   ;; "/org/brain/"
                   )
   ;; zot_bib (concat (getenv "HOME") "/org/main.bib")
   ;; org-directory org_notes
   deft-directory org_notes
   org-roam-directory org_notes
   )

(setq org-roam-directory (expand-file-name (or org-roam-directory "roam")
                                             org-directory)
        org-roam-verbose nil  ; https://youtu.be/fn4jIlFwuLU
        ; org-roam-buffer-no-delete-other-windows t ; make org-roam buffer sticky
        org-roam-completion-system 'default
)

;; 7.3. Configuring the Org-roam buffer display (https://www.orgroam.com/manual.html#Configuring-the-Org_002droam-buffer-display)
(add-to-list 'display-buffer-alist
             '("\\*org-roam\\*"
               ;; (display-buffer-in-direction)
               ;; (direction . right)
               ;; (window-width . 0.33)
               ;; (window-height . fit-window-to-buffer)
               ))
;; Org roam:1 ends here

;; [[file:config.org::*Org Notes and PDF Tools][Org Notes and PDF Tools:1]]
;; set pdf-view-mode as default
(add-to-list 'auto-mode-alist '("\\.pdf\\'" . pdf-view-mode))
;; Org Notes and PDF Tools:1 ends here

;; [[file:config.org::*Org Noter][Org Noter:1]]
;; ref: https://rgoswami.me/posts/org-note-workflow/#indexing-notes
(use-package! org-noter
  :after (:any org pdf-view)
  :config
  (setq
   ;; The WM can handle splits
   ;; org-noter-notes-window-location 'other-frame
   ;; Please stop opening frames
   org-noter-always-create-frame nil
   ;; I want to see the whole file
   org-noter-hide-other nil
   ;; Everything is relative to the main notes file
   org-noter-notes-search-path (list org_notes))
   (require 'org-noter-pdftools)
  )
;; Org Noter:1 ends here

;; [[file:config.org::*Org babel][Org babel:1]]
(message "====================loads Org-Babel===================================")
;; Org babel:1 ends here

;; [[file:config.org::*Org babel][Org babel:2]]
(org-babel-do-load-languages
 'org-babel-load-languages
 '((ipython . t)
   (jupyter . t)
   (scala . t)
   (go . t  )
   (python . t)
   (julia . t)
   (ditaa . t)
   (dot . t)))
;; Org babel:2 ends here

;; [[file:config.org::*Org babel][Org babel:3]]
(org-babel-lob-ingest "~/org/org-babel-library/library-of-babel.org")
;; Org babel:3 ends here

;; [[file:config.org::*Org babel][Org babel:4]]
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
;; Org babel:4 ends here

;; [[file:config.org::*Org roam protocol][Org roam protocol:1]]
;; Since the org module lazy loads org-protocol (waits until an org URL is
;; detected), we can safely chain `org-roam-protocol' to it.
(use-package! org-roam-protocol
  :after org-protocol)
;; Org roam protocol:1 ends here

;; [[file:config.org::*Org roam bibtex][Org roam bibtex:1]]
;; org-roam-bibtex
(require 'org-roam-bibtex)
;; (setq orb-preformat-keywords '("citekey" "author" "date" "title" "url" "file" "author-or-editor" "keywords"))
(setq org-roam-capture-templates
      '(("r" "bibliography reference" plain
         (file "~/org/org-roam/template/citation.org") ; <-- template store in a separate file
         :target
         (file "~/org/org-roam/${citekey}.org"))
        ("d" "default" plain "%?" :target
         (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
         :unnarrowed t)))
;; Org roam bibtex:1 ends here

;; [[file:config.org::*Org capture][Org capture:1]]
;; Capture templates for: TODO tasks, Notes, appointments, phone calls, meetings, and org-protocol
(setq org-capture-templates
      (quote (("t" "todo" entry (file "~/org/refile.org")
               "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
              ("r" "respond" entry (file "~/org/refile.org")
               "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
              ("n" "note" entry (file "~/org/refile.org")
               "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
              ("j" "Journal" entry (file+datetree "~/org/journal.org")
               "* %?\n%U\n" :clock-in t :clock-resume t)
              ("d" "daily" entry (file+datetree "~/org/daily.org")
               "* %?\n%U\n" :clock-in t :clock-resume t)
              ("w" "org-protocol" entry (file "~/org/refile.org")
               "* TODO Review %c\n%U\n" :immediate-finish t)
              ("l" "Learning" entry (file "~/org/refile.org")
               "* LEARNING %?\n%U\n" :clock-in t :clock-resume t)
              ("?" "Questions" entry (file "~/org/refile.org")
               "* Questions %?\n%U\n" :clock-in t :clock-resume t)
              ("m" "Meeting" entry (file "~/org/refile.org")
               "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t)
              ("p" "Phone call" entry (file "~/org/refile.org")
               "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
              ("h" "Habit" entry (file "~/org/refile.org")
               "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+1d/3d>>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n"))))
;; Org capture:1 ends here

;; [[file:config.org::*Org clock][Org clock:1]]
;; clockin setup url:http://doc.norang.ca/org-mode.html
;; Resume clocking task when emacs is restarted
(org-clock-persistence-insinuate)
(setq org-time-stamp-rounding-minutes (quote (1 1)))

;; Show lot of clocking history so it's easy to pick items off the C-F11 list
(setq org-clock-history-length 23)
;; Resume clocking task on clock-in if the clock is open
(setq org-clock-in-resume t)
;; Change tasks to NEXT when clocking in
(setq org-clock-in-switch-to-state 'bh/clock-in-to-next)
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

;; checking clock consistency
(setq org-agenda-clock-consistency-checks
      (quote (:max-duration "4:00"
              :min-duration 0
              :max-gap 0
              :gap-ok-around ("4:00"))))
;; Org clock:1 ends here

;; [[file:config.org::*base config setting][base config setting:1]]
;; evil mode disable in agenda mode
;; (setq evil-emacs-state-modes 'org-agenda-mode)

(setq org-agenda-files '("/home/awannaphasch2016/org/PhD.org"
                         "/home/awannaphasch2016/org/diary.org"
                         "/home/awannaphasch2016/org/journal.org"
                         "/home/awannaphasch2016/org/refile.org"
                         "/home/awannaphasch2016/org/todo.org"
                         "/home/awannaphasch2016/org/projects/sideprojects/garun/garun.org"
                         "/home/awannaphasch2016/org/notes/incremental-learning.org"
                         "/home/awannaphasch2016/org/projects/sideprojects/pen.org"
                         "/home/awannaphasch2016/org/GTD.org"
                         "/home/awannaphasch2016/org/notes/articles-to-reads.org"
                         "/home/awannaphasch2016/org/notes/books/books-to-read.org"
                         "/home/awannaphasch2016/org/personal-website.org"
                         "/home/awannaphasch2016/org/school.org"
                         "/home/awannaphasch2016/org/expert-identification.org"
                         "/home/awannaphasch2016/org/life.org"
                         "/home/awannaphasch2016/org/finance/personal-finance.org"
                         "/home/awannaphasch2016/org/finance/investing.org"
                         "/home/awannaphasch2016/org/projects/sideprojects/semosis.org"
                         "/home/awannaphasch2016/org/notes/blockchains/dao-the-rabbit-hole-note.org"
                         "/home/awannaphasch2016/org/notes/economic-note.org"
                         "/home/awannaphasch2016/org/notes/finance/portfolio-management-note.org"
                         "/home/awannaphasch2016/org/notes/blockchains/token-engineering-common-note.org"
                         "/home/awannaphasch2016/org/notes/blockchains/garun-blockchain-club-note.org"
                         "/home/awannaphasch2016/org/projects/sideprojects/website/adam-website/adam-website-note.org"
                         ))

(setq org-default-notes-file "/home/awannaphasch2016/org/refile.org")

;; ;; disable evil mode in org-agenda doesn't work.
;; (set-evil-initial-state! 'org-agenda-mode 'emacs)
(add-hook 'org-agenda-mode-hook #'turn-off-evil-mode nil)


;; config set of days to be shown in org-agenda (https://emacs.stackexchange.com/questions/12517/how-do-i-make-the-timespan-shown-by-org-agenda-start-yesterday)
;; (setq org-agenda-span 'day) ;; :FIXME: org agenda doesn't show today. it only shows 3 days eariler.
;; (setq org-agenda-span 'week)
(setq org-agenda-span 7)
(setq org-agenda-start-day nil)
;; (setq org-agenda-start-day "-1d")
(setq org-agenda-start-on-weekday 1)


;; ref: http://doc.norang.ca/org-mode.html
(setq org-deadline-warning-days 30)
(setq org-enforce-todo-dependencies t)
;; base config setting:1 ends here

;; [[file:config.org::*5.1 TODO keywords][5.1 TODO keywords:1]]
;; org-todo
;; note: special markers ‘!’ (for a timestamp) or ‘@’ (for a note with timestamp) in parentheses after each keyword.
(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
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
;; 5.1 TODO keywords:1 ends here

;; [[file:config.org::*5.2 Fast Todo Selection][5.2 Fast Todo Selection:1]]
(setq org-treat-S-cursor-todo-selection-as-state-change nil)
;; 5.2 Fast Todo Selection:1 ends here

;; [[file:config.org::*5.3 Todo state triggers][5.3 Todo state triggers:1]]
(setq org-todo-state-tags-triggers
      (quote (("CANCELLED" ("CANCELLED" . t))
              ("WAITING" ("WAITING" . t))
              ("HOLD" ("WAITING") ("HOLD" . t))
              ;; ("DONE" ("WAITING") ("HOLD"))
              (done ("WAITING") ("HOLD"))
              ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
              ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
              ("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))
;; 5.3 Todo state triggers:1 ends here

;; [[file:config.org::*Refiling][Refiling:1]]
;; ref: http://doc.norang.ca/org-mode.html

; Targets include this file and any file contributing to the agenda - up to 9 levels deep
(setq org-refile-targets (quote ((nil :maxlevel . 9)
(org-agenda-files :maxlevel . 9))))
; Use full outline paths for refile targets - we file directly with IDO
(setq org-refile-use-outline-path t)
; Targets complete directly with IDO
(setq org-outline-path-complete-in-steps nil)
; Allow refile to create parent tasks with confirmation
(setq org-refile-allow-creating-parent-nodes (quote confirm))

;; ; Use IDO for both buffer and file completion and ido-everywhere to t
;; (setq org-completion-use-ido t)
;; (setq ido-everywhere t)
;; (setq ido-max-directory-size 100000)
;; (ido-mode (quote both))
;; ; Use the current window when visiting files and buffers with ido
;; (setq ido-default-file-method 'selected-window)
;; (setq ido-default-buffer-method 'selected-window)

; Use the current window for indirect buffer display
(setq org-indirect-buffer-display 'current-window)
;;;; Refile settings
; Exclude DONE state tasks from refile targets
(setq org-refile-target-verify-function 'bh/verify-refile-target)
;; Refiling:1 ends here

;; [[file:config.org::*Custom Agenda Views][Custom Agenda Views:1]]
;; ref: http://doc.norang.ca/org-mode.html

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
               nil))))
;; Custom Agenda Views:1 ends here

;; [[file:config.org::*Report block][Report block:1]]
;; Agenda clock report parameters
(setq org-agenda-clockreport-parameter-plist
      (quote (:link t :maxlevel 5 :fileskip0 t :compact t :narrow 80)))

; Set default column view headings: Task Effort Clock_Summary
(setq org-columns-default-format "%50ITEM(Task) %10Effort(Effort){:} %10CLOCKSUM")
; global Effort estimate values
; global STYLE property values for completion
(setq org-global-properties (quote (("Effort_ALL" . "0:15 0:30 0:45 1:00 2:00 3:00 4:00 5:00 6:00 0:00")
                                    ("STYLE_ALL" . "habit"))))

;; Agenda log mode items to display (closed and state changes by default)
(setq org-agenda-log-mode-items (quote (closed state)))
;; Report block:1 ends here

;; [[file:config.org::*Reminder][Reminder:1]]
; Rebuild the reminders everytime the agenda is displayed
(add-hook 'org-agenda-finalize-hook 'bh/org-agenda-to-appt 'append)

; This is at the end of my .emacs - so appointments are set up when Emacs starts
(bh/org-agenda-to-appt)

; Activate appointments so we get notifications
(appt-activate t)

; If we leave Emacs running overnight - reset the appointments one minute after midnight
(run-at-time "24:01" nil 'bh/org-agenda-to-appt)
;; Reminder:1 ends here

;; [[file:config.org::*Org drill][Org drill:1]]
(add-to-list 'load-path "~/org/space-repetition/")
;; Org drill:1 ends here

;; [[file:config.org::*Org tree slide][Org tree slide:1]]
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
;; Org tree slide:1 ends here

;; [[file:config.org::*Org habit][Org habit:1]]
(require 'org-habit)
;; Org habit:1 ends here

;; [[file:config.org::*Org checklist][Org checklist:1]]
(require 'org-checklist)
;; Org checklist:1 ends here

;; [[file:config.org::*Org fragtog][Org fragtog:1]]
(add-hook 'org-mode-hook 'org-fragtog-mode)
;; Org fragtog:1 ends here

;; [[file:config.org::*Org sticky header][Org sticky header:1]]
(add-hook 'org-mode-hook 'org-sticky-header-mode)
;; Org sticky header:1 ends here

;; [[file:config.org::*Org brain][Org brain:1]]
;; ;; https://github.com/Kungsgeten/org-brain
;; (require 'org-brain)
;; (setq org-brain-path "~/org/brain/")
;; ;; For Evil users
;; (with-eval-after-load 'evil
;;   (evil-set-initial-state 'org-brain-visualize-mode 'emacs))

;; ;; (bind-key "C-c b" 'org-brain-prefix-map org-mode-map)
;; ;; (setq org-id-track-globally t)
;; ;; (setq org-id-locations-file "~/.emacs.d/.org-id-locations")
;; (add-hook 'before-save-hook #'org-brain-ensure-ids-in-buffer)
;; (push '("b" "Brain" plain (function org-brain-goto-end)
;;         "* %i%?" :empty-lines 1)
;;       org-capture-templates)
;; (setq org-brain-visualize-default-choices 'all)
;; (setq org-brain-title-max-length 12)
;; (setq org-brain-include-file-entries nil
;;       org-brain-file-entries-use-title nil)
;; Org brain:1 ends here

;; [[file:config.org::*Polymode][Polymode:1]]
;; (add-hook 'org-brain-visualize-mode-hook #'org-brain-polymode)
;; Polymode:1 ends here

;; [[file:config.org::*Ace jump][Ace jump:1]]

;; Ace jump:1 ends here

;; [[file:config.org::*Avy][Avy:1]]

;; Avy:1 ends here

;; [[file:config.org::*elfeed][elfeed:1]]
(setq rmh-elfeed-org-files '("~/org/elfeed.org"))
(setq elfeed-goodies/entry-pane-size 0.50)

(add-hook! 'elfeed-search-mode-hook 'elfeed-update)

(after! elfeed
  (setq elfeed-search-filter "@1-month-ago +unread"))

(map! :leader "l f" 'elfeed)

;; (setq elfeed-feeds
;;       '("https://this-week-in-rust.org/rss.xml"
;;         "http://feeds.bbci.co.uk/news/rss.xml"
;;         "https://www.reddit.com/r/emacs.rss"
;;         ))


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
;; elfeed:1 ends here

;; [[file:config.org::*mu4e][mu4e:1]]
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
;; mu4e:1 ends here

;; [[file:config.org::*ox extra][ox extra:1]]
(after! org
  (use-package! ox-extra
    :config
    (ox-extras-activate '(latex-header-blocks ignore-headlines))))
;; ox extra:1 ends here

;; [[file:config.org::*ox reveal][ox reveal:1]]
(require 'ox-reveal)
;; ox reveal:1 ends here

;; [[file:config.org::*leetcode][leetcode:1]]
(setq leetcode-prefer-language "python3")
(setq leetcode-save-solutions t)
(setq leetcode-directory "~/leetcode")
;; leetcode:1 ends here

;; [[file:config.org::*Default Text Mode][Default Text Mode:1]]
;; (require 'default-text-scale)

;; (default-text-scale-increment (- default-text-scale-amount))
;; Default Text Mode:1 ends here

;; [[file:config.org::*ox-hugo][ox-hugo:1]]
(require 'ox-hugo)

;; org-ref citation
;; reference:https://ox-hugo.scripter.co/doc/org-ref-citations/
(use-package org-ref
  :ensure t
  :init
  (with-eval-after-load 'ox
    (defun my/org-ref-process-buffer--html (backend)
      "Preprocess `org-ref' citations to HTML format.

Do this only if the export backend is `html' or a derivative of
that."
      ;; `ox-hugo' is derived indirectly from `ox-html'.
      ;; ox-hugo <- ox-blackfriday <- ox-md <- ox-html
      (when (org-export-derived-backend-p backend 'html)
        (org-ref-process-buffer 'html)))
    (add-to-list 'org-export-before-parsing-hook #'my/org-ref-process-buffer--html)))
;; ox-hugo:1 ends here

;; [[file:config.org::*multi-term][multi-term:1]]
(setq multi-term-program "/bin/zsh")
;; multi-term:1 ends here

;; [[file:config.org::*basic config][basic config:1]]
(after! org
  ;; Import ox-latex to get org-latex-classes and other funcitonality
  ;; for exporting to LaTeX from org
  (use-package! ox-latex
    :init
    ;; code here will run immediately
    :config
    ;; code here will run after the package is loaded
    ;; (setq org-latex-pdf-process
    ;;       '("pdflatex -interaction nonstopmode -output-directory %o %f"
    ;;         "bibtex %b"
    ;;         "pdflatex -interaction nonstopmode -output-directory %o %f"
    ;;         "pdflatex -interaction nonstopmode -output-directory %o %f"))
    (setq org-latex-pdf-process (list "latexmk -shell-escape -bibtex -f -pdf %f"))
    (setq org-latex-with-hyperref nil) ;; stop org adding hypersetup{author..} to latex export
    ;; (setq org-latex-prefer-user-labels t)

    ;; deleted unwanted file extensions after latexMK
    (setq org-latex-logfiles-extensions
          (quote ("lof" "lot" "tex~" "aux" "idx" "log" "out" "toc" "nav" "snm" "vrb" "dvi" "fdb_latexmk" "blg" "brf" "fls" "entoc" "ps" "spl" "bbl" "xmpi" "run.xml" "bcf" "acn" "acr" "alg" "glg" "gls" "ist")))

    (unless (boundp 'org-latex-classes)
      (setq org-latex-classes nil))))
;; basic config:1 ends here

;; [[file:config.org::*Doom specific config][Doom specific config:1]]
;; (setq reftex-default-bibliography "/your/bib/file.bib")
;; Doom specific config:1 ends here

;; [[file:config.org::*templates][templates:1]]
(add-to-list 'org-latex-classes
             '("altacv" "\\documentclass[10pt,a4paper,ragged2e,withhyper]{altacv}

% Change the page layout if you need to
\\geometry{left=1.25cm,right=1.25cm,top=1.5cm,bottom=1.5cm,columnsep=1.2cm}

% Use roboto and lato for fonts
\\renewcommand{\\familydefault}{\\sfdefault}

% Change the colours if you want to
\\definecolor{SlateGrey}{HTML}{2E2E2E}
\\definecolor{LightGrey}{HTML}{666666}
\\definecolor{DarkPastelRed}{HTML}{450808}
\\definecolor{PastelRed}{HTML}{8F0D0D}
\\definecolor{GoldenEarth}{HTML}{E7D192}
\\colorlet{name}{black}
\\colorlet{tagline}{PastelRed}
\\colorlet{heading}{DarkPastelRed}
\\colorlet{headingrule}{GoldenEarth}
\\colorlet{subheading}{PastelRed}
\\colorlet{accent}{PastelRed}
\\colorlet{emphasis}{SlateGrey}
\\colorlet{body}{LightGrey}

% Change some fonts, if necessary
\\renewcommand{\\namefont}{\\Huge\\rmfamily\\bfseries}
\\renewcommand{\\personalinfofont}{\\footnotesize}
\\renewcommand{\\cvsectionfont}{\\LARGE\\rmfamily\\bfseries}
\\renewcommand{\\cvsubsectionfont}{\\large\\bfseries}

% Change the bullets for itemize and rating marker
% for \cvskill if you want to
\\renewcommand{\\itemmarker}{{\\small\\textbullet}}
\\renewcommand{\\ratingmarker}{\\faCircle}
"

               ("\\cvsection{%s}" . "\\cvsection*{%s}")))

(add-to-list 'org-latex-classes
             '("IEEE" "\\documentclass{IEEEtran}"
  ("\\section{%s}" . "\\section*{%s}")
  ("\\subsection{%s}" . "\\subsection*{%s}")
  ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
  ("\\paragraph{%s}" . "\\paragraph*{%s}")
  ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(add-to-list 'org-latex-classes
             '("acmart" "\\documentclass{acmart}"
  ("\\section{%s}" . "\\section*{%s}")
  ("\\subsection{%s}" . "\\subsection*{%s}")
  ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
  ("\\paragraph{%s}" . "\\paragraph*{%s}")
  ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(add-to-list 'org-latex-classes
             '("org-plain-text"
               "\\documentclass{article}
[NO-DEFAULT-PACKAGES]
[PACKAGES]
[EXTRA]"

                ("\\section{%s}" . "\\section*{%s}")
                ("\\subsection{%s}" . "\\subsection*{%s}")
                ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                ("\\paragraph{%s}" . "\\paragraph*{%s}")
                ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
;; templates:1 ends here

;; [[file:config.org::*version 1][version 1:1]]
(defun anak/my-yank-image-from-win-clipboard-through-powershell() "to simplify the logic, use c:/Users/Public as temporary directoy, and move it into current directoy"
       (interactive)
       (let* ((powershell "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe")
              (file-name (format-time-string "screenshot_%Y%m%d_%H%M%S.png"))
              (file-path-wsl (concat "./images/" file-name))
              )
         (make-directory "images" ".")
         (shell-command (concat powershell " -command \"(Get-Clipboard -Format Image).Save(\\\"./images/" file-name "\\\")\""))
         ;; (rename-file (concat "/mnt/c/Users/Public/images/" file-name) file-path-wsl)
         (insert (concat "[[file:" file-path-wsl "]]"))
         (message "insert DONE.")
         ))
;; version 1:1 ends here

;; [[file:config.org::*version 2][version 2:1]]
;; ;; ref:  https://alexrampp.de/2020/11/07/how-to-paste-images-into-emacs-org-mode-running-in-windows-subsystem-for-linux/
;; (defun my-org-paste-image ()
;;   "Paste an image into a time stamped unique-named file in the
;; same directory as the org-buffer and insert a link to this file."
;;   (interactive)
;;   (let* ((target-file
;;           (concat
;;            (make-temp-name
;;             (concat (buffer-file-name)
;;                     "_"
;;                     (format-time-string "%Y%m%d_%H%M%S_"))) ".png"))
;;          (wsl-path
;;           (concat (as-windows-path(file-name-directory target-file))
;;                   "\"
;;                   (file-name-nondirectory target-file)))
;;          (ps-script
;;           (concat "(Get-Clipboard -Format image).Save('" wsl-path "')")))

;;     (powershell ps-script)

;;     (if (file-exists-p target-file)
;;         (progn (insert (concat "[[" target-file "]]"))
;;                (org-display-inline-images))
;;       (user-error
;;        "Error pasting the image, make sure you have an image in the clipboard!"))
;;     ))

;; (defun as-windows-path (unix-path)
;;   "Takes a unix path and returns a matching WSL path
;; (e.g. \\wsl$\Ubuntu-20.04\tmp)"
;;   ;; substring removes the trailing \n
;;   (substring
;;    (shell-command-to-string
;;     (concat "wslpath -w " unix-path)) 0 -1))

;; (defun powershell (script)
;;   "executes the given script within a powershell and returns its return value"
;;   (call-process "powershell.exe" nil nil nil
;;                 "-Command" (concat "& {" script "}")))
;; version 2:1 ends here

;; [[file:config.org::*Compile command][Compile command:1]]
;; (add-hook 'LaTeX-mode-hook
;;           (lambda ()
;;             (set (make-local-variable 'compile-command)
;;                  (format "pdflatex %s" (buffer-file-name)))))

(defun set-compile-command-default-in-LaTeX-mode ()
  (set (make-local-variable 'compile-command)
                 (format "pdflatex %s" (buffer-file-name))))

(add-hook 'LaTeX-mode-hook
          'set-compile-command-default-in-LaTeX-mode)
;; Compile command:1 ends here

;; [[file:config.org::*Common Lisp][Common Lisp:1]]
(setq inferior-lisp-program "sbcl")
;; Common Lisp:1 ends here

;; [[file:config.org::*Scimax][Scimax:1]]
;; (load-file "~/Downloads/scimax/init.el")
;; Scimax:1 ends here

;; [[file:config.org::*scimax-jupyter][scimax-jupyter:1]]
(load-file "~/Downloads/scimax/scimax-ob.el")
(load-file "~/Downloads/scimax/scimax-jupyter.el")
;; scimax-jupyter:1 ends here

;; [[file:config.org::*scimax-jupyter][scimax-jupyter:2]]
(scimax-jupyter-advise)
;; scimax-jupyter:2 ends here

;; [[file:config.org::*stack exchage (sx.el)][stack exchage (sx.el):1]]
;; (add-hook 'sx-question-mode-hook (lambda () (turn-off-evil-mode))) ;; work
;; (add-hook 'sx-question-list-mode-hook #'turn-off-evil-mode) ;; doesn't work. not sure why.
(set-evil-initial-state! 'sx-question-list-mode 'emacs)
(set-evil-initial-state! 'sx-question-mode 'emacs)
;; stack exchage (sx.el):1 ends here

;; [[file:config.org::*stack exchage (sx.el)][stack exchage (sx.el):2]]
(after! org
       (use-package! sx
         :config
         (bind-keys :prefix "C-c s"
                    :prefix-map my-sx-map
                    :prefix-docstring "Global keymap for SX."
                    ("q" . sx-tab-all-questions)
                    ("i" . sx-inbox)
                    ("o" . sx-open-link)
                    ("u" . sx-tab-unanswered-my-tags)
                    ("a" . sx-ask)
                    ("s" . sx-search))))

(map! :leader "l s" 'sx-ask)
;; stack exchage (sx.el):2 ends here

;; [[file:config.org::*yankpad][yankpad:1]]
(setq yankpad-file "~/org/yankpad.org")
(map! :leader "y m" #'yankpad-map)
(map! :leader "y i" #'yankpad-insert)
(map! :leader "y x" #'yankpad-expand)
(map! :leader "y c" #'yankpad-capture-snippet)
(map! :leader "y s" #'yankpad-set-category)
(map! :leader "y e" #'yankpad-edit)
(map! :leader "y p" #'yankpad-aya-persist)
(map! :leader "y r" #'yankpad-reload)
;; yankpad:1 ends here

;; [[file:config.org::*Code Library][Code Library:1]]
(setq code-library-directory "~/org/CodeLibrary"
      code-library-sync-to-gist t)
;; Code Library:1 ends here

;; [[file:config.org::*Hierarchy][Hierarchy:1]]
(load-file "~/.emacs.d/.local/straight/repos/hierarchy/hierarchy.el")
(require 'hierarchy)
;; Hierarchy:1 ends here

;; [[file:config.org::*reddit (md4rd packages)][reddit (md4rd packages):1]]
(require 'md4rd)

;; authentication
(add-hook 'md4rd-mode-hook 'md4rd-indent-all-the-lines)
(setq md4rd-subs-active '(emacs lisp+Common_Lisp orgmode OrgRoam))
;; (setq md4rd--oauth-access-token "your-access-token-here")
;; (setq md4rd--oauth-refresh-token "your-refresh-token-here")
;; (run-with-timer 0 3540 'md4rd-refresh-login))

(add-hook 'md4rd-mode-hook #'turn-off-evil-mode nil)
;; (set-evil-initial-state! 'sx-question-list-mode 'emacs)
(map! :leader "l r" 'md4rd)                   ;; logging to reddit

;; (map! :leader "l s r u" 'tree-mode-goto-parent)
;; (map! :leader "l s r o" 'md4rd-open)
;; (map! :leader "l s r v" 'md4rd-visit)
;; (map! :leader "l s r e" 'tree-mode-toggle-expand)
;; (map! :leader "l s r E" 'md4rd-widget-expand-all)
;; (map! :leader "l s r C" 'md4rd-widget-collapse-all)
;; (map! :leader "l s r n" 'widget-forward)
;; (map! :leader "l s r j" 'widget-forward)
;; (map! :leader "l s r h" 'backward-button)
;; (map! :leader "l s r p" 'widget-backward)
;; (map! :leader "l s r k" 'widget-backward)
;; (map! :leader "l s r l" 'forward-button)
;; (map! :leader "l s r q" 'kill-current-buffer)
;; (map! :leader "l s r r" 'md4rd-reply)
;; (map! :leader "l s r u" 'md4rd-upvote)
;; (map! :leader "l s r d" 'md4rd-downvote)
;; (map! :leader "l s r t" 'md4rd-widget-toggle-line)
;; reddit (md4rd packages):1 ends here

;; [[file:config.org::*howdoyou][howdoyou:1]]
(map! :leader "l h" 'howdoyou-query)
;; howdoyou:1 ends here

;; [[file:config.org::*langtool][langtool:1]]
(setq langtool-language-tool-jar "~/Downloads/LanguageTool-5.6-stable/languagetool-commandline.jar")
(map! :leader "l l c" 'langtool-check)
(map! :leader "l l q" 'langtool-check-done)
;; (map! :leader "l l s" 'langtool-switch-default-language)
(map! :leader "l l m" 'langtool-show-message-at-point)
(map! :leader "l l e" 'langtool-correct-buffer)
;; langtool:1 ends here

;; [[file:config.org::*spell fu][spell fu:1]]
;; (after! spell-fu)
;; (setf (alist-get 'markdown-mode '+spell-excluded-faces-alist)
;;       '(markdown-code-face
;;         markdown-reference-face
;;         markdown-link-face
;;         markdown-url-face
;;         markdown-markup-face
;;         markdown-html-attr-value-face
;;         markdown-html-attr-name-face
;;         markdown-html-tag-name-face))

;; (setf (alist-get 'org-mode '+spell-excluded-faces-alist)
;;       '(org-block-begin-line
;;        org-block-end-line
;;        org-code
;;        org-date
;;        org-drawer org-document-info-keyword
;;        org-ellipsis
;;        org-link
;;        org-meta-line
;;        org-properties
;;        org-properties-value
;;        org-special-keyword
;;        org-src
;;        org-tag
;;        org-verbatim))
;; spell fu:1 ends here

;; [[file:config.org::*flyspell][flyspell:1]]
(map! :n "z ." 'flyspell-correct-wrapper)
;; flyspell:1 ends here

;; [[file:config.org::*org superlink][org superlink:1]]
(add-to-list 'load-path "~/.emacs.d/manual-install/org-super-links/")
(require 'org-super-links)
(use-package! org-super-links
  :bind (("C-c s s" . org-super-links-link)
	   ("C-c s l" . org-super-links-store-link)
	   ("C-c s C-l" . org-super-links-insert-link)))
;; (map! :leader "n l" #'org-super-links-store-link)
;; (map! :leader "m l l" #'org-super-links-insert-link)
;; org superlink:1 ends here

;; [[file:config.org::*ledger][ledger:1]]
(add-to-list 'auto-mode-alist '("\\.dat\\'" . ledger-mode))
;; ledger:1 ends here
