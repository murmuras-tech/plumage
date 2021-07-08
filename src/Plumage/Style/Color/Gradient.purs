module Plumage.Style.Color.Background where

import Prelude
import Color (Color, cssStringRGBA)
import Data.Array (intercalate)
import React.Basic.Emotion (Style, color, css)
import React.Basic.Emotion as E

col ∷ Color -> Style
col = css <<< { backgroundColor: _ } <<< color

linear ∷ Int -> Array Color -> Style
linear deg colors = css { background }
  where
    background =
      E.str
        $ "linear-gradient("
        <> show deg
        <> "deg, "
        <> intercalate "," (cssStringRGBA <$> colors)
        <> ")"