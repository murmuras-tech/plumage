{-
Welcome to a Spago project!
You can edit this file as you like.

Need help? See the following resources:
- Spago documentation: https://github.com/purescript/spago
- Dhall language tour: https://docs.dhall-lang.org/tutorials/Language-Tour.html

When creating a new Spago project, you can use
`spago init --no-comments` or `spago init -C`
to generate this file without the comments in this block.
-}
{ name = "plumage"
, dependencies =
  [ "aff"
  , "arrays"
  , "colors"
  , "console"
  , "datetime"
  , "effect"
  , "enums"
  , "exceptions"
  , "fahrtwind"
  , "foldable-traversable"
  , "foreign"
  , "foreign-object"
  , "framer-motion"
  , "literals"
  , "maybe"
  , "newtype"
  , "now"
  , "nullable"
  , "ordered-collections"
  , "prelude"
  , "react-basic"
  , "react-basic-dom"
  , "react-basic-emotion"
  , "react-basic-hooks"
  , "record"
  , "remotedata"
  , "ry-blocks"
  , "strings"
  , "tuples"
  , "unsafe-coerce"
  , "unsafe-reference"
  , "untagged-union"
  , "web-dom"
  , "web-html"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
