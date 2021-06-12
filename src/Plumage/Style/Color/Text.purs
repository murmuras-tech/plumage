module Plumage.Style.Color.Text where

import Prelude
import Color (Color)
import React.Basic.Emotion (Style, color, css)

text ∷ Color -> Style
text = css <<< { color: _ } <<< color
