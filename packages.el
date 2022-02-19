;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.


;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
;(package! some-package)

;; To install a package directly from a remote git repo, you must specify a
;; `:recipe'. You'll find documentation on what `:recipe' accepts here:
;; https://github.com/raxod502/straight.el#the-recipe-format
;(package! another-package
;  :recipe (:host github :repo "username/repo"))

;; If the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
;(package! this-package
;  :recipe (:host github :repo "username/repo"
;           :files ("some-file.el" "src/lisp/*.el")))

;; If you'd like to disable a package included with Doom, you can do so here
;; with the `:disable' property:
;(package! builtin-package :disable t)

;; You can override the recipe of a built in package without having to specify
;; all the properties for `:recipe'. These will inherit the rest of its recipe
;; from Doom or MELPA/ELPA/Emacsmirror:
;(package! builtin-package :recipe (:nonrecursive t))
;(package! builtin-package-2 :recipe (:repo "myfork/package"))

;; Specify a `:branch' to install a package from a particular branch or tag.
;; This is required for some packages whose default branch isn't 'master' (which
;; our package manager can't deal with; see raxod502/straight.el#279)
;(package! builtin-package :recipe (:branch "develop"))

;; Use `:pin' to specify a particular commit to install.
;(package! builtin-package :pin "1a2b3c4d5e")


;; Doom's packages are pinned to a specific commit and updated from release to
;; release. The `unpin!' macro allows you to unpin single packages...
;(unpin! pinned-package)
;; ...or multiple packages
;(unpin! pinned-package another-pinned-package)
;; ...Or *all* packages (NOT RECOMMENDED; will likely break things)
;(unpin! t)

(package! org-roam-bibtex
  :recipe (:host github :repo "org-roam/org-roam-bibtex"))

;; When using org-roam via the `+roam` flag
(unpin! org-roam)

;; When using bibtex-completion via the `biblio` module
(unpin! bibtex-completion helm-bibtex ivy-bibtex)

;; (package! mu4e)

(package! org-drill)
(package! command-log-mode)
(package! org-tree-slide)
(package! ace-jump-mode)
(package! org-ref)
;; (package! org-noter)
(package! ledger-mode)
(package! org-sidebar)
(package! org-bullets)
(package! pdf-tools) ;; for
(package! ox-reveal)
;; dap-mode is highlighted in pink while other is highlighted in white. Does it mean it always is loaded by doom emacs?
(package! dap-mode)
;; (package! dap-lldb)
(package! elfeed-goodies)
(package! leetcode)
(package! simple-httpd)
(package! bookmark+)
;; (package! jupyter)
(package! tree-sitter)
(package! tree-sitter-langs)
(package! cask) ;; added this while attempted to debug pdf-tools (I still can't fix it)
(package! stickyfunc-enhance)
(package! exec-path-from-shell)
;; (package! evil-paredit)
;; (package! paredit)
;; (package! paredit-everywhere)

;; (package! gitconfig-mode :disable t)
;; (package! gitignore-mode :disable t)
;; (package! git-modes :pin "433e1c57a63c88855fc41a942e29d7bc8c9c16c7")
(package! web-beautify)

;; environment variables managers
;; (package! conda)
;; (package! pyvenv)
;; (package! lispy)
;; (package! lispyville)

(package! lsp-metals)                   ;; lsp for  scala-mode
;; (package! format-all)                   ;; lsp for  scala-mode

;; (package! webfrer -debug)
(package! benchstat)                    ;;
(package! cfn-mode) ;; cloudformation mode
;; (package! code-cell)
(package! camcorder)
(package! ob-mermaid)
(package! mermaid-mode)
(package! graphviz-dot-mode)
;; (package! ob-scala)
(package! lsp-pyright)
(package! yankpad)
(package! org-transclusion)
(package! ox-reveal)
