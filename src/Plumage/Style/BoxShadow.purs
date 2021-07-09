module Plumage.Style.BoxShadow where

import Prelude
import Color (Color, black, cssStringRGBA)
import Plumage.Style.Color.Util (withAlpha)
import React.Basic.Emotion (Style, StyleProperty, css, str)

shadow ∷ StyleProperty → Style
shadow boxShadow = css { boxShadow }

shadowSm ∷ Style
shadowSm = shadowSmCol black

shadowSmCol ∷ Color → Style
shadowSmCol col = shadow $ str $ "0 1px 2px 0 " <> cssStringRGBA (col # withAlpha 0.05)

shadowMd ∷ Style
shadowMd = shadowSmCol black

shadowMdCol ∷ Color → Style
shadowMdCol col = shadow $ str $ "0 1px 2px 0 " <> cssStringRGBA (col # withAlpha 0.1) <> "," <> "0 2px 4px -1px " <> cssStringRGBA (col # withAlpha 0.06)

shadowLg ∷ Style
shadowLg = shadowLgCol black

shadowLgCol ∷ Color → Style
shadowLgCol col = shadow $ str $ "0 10px 15px -3px " <> cssStringRGBA (col # withAlpha 0.1) <> "," <> "0 4px 6px -2px " <> cssStringRGBA (col # withAlpha 0.05)

shadowXl ∷ Style
shadowXl = shadowXlCol black

shadowXlCol ∷ Color → Style
shadowXlCol col = shadow $ str $ "0 20px 25px -5px " <> cssStringRGBA (col # withAlpha 0.1) <> "," <> "0 10px 10px -5px " <> cssStringRGBA (col # withAlpha 0.04)

shadowXxl ∷ Style
shadowXxl = shadowXxlCol black

shadowXxlCol ∷ Color → Style
shadowXxlCol col = shadow $ str $ "0 25px 50px -12px " <> cssStringRGBA (col # withAlpha 0.25)

shadowDefault ∷ Style
shadowDefault = shadowDefaultCol black

shadowDefaultCol ∷ Color → Style
shadowDefaultCol col =
  css
    { boxShadow:
        str
          $ "0 1px 3px 0 "
          <> cssStringRGBA (col # withAlpha 0.1)
          <> ", 0 1px 2px 0 "
          <> cssStringRGBA (col # withAlpha 0.06)
    }
