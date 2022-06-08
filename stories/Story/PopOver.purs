module Story.PopOver (default, popOver, popOverDynamic) where

import Yoga.Prelude.View

import Data.String as String
import Fahrtwind (border, flexCol, gray, height, heightFull, heightScreen, justifyBetween, mXAuto, mXY, pX, pX', pY, roundedMd, roundedSm, textCol, width, width', widthAndHeight, widthFull)
import Fahrtwind.Icon.Heroicons as Heroicon
import Fahrtwind.Style (background, shadowDefault, widthAndHeight)
import Plumage.Atom.PopOver.View (Placement(..), PrimaryPlacement(..), SecondaryPlacement(..), printPlacement, toTransformOrigin)
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
      , clickAwayIdʔ: Nothing -- Just "clickaway"
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
  placement /\ setPlacement ← React.useState (Placement Top Start)
  containerMargins /\ setContainerMargins ← React.useState' (R.css {})
  { hidePopOver, isVisible, showPopOver, renderInPopOver, targetRef } ←
    usePopOver
      { containerId: "cm"
      , clickAwayIdʔ: Nothing
      , placement
      }
  useEffectOnce $ showPopOver *> mempty
  let
    cyclePlacement = case _ of
      Placement Top Start → Placement Top Centre
      Placement Top Centre → Placement Top End
      Placement Top End → Placement Right Start
      Placement Right Start → Placement Right Centre
      Placement Right Centre → Placement Right End
      Placement Right End → Placement Bottom End
      Placement Bottom End → Placement Bottom Centre
      Placement Bottom Centre → Placement Bottom Start
      Placement Bottom Start → Placement Left End
      Placement Left End → Placement Left Centre
      Placement Left Centre → Placement Left Start
      Placement Left Start → Placement Top Start
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
          , onClick: handler_ showPopOver
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