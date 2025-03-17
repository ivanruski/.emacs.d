(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

;; https://github.com/purcell/exec-path-from-shell
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;;;; UI changes
;; Skip the startup screen
(setq-default inhibit-startup-screen t)

;; Turn off the awful beep in Windows
(setq visible-bell 1)

;;Load default theme
(load-theme 'zenburn t)

;; Hide the toolbar
(tool-bar-mode -1)

;; Hide the menu bar
(menu-bar-mode -1)

;; Hide the scroll bar
(scroll-bar-mode -1)

;; Change the cursor type
(set-default 'cursor-type 'box)

;; turn on highlight matching brackets when cursor is on one
(show-paren-mode 1)

;; Move through windows using s + arrow keys
(windmove-default-keybindings)

;; Display current position of the point (row, col)
(setq column-number-mode t)

;; Delete marked area when typing instead of insert
(delete-selection-mode t)

;; Show lines numbers relatively to the current line
(global-display-line-numbers-mode)
(setq display-line-numbers-type 'visual)
(setq display-line-numbers-mode 't)

;; Go to the next captial letter or end of word when using M-f
(global-subword-mode)

;; Go to the top/bottom of buffer when no more scrolling is possible
(setq scroll-error-top-bottom t)

;; Do not wrap long lines
(setq-default truncate-lines t)

;;;;
;; use separete file for customize
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;;;; global-set-key re-maps
;; Use ibuffer instead of list-all-buffers
(global-set-key (kbd "C-x C-b") 'ibuffer)

(setq ibuffer-saved-filter-groups
      '(("default"
         ("playg" (filename . "\/playg"))
         ("orgfiles" (filename . "\/orgfiles"))
         ("config-service" (filename . "\/bc\/config-service"))
         ("event-forwarder" (filename . "\/bc\/event-forwarder"))
         ("uma-config" (filename . "uma-config"))
         ("vmwcbc" (filename . "vmwcbc")))))

(add-hook 'ibuffer-mode-hook
	  (lambda ()
	    (ibuffer-switch-to-saved-filter-groups "default")))

;; Change hotkey for undo
(global-set-key (kbd "C-z") 'undo)

;; Change M-x to C-x C-m
(global-set-key (kbd "C-x C-m") 'execute-extended-command)

;; Move point to the beginning of the buffer
(global-set-key (kbd "C-c t") 'beginning-of-buffer)

;; Move point to the end of the buffer
(global-set-key (kbd "C-c b") 'end-of-buffer)

;; Multiple cursors
(global-set-key (kbd "C-c l") 'mc/edit-lines)
(global-set-key (kbd "C-c C-.") 'mc/mark-next-like-this-symbol)


(global-set-key (kbd "C-<tab>") 'switch-to-buffer)

;; direx
(global-set-key (kbd "C-x C-j") 'direx:jump-to-directory)

;; expand-region
(global-set-key (kbd "C-=") 'er/expand-region)
(global-set-key (kbd "C--") 'er/contract-region)

;; fill-paragraph
(global-set-key (kbd "C-c f") 'fill-paragraph)

;; Wrap lines at 80 characters
(setq-default fill-column 80)

;; Make right Alt to be treated the same as left Alt
(setq w32-recognize-altgr nil)

;; backup files
(setq backup-directory-alist `((".*" . ,"~/.emacs.d/backup/"))
      delete-old-versions t)

;; use spaces instead of tab characters
(setq-default indent-tabs-mode nil)
;; make the default tab width to 4 chars 
(setq-default tab-width 4)

;;;; Magit configuration
(require 'magit)
(define-key magit-mode-map (kbd "C-c s") 'magit-status)

;;;; Org mode Configuration
;; Turn on auto-fill-mode when org-starts
(require 'org)

(add-hook 'org-mode-hook 'auto-fill-mode)

;; Change TODO keywords
(setq org-todo-keywords
      '((sequence "TODO(t!)" "DOING(w!)" "BLOCKED(b!)" "|" "DONE(d!)")))

;; Change colors of TODO keywords
(setq org-todo-keyword-faces
      '(("TODO" . "#F0DFAF")
        ("DOING" . "#AFB3F0")
        ("BLOCKED" . "#DC143C")))

(setq org-log-into-drawer "LOGBOOK")

(setq org-startup-indented t)
(setq org-hide-emphasis-markers t)
(setq org-ellipsis " ▾") ;; M-x customize-face Ret org-ellipsis (in case there is _)

(setq org-agenda-files
      '("~/orgfiles/tasks.org" "~/orgfiles/today.org" "~/Documents/backlog.org"))

;; group files by year and exclude them from here every january
(setq org-refile-targets
      '(("~/orgfiles/archive-24.org" :maxlevel . 1)
        ("~/orgfiles/today.org" :maxlevel . 1)))

(advice-add 'org-refile :after 'org-save-all-org-buffers)

;;;; Org roam
(setq org-roam-directory "~/roam-notes")
(setq org-roam-v2-ack 't)
(global-set-key (kbd "C-c n l") 'org-roam-buffer-toggle)
(global-set-key (kbd "C-c n f") 'org-roam-node-find)
(global-set-key (kbd "C-c n i") 'org-roam-node-insert)
(org-roam-db-autosync-mode)

;;;; projectile configuration
(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "s-s") 'projectile-find-file)
(define-key projectile-mode-map (kbd "s-p") 'projectile-switch-project)
(setq projectile-project-search-path '("~/repos/"))
(setq projectile-completion-system 'ivy)
(setq projectile-indexing-method 'alien)

;;;; ivy
(ivy-mode 1)
(define-key ivy-mode-map (kbd "C-s") 'swiper-isearch)
(define-key ivy-mode-map (kbd "C-r") 'swiper-backward)
(define-key ivy-mode-map (kbd "C-x C-f") 'counsel-find-file)

;; disabled commnads
(put 'set-goal-column 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;;;; golang
(require 'go-mode)

(define-key go-mode-map (kbd "C-c d") 'lsp-find-definition)
(define-key go-mode-map (kbd "C-c r") 'lsp-find-references)
(define-key go-mode-map (kbd "C-c C-r") 'lsp-rename)

;; start lsp server on opening go file
(add-hook 'go-mode-hook #'lsp-deferred)

;; gopls doesn't work well out of the box in files with build tags
(setq lsp-go-build-flags [ "-tags=integration" ])

;;;; lsp
(require 'lsp-mode)

(defun before-save-per-mode ()
  (when (equal major-mode 'go-mode)
    (lsp-organize-imports)
    (lsp-format-buffer)))

(add-hook 'before-save-hook 'before-save-per-mode)

(setq lsp-lens-enable nil)
(setq lsp-enable-snippet nil)

;;;; prettier

;; First install with "npm install -g prettier" and make sure Emacs can find the
;; "prettier" command
(require 'prettier-js)

;;;; typescript
(require 'typescript-mode)
(add-hook 'typescript-mode-hook #'lsp-deferred)
(add-hook 'typescript-mode-hook 'prettier-js-mode)

(setq typescript-indent-level 4)

;;;; Scheme
(setq scheme-program-name "mit-scheme")
