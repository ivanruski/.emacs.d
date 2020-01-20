;; add melpa packages
;; no sure what exacly the function
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; use separete file for customize
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;; Skip the startup screen
(setq-default inhibit-startup-screen t)

;; Turn off the awful beep in Windows
(setq visible-bell 1)

;;Load default theme
(load-theme 'ample-zen t)

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

;; Key re-maps
;; Change hotkey for undo
(global-set-key [(control z)] 'undo)
;; Change M-x to C-x C-m
(global-set-key "\C-x\C-m" 'execute-extended-command)

;; Overriding the default (control-b) for showing and navigating
;; to all available opened buffers
(global-set-key [(control tab)] 'switch-to-buffer)

;; Set emacs backup directory
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
  backup-by-copying t    ; Don't delink hardlinks
  version-control t      ; Use version numbers on backups
  delete-old-versions t  ; Automatically delete excess backups
  kept-new-versions 5   ; how many of the newest versions to keep
  kept-old-versions 5    ; and how many of the old
  )

;; use spaces instead of tab characters and make the default tab width to 4 chars 
(setq-default tab-width 4)
(setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80))
(setq-default indent-tabs-mode nil)

(setq default-directory "~/")
(setq column-number-mode t)


;;;; Org mode Configuration
;; Enable org mode
(require 'org)
;; Enter org mode when encounter file ending in .org

