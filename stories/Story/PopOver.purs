module Story.PopOver (default, popOver, popOverDynamic) where

import Yoga.Prelude.View

import Data.Array.NonEmpty as NEA
import Data.String as String
import Fahrtwind (border, flexCol, gray, height, heightFull, heightScreen, justifyBetween, mXAuto, mXY, pX, pX', pY, roundedMd, roundedSm, textCol, width, width', widthAndHeight, widthFull)
import Fahrtwind.Icon.Heroicons as Heroicon
import Fahrtwind.Style (background, shadowDefault, widthAndHeight)
import Plumage.Atom.PopOver.Types (DismissBehaviour(..), HookDismissBehaviour(..), Placement(..), PrimaryPlacement(..), SecondaryPlacement(..), printPlacement)
import Plumage.Atom.PopOver.View (toTransformOrigin)
import Plumage.Hooks.UsePopOver (usePopOver)
import Plumage.Util.HTML as H
import React.Basic.DOM as R
import React.Basic.Emotion (auto, percent)
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
                [ compo (Placement Above Centre)
                , compo (Placement Above Start)
                , compo (Placement Above End)
                ]
            , Block.cluster { space: "8px" }
                [ compo (Placement RightOf Centre)
                , compo (Placement RightOf Start)
                , compo (Placement RightOf End)
                ]
            , Block.cluster { space: "8px" }
                [ compo (Placement LeftOf Centre)
                , compo (Placement LeftOf Start)
                , compo (Placement LeftOf End)
                ]
            , Block.cluster { space: "8px" }
                [ compo (Placement Below Centre)
                , compo (Placement Below Start)
                , compo (Placement Below End)
                ]
            ]
        ]
    )

mkCompo ∷ Component Placement
mkCompo = React.component "Example" \placement → React.do
  { hidePopOver, isVisible, showPopOver, renderInPopOver, targetRef } ←
    usePopOver
      { containerId: "cm"
      , dismissBehaviourʔ: Just
          ( DismissPopOverOnClickOutsideTargetAnd []
          )
      , placement
      }
  -- useEffectOnce $ showPopOver *> mempty
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

popOverDynamic ∷ Effect JSX
popOverDynamic = do
  compo ← mkDynamicCompo
  pure $ inContainer
    ( compo unit
    )

mkDynamicCompo ∷ Component Unit
mkDynamicCompo = React.component "DynamicExample" \_ → React.do
  placement /\ setPlacement ← React.useState (Placement Above Start)
  containerMargins /\ setContainerMargins ← React.useState' (R.css {})
  { hidePopOver, isVisible, showPopOver, renderInPopOver, targetRef } ←
    usePopOver
      { containerId: "cm"
      , dismissBehaviourʔ: Just (DismissPopOverOnClickOutsideTargetAnd [])
      , placement
      }
  useEffectOnce $ showPopOver *> mempty
  let
    cyclePlacement = case _ of
      Placement Above Start → Placement Above Centre
      Placement Above Centre → Placement Above End
      Placement Above End → Placement RightOf Start
      Placement RightOf Start → Placement RightOf Centre
      Placement RightOf Centre → Placement RightOf End
      Placement RightOf End → Placement Below End
      Placement Below End → Placement Below Centre
      Placement Below Centre → Placement Below Start
      Placement Below Start → Placement LeftOf End
      Placement LeftOf End → Placement LeftOf Centre
      Placement LeftOf Centre → Placement LeftOf Start
      Placement LeftOf Start → Placement Above Start
  let
    btn ∷ ∀ css. { | css } → JSX
    btn margins = R.button
      { onClick: handler_ (setContainerMargins (R.css margins))
      , style: R.css { border: "1px solid black" }
      , children: [ H.div_ (widthAndHeight 20) [ Heroicon.arrowsExpand ] ]
      }
  pure $ fragment
    [ R.div'
        </*
          { css: background gray._50 <> width 300 <> height 200
              <>
                mXY 8
          , style: containerMargins
          , ref: targetRef
          }
        />
          [ H.div_ (flexCol <> justifyBetween <> heightFull)
              [ Block.cluster { justify: "space-between" }
                  [ btn {}
                  , btn { marginLeft: "auto", marginRight: "auto" }
                  , btn { marginLeft: "auto" }
                  ]
              , Block.cluster { justify: "space-between" }
                  [ btn {}
                  , Block.stack { css: width 200 <> background gray._100 }
                      [ R.text (printPlacement placement)
                      , H.div_ widthFull
                          [ R.button'
                              </*
                                { css: shadowDefault <> border 1 <> roundedMd
                                    <> pX 8
                                    <> pY 2
                                    <> mXAuto
                                , onClick: handler_ $ setPlacement
                                    cyclePlacement
                                }
                              />
                                [ R.text "change" ]
                          ]
                      , Block.button
                          { onClick: handler stopPropagation (const showPopOver)
                          }
                          [ R.text "show" ]
                      ]
                  , btn { marginLeft: "auto" }
                  ]
              , Block.cluster { justify: "space-between" }
                  [ btn {}
                  , btn { marginLeft: "auto", marginRight: "auto" }
                  , btn { marginLeft: "auto" }
                  ]
              ]
          ]
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