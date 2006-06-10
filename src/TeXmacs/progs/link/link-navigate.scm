
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; MODULE      : link-navigate.scm
;; DESCRIPTION : navigation routines for links
;; COPYRIGHT   : (C) 2006  Joris van der Hoeven
;;
;; This software falls under the GNU general public license and comes WITHOUT
;; ANY WARRANTY WHATSOEVER. See the file $TEXMACS_PATH/LICENSE for details.
;; If you don't have this file, write to the Free Software Foundation, Inc.,
;; 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(texmacs-module (link link-navigate)
  (:use (link link-edit) (link link-extern)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Navigation mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define navigation-bidirectional-links? #t)
(define navigation-external-links? #t)
(define navigation-link-pages? #t)
(define navigation-blocked-types (make-ahash-table))

(define (navigation-bidirectional?) navigation-bidirectional-links?)
(tm-define (navigation-toggle-bidirectional)
  (:synopsis "Toggle whether we may follow links in both directions.")
  (:check-mark "v" navigation-bidirectional?)
  (toggle! navigation-bidirectional-links?))

(define (navigation-external?) navigation-external-links?)
(tm-define (navigation-toggle-external)
  (:synopsis "Toggle whether we may follow links defined in other loci.")
  (:check-mark "v" navigation-external?)
  (toggle! navigation-external-links?))

(define (navigation-build-link-pages?) navigation-link-pages?)
(tm-define (navigation-toggle-build-link-pages)
  (:synopsis "Toggle whether we generate link pages.")
  (:check-mark "v" navigation-build-link-pages?)
  (toggle! navigation-link-pages?))

(define (navigation-allow-type? type)
  (not (ahash-ref navigation-blocked-types type)))
(tm-define (navigation-toggle-type type)
  (:synopsis "Toggle whether we may follow links of a given @type.")
  (:check-mark "v" navigation-allow-type?)
  (ahash-set! navigation-blocked-types type
	      (not (ahash-ref navigation-blocked-types type))))

(define (navigation-allow-no-types?)
  (with l (ahash-table->list navigation-blocked-types)
    (null? (list-difference (current-link-types)
			    (map car (list-filter l cdr))))))
(tm-define (navigation-allow-no-types)
  (:synopsis "Disallow any link types from being followed.")
  (:check-mark "v" navigation-allow-no-types?)
  (for-each (cut ahash-set! navigation-blocked-types <> #t)
	    (current-link-types)))

(define (navigation-allow-all-types?)
  (with l (ahash-table->list navigation-blocked-types)
    (null? (list-filter l cdr))))
(tm-define (navigation-allow-all-types)
  (:synopsis "Allow all link types to be followed.")
  (:check-mark "v" navigation-allow-all-types?)
  (set! navigation-blocked-types (make-ahash-table)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Finding links
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-define (Id->id Id)
  (and (func? Id 'id 1) (string? (cadr Id)) (cadr Id)))

(define (id->link-list id)
  (let* ((lns (id->links id))
	 (sts (map tree->stree lns)))
    (map (cut cons id <>) (map cdr sts))))

(tm-define (ids->link-list ids)
  (append-map id->link-list ids))

(define (exact-link-list-global t)
  (ids->link-list (tree->ids t)))

(define (exact-link-list-local t)
  (if (not (tm-func? t 'locus)) '()
      (let* ((id (locus-id t))
	     (ch (cDdr (tree->stree t)))
	     (lns (list-filter ch (cut func? <> 'link))))
	(map (cut cons id <>) (map cdr lns)))))

(define (filter-on-bidirectional x)
  (with (id type first . other) x
    (== id (Id->id first))))

(define (filter-on-type x)
  (with (id type . args) x
    (navigation-allow-type? type)))

(define (filter-link-list l)
  (if (not (navigation-bidirectional?))
      (set! l (list-filter l filter-on-bidirectional)))
  (list-filter l filter-on-type))

(tm-define (exact-link-list t filter?)
  (with l (if (and filter? (not (navigation-external?)))
	      (exact-link-list-local t)
	      (exact-link-list-global t))
    (if filter? (filter-link-list l) l)))

(tm-define (upward-link-list t filter?)
  (with l (exact-link-list t filter?)
    (if (== (buffer-path) (tree->path t)) l
	(append l (upward-link-list (tree-up t) filter?)))))

(tm-define (complete-link-list t filter?)
  (with l (exact-link-list t filter?)
    (if (tree-atomic? t) l
	(with ls (map (cut complete-link-list <> filter?) (tree-children t))
	  (apply append (cons l ls))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Prospect for active links
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-define (link-may-follow? t)
  (:synopsis "Does @t contain an active link?")
  (nnull? (upward-navigation-list t)))

(define (link-active-upwards-sub t active-ids)
  (let* ((ids (tree->ids t))
	 (add? (nnull? (list-intersection ids active-ids)))
	 (r (if add? (list t) '())))
    (if (== (buffer-path) (tree->path t)) r
	(append r (link-active-upwards-sub (tree-up t) active-ids)))))

(tm-define (link-active-upwards t)
  (:synopsis "Return active ancestor trees for the tree @t.")
  (with l (upward-link-list t #t)
    (link-active-upwards-sub t (map car l))))

(tm-define (link-active-ids l)
  (:synopsis "Return list of identifiers in @l which admit an active link.")
  (with r (filter-link-list (ids->link-list l))
    (list-remove-duplicates (map car r))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Navigation lists
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (navigation-list-sub type nr source l)
  (if (null? l) l
      (let* ((head (list type nr source (car l)))
	     (tail (navigation-list-sub type (+ nr 1) source (cdr l))))
	(if (== source (Id->id (car l))) tail
	    (cons head tail)))))

(tm-define (link-list->navigation-list l)
  (if (null? l) l
      (let* ((item (car l))
	     (source (car item))
	     (type (cadr item))
	     (components (cddr item))
	     (h (navigation-list-sub type 0 source components))
	     (r (link-list->navigation-list (cdr l))))
	(list-remove-duplicates (append h r)))))

(tm-define (upward-navigation-list t)
  (link-list->navigation-list (upward-link-list t #t)))

(tm-define (navigation-list-filter l type nr)
  (cond ((null? l) l)
	((and (or (== type #t) (== (caar l) type))
	      (or (== nr #t) (== (cadar l) nr)))
	 (cons (car l) (navigation-list-filter (cdr l) type nr)))
	(else (navigation-list-filter (cdr l) type nr))))

(tm-define (navigation-list-types l)
  (list-remove-duplicates (map car l)))

(tm-define (navigation-list-xtypes l)
  (let* ((direct (navigation-list-filter l #t 1))
	 (inverse (navigation-list-filter l #t 0))
	 (dtypes (map car direct))
	 (itypes (map (cut string-append <> "*") (map car inverse))))
    (list-remove-duplicates (append dtypes itypes))))

(tm-define (navigation-list-first-xtype l xtype)
  (let* ((inverse? (string-ends? xtype "*"))
	 (type (if inverse? (string-drop-right xtype 1) xtype))
	 (fl (navigation-list-filter l type (if inverse? 0 1))))
    (and (nnull? fl) (car fl))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Link pages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (resolve-navigation-list l fun)
  (if (null? l) (fun)
      (let* ((id (Id->id (cadddr (car l))))
	     (ok (or (nstring? id) (nnull? (id->trees id)))))
	(if ok (resolve-navigation-list (cdr l) fun)
	    (begin
	      (resolve-id id)
	      (delayed (:idle 25) (resolve-navigation-list (cdr l) fun)))))))

(tm-define (automatic-link back-id . opt)
  (let* ((broken-text (if (null? opt) "Broken" (car opt)))
	 (item-id (create-unique-id))
	 (ts (id->trees back-id)))
    (if (null? ts) `(with "color" "red" ,broken-text)
	`(locus (id ,item-id)
		(link "automatic" (id ,item-id) (id ,back-id))
		,(tree->stree (car ts))))))

(tm-define (build-enumeration l)
  (if (<= (length l) 1) l
      `((enumerate
	 (document
	  ,@(map (lambda (x) `(surround (item) "" ,x)) l))))))

(define (navigation-item->document x)
  (with (type nr source target) x
    (automatic-link (Id->id target))))

(define (navigation-list-by-type->document type l)
  (cons `(strong ,type)
	(build-enumeration (map navigation-item->document l))))

(define (navigation-list->document style l)
  (let* ((direct (navigation-list-filter l #t 1))
	 (inverse (navigation-list-filter l #t 0))
	 (direct-types (navigation-list-types direct))
	 (inverse-types (navigation-list-types inverse))
	 (direct-by-type (map (cut navigation-list-filter direct <> #t)
			      direct-types))
	 (inverse-by-type (map (cut navigation-list-filter inverse <> #t)
			       inverse-types)))
    `(document
      (style ,style)
      (body (document
	     (strong "Source")
	     ,(automatic-link (caddr (car l)) "Unaccessible")
	     ,@(append-map
		navigation-list-by-type->document
		(map (cut string-append "Direct " <>) direct-types)
		direct-by-type)
	     ,@(append-map
		navigation-list-by-type->document
		(map (cut string-append "Inverse " <>) inverse-types)
		inverse-by-type))))))

(define (build-navigation-page-sub style l)
  (with doc (navigation-list->document style l)
    (set-aux-buffer "* Link page *" "* Link page *" doc)))

(define (build-navigation-page l)
  (let* ((style (tree->stree (get-style-tree)))
	 (fun (lambda () (build-navigation-page-sub style l))))
    (resolve-navigation-list l fun)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Actual navigation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-define (go-to-id id)
  (with l (id->trees id)
    (if (nnull? l)
	(tree-go-to (car l) :end)
	(and (resolve-id id)
	     (delayed (:idle 25) (go-to-id id))))))

(tm-define (go-to-Id Id)
  (cond ((func? Id 'id 1) (go-to-id (cadr Id)))
	(else (noop))))

(define (id-set-visited id)
  (id-declare-visited id)
  (with pl (filter-map tree->path (id->trees id))
    (for-each update-all-path pl)))

(define (navigation-item-follow hit)
  (id-set-visited (caddr hit))
  (go-to-Id (cadddr hit)))

(define the-navigation-list '())
(tm-define (navigation-list-follow-xtyped xtype)
  (:synopsis "Follow the first link with given @type in @the-navigation-list.")
  (:argument xtype "Link type")
  (:proposals xtype (navigation-list-xtypes the-navigation-list))
  (and-with hit (navigation-list-first-xtype the-navigation-list xtype)
    (set! the-navigation-list #f)
    (navigation-item-follow hit)))

(tm-define (navigation-list-follow nl)
  (:synopsis "Follow one of the links in the navigation list @nl.")
  (with types (navigation-list-types nl)
    (if (and (>= (length types) 2) (in? "automatic" types))
	(with auto-nl (navigation-list-filter nl "automatic" #t)
	  (set! nl (list-difference nl auto-nl))))
    (with xtypes (navigation-list-xtypes nl)
      (cond ((null? xtypes) (noop))
	    ((and (navigation-build-link-pages?) (>= (length nl) 2))
	     (id-set-visited (caddr (car nl)))
	     (build-navigation-page nl))
	    ((null? (cdr xtypes)) (navigation-item-follow (car nl)))
	    (else
	     (set! the-navigation-list nl)
	     (interactive navigation-list-follow-xtyped))))))

(tm-define (link-follow-ids ids)
  (:synopsis "Follow one of the links for identifiers in @ids.")
  (navigation-list-follow
   (link-list->navigation-list
    (filter-link-list (ids->link-list ids)))))

(tm-define (locus-link-follow)
  (:synopsis "Follow one of the links in the current locus.")
  (let* ((ts (link-active-upwards (cursor-tree)))
	 (ids (append-map tree->ids ts)))
    (link-follow-ids ids)))
