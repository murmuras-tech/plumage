module Story.Input (default, input) where

import Prelude

import Effect (Effect)
import Plumage (globalStyles, width)
import Plumage.Atom.Input.View (mkInput)
import Plumage.Util.HTML (div_)
import React.Basic (JSX, fragment)
import React.Basic.Emotion (px)
import React.Basic.Emotion as E
import Yoga ((</>))
import Yoga.Block as Block

default ∷ { title ∷ String }
default = { title: "Atom/Input/Text" }

input ∷ Effect JSX
input = do
  inputView ← mkInput
  pure $ fragment
    [ E.global </> { styles: globalStyles }
    , Block.stack { space: 20 # px }
        [ div_ (width 120)
            [ inputView
                { id: "1"
                , value: "Hi!"
                , setValue: mempty
                , placeholder: "Hi"
                , placeholders: []
                }
            ]
        , div_ (width 120)
            [ inputView
                { id: "2"
                , value: ""
                , setValue: mempty
                , placeholder: "Hi"
                , placeholders: []
                }
            ]
        ]
    ]
