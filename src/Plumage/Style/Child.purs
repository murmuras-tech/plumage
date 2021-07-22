module Plumage.Style.Child where

import React.Basic.Emotion (Style)
import React.Basic.Emotion as E

firstChild ∷ Style → Style
firstChild s = E.css { "& > *:not(style):first-of-type": E.nested s }

lastChild ∷ Style → Style
lastChild s = E.css { "& > *:not(style):last-of-type": E.nested s }

evenChild ∷ Style → Style
evenChild s = E.css { "& > *:not(style):nth-of-type(even)": E.nested s }

oddChild ∷ Style → Style
oddChild s = E.css { "& > *:not(style):nth-of-type(odd)": E.nested s }
