

### 

```sh
$ echo "--- path resolution issues with dune and mdx ---"
--- path resolution issues with dune and mdx ---
```

## both ocaml file=... an $MDX file ... in quote do not work

## syblying
```
with   ocaml file=../core/patt.ml,part=snippet 

dune runtest .
Error: path outside the workspace: ../core/patt.ml from .
-> required by _build/default/lib/docs/.mdx/testmdx.md.corrected
-> required by alias lib/docs/runtest in lib/docs/dune:1
```

## path is expanded downward only

```
with   ocaml file=lib/core/patt.ml,part=snippet
dune runtest .
File "lib/docs/dune", line 1, characters 0-24:
1 | (mdx
2 |  (package mdxpath))
Error: No rule found for lib/docs/lib/core/patt.ml

```

## absolute path not from workspace root
```
with   ocaml file=/lib/core/patt.ml,part=snippet

dune runtest .
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
   { id = 45
   ; info =
       From_dune_file
         { pos_fname = "lib/docs/dune"
         ; start = { pos_lnum = 1; pos_bol = 0; pos_cnum = 0 }
         ; stop = { pos_lnum = 2; pos_bol = 5; pos_cnum = 24 }
         }
   })
-> required by ("<unnamed>", ())
-> required by
   ("build-file", In_build_dir "default/lib/docs/.mdx/testmdx.md.corrected")
-> required by ("<unnamed>", ())
-> required by
   ("build-alias", { dir = "default/lib/docs"; name = "runtest" })
-> required by ("toplevel", ())
```


### Some trace
why is mdx adding junk in my directory during the build, even temporarily

```sh
$ dune --version
3.1.0
$ ocamlc --version
4.14.0
$ ocaml-mdx --version
2.1.0
$ ocaml-mdx deps lib/docs/testmdx.md
()
$ tree --gitignore -I _opam
.
├── META.mdxpath
├── README.md
├── lib
│   ├── core
│   │   └── patt.ml
│   ├── docs
│   │   ├── mdx_gen.bc
│   │   ├── mdx_gen.ml-gen
│   │   └── testmdx.md
│   ├── mdxpath.a
│   ├── mdxpath.cma
│   ├── mdxpath.cmxa
│   └── mdxpath.cmxs
├── mdx_gen.bc
├── mdx_gen.ml-gen
├── mdxpath.dune-package
├── mdxpath.install
└── mdxpath.opam

3 directories, 15 files
```

