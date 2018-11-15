;;; reveal-in-osx-finder.el --- Reveal file in OS X Finder

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; Usage:
;;
;; If M-x reveal-in-osx-finder is invoked,
;; If marked region is not empty and the marked region is a valid file/path
;; It will open the folder enclosing the file in the OS X Finder.
;; and highlight the file the buffer is associated with within the folder.
;; If there's no marked region,
;; It will open the folder enclosing the file associated with the buffer in the OS X Finder.
;; and highlight the file the buffer is associated with within the folder.
;;
;; If M-x reveal-in-osx-finder is invoked in a dired buffer,
;; it will open the current folder in the OS X Finder.
;; It will also highlight the file at point if available.
;;
;; If M-x reveal-in-osx-finder is invoked in a buffer not associated with a file,
;; it will open the folder defined in the default-directory variable.
;;
;;
;; Give special thanks to the work of Kazuki YOSHIDA (URL: https://github.com/kaz-yos/reveal-in-osx-finder),
;; as this comes by standing on shoulder of that work.

;;; Code:

;; Requires dired.el for (dired-file-name-at-point)
(require 'dired)


;;;###autoload
(defun reveal-in-osx-finder ()
  "Reveal the file associated with the current buffer in the OS X Finder.
In a dired buffer, it will open the current directory."
  (interactive)
  (let* ((path-tmp (if (use-region-p)
		   (expand-file-name (buffer-substring (region-beginning) (region-end)))
		 (buffer-file-name))) ; The file path under marked or full file path associated with the buffer.
	 ;;check if the path is valid (it may be invalide if is coming from marked region
	 (path (if (or (file-directory-p path-tmp) (file-exists-p path-tmp)) path-tmp nil))
	 (filename-at-point (dired-file-name-at-point)) ; effective in dired only
	 ;; Create a full path if filename-at-point is non-nil
	 (filename-at-point (if filename-at-point
				(expand-file-name filename-at-point) ; full path
			      nil)) ; if nil, return nil
	 dir file)		   ; let* definition part ends here.

    ;; Conditionals: The first one that is non-nil is executed.
    (cond (path
	   ;; If path is non-nil,
	   (setq dir  (file-name-directory    path))
	   (setq file (file-name-nondirectory path)))

	  (filename-at-point
	   ;; If filename-at-point is available from dired,
	   (setq dir  (file-name-directory    filename-at-point))
	   (setq file (file-name-nondirectory filename-at-point)))

	  (t
	   ;; Otherwise,
	   (setq dir  (expand-file-name default-directory))))

    ;; Pass dir and file to the helper function.
    ;; (message (concat "dir:" dir " ; file:" file " ; path1:" path1 " ; fap:" filename-at-point)) ; for debugging
    (reveal-in-osx-finder-as dir file) ; These variables are  passed to the helper function.
    ))


;; AppleScript helper function. Thanks milkeypostman for suggestions.
;; Use let* to reuse revealpath in defining script.
(defun reveal-in-osx-finder-as (dir file)
  "A helper function for reveal-in-osx-finder.
This function runs the actual AppleScript."
  (let* ((revealpath (if file		   ; Define revealpath local variable.
			 (concat dir file) ; dir/file if file name available.
		       dir))		   ; dir only if not.
	 (script			   ; Define script variable using revealpath and text.
	  (concat
	   "set thePath to POSIX file \"" revealpath "\"\n"
	   "tell application \"Finder\"\n"
	   " set frontmost to true\n"
	   " reveal thePath \n"
	   "end tell\n")))		   ; let* definition part ends here.
    ;; (message script)			   ; Check the text output.
    (start-process "osascript-getinfo" nil "osascript" "-e" script) ; Run AppleScript.
    ))


(provide 'reveal-in-osx-finder)
;;; reveal-in-osx-finder.el ends here
