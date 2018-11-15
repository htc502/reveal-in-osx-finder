reveal-in-osx-finder
=====

**Usage:**

- If ```M-x reveal-in-osx-finder``` is invoked in a file-associated buffer.
-  If there exists marked region with a valid file/file path, it will open the folder enclosing the file indicated by the marked region in the OS X Finder. It will also highlight the file the buffer is associated with within the folder.
-  Otherwise, it will open the folder enclosing the file associated with the buffer. It will also highlight the file the buffer is associated with within the folder.

- If ```M-x reveal-in-osx-finder``` is invoked in a dired buffer, it will open the current folder in the OS X Finder. It will also highlight the file at point if available.

- If ```M-x reveal-in-osx-finder``` is invoked in a buffer not associated with a file, it will open the folder defined in the default-directory variable.


**Installation**

This package depends on ```dired.el```, which should be available in the default emacs installation. It only works on the OS X environment on Macs.

Put the following in your emacs configuration file.

```lisp
;; To load at the start up
(require 'reveal-in-osx-finder)
;; If you want to configure a keybinding (e.g., C-c z), add the following
(global-set-key (kbd "C-c z") 'reveal-in-osx-finder)
```

**Acknowledgement:**


Give special thanks to the work of Kazuki YOSHIDA (URL: https://github.com/kaz-yos/reveal-in-osx-finder), as this comes by standing on the shoulder of that awesome work.

