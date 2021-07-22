module Plumage.Style.Hover where

import React.Basic.Emotion (Style)
import React.Basic.Emotion as E

hover ∷ Style → Style
hover s = E.css { "&:hover": E.nested s }
