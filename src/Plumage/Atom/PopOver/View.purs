module Plumage.Atom.PopOver.View where

import Yoga.Prelude.View

import Framer.Motion as M
import Fahrtwind (acceptClicks, positionAbsolute)
import Plumage.Atom.Modal.View (mkClickAway)
import Plumage.Hooks.UseRenderInPortal (useRenderInPortal)
import Plumage.Prelude.Style (Style)
import Fahrtwind.Style.BoxShadow (shadow)
import React.Basic.DOM as R
import React.Basic.Hooks as React

popOverShadow ∷ Style
popOverShadow =
  shadow
    "0 30px 12px 2px rgba(50,57,70,0.2), 0 24px 48px 0 rgba(0,0,0,0.4)"

mkPopOverView ∷
  { clickAwayId ∷ String, containerId ∷ String } →
  React.Component
    { placementRef ∷ NodeRef, childʔ ∷ Maybe JSX, hide ∷ Effect Unit }
mkPopOverView ids = do
  popOver ← mkPopOver ids # liftEffect
  React.component "PopOverView" \props → React.do
    pure $ popOver
      { isVisible: props.childʔ # isJust
      , hide: props.hide
      , placementRef: props.placementRef
      , content:
          M.animatePresence </ {} />
            [ props.childʔ # foldMap \child →
                M.div
                  </
                    { key: "popOver"
                    , style: R.css
                        { transformOrigin: "top left"
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

                    , onClick: handler stopPropagation mempty
                    }
                  />
                    [ child ]
            ]
      }

popOverStyle ∷ Style
popOverStyle = positionAbsolute <> acceptClicks

type PopOverIds = { clickAwayId ∷ String, containerId ∷ String }

type Props =
  { hide ∷ Effect Unit
  , isVisible ∷ Boolean
  , content ∷ JSX
  , placementRef ∷ NodeRef
  }

mkPopOver ∷ PopOverIds → React.Component Props
mkPopOver { clickAwayId, containerId } = do
  clickAway ← mkClickAway clickAwayId
  React.component "popOver" \props → React.do
    let { hide, isVisible, content } = props
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
          }
      , renderInPortal
          ( R.div'
              </*
                { className: "popOver"
                , css: popOverStyle
                , style: R.css { left: bb.left, top: bb.bottom }
                }
              />
                [ content ]
          )
      ]
