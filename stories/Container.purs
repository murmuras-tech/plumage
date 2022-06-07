module Story.Container where

import Prelude

import Fahrtwind (background, globalStyles, gray, height', widthFull)
import Plumage.Util.HTML as H
import React.Basic (JSX, fragment)
import React.Basic.DOM as R
import React.Basic.Emotion as E
import Yoga ((</>))

inContainer ∷ JSX → JSX
inContainer content = fragment
  [ E.global </> { styles: globalStyles }
  , H.div_ (height' (E.px 5000) <> widthFull <> background gray._400)
      [ content ]
  , R.div
      { id: "clickaway"
      , style: R.css
          { position: "fixed"
          , top: "0"
          , left: "0"
          , width: "100%"
          , height: "100%"
          , backgroundColor: "rgba(0, 0, 0, 0.00)"
          , pointerEvents: "none"
          }
      }
  , R.div
      { id: "cm"
      , style: R.css
          { position: "absolute"
          , top: "0"
          , left: "0"
          , width: "100%"
          , height: "100%"
          , backgroundColor: "rgba(0, 0, 0, 0.00)"
          , pointerEvents: "none"
          }
      }
  ]