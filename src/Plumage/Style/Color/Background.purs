module Plumage.Style.Color.Background where

import Prelude
import Color (Color, cssStringRGBA)
import Data.Array (intercalate)
import Plumage.Style.Color.Util (withAlpha)
import React.Basic.Emotion (Style, color, css, nested, str)

background ∷ Color → Style
background = css <<< { backgroundColor: _ } <<< color

linearGradient ∷ Int → Array Color → Style
linearGradient deg colors = css { background: str bg }
  where
  bg = linearGradientString deg colors

linearGradientString deg colors = bg
  where
  bg =
    "linear-gradient("
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
    { background: str $ cssStringRGBA fallbackCol
    , "@supports (backdrop-filter: blur(12px)) or (-webkit-backdrop-filter: blur(12px))":
        nested
          $ css
              { background: str $ cssStringRGBA blurredCol
              , backdropFilter: str $ "blur(" <> show blurRadius <> "px)"
              }
    }
