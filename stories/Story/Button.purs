module Story.Button (default, button) where

import Prelude
import Effect (Effect)
import Effect.Uncurried (mkEffectFn1)
import Framer.Motion (animateSharedLayout, crossfade)
import Plumage.Atom.Button (baseButtonStyle, primaryButtonStyle)
import Plumage.Atom.Button (mkButton) as P
import React.Basic (JSX)
import React.Basic.DOM as R
import React.Basic.Hooks as React
import Effect.Class.Console as Console

default ∷ { title ∷ String }
default = { title: "Atom/Button" }

button ∷ Effect JSX
button = do
  btn ← P.mkButton
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
                    , onPress: mkEffectFn1 $ const $ (Console.log "Sausage")
                    }
                }
            ]
        }
