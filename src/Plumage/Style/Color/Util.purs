module Plumage.Style.Color.Util where

import Prelude
import Color (Color)
import Color as Color

withAlpha ∷ Number → Color → Color
withAlpha alpha c1 = Color.rgba' r g b alpha
  where
  { r, g, b } = Color.toRGBA' c1

lightness ∷ Color → Number
lightness = Color.toHSLA >>> _.l

saturation ∷ Color → Number
saturation = Color.toHSLA >>> _.s

hue ∷ Color → Number
hue = Color.toHSLA >>> _.h
