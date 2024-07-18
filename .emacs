(setq inhibit-startup-message t)
(setq left-fringe-width 16)
(set-fringe-style (quote (20 . 10)))


;; Enable line numbers globally
(global-display-line-numbers-mode 1)

;; Use relative line numbers
(setq display-line-numbers-type 'relative)

(column-number-mode)
(set-fringe-mode 10)
(global-set-key (kbd "C-c t") 'shell)

;; do not show in shell line number
(dolist (mode '(shell-mode-hook term-mode-hook eterm-mode-hook eshell-mode-hook treemacs-mode-hook)) (add-hook mode (lambda() (display-line-numbers-mode 0))))

;; OPEN PROJECT MANAGEMENT
(add-hook 'emacs-startup-hook 'treemacs-add-and-display-current-project-exclusively)

;; sources

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("melpa-stable" . "http://stable.melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(setq global-display-line-numbers 'relative) 
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)
;; TABS
(use-package centaur-tabs
  :ensure t
  :demand
  :config
  (centaur-tabs-mode t)
  (setq centaur-tabs-set-icons t)
  :bind
  ("C-<prior>" . centaur-tabs-backward)
  ("C-<next>" . centaur-tabs-forward))
(setq centaur-tabs-style "rounded")

;; DOCKER
(use-package docker
  :ensure t
  :bind ("C-c d" . docker))
(use-package lsp-docker)
(use-package eterm-256color
  :hook (term-mode . eterm-256color-mode))
(defun efs/configure-eshell ()
  ;; Save command history when commands are entered
  (add-hook 'eshell-pre-command-hook 'eshell-save-some-history)

  ;; Truncate buffer for performance
  (add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)

  ;; Bind some useful keys for evil-mode
  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "C-r") 'counsel-esh-history)
  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "<home>") 'eshell-bol)
  (evil-normalize-keymaps)

  (setq eshell-history-size         10000
        eshell-buffer-maximum-lines 10000
        eshell-hist-ignoredups t
        eshell-scroll-to-bottom-on-input t))

(use-package eshell-git-prompt)

(use-package eshell
  :hook (eshell-first-time-mode . efs/configure-eshell)
  :config

  (with-eval-after-load 'esh-opt
    (setq eshell-destroy-buffer-when-process-dies t)
    (setq eshell-visual-commands '("htop" "zsh" "vim")))

  (eshell-git-prompt-use-theme 'powerline))


(use-package all-the-icons)

;; IVY
(use-package ivy :diminish)
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq ivy-count-format "(%d/%d) ")
(global-set-key (kbd "C-s") 'swiper-isearch)
(use-package ivy-rich :diminish)

(use-package flycheck
  :ensure t
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode))
;; THEME
(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-Iosvkem t))

;; DOOM
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))
(setq doom-modeline-icon t)
(setq doom-modeline-major-mode-icon t)
(setq doom-modeline-major-mode-color-icon t)
(setq doom-modeline-buffer-state-icon t)
(setq doom-modeline-buffer-modification-icon nil)
(setq doom-modeline-height 35)
(setq doom-modeline-project-detection 'auto)
(setq doom-modeline-lsp-icon t)
(setq doom-modeline-enable-word-count t)
(setq doom-modeline-total-line-number t)
(setq find-file-visit-truename t)
(setq doom-modeline-modal t)
(setq doom-modeline-modal-icon t)
(setq doom-modeline-modal-modern-icon t)
(setq doom-modeline-check-icon t)

(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-initialize))

;; RAINBOW
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; WHICH-KEY
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config (setq which-key-idle-delay 0.1))

;; LSP
(use-package lsp-mode
  :ensure t)
(use-package lsp-treemacs
  :ensure t)
(lsp-treemacs-sync-mode 1)
(use-package company)
(use-package company-box
  :hook (company-mode . company-box-mode))
(use-package lsp-mode
  :init
    (setq lsp-keymap-prefix "C-c l")
  :ensure t
  :hook
  ((c++-mode . lsp)
(lsp-mode . (lambda ()
                      (let ((lsp-keymap-prefix "C-c l"))
                        (lsp-enable-which-key-integration))))   )
  :commands lsp
   :config
  (define-key lsp-mode-map (kbd "C-c l") lsp-command-map))
(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)
(setq lsp-auto-guess-root t)
(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      treemacs-space-between-root-nodes nil
      company-idle-delay 0.5
      company-minimum-prefix-length 1
      lsp-idle-delay 0.3)  ;; clangd is fast
(global-set-key (kbd "C-c RET") 'lsp-find-definition)
;;(setq lsp-clients-clangd-args '("-I=/home/fernandoritter/SITA/megaswitch-server/build/sym"))

;; PROJECTILE
(use-package projectile
  :custom ((projectile-completion-system 'ivy)))
(projectile-mode +1)
(setq projectile-enable-caching t)

(use-package treemacs-projectile)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

(use-package disaster
  :init
  ;; If you prefer viewing assembly code in `nasm-mode` instead of `asm-mode`
  (setq disaster-assembly-mode 'nasm-mode))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

;; CMAKE FONTS
(use-package cmake-font-lock)
(use-package dap-mode
  :ensure t
  :after lsp-mode
  :config
  (dap-auto-configure-mode t))
;; Install the debug adapter for C/C++
(use-package dap-cpptools
  :ensure nil
  :after dap-mode
  :config
  (require 'dap-cpptools))
;; Map F5 to dap-debug
(global-set-key (kbd "<f5>") 'dap-debug)
;; JAVA
(use-package lsp-java :after lsp :config (add-hook 'java-mode-hook 'lsp))
(use-package java
  :ensure nil
  :after lsp-java
  :bind (:map java-mode-map ("C-c i" . lsp-java-add-import)))
(use-package dap-java :ensure nil)

;; STANDARD DEBUG LAUNCH VM
(dap-register-debug-template
  "Java Remote LMA"
  (list :name "Java Remote LMA"
        :type "java"
        :request "attach"
        :args "-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:8000"
        :cwd nil
	:port 8000
        :stopOnEntry :json-false
        :host "localhost"
        :modulePaths []))
(use-package cmake-mode
  :ensure t
  :mode ("CMakeLists\\.txt\\'" "\\.cmake\\'"))

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :after lsp-mode
  :config
  (setq lsp-ui-sideline-enable t
        lsp-ui-sideline-show-hover t
	lsp-ui-sideline-delay 3
	lsp-ui-sideline-show-diagnostics t
        lsp-ui-doc-enable t
        lsp-ui-doc-position 'at-point))

;; YASNIPPET
(use-package yasnippet
  :ensure t)
(use-package yasnippet-snippets)
(yas-global-mode 1)

;; DASH
(use-package dashboard
  :config
  (add-hook 'elpaca-after-init-hook #'dashboard-insert-startupify-lists)
  (add-hook 'elpaca-after-init-hook #'dashboard-initialize)
  (dashboard-setup-startup-hook))

;; LINK WITH COMPANY
(defun my-company-yasnippet-or-completion ()
  "Invoke `yasnippet' if snippet expansion is possible, otherwise use `company-complete-common'."
  (interactive)
  (let ((yas-fallback-behavior nil))
    (unless (yas-expand)
      (call-interactively 'company-complete-common))))

(with-eval-after-load 'company
  (define-key company-active-map (kbd "<tab>") 'my-company-yasnippet-or-completion)
  (define-key company-active-map (kbd "TAB") 'my-company-yasnippet-or-completion))

;; COUNSEL
(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x C-f" . counsel-find-file)))
(global-set-key (kbd "C-M-b") 'counsel-switch-buffer)

;; GENERAL
(use-package general
  :config
  (general-create-definer rune/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (rune/leader-keys
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")))

;; EVIL
(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump t)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))
;; Remap mouse-9 to evil-jump-backward
(global-set-key (kbd "<mouse-9>") 'evil-jump-backward)

;; Remap mouse-8 to evil-jump-forward
(global-set-key (kbd "<mouse-8>") 'evil-jump-forward)
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))
(setq evil-normal-state-cursor '(box "red")
      evil-insert-state-cursor '(bar "medium sea green")
      evil-visual-state-cursor '(hollow "orange"))
;; MAGIT
(use-package magit
  :ensure t
  :commands (magit-status magit-get-current-branch)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; HYDRA
(use-package hydra)
(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(rune/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text"))

;; MY C FORMAT
(defun my-c-c++-mode-hook ()
  (setq c-basic-offset 4)        ;; set the basic indentation to 8 spaces
  (setq indent-tabs-mode nil)    ;; use spaces instead of tabs
  (c-set-offset 'substatement-open 0)) ;; align braces with if, for, etc.

(defun my-c-c++-style ()
  (c-set-style "bsd") ;; You can choose "bsd", "k&r", or other styles and modify as needed
  (c-set-offset 'brace-list-open '+)
  (c-set-offset 'brace-list-close 0)
  (c-set-offset 'substatement-open 0)
  (c-set-offset 'inline-open 0)
  (setq c-hanging-braces-alist
        '((brace-list-open)
          (brace-entry-open)
          (statement-case-open after)
          (substatement-open after)
          (block-close . c-snug-do-while)
          (extern-lang-open after)
          (namespace-open after)
          (module-open after)
          (composition-open after)
          (inexpr-class-open after)
          (inexpr-class-close before)
          (arglist-cont-nonempty)
          (brace-list-intro after)
          (brace-list-close)))

  (setq c-hanging-colons-alist
        '((member-init-intro before)
          (inher-intro)
          (case-label after)
          (label after)
          (access-label after))))

;; UNDO-TREE
(use-package undo-tree
  :ensure t
  :init
  (global-undo-tree-mode 1))

(add-hook 'c-mode-hook 'my-c-c++-mode-hook)
(add-hook 'c++-mode-hook 'my-c-c++-mode-hook)
(add-hook 'c-mode-hook 'my-c-c++-style)
(add-hook 'c++-mode-hook 'my-c-c++-style)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(flycheck eshell-git-prompt eterm-256color lldb-dap undo-tree doom-themes magit evil-collection evil general dashboard yasnippet-snippets yasnippet lsp-ui lsp-java dap-mode cmake-font-lock counsel-projectile disaster treemacs-projectile projectile company-box company lsp-treemacs which-key rainbow-delimiters exec-path-from-shell doom-modeline ivy-rich ivy all-the-icons lsp-docker docker centaur-tabs)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
