module Plumage.Atom.Modal.View where

import Yoga.Prelude.View

import Plumage.Hooks.UseRenderInPortal (useRenderInPortal)
import Plumage (acceptClicks)
import Plumage.Style.Color.Background (background)
import Plumage.Style.Color.Tailwind as TW
import Plumage.Style.Color.Util (withAlpha)
import Plumage.Style.Inset (left, left', top) as P
import Plumage.Style.Position (positionFixed)
import Plumage.Style.Size (heightScreen, widthScreen) as P
import Plumage.Style.Transform (translate)
import Plumage.Util.HTML as H
import React.Basic.DOM as R
import React.Basic.Emotion (Style)
import React.Basic.Emotion as E
import React.Basic.Hooks as React

clickAwayStyle ∷ Style
clickAwayStyle = P.widthScreen <> P.heightScreen
  <> positionFixed
  <> P.left 0
  <> P.top 0
  <> acceptClicks

-- [TODO] Move out
mkClickAway
  ∷ String
  → React.Component { css ∷ Style, hide ∷ Effect Unit, isVisible ∷ Boolean }
mkClickAway clickAwayId = do
  React.component "Clickaway"
    \{ css, isVisible, hide } →
      React.do
        renderInPortal ← useRenderInPortal clickAwayId
        pure
          $ guard isVisible
          $ renderInPortal
          $ R.div'
          </*>
            { className: "click-away"
            , css: clickAwayStyle <> css
            , onClick: handler_ hide
            }

modalStyle ∷ Style
modalStyle = positionFixed <> P.left' (50.0 # E.percent)
  <> P.top 0
  <> translate "-50%" "0"
  <> acceptClicks

type ModalIds = { clickAwayId ∷ String, modalContainerId ∷ String }

type Props =
  { hide ∷ Effect Unit
  , isVisible ∷ Boolean
  , content ∷ JSX
  , allowClickAway ∷ Boolean
  }

mkModal ∷ ModalIds → React.Component Props
mkModal { clickAwayId, modalContainerId } = do
  clickAway ← mkClickAway clickAwayId
  React.component "Modal" \props → React.do
    let { hide, isVisible, content, allowClickAway } = props
    renderInPortal ← useRenderInPortal modalContainerId
    pure $ fragment
      [ clickAway
          { css: background (TW.gray._900 # withAlpha 0.5)
          , hide: if allowClickAway then hide else mempty
          , isVisible
          }
      , renderInPortal (H.div "modal" modalStyle [ content ])
      ]