(require 'ox-md)

;;;###autoload
(defun create-github-readme (author project-name desc)
  (interactive)
  (with-temp-buffer
    (insert (format "# %s\n%s\n" project-name desc))
    (let (file-name)
      (dolist (file (directory-files "./" nil ".md"))
        (setq file-name (string-remove-suffix ".md" file))
        (unless (string= "README" file-name)
          (insert (format "* [%s](https://github.com/%s/%s/blob/master/%s.md) \n" file-name author project-name file-name))
          )
        )
      (write-file "./README.md")
      )
    )
  )

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

;;;###autoload
(defun org-split-with-readme (author project-name desc)
  (interactive)
  (org-split-into-mmd)
  (create-github-readme author project-name desc)
  )

(defun test-create-github-readme ()
  (with-temp-buffer
    (write-file "./test.md")
    (erase-buffer)
    )
  (create-github-readme "itsme" "test" "for testing")
  (delete-file "test.md")
  (delete-file "README.md")
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
