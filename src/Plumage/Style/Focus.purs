module Plumage.Style.Focus where

import React.Basic.Emotion (Style)
import React.Basic.Emotion as E

focus ∷ Style → Style
focus s = E.css { "&:focus": E.nested s }

focusWithin ∷ Style → Style
focusWithin s = E.css { "&:focus-within": E.nested s }
