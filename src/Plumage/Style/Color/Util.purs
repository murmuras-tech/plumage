module Plumage.Style.Color.Util where

import Color (Color)
import Color as Color

withAlpha ∷ Number -> Color -> Color
withAlpha alpha c1 = Color.rgba' r g b alpha
  where
  { r, g, b } = Color.toRGBA' c1