module Plumage.Atom.PopOver.View where

import Yoga.Prelude.View

import Debug (spy)
import Fahrtwind (acceptClicks, positionAbsolute)
import Fahrtwind.Style.BoxShadow (shadow)
import Framer.Motion as M
import Plumage.Atom.Modal.View (mkClickAway)
import Plumage.Hooks.UseRenderInPortal (useRenderInPortal)
import Plumage.Prelude.Style (Style)
import React.Basic.DOM as R
import React.Basic.Hooks as React

popOverShadow ∷ Style
popOverShadow =
  shadow
    "0 30px 12px 2px rgba(50,57,70,0.2), 0 24px 48px 0 rgba(0,0,0,0.4)"

type PopOverViewProps =
  { clickAwayId ∷ String
  , containerId ∷ String
  , placement ∷ Placement
  , placementRef ∷ NodeRef
  , childʔ ∷ Maybe JSX
  , hide ∷ Effect Unit
  }

mkPopOverView ∷ React.Component PopOverViewProps
mkPopOverView = do
  popOver ← mkPopOver
  React.component "PopOverView" \props → React.do
    pure $ popOver
      { isVisible: props.childʔ # isJust
      , clickAwayId: props.clickAwayId
      , containerId: props.containerId
      , hide: props.hide
      , placement: props.placement
      , placementRef: props.placementRef
      , content:
          M.animatePresence </ {} />
            [ props.childʔ # foldMap \child →
                M.div
                  </
                    { key: "popOver"
                    , style: R.css
                        { transformOrigin: toTransformOrigin props.placement
                        }
                    , initial: M.initial $ R.css
                        { scale: 0.25
                        , opacity: 0
                        }
                    , animate: M.animate $ R.css
                        { scale: 1
                        , opacity: 1
                        , y: 0
                        , transition:
                            { type: "spring", bounce: 0.16, duration: 0.3 }

                        }
                    , exit:
                        M.exit $ R.css
                          { scale: 0.25
                          , opacity: 0
                          , transition:
                              { type: "spring", bounce: 0.2, duration: 0.3 }
                          }
                    }
                  />
                    [ child ]
            ]
      }

popOverStyle ∷ Style
popOverStyle = positionAbsolute <> acceptClicks

type Props =
  { hide ∷ Effect Unit
  , isVisible ∷ Boolean
  , content ∷ JSX
  , placement ∷ Placement
  , placementRef ∷ NodeRef
  , clickAwayId ∷ String
  , containerId ∷ String
  }

data Placement = Placement PrimaryPlacement SecondaryPlacement
data PrimaryPlacement = Top | Left | Right | Bottom
data SecondaryPlacement = Centre | Start | End

derive instance Eq PrimaryPlacement
derive instance Ord PrimaryPlacement
derive instance Eq SecondaryPlacement
derive instance Ord SecondaryPlacement
derive instance Eq Placement
derive instance Ord Placement

printPlacement ∷ Placement → String
printPlacement (Placement primary secondary) = p <> " " <> s
  where
  p = case primary of
    Top → "top"
    Left → "left"
    Right → "right"
    Bottom → "bottom"
  s = case secondary of
    Centre → "centre"
    Start → "start"
    End → "end"

toTransformOrigin ∷ Placement → String
toTransformOrigin (Placement primary secondary) = primaryOrigin <> " " <>
  secondaryOrigin
  where
  primaryOrigin = case primary of
    Top → "bottom"
    Left → "right"
    Right → "left"
    Bottom → "top"
  secondaryOrigin = case secondary of
    Centre → "center"
    Start | primary == Top || primary == Bottom → "left"
    Start → "top"
    End | primary == Top || primary == Bottom → "right"
    End → "bottom"

mkPopOver ∷ React.Component Props
mkPopOver = do
  clickAway ← mkClickAway
  React.component "popOver" \props → React.do
    let { hide, isVisible, content, clickAwayId, containerId } = props
    bb /\ setBoundingBox ← React.useState' (zero ∷ DOMRect)
    useEffect isVisible do
      when isVisible do
        bbʔ ← getBoundingBoxFromRef props.placementRef
        for_ bbʔ \newBb →
          unless (bb == newBb) do
            setBoundingBox newBb
      mempty

    renderInPortal ← useRenderInPortal containerId
    pure $ fragment
      [ clickAway
          { css: mempty
          , hide
          , isVisible
          , clickAwayId
          }
      , renderInPortal
          ( R.div'
              </*
                { className: "popOver"
                , css: popOverStyle
                , style: toAbsoluteCSS bb props.placement
                }
              />
                [ content ]
          )
      ]

toAbsoluteCSS ∷ DOMRect → Placement → R.CSS
toAbsoluteCSS bb (Placement primary secondary) = spy "absolute"
  case primary, secondary of
    Top, Centre → R.css
      { top: bb.top
      , left: bb.left + bb.width / 2.0
      , transform: "translate(-50%, -100%)"
      }
    Top, Start → R.css
      { top: bb.top
      , left: bb.left
      , transform: "translate(0, -100%)"
      }
    Top, End → R.css
      { top: bb.top
      , left: bb.right
      , transform: "translate(-100%, -100%)"
      }
    Right, Centre → R.css
      { top: bb.top + bb.height / 2.0
      , left: bb.right
      , transform: "translate(0, -50%)"
      }
    Right, Start → R.css
      { top: bb.top
      , left: bb.right
      }
    Right, End → R.css
      { top: bb.bottom
      , left: bb.right
      , transform: "translate(0, -100%)"
      }
    Left, Centre → R.css
      { top: bb.top + bb.height / 2.0
      , left: bb.left
      , transform: "translate(-100%, -50%)"
      }
    Left, Start → R.css
      { top: bb.top
      , left: bb.left
      , transform: "translate(-100%, 0)"
      }
    Left, End → R.css
      { top: bb.bottom
      , left: bb.left
      , transform: "translate(-100%, -100%)"
      }
    Bottom, Centre → R.css
      { top: bb.bottom
      , left: bb.left + bb.width / 2.0
      , transform: "translate(-50%, 0)"
      }
    Bottom, Start → R.css
      { top: bb.bottom
      , left: bb.left
      }
    Bottom, End → R.css
      { top: bb.bottom
      , left: bb.right
      , transform: "translate(-100%, 0)"
      }