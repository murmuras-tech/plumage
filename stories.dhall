let conf = ./spago.dhall
in    conf
    ⫽ { sources = conf.sources # [ "stories/**/*.purs" ]
      , dependencies = conf.dependencies
      }