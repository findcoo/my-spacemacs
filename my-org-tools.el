(require 'ox-md)

;;;###autoload
(defun org-split-into-mmd (&optional async subtreep visible-only)
  (interactive)
  (org-mode)
  (goto-char (point-min))
  (set-text-properties (point-min) (point-max) nil)
  (let (titleCount outfile)
    (setq titleCount (count-matches "^* [a-zA-Z]+"))
    (loop for x from 1 to titleCount
          do (save-restriction
            (org-narrow-to-subtree)
            (save-excursion
              (setq outfile (replace-regexp-in-string " " "" (concat
                             (string-trim-right (string-remove-prefix "* " (thing-at-point 'line))) ".md")))
              (message outfile)
              (org-export-to-file 'md outfile async subtreep visible-only)
              )
            )
          (widen)
          (next-line)
          )
    )
  )

(defun test-org-split-into-mmd ()
  (with-temp-buffer
    (insert-file-contents "./test.org")
    (org-split-into-mmd)
    )
  (delete-file "./L1-1.md")
  (delete-file "./L1.md")
  )

(provide 'my-org-tools)
