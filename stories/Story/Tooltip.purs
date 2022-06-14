module Story.Tooltip (default, tooltip) where

import Yoga.Prelude.View

import Fahrtwind (border, flexCol, gray, height, heightFull, justifyBetween, mXAuto, mXY, pX, pY, roundedMd, textCol, width, widthFull)
import Fahrtwind.Icon.Heroicons as Heroicon
import Fahrtwind.Style (background, shadowDefault, widthAndHeight)
import Plumage.Atom.PopOver.Types (HookDismissBehaviour(..), Placement(..), PrimaryPlacement(..), SecondaryPlacement(..), printPlacement)
import Plumage.Atom.Tooltip.View as Tooltip
import Plumage.Hooks.UsePopOver (usePopOver)
import Plumage.Util.HTML as H
import React.Basic.DOM as R
import React.Basic.Emotion as E
import React.Basic.Hooks as React
import Story.Container (inContainer)
import Yoga.Block as Block
import Yoga.Block.Container.View (tooltipContainerId)

default ∷ { title ∷ String }
default = { title: "Molecule/PopOver" }

tooltip ∷ Effect JSX
tooltip = do
  pure $ inContainer $
    Tooltip.tooltip
      { containerId: "cm"
      , placement: Placement Below Centre
      , tooltip: R.text "He!"
      }
      (R.button_ [ R.text "hahah" ])
