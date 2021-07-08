module Plumage.Style.BoxShadow where

import Prelude
import Color (Color, black, cssStringRGBA)
import Plumage.Style.Color.Util (withAlpha)
import React.Basic.Emotion (Style, css, str)

sm ∷ Style
sm = smCol black

smCol ∷ Color → Style
smCol col = css { boxShadow: str $ "0 1px 2px 0 " <> cssStringRGBA (col # withAlpha 0.05) }

md ∷ Style
md = smCol black

mdCol ∷ Color → Style
mdCol col = css { boxShadow: str $ "0 1px 2px 0 " <> cssStringRGBA (col # withAlpha 0.1) <> "," <> "0 2px 4px -1px " <> cssStringRGBA (col # withAlpha 0.06) }

lg ∷ Style
lg = lgCol black

lgCol ∷ Color → Style
lgCol col = css { boxShadow: str $ "0 10px 15px -3px " <> cssStringRGBA (col # withAlpha 0.1) <> "," <> "0 4px 6px -2px " <> cssStringRGBA (col # withAlpha 0.05) }

xl ∷ Style
xl = xlCol black

xlCol ∷ Color → Style
xlCol col = css { boxShadow: str $ "0 20px 25px -5px " <> cssStringRGBA (col # withAlpha 0.1) <> "," <> "0 10px 10px -5px " <> cssStringRGBA (col # withAlpha 0.04) }

xxl ∷ Style
xxl = xxlCol black

xxlCol ∷ Color → Style
xxlCol col = css { boxShadow: str $ "0 25px 50px -12px " <> cssStringRGBA (col # withAlpha 0.25) }

default ∷ Style
default = defaultCol black

defaultCol ∷ Color → Style
defaultCol col =
  css
    { boxShadow:
        str
          $ "0 1px 3px 0 "
          <> cssStringRGBA (col # withAlpha 0.1)
          <> ", 0 1px 2px 0 "
          <> cssStringRGBA (col # withAlpha 0.06)
    }
