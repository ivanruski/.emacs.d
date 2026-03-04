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

(defun iv/parse-duration (dur-str)
  "Parse a duration string like \"5h15m\", \"4h\", or \"40m\" into total minutes."
  (let ((hours 0) (mins 0))
    (when (string-match "\\([0-9]+\\)h" dur-str)
      (setq hours (string-to-number (match-string 1 dur-str))))
    (when (string-match "\\([0-9]+\\)m" dur-str)
      (setq mins (string-to-number (match-string 1 dur-str))))
    (+ (* hours 60) mins)))

(defun iv/day-heading-p ()
  "Return non-nil if the heading at point is a day-of-week heading."
  (let ((text (org-get-heading t t t t)))
    (string-match-p "^\\(Mon\\|Tue\\|Wed\\|Thu\\|Fri\\|Sat\\|Sun\\)" text)))

(defun iv/weekly-summary ()
  "Compute average hours worked for the week and insert a Weekly Summary heading.
Can be invoked from anywhere within a week (level 1 or level 2 heading).
Only day headings (Mon-Sun) with a HoursWorked property are counted."
  (interactive)
  (save-excursion
    (org-back-to-heading t)
    (when (> (org-current-level) 1)
      (outline-up-heading (- (org-current-level) 1)))
    (unless (= 1 (org-current-level))
      (user-error "Could not find a week heading (level 1)"))
    (let ((week-begin (point))
          (week-end (save-excursion (org-end-of-subtree t t) (point)))
          (total-minutes 0)
          (day-count 0)
          (last-day-end nil))
      (org-goto-first-child)
      (let ((done nil))
        (while (not done)
          (when (and (= 2 (org-current-level)) (iv/day-heading-p))
            (let ((hours (org-entry-get (point) "HoursWorked")))
              (when hours
                (setq total-minutes (+ total-minutes (iv/parse-duration hours)))
                (setq day-count (1+ day-count))))
            (setq last-day-end (save-excursion (org-end-of-subtree t t) (point))))
          (unless (org-get-next-sibling)
            (setq done t))))
      (if (= day-count 0)
          (message "No days with HoursWorked found in this week.")
        (let ((avg-minutes (/ total-minutes day-count)))
          (goto-char last-day-end)
          (unless (bolp) (insert "\n"))
          (org-insert-heading)
          (insert "Summary")
          (org-set-property "AvgHoursWorked" (iv/format-duration avg-minutes))
          (message "Average: %s over %d days" (iv/format-duration avg-minutes) day-count))))))

(defvar iv/llm-prompt "Summarize into bullet points what I did this week:\n\n"
  "Prompt prepended to the week's text when copying for an LLM.")

(defun iv/copy-week-for-llm ()
  "Copy all day (Mon-Fri) text from the current week with an LLM prompt.
Prepends `iv/llm-prompt' and copies the result to the kill ring."
  (interactive)
  (save-excursion
    (org-back-to-heading t)
    (when (> (org-current-level) 1)
      (outline-up-heading (- (org-current-level) 1)))
    (unless (= 1 (org-current-level))
      (user-error "Could not find a week heading (level 1)"))
    (let ((texts '()))
      (org-goto-first-child)
      (let ((done nil))
        (while (not done)
          (when (and (= 2 (org-current-level)) (iv/day-heading-p))
            (let ((beg (point))
                  (end (save-excursion (org-end-of-subtree t t) (point))))
              (push (buffer-substring-no-properties beg end) texts)))
          (unless (org-get-next-sibling)
            (setq done t))))
      (if (null texts)
          (message "No day headings found in this week.")
        (let ((result (concat iv/llm-prompt
                              (mapconcat #'identity (nreverse texts) "\n"))))
          (kill-new result)
          (message "Week text copied to clipboard."))))))

(define-key org-mode-map (kbd "C-c h") 'iv/calculate-hours-worked)
(define-key org-mode-map (kbd "C-c w") 'iv/weekly-summary)
(define-key org-mode-map (kbd "C-c S") 'iv/copy-week-for-llm)

(provide 'hours-worked)
;;; hours-worked.el ends here
