module Plumage.Style.PointerEvents where

import React.Basic.Emotion (Style, css, none)

pointerEventsNone ∷ Style
pointerEventsNone = css { pointerEvents: none }
