module Plumage.Style.Size where

import React.Basic.Emotion (Style, StyleProperty, css, percent, vh, vw)

width ∷ StyleProperty → Style
width w = css { width: w }

screenWidth ∷ StyleProperty
screenWidth = vw 100.0

height ∷ StyleProperty → Style
height h = css { height: h }

screenHeight ∷ StyleProperty
screenHeight = vh 100.0

full ∷ StyleProperty
full = percent 100.0

widthScreen ∷ Style
widthScreen = width screenWidth

heightScreen ∷ Style
heightScreen = height screenHeight
