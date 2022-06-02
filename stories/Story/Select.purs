module Story.Select (default, select) where

import Prelude

import Effect (Effect)
import Plumage (globalStyles, width)
import Plumage.Atom.Input.Select (mkSelect)
import Plumage.Util.HTML (div_)
import React.Basic (JSX, fragment)
import React.Basic.Emotion (px)
import React.Basic.Emotion as E
import React.Basic.Events (handler_)
import Yoga ((</>))
import Yoga.Block as Block

default ∷ { title ∷ String }
default = { title: "Atom/Input/Select" }

select ∷ Effect JSX
select = do
  selectView <- mkSelect
  pure $ fragment
    [ E.global </> { styles: globalStyles }
    , Block.stack { space: 20 # px }
        [ div_ (width 120)
            [ selectView
                { choice: "Hi!"
                , toString: identity
                , toValue: identity
                , choices: [ "Heinz", "Dembo" ]
                , onChange: handler_ mempty
                }
            ]
        ]
    ]
