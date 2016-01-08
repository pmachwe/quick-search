;;; quick-search-ert.el --- quick-search -*- lexical-binding: t -*-

;; Copyright (C) 2016 

;; Author:  <pmachwe@PMACHWE-E7440>
;; Created: 05 Jan 2016
;; Version: 0.0.1
;; Keywords: quick, search, test, ert
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

;; Unit tests for the quick-search package

;;; Code:

(require 'ert)
(require 'quick-search)

(ert-deftest url-test1()
  "Check that no space gets created in the URL"
  (let (cat-str)
    (setq cat-str (qs-compose-google-search-url "this   is a  test string "))
    (should (eql (string-match " " cat-str) nil))))

(ert-deftest url-test2()
  "Check no leading and ending +"
  (let (cat-str)
    (setq cat-str (qs-compose-google-search-url "  this   is a  test string  "))
    (should (eql (string-match "^\+" cat-str) nil))
    (should (eql (string-match "\+$" cat-str) nil))))

(ert-deftest site-test1()
  "Check that no site is appended for illegal key"
  (let (url)
    (setq url (qs-compose-google-search-url "  this   is a  test string  "))
    (setq url (qs-add-site-to-url url "z"))
    (should (eql (string-match "site" url) nil))))

(ert-deftest site-test2()
  "Check that correct site is appended for correct key"
  (let (url)
    (setq url (qs-compose-google-search-url "  this   is a  test string  "))
    (setq url (qs-add-site-to-url url "w"))
    (should-not (eql (string-match "wikipedia" url) nil))))

(ert-deftest user-add-test1()
  "Just to evoke the user function"
  (qs-add-custom-site "www.justfortest.com" "@")
  (should-not (eql (gethash "@" qs-site-table) nil))
  (remhash "@" qs-site-table))

(provide 'quick-search-ert)

;;; quick-search-ert.el ends here
