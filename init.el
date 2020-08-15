;;
(require 'package)
(package-initialize)

(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))

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

;; Set emacs backup directory
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
  backup-by-copying t    ; Don't delink hardlinks
  version-control t      ; Use version numbers on backups
  delete-old-versions t  ; Automatically delete excess backups
  kept-new-versions 2   ; how many of the newest versions to keep
  kept-old-versions 2    ; and how many of the old
  )

;; use spaces instead of tab characters
(setq-default indent-tabs-mode nil)
;; make the default tab width to 4 chars 
(setq-default tab-width 4)

;;;; Org mode Configuration
;;
(require 'org)
;; Turn on auto-fill-mode when org-starts
(add-hook 'org-mode-hook 'auto-fill-mode) 
;; Change TODO keywords
(setq org-todo-keywords
      '((sequence "TODO" "DOING" "|" "DONE")))
;; Change colors of TODO keywords
(setq org-todo-keyword-faces
      '(("TODO" . "#F0DFAF")
        ("DOING" . "#AFB3F0")))

;;;; projectile configuration
(require 'projectile)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(projectile-mode +1)
(setq projectile-project-search-path '("~/../../projects/" "~/Documents/"))

;;;; Shell configuration
;; TODO: Check the OS
(setq explicit-shell-file-name "C:/Program Files/Git/bin/bash.exe")
(setq shell-file-name "bash")
(setq explicit-bash.exe-args '("--noediting" "--login" "-i"))
(setenv "SHELL" shell-file-name)
(add-hook 'comint-output-filter-functions 'comint-strip-ctrl-m)

;;;; Counsel
(ivy-mode 1)
(global-set-key (kbd "C-s") 'swiper-isearch)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "C-x b") 'ivy-switch-buffer)
(global-set-key (kbd "M-y") 'counsel-yank-pop)

;;;; Neotree
(global-set-key (kbd "<f8>") 'neotree-toggle)
