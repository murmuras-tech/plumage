--| Tailwind.css inspired helper functions for speeding up styling elements
module Plumage.Style where

import Prelude
import React.Basic.Emotion (Style, StyleProperty, css)

p ∷ StyleProperty -> Style
p = css <<< { padding: _ }

pT ∷ StyleProperty -> Style
pT = css <<< { paddingTop: _ }

pB ∷ StyleProperty -> Style
pB = css <<< { paddingBottom: _ }

pL ∷ StyleProperty -> Style
pL = css <<< { paddingLeft: _ }

pR ∷ StyleProperty -> Style
pR = css <<< { paddingRight: _ }

pX ∷ StyleProperty -> Style
pX n = pR n <> pL n

pY ∷ StyleProperty -> Style
pY n = pT n <> pB n

m ∷ StyleProperty -> Style
m = css <<< { margin: _ }

mT ∷ StyleProperty -> Style
mT = css <<< { marginTop: _ }

mB ∷ StyleProperty -> Style
mB = css <<< { marginBottom: _ }

mL ∷ StyleProperty -> Style
mL = css <<< { marginLeft: _ }

mR ∷ StyleProperty -> Style
mR = css <<< { marginRight: _ }

mX ∷ StyleProperty -> Style
mX n = mR n <> mL n

mY ∷ StyleProperty -> Style
mY n = mT n <> mB n
