module Story.PopOver (default, popOver) where

import Yoga.Prelude.View

import Data.String as String
import Fahrtwind (gray, height, mXY, textCol, width)
import Fahrtwind.Icon.Heroicons as Heroicon
import Fahrtwind.Style (background, shadowDefault, widthAndHeight)
import Plumage.Atom.PopOver.View (Placement(..), PrimaryPlacement(..), SecondaryPlacement(..), printPlacement, toTransformOrigin)
import Plumage.Hooks.UsePopOver (usePopOver)
import Plumage.Util.HTML as H
import React.Basic.DOM as R
import React.Basic.Emotion as E
import React.Basic.Hooks as React
import Story.Container (inContainer)
import Yoga.Block as Block

default ∷ { title ∷ String }
default = { title: "Molecule/PopOver" }

popOver ∷ Effect JSX
popOver = do
  compo ← mkCompo
  pure $ inContainer
    ( Block.centre { padding: E.px 24 }
        [ Block.stack_
            [ Block.cluster { space: "8px" }
                [ compo (Placement Top Centre)
                , compo (Placement Top Start)
                , compo (Placement Top End)
                ]
            , Block.cluster { space: "8px" }
                [ compo (Placement Right Centre)
                , compo (Placement Right Start)
                , compo (Placement Right End)
                ]
            , Block.cluster { space: "8px" }
                [ compo (Placement Left Centre)
                , compo (Placement Left Start)
                , compo (Placement Left End)
                ]
            , Block.cluster { space: "8px" }
                [ compo (Placement Bottom Centre)
                , compo (Placement Bottom Start)
                , compo (Placement Bottom End)
                ]
            ]
        ]
    )

mkCompo ∷ Component Placement
mkCompo = React.component "Example" \placement → React.do
  { hidePopOver, isVisible, showPopOver, renderInPopOver, targetRef } ←
    usePopOver
      { containerId: "cm"
      , clickAwayId: "clickaway"
      , placement
      }
  pure $ fragment
    [ R.div'
        </*
          { css: background gray._50 <> width 100 <> height 50
          , ref: targetRef
          , onClick: handler_ showPopOver
          }
        />
          [ R.text (printPlacement placement) ]
    , renderInPopOver
        ( R.div'
            </*
              { css:
                  ( widthAndHeight 36 <> shadowDefault
                      <> background gray._100
                      <> textCol gray._800
                  )
              }
            />
              [ Heroicon.heart ]
        )
    ]