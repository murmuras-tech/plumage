module Plumage.Style.Color.Background where

import Prelude
import Color (Color, cssStringRGBA)
import Data.Array (intercalate)
import Plumage.Style.Color.Util (withAlpha)
import React.Basic.Emotion (Style, color, css, nested, str)
import React.Basic.Emotion as E

background ∷ Color → Style
background = css <<< { backgroundColor: _ } <<< color

linearGradient ∷ Int → Array Color → Style
linearGradient deg colors = css { background: bg }
  where
  bg =
    E.str
      $ "linear-gradient("
      <> show deg
      <> "deg, "
      <> intercalate "," (cssStringRGBA <$> colors)
      <> ")"

blurredBackground ∷ Color → Int → Style
blurredBackground col blurRadius =
  blurredBackground'
    { blurredCol: col # withAlpha 0.3
    , fallbackCol: col # withAlpha 0.8
    , blurRadius
    }

blurredBackground' ∷ { blurredCol ∷ Color, fallbackCol ∷ Color, blurRadius ∷ Int } → Style
blurredBackground' { blurredCol, fallbackCol, blurRadius } =
  css
    { "@supports (backdrop-filter: blur(12px))":
        nested
          $ css
              { backgroundColor: color blurredCol
              , backdropFilter: str $ "blur(" <> show blurRadius <> ")"
              }
    , "@supports not (backdrop-filter: blur(12px))":
        nested
          $ css
              { backgroundColor: color fallbackCol
              }
    }
