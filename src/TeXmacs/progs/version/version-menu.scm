
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; MODULE      : version-menu.scm
;; DESCRIPTION : menus for versioning portions of text
;; COPYRIGHT   : (C) 2010  Joris van der Hoeven
;;
;; This software falls under the GNU general public license version 3 or later.
;; It comes WITHOUT ANY WARRANTY WHATSOEVER. For details, see the file LICENSE
;; in the root directory or <http://www.gnu.org/licenses/gpl-3.0.html>.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(texmacs-module (version version-menu)
  (:use (version version-compare)
        (version version-tmfs)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Main version menu
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(menu-bind version-menu
  (when (versioned? (current-buffer))
    (when (!= (version-status (current-buffer)) "unknown")
      ("History" (version-show-history (current-buffer)))
      ("Update" (version-interactive-update (current-buffer))))
    (assuming (== (version-status (current-buffer)) "unknown")
      ("Register" (register-buffer (current-buffer))))
    (assuming (!= (version-status (current-buffer)) "unknown")
      (when (or (== (version-status (current-buffer)) "modified")
                (buffer-modified? (current-buffer)))
        ("Commit" (version-interactive-commit (current-buffer))))))
  ---
  (-> "Compare"
      (assuming (version-revision? (current-buffer))
        ("With current user version"
         (compare-with-newer* (version-head (current-buffer)))))          
      ("With older version"
       (choose-file compare-with-older "Compare with older version" ""))
      ("With newer version"
       (choose-file compare-with-newer "Compare with newer version" "")))
  ;;(-> "File"
  ;;    ("Show both versions" (version-show-all 'version-both))
  ;;    ("Show old version" (version-show-all 'version-old))
  ;;    ("Show new version" (version-show-all 'version-new))
  ;;    ---
  ;;    ("Retain current version" (version-retain-all 'current))
  ;;    ("Retain old version" (version-retain-all 0))
  ;;    ("Retain new version" (version-retain-all 1)))
  ;;(-> "Merge" ...)
  ;;(when (or (inside-version?) (selection-active-any?))
  ;;  ("Reactualize" (reactualize-differences)))
  (-> "Move"
      ("First difference" (version-first-difference))
      ("Previous difference" (version-previous-difference))
      ("Next difference" (version-next-difference))
      ("Last difference" (version-last-difference)))
  (when (or (inside-version?) (selection-active-any?))
    (-> "Show"
	("Both versions" (version-show 'version-both))
	("Old version" (version-show 'version-old))
	("New version" (version-show 'version-new)))
    (-> "Retain"
	("Current version" (version-retain 'current))
	("Old version" (version-retain 0))
	("New version" (version-retain 1))))
  (-> "Grain"
      ("Detailed" (version-set-grain "detailed"))
      ("Block" (version-set-grain "block"))
      ("Rough" (version-set-grain "rough"))))
