

## Issue opened at
[dune issue 5596 ](https://github.com/ocaml/dune/issues/5596)

<!-- Thank you for filing an issue to help us improve Dune! -->
## Expected Behavior
In markdown files, code blocks with file sync feature - file attribute `ocaml file=...` - do not resolve correctly when non downwards path are used.
This makes it impossible to have a `docs` directory not below the code.  
Trying to do that is either plain error, buggy or not working. Code should work with:
- relative path not limited to downwards path to access siblings such as `ocaml file ../lib/file.ml`
- absolute path from workspace root `ocaml file=/lib/file.ml`

This is also true for the comment syntax `$MDX file=...`

### 

```sh
$ echo "--- path resolution issues with dune and mdx ---"
--- path resolution issues with dune and mdx ---
```


## Actual Behavior


## Sibling
```
Error: path outside the workspace: ../core/patt.ml from .
-> required by _build/default/lib/docs/.mdx/testmdx1.md.corrected
-> required by alias lib/docs/runtest in lib/docs/dune:1
File "lib/docs/dune", line 1, characters 0-24:
1 | (mdx
2 |  (package extissues1001))

```

## relative path is expanded downward only
normal behaviour the error is expected
```
Error: No rule found for lib/docs/lib/core/patt.ml
File "README.md", line 1, characters 0-0:

```

## absolute path not from workspace root - error
```
Internal error, please report upstream including the contents of _build/log.
Description:
  ("Local.relative: received absolute path",
  { t = "."; path = "/lib/core/patt.ml" })
.... see trace ....
```

### Can be reproduced at
https://github.com/K-Wgit/extissues1001


### Versions and environment

```sh
$ dune --version
3.1.0
$ ocamlc --version
4.14.0
$ ocaml-mdx --version
2.1.0
$ ocaml-mdx deps lib/docs/testmdx1.md
((4:file15:../core/patt.ml))
$ tree -I _build -I _opam ../../
../../
├── README.md
├── dune
├── dune-project
├── extissues1001.opam
└── lib
    ├── core
    │   └── patt.ml
    ├── docs
    │   ├── dune
    │   ├── testmdx1.md
    │   ├── testmdx2.md
    │   └── testmdx3.md
    └── dune

3 directories, 10 files
```



### Some trace


```
$ dune runtest .

dune runtest
Internal error, please report upstream including the contents of _build/log.
Description:
  ("Local.relative: received absolute path",
  { t = "."; path = "/lib/core/patt.ml" })
Raised at Stdune__code_error.raise in file "otherlibs/stdune/code_error.ml",
  line 11, characters 30-62
Called from Stdune__path.Local_gen.relative in file
  "otherlibs/stdune/path.ml", line 244, characters 6-114
Called from Stdune__path.Local_gen.of_string in file
  "otherlibs/stdune/path.ml" (inlined), line 298, characters 20-53
Called from Dune_rules__mdx.Deps.to_path in file "src/dune_rules/mdx.ml",
  line 73, characters 16-40
Called from Dune_rules__mdx.Deps.dirs_and_files.(fun) in file
  "src/dune_rules/mdx.ml", line 80, characters 24-40
Called from Stdune__list.rev_partition_map.loop in file
  "otherlibs/stdune/list.ml", line 56, characters 13-16
Called from Stdune__list.rev_partition_map.(fun) in file
  "otherlibs/stdune/list.ml" (inlined), line 60, characters 14-29
Called from Stdune__list.partition_map in file "otherlibs/stdune/list.ml",
  line 63, characters 13-35
Called from Dune_rules__mdx.Deps.to_dep_set in file "src/dune_rules/mdx.ml",
  line 84, characters 22-48
Called from Dune_rules__mdx.gen_rules_for_single_file.(fun) in file
  "src/dune_rules/mdx.ml", line 228, characters 38-68
Called from Dune_engine__action_builder0.T.M.bind.(fun) in file
  "src/dune_engine/action_builder0.ml", line 40, characters 28-40
Called from Fiber.Scheduler.exec in file "src/fiber/fiber.ml", line 854,
  characters 10-13
-> required by ("Rule.make", ())
-> required by
   ("execute-rule",
   { id = 49
   ; info =
       From_dune_file
         { pos_fname = "lib/docs/dune"
         ; start = { pos_lnum = 1; pos_bol = 0; pos_cnum = 0 }
         ; stop = { pos_lnum = 2; pos_bol = 5; pos_cnum = 24 }
         }
   })
-> required by ("<unnamed>", ())
-> required by
   ("build-file", In_build_dir "default/lib/docs/.mdx/testmdx3.md.corrected")
-> required by ("<unnamed>", ())
-> required by
   ("build-alias", { dir = "default/lib/docs"; name = "runtest" })
-> required by ("toplevel", ())

I must not crash.  Uncertainty is the mind-killer. Exceptions are the
little-death that brings total obliteration.  I will fully express my cases.
Execution will pass over me and through me.  And when it has gone past, I
will unwind the stack along its path.  Where the cases are handled there will
be nothing.  Only I will remain.
Error: path outside the workspace: ../core/patt.ml from .
-> required by _build/default/lib/docs/.mdx/testmdx1.md.corrected
-> required by alias lib/docs/runtest in lib/docs/dune:1
File "lib/docs/dune", line 1, characters 0-24:
1 | (mdx
2 |  (package extissues1001))
Error: No rule found for lib/docs/lib/core/patt.ml
File "README.md", line 1, characters 0-0:
diff --git a/_build/default/README.md b/_build/default/.mdx/README.md.corrected
index 8f35f3d..ad5349e 100644
--- a/_build/default/README.md
+++ b/_build/default/.mdx/README.md.corrected
@@ -96,7 +96,10 @@ $ ocamlc --version
 $ ocaml-mdx --version
 2.1.0
 $ ocaml-mdx deps lib/docs/testmdx.md
-()
+ocaml-mdx: FILE argument: no 'lib/docs/testmdx.md' file
+Usage: ocaml-mdx deps [OPTION]… FILE
+Try 'ocaml-mdx deps --help' or 'ocaml-mdx --help' for more information.
+[124]
 $ tree --gitignore -I _opam
 .
 ├── META.extissues1001
@@ -107,7 +110,9 @@ $ tree --gitignore -I _opam
 │   ├── docs
 │   │   ├── mdx_gen.bc
 │   │   ├── mdx_gen.ml-gen
-│   │   └── testmdx.md
+│   │   ├── testmdx1.md
+│   │   ├── testmdx2.md
+│   │   └── testmdx3.md
 │   ├── extissues1001.a
 │   ├── extissues1001.cma
 │   ├── extissues1001.cmxa
@@ -118,6 +123,6 @@ $ tree --gitignore -I _opam
 ├── extissues1001.install
 └── extissues1001.opam

-3 directories, 15 files
+3 directories, 17 files
```



