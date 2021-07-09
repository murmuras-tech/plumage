module Plumage.Style.Divide
  ( divideX
  , divideXReverse
  , divideY
  , divideYReverse
  ) where

import Prelude
import React.Basic.Emotion (Style, css, nested, px)

nestChildren ∷ Style → Style
nestChildren inner = css { "&: * > *": nested inner }

divideX ∷ Int → Style
divideX pixels =
  nestChildren
    $ css
        { borderRightWidth: px (negate pixels)
        , borderLeftWidth: px pixels
        }

divideXReverse ∷ Int → Style
divideXReverse = negate >>> divideX

divideY ∷ Int → Style
divideY pixels =
  nestChildren
    $ css
        { borderTopWidth: px (negate pixels)
        , borderBottomWidth: px pixels
        }

divideYReverse ∷ Int → Style
divideYReverse = negate >>> divideY
