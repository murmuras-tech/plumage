module Plumage.Style.UserSelect where

import React.Basic.Emotion (Style)
import React.Basic.Emotion as E

userSelectNone ∷ Style
userSelectNone = E.css { userSelect: E.none }

userSelectDefault ∷ Style
userSelectDefault = E.css { userSelect: E.default }

userSelectText ∷ Style
userSelectText = E.css { userSelect: E.str "text" }
