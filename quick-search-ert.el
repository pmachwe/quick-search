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

(load-file "./quick-search.el")

(require 'ert)
(require 'quick-search)

(ert-deftest url-test1()
  "Check that no space gets created in the URL"
  (let (cat-str)
    (setq cat-str (qs-compose-google-search-url "this   is a  test string "))
    (should (eql (string-match " " cat-str) nil))))

(provide 'quick-search-ert)

;;; quick-search-ert.el ends here
