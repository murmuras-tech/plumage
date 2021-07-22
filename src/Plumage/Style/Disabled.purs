module Plumage.Style.Disabled where

import React.Basic.Emotion (Style)
import React.Basic.Emotion as E

disabled ∷ Style → Style
disabled s = E.css { "&:disabled": E.nested s }
