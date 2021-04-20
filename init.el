;;
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

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

;;;;
;; use separete file for customize
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;;;; Key re-maps
;; Use ibuffer instead of list-all-buffers
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; Change hotkey for undo
(global-set-key (kbd "C-z") 'undo)

;; Change M-x to C-x C-m
(global-set-key (kbd "C-x C-m") 'execute-extended-command)

;; Make right Alt to be treated the same as left Alt
(setq w32-recognize-altgr nil)

;; Multiple cursors
(global-set-key (kbd "C-c l") 'mc/edit-lines)

;;
(global-set-key (kbd "C-<tab>") 'switch-to-buffer)

;; backup files
(setq backup-directory-alist `((".*" . ,"~/.emacs.d/backup/"))
      delete-old-versions t)

;; use spaces instead of tab characters
(setq-default indent-tabs-mode nil)
;; make the default tab width to 4 chars 
(setq-default tab-width 4)

;;;; Magit configuration
;;
(require 'magit)
(define-key magit-mode-map (kbd "C-c s") 'magit-status)

;;;; Org mode Configuration
;; Turn on auto-fill-mode when org-starts
(add-hook 'org-mode-hook 'auto-fill-mode) 
;; Change TODO keywords
(setq org-todo-keywords
      '((sequence "TODO" "DOING" "|" "DONE")))
;; Change colors of TODO keywords
(setq org-todo-keyword-faces
      '(("TODO" . "#F0DFAF")
        ("DOING" . "#AFB3F0")))
(setq org-startup-indented t)

;;;; projectile configuration
(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "s-s") 'projectile-find-file)
(define-key projectile-mode-map (kbd "s-p") 'projectile-switch-project)
(setq projectile-project-search-path '("~/repos/"))
(setq projectile-completion-system 'ivy)
(setq projectile-indexing-method 'alien)

;;;; Counsel
(ivy-mode 1)
(global-set-key (kbd "C-s") 'swiper-isearch)
(global-set-key (kbd "C-r") 'swiper-backward)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "C-x b") 'ivy-switch-buffer)
(global-set-key (kbd "M-y") 'counsel-yank-pop)

;;;; expand-region
(global-set-key (kbd "C-=") 'er/expand-region)

;; disabled commnads
(put 'set-goal-column 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;;;; golang
;; start lsp server on opening go file
(add-hook 'go-mode-hook #'lsp)

;; call fmt and imports on every save
(setq gofmt-command "goimports")
(add-hook 'before-save-hook 'gofmt-before-save)

;; Extend PATH when emacs is started from Launchpad
(when (not (cl-search "/Users/ivanruski/go/bin:" (getenv "PATH")))
  (setenv "PATH" (concat "/Users/ivanruski/go/bin:" "/usr/local/bin:" (getenv "PATH")))
  (setq exec-path (cons "/Users/ivanruski/go/bin" (cons "/usr/local/bin" exec-path))))

;;;; direx
(global-set-key (kbd "C-x C-j") 'direx:jump-to-directory)
