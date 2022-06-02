module Story.Button (default, button) where

import Prelude
import Effect (Effect)
import Effect.Class.Console as Console
import Effect.Uncurried (mkEffectFn1)
import Plumage.Atom.Button (baseButtonStyle, primaryButtonStyle)
import Plumage.Atom.Button (mkButton) as P
import Plumage.Style (pT)
import Plumage.Util.HTML as H
import React.Basic (JSX)
import React.Basic.DOM as R

default ∷ { title ∷ String }
default = { title: "Atom/Button" }

button ∷ Effect JSX
button = do
  btn ← P.mkButton
  pure
    $ H.div_ (pT 200)
        [ btn
            { children: [ R.text "Click me" ]
            , containerCss: mempty
            , css: primaryButtonStyle
            , buttonProps:
                { "aria-label": "eddy"
                , onPress: mkEffectFn1 $ const $ (Console.log "Sausage")
                }
            }
        , btn
            { children: [ R.text "Click Me" ]
            , containerCss: mempty
            , css: baseButtonStyle
            , buttonProps:
                { "aria-label": "eddy"
                , onPress: mkEffectFn1 $ const $ (Console.log "Sausage")
                }
            }
        ]
