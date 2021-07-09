module Plumage.Style.Color.Background where

import Prelude
import Color (Color, cssStringRGBA)
import Data.Array (intercalate)
import React.Basic.Emotion (Style, color, css)
import React.Basic.Emotion as E

background ∷ Color → Style
background = css <<< { backgroundColor: _ } <<< color

linearGradient ∷ Int → Array Color → Style
linearGradient deg colors = css { background }
  where
  background =
    E.str
      $ "linear-gradient("
      <> show deg
      <> "deg, "
      <> intercalate "," (cssStringRGBA <$> colors)
      <> ")"
