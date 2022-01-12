(lang dune 3.0)

(name mdxpath)

; version field is optional
; (version 1.0.0)

(using mdx 0.2)

(generate_opam_files true)

;(source (github K-Wgit/issue10000))

(license ISC)

(authors "K-Wgit")

(maintainers "K-Wgit")

(package
 (name mdxpath)
 (synopsis "mdx path resolution only downwards")
 (description "like I said")
 (depends
  (alcotest :with-test)
  (dune
   (> 2.0))))
