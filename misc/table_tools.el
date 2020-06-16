;; (load "/path/to/table_tools.el")
;; (setq table-tools:bin-dir "/path/to/table_tools/bin")
;; (global-set-key (kbd "<f4>") 'table-tools:format)

(defvar table-tools:bin-dir
  "/path/to/bin")

(defun table-tools:mrtable:formatter-path ()
  (concat table-tools:bin-dir "/mrtable-formatter.sh"))

(defun table-tools:array-table:formatter-path ()
  (concat table-tools:bin-dir "/jatable-formatter.sh"))

;; --------------------------------

(defun table-tools:line-head-char ()
  (save-excursion
      (beginning-of-line)
      (string (char-after (point)))))

(defun table-tools:first-line-p ()
  (save-excursion
    (beginning-of-line)
    (bobp)))

(defun table-tools:last-line-p ()
  (save-excursion
    (end-of-line)
    (eobp)))

;; --------------------------------
;; mrtable

(defun table-tools:mrtable:row-line-p ()
  (let ((beg) (end))
    (save-excursion
      (beginning-of-line)
      (setq beg (looking-at "|")))
    (save-excursion
      (end-of-line)
      (backward-char)
      (setq end (looking-at "|")))
    (and beg end)))

(defun table-tools:mrtable:search-beg ()
  (save-excursion
    (while (and
            (table-tools:mrtable:row-line-p)
            (not (table-tools:first-line-p)))
      (forward-line -1))
    (if (not (table-tools:first-line-p))
        (forward-line))
    (beginning-of-line)
    (point)))

; 最後の行末の改行まで含む
; （ただし、バッファ終端の場合は末尾改行なし）
(defun table-tools:mrtable:search-end ()
  (save-excursion
    (while (and (table-tools:mrtable:row-line-p)
                (not (table-tools:last-line-p)))
      (forward-line))
    (when (table-tools:last-line-p)
      (end-of-line))
    (point)))

(defun table-tools:mrtable:format ()
  (if (table-tools:mrtable:row-line-p)
      (save-excursion
        (shell-command-on-region
         (table-tools:mrtable:search-beg)
         (table-tools:mrtable:search-end)
         (table-tools:mrtable:formatter-path)
         nil t))
    (message "not in mrtable")))

;; --------------------------------
;; array table

(defun table-tools:array-table:row-line-p ()
  (let ((beg) (end))
    (save-excursion
      (beginning-of-line)
      (setq beg (looking-at "\\[")))
    (save-excursion
      (end-of-line)
      (backward-char)
      (setq end (looking-at "\\]")))
    (and beg end)))

(defun table-tools:array-table:search-beg ()
  (save-excursion
    (while (and
            (table-tools:array-table:row-line-p)
            (not (table-tools:first-line-p)))
      (forward-line -1))
    (if (not (table-tools:first-line-p))
        (forward-line))
    (beginning-of-line)
    (point)))

; 最後の行末の改行まで含む
; （ただし、バッファ終端の場合は末尾改行なし）
(defun table-tools:array-table:search-end ()
  (save-excursion
    (while (and (table-tools:array-table:row-line-p)
                (not (table-tools:last-line-p)))
      (forward-line))
    (when (table-tools:last-line-p)
      (end-of-line))
    (point)))

(defun table-tools:array-table:format ()
  (if (table-tools:array-table:row-line-p)
      (save-excursion
        (shell-command-on-region
         (table-tools:array-table:search-beg)
         (table-tools:array-table:search-end)
         (table-tools:array-table:formatter-path)
         nil t))
    (message "not in array table")))

;; --------------------------------

(defun table-tools:format ()
  "Format mrtable/array table"
  (interactive)
  (let ((line-head-char (table-tools:line-head-char)))
    (cond
     ((string= line-head-char "|")
      (table-tools:mrtable:format))
     ((string= line-head-char "[")
      (table-tools:array-table:format))
     (t
      (message "not in valid table")))))
