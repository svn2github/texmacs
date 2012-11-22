
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; MODULE      : tm-tools.scm
;; DESCRIPTION : various tools
;; COPYRIGHT   : (C) 2012  Joris van der Hoeven
;;
;; This software falls under the GNU general public license version 3 or later.
;; It comes WITHOUT ANY WARRANTY WHATSOEVER. For details, see the file LICENSE
;; in the root directory or <http://www.gnu.org/licenses/gpl-3.0.html>.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(texmacs-module (texmacs texmacs tm-tools))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Document statistics
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-define (count-characters doc)
  (with s (convert doc "texmacs-tree" "verbatim-snippet")
    (string-length s)))

(define (compress-spaces s)
  (let* ((s1 (string-replace s "\n" " "))
         (s2 (string-replace s1 "\t" " "))
         (s3 (string-replace s2 "  " " "))
         (s4 (if (string-starts? s3 " ") (string-drop s3 1) s3))
         (s5 (if (string-ends? s4 " ") (string-drop-right s4 1) s4)))
    (if (== s5 s) s (compress-spaces s5))))

(tm-define (count-words doc)
  (with s (convert doc "texmacs-tree" "verbatim-snippet")
    (length (string-tokenize-by-char (compress-spaces s) #\space))))

(tm-define (count-lines doc)
  (with s (convert doc "texmacs-tree" "verbatim-snippet")
    (length (string-tokenize-by-char s #\newline))))

(define (selection-or-document)
  (if (selection-active-any?)
      (selection-tree)
      (buffer-tree)))

(tm-define (show-character-count)
  (with nr (count-characters (selection-or-document))
    (set-message (string-append "Character count: " (number->string nr)) "")))

(tm-define (show-word-count)
  (with nr (count-words (selection-or-document))
    (set-message (string-append "Word count: " (number->string nr)) "")))

(tm-define (show-line-count)
  (with nr (count-lines (selection-or-document))
    (set-message (string-append "Line count: " (number->string nr)) "")))
