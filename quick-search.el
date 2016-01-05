;;; quick-search.el --- quick-search -*- lexical-binding: t -*-

;; Copyright (C) 2016 

;; Author:  Parikshit Machwe
;; Created: 04 Jan 2016
;; Version: 0.0.1
;; Keywords: quick, search, google, emacs, eww
;; X-URL: https://github.com/pmachwe/quick-search

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or (at
;; your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; This is packagee that enables searching through specialized websites like
;; Wikipedia, StackOverflow etc from within Emacs. The best way to use this is
;; with the inbuilt browser "eww" but should be able to fire the search in an
;; external browser. The use case is simple: Either use the highlighted text or
;; get an input from the user and then the specialized website to fire the
;; search on. The search goes through Google with a special keyword
;; site:<website>

;;; Code:

(require 'eww)

(defgroup quick-search nil
  "quick-search"
  :group 'quick-search)

(defcustom qs-browser "eww"
  "User can override this by setting the variable to another browser \
which will be run through \'shell-command\'."
  :group 'quick-search)

(defvar qs-google-search-prefix "http://www.google.com/search?q="
  "URL prefix for Google search.")

(defvar qs-site-table 'nil
  "Table of specialized websites and the keybindings.")

(defun qs-load-table ()
  "Load the site table and map to keybindings."
  (setq qs-site-table (make-hash-table :test 'equal))
  (puthash "s" "www.stackoverflow.com" qs-site-table)
  (puthash "S" "www.scikit-learn.org" qs-site-table)
  (puthash "t" "www.tutorialspoint.com" qs-site-table)
  (puthash "g" "www.github.com" qs-site-table)
  (puthash "w" "www.wikipedia.com" qs-site-table)
  (puthash "e" "www.emacswiki.com" qs-site-table)
  (puthash "E" "www.ergoemacs.org" qs-site-table)
  (puthash "c" "www.cplusplus.com" qs-site-table))

;; auto-load the above
(qs-load-table)

(defun qs-add-custom-site (site key)
  "Allow user to add a custom SITE and the corresponding KEY."
  (interactive "sSite: \nsKey: ")
  (if (gethash key qs-site-table)
      (message "Key already exists, please use another key.")
    (puthash key site qs-site-table)))

(defun qs-compose-google-search-url (str)
  "Add '+' between different words of STR to add to Google search URL."
  (let (cat-str)
    (setq cat-str (replace-regexp-in-string " +" "+" str))
    (concat qs-google-search-prefix cat-str)))

(defun qs-add-site-to-url (url site)
  "To the given URL add the special SITE keywords."
  (if (string-equal site "")
      (url)
    (concat url "+:site=" (gethash site qs-site-table))))

;; Not using the qs- prefix as this is a useful function otherwise also
(defun eww-in-new-window (url)
  "Open the URL in a side buffer."
  (interactive "sEnter the url: ")
  (if (get-buffer-window "*eww*")
      ()
    (progn
      (split-window-right)
      (switch-to-buffer-other-window "*eww*")))
  (with-current-buffer (get-buffer "*eww*")
    (eww url)))

(defun qs-do-search (str site)
  "Fire the search for the given string STR on the given site SITE."
  (interactive "sSearch: \nsWebsite Code: ")
  (let (url)
    (setq url (qs-compose-google-search-url str))
    (setq url (qs-add-site-to-url url site))
    (if (string-equal qs-browser "eww")
        (eww-in-new-window url)
      (shell-command (concat qs-browser " " url)))))

;; TODO:
;;   - test: allow user to add custom website
;;   - test: allow user to open in external browser
;;   - search highlighted region if selected
;;   - take the "key" as a char input and not string
;;   - load table at first quick-search
(provide 'quick-search)

;;; quick-search.el ends here
