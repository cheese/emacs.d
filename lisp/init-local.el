(require-package 'rpm-spec-mode)
(setq rpm-spec-user-full-name "Robin Lee")
(setq rpm-spec-user-mail-address "cheeselee@fedoraproject.org")
(when (string= system-name "lirb-winhong")
  (setq rpm-spec-user-full-name "Li Rui Bin")
  (setq rpm-spec-user-mail-address "lirb@winhong.com"))

(require-package 'highlight-symbol)
(global-set-key (kbd "C-)") 'highlight-symbol-next)
(global-set-key (kbd "C-(") 'highlight-symbol-prev)
(setq calendar-week-start-day 1)

(defun goto-match-paren (arg)
  "Go to the matching parenthesis if on parenthesis, otherwise insert %.
vi style of % jumping to matching brace."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))
(global-set-key (kbd "C-%") 'goto-match-paren)

(defun count-words-buffer ( )
  "Count the number of words in the current buffer;
print a message in the minibuffer with the result."
  (interactive)
  (save-excursion
    (let ((count 0))
      (goto-char (point-min))
      (while (< (point) (point-max))
        (forward-word 1)
        (setq count (1+ count)))
      (message "buffer contains %d words." count))))

(defun my-empty-tr (count)
  "Enter an empty tr, with COUNT numbers of empty td."
  (interactive "nNumber of td: ")
  (insert "<!-- ko foreach: pageLeft -->\n")
  (insert "<tr>")
  (while (> count 0)
    (insert "<td>&nbsp;</td>")
    (setq count (1- count))
    )
  (insert "</tr>\n")
  (insert "<!-- /ko -->\n"))

(defun perl-new-method (name)
  "Create a Perl Object method"
  (interactive "sName of method: ")
  (insert "sub ")
  (insert name)
  (insert " {\n")
  (insert "    my $self = shift;\n")
  (insert "    \n")
  (insert "}\n")
  (backward-char)
  (backward-char)
  (backward-char))

(global-prettify-symbols-mode -1)

(defun c-lineup-arglist-tabs-only (ignored)
  "Line up argument lists by tabs, not spaces"
  (let* ((anchor (c-langelem-pos c-syntactic-element))
         (column (c-langelem-2nd-pos c-syntactic-element))
         (offset (- (1+ column) anchor))
         (steps (floor offset c-basic-offset)))
    (* (max steps 1)
       c-basic-offset)))

;; cscope
(add-hook 'c-mode-common-hook
          (lambda ()
            (require 'xcscope)
            ;; Add kernel style
            (c-add-style
             "linux-tabs-only"
             '("linux" (c-offsets-alist
                        (arglist-cont-nonempty
                         c-lineup-gcc-asm-reg
                         c-lineup-arglist-tabs-only))))))
;; cc-mode
(add-hook 'c-mode-hook
          (lambda ()
            (c-set-style "stroustrup")
            (let ((filename (buffer-file-name)))
              ;; Enable kernel mode for the appropriate files
              (when (and filename
                         (string-match "linux" filename))
                (setq indent-tabs-mode t)
                (setq tab-width 8)
                (c-set-style "linux-tabs-only")))))
(add-hook 'c++-mode-hook
          (lambda ()
            (c-set-style "stroustrup")))

;;(global-set-key (kbd "M-/") 'dabbrev-expand)

(provide 'init-local)
