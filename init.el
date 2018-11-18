;; Hide the toolbar
(tool-bar-mode -1)

;; Hide the menu bar
(menu-bar-mode -1)

;; Hide the scroll bar
(scroll-bar-mode -1)

;; Change the cursor to _
(set-default 'cursor-type 'hbar)

;; turn on highlight matching brackets when cursor is on one
(show-paren-mode 1)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-enabled-themes (quote (wombat)))
 '(inhibit-startup-screen t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/")
             t)

;; set path to the racket binary in order to be abel to use racket-mode
(setq racket-program "./../../usr/bin/racket")

;; Change hotkey for undo
(global-set-key [(control z)] 'undo)

;; Overriding the default (control-b) for showing and navigating
;; to all available opened buffers
(global-set-key [(control tab)] 'switch-to-buffer)

;; Set indentaion to 4 for c/cpp files
(setq-default c-basic-offset 4)
