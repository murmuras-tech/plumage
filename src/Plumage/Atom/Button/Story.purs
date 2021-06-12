module Plumage.Atom.Button.Story (default, button) where

import Prelude
import Data.Traversable (traverse)
import Effect (Effect)
import Effect.Uncurried (mkEffectFn1)
import Foreign.Object as Object
import Framer.Motion (animateSharedLayout, crossfade)
import Plumage.Atom.Button (baseButtonStyle, primaryButtonStyle)
import Plumage.Atom.Button (mkButton) as P
import React.Basic (JSX, fragment)
import React.Basic.DOM as R
import React.Basic.Hooks as React
import Web.HTML (window)
import Web.HTML.Window (alert)
import Effect.Class.Console as Console

default ∷ { title ∷ String }
default = { title: "Atom/Button" }

button ∷ Effect JSX
button = do
  btn <- P.mkButton
  pure
    $ React.element animateSharedLayout
        { type: crossfade
        , children:
          [ btn
              { children: [ R.text "Click me" ]
              , css: primaryButtonStyle
              , buttonProps:
                { "aria-label": "eddy"
                , onPress: mkEffectFn1 $ const $ (Console.log "Sausage")
                }
              }
          , btn
              { children: [ R.text "Click Me" ]
              , css: baseButtonStyle
              , buttonProps:
                { "aria-label": "eddy"
                , element: R.a'
                , onPress: mkEffectFn1 $ const $ (Console.log "Sausage")
                }
              }
          ]
        }
