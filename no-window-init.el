(require 'package)
(package-initialize)

;; Skip the startup screen
(setq-default inhibit-startup-screen t)

;; Turn off the awful beep in Windows
(setq visible-bell 1)

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

;; use spaces instead of tab characters
(setq-default indent-tabs-mode nil)
;; make the default tab width to 4 chars 
(setq-default tab-width 4)

;;;; Counsel
(ivy-mode 1)
(global-set-key (kbd "C-s") 'swiper-isearch)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "C-x b") 'ivy-switch-buffer)
(global-set-key (kbd "M-y") 'counsel-yank-pop)

;;;; expand-region
(global-set-key (kbd "C-=") 'er/expand-region)

;; disabled commnads
(put 'set-goal-column 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

