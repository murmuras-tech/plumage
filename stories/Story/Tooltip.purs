module Story.Tooltip (default, tooltip) where

import Yoga.Prelude.View

import Plumage.Atom.PopOver.Types (Placement(..), PrimaryPlacement(..), SecondaryPlacement(..))
import Plumage.Atom.Tooltip.View as Tooltip
import React.Basic.DOM as R
import Story.Container (inContainer)

default ∷ { title ∷ String }
default = { title: "Molecule/PopOver" }

tooltip ∷ Effect JSX
tooltip = do
  pure $ inContainer $
    Tooltip.tooltip
      { containerId: "cm"
      , placement: Placement LeftOf Centre
      , tooltip: R.text "He!"
      }
      (R.button_ [ R.text "hahah" ])
