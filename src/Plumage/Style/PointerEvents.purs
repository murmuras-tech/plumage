module Plumage.Style.PointerEvents where

import React.Basic.Emotion (Style, css, default, none)

pointerEventsNone ∷ Style
pointerEventsNone = css { pointerEvents: none }

pointerEventsDefault ∷ Style
pointerEventsDefault = css { pointerEvents: default }

ignoreClicks ∷ Style
ignoreClicks = pointerEventsNone

acceptClicks ∷ Style
acceptClicks = pointerEventsDefault