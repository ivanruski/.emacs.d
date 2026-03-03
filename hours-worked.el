;;; hours-worked.el --- Calculate hours worked from time blocks in Org Mode

(require 'org)

(defun iv/time-to-minutes (time-str)
  "Convert a time string like \"14:30\" to total minutes from midnight."
  (let* ((parts (split-string time-str ":"))
         (hours (string-to-number (nth 0 parts)))
         (mins (string-to-number (nth 1 parts))))
    (+ (* hours 60) mins)))

(defun iv/format-duration (total-minutes)
  "Format TOTAL-MINUTES as a duration string like \"4h30m\", \"2h\", or \"45m\"."
  (let ((h (/ total-minutes 60))
        (m (% total-minutes 60)))
    (cond ((and (> h 0) (> m 0)) (format "%dh%dm" h m))
          ((> h 0) (format "%dh" h))
          (t (format "%dm" m)))))

(defun iv/calculate-hours-worked ()
  "Calculate hours worked for the day heading at point.
For each time block like \"10:30 till 14:00\", appends the
duration in parentheses if not already present. Then sets the
HoursWorked property to the total."
  (interactive)
  (save-excursion
    (org-back-to-heading t)
    (unless (= 2 (org-current-level))
      (user-error "Not on a day heading (level 2)"))
    (let ((day-begin (point))
          (day-end (save-excursion (org-end-of-subtree t t) (point)))
          (total-minutes 0))
      (goto-char day-begin)
      (while (re-search-forward
              "^- \\([0-9]+:[0-9][0-9]\\) till \\([0-9]+:[0-9][0-9]\\)\\(\\( (.+)\\)\\)?"
              day-end t)
        (let* ((start-time (match-string 1))
               (end-time (match-string 2))
               (end-time-pos (match-end 2))
               (existing-duration (match-string 3))
               (duration (- (iv/time-to-minutes end-time)
                            (iv/time-to-minutes start-time))))
          (setq total-minutes (+ total-minutes duration))
          (when (or (null existing-duration) (string-empty-p existing-duration))
            (goto-char end-time-pos)
            (insert " (" (iv/format-duration duration) ")")
            (setq day-end (save-excursion (org-end-of-subtree t t)
                                          (point))))))
      (if (= total-minutes 0)
          (message "No time blocks found under this heading.")
        (goto-char day-begin)
        (org-set-property "HoursWorked" (iv/format-duration total-minutes))
        (message "Total: %s" (iv/format-duration total-minutes))))))

(define-key org-mode-map (kbd "C-c h") 'iv/calculate-hours-worked)

(provide 'hours-worked)
;;; hours-worked.el ends here
