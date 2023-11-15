;;; init.el --- Emacs config for Elixir hacking  -*- lexical-binding: t; -*-

;; Copyright (C) 2023 Wilhelm H Kirschbaum

;; Author           : Wilhelm H Kirschbaum
;; URL              : https://github.com/wkirschbaum/ex-emacs
;; Package-Requires : ((emacs "29.1") (lsp-mode "8.0.1"))
;; Created          : November 2023
;; Keywords         : elixir languages

;;  This program is free software: you can redistribute it and/or modify
;;  it under the terms of the GNU General Public License as published by
;;  the Free Software Foundation, either version 3 of the License, or
;;  (at your option) any later version.

;;  This program is distributed in the hope that it will be useful,
;;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;  GNU General Public License for more details.

;;  You should have received a copy of the GNU General Public License
;;  along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;;; Code:


(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024))

;; Hide UI
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(electric-pair-mode t)
(show-paren-mode 1)
(setq-default indent-tabs-mode nil)
(save-place-mode t)
(savehist-mode t)
(global-auto-revert-mode t)

(progn
  (setq custom-file (concat user-emacs-directory "custom.el"))
  (if (file-exists-p custom-file)
      (load custom-file)))

(require 'uniquify)
(setq uniquify-buffer-name-style 'forward
      window-resize-pixelwise t
      frame-resize-pixelwise t
      load-prefer-newer t
      backup-by-copying t)

;; supress warnings
(setq warning-minimum-level :error)

(add-hook 'prog-mode-hook 'display-line-numbers-mode)

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

(use-package modus-themes
  :ensure t
  :config
  (load-theme 'modus-vivendi :no-confirm))

;; Code completion at point
(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :custom
  (company-idle-delay 0))

;; Better minibuffer completion
(use-package vertico
  :ensure t
  :custom
  (vertico-cycle t)
  (read-buffer-completion-ignore-case t)
  (read-file-name-completion-ignore-case t)
  (completion-styles '(basic substring partial-completion flex))
  :init
  (vertico-mode))


;; Save minibuffer results
(use-package savehist
  :init
  (savehist-mode))

;; Show lots of useful stuff in the minibuffer
(use-package marginalia
  :after vertico
  :ensure t
  :init
  (marginalia-mode))

(use-package which-key
  :ensure t
  :init
  (which-key-mode))

(use-package magit
  :ensure t)

(use-package lsp-mode
  :ensure t
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (elixir-ts-mode . lsp)
         (heex-ts-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp
  :config

  (load (expand-file-name "lsp-lexical.el" user-emacs-directory))
  (load (expand-file-name "lsp-next-ls.el" user-emacs-directory)))

(setq treesit-language-source-alist
      '((elixir "https://github.com/elixir-lang/tree-sitter-elixir")
        (heex "https://github.com/phoenixframework/tree-sitter-heex")))

(mapc #'treesit-install-language-grammar (mapcar #'car treesit-language-source-alist))

(use-package elixir-ts-mode
  :ensure t)

;; disable suspend keybindings
(global-unset-key [(control z)])
(global-unset-key [(control x) (control z)])


;;; init.el ends here
