module Plumage.Hooks.UsePopOver where

import Yoga.Prelude.View

import Data.Newtype (class Newtype)
import Effect.Unsafe (unsafePerformEffect)
import Plumage.Atom.PopOver.View (Placement, mkPopOverView)
import Plumage.Atom.PopOver.View as PopOver
import React.Basic.Hooks as React

type Options =
  { clickAwayId ∷ String
  , containerId ∷ String
  , placement ∷ Placement
  }

newtype UsePopOver hooks = UsePopOver
  (UseRef (Nullable Node) (UseState Boolean hooks))

derive instance Newtype (UsePopOver hooks) _

usePopOver ∷
  Options →
  Hook UsePopOver
    { hidePopOver ∷ Effect Unit
    , renderInPopOver ∷ JSX → JSX
    , targetRef ∷ NodeRef
    , showPopOver ∷ Effect Unit
    , isVisible ∷ Boolean
    }
usePopOver options = coerceHook React.do
  isVisible /\ setIsVisible ← React.useState' false
  targetRef ← React.useRef null
  let
    renderInPopOver content = popOverComponent
      { hide: when isVisible $ setIsVisible false
      , childʔ: if isVisible then Just content else Nothing
      , placementRef: targetRef
      , placement: options.placement
      , clickAwayId: options.clickAwayId
      , containerId: options.containerId
      }
  pure
    { targetRef
    , renderInPopOver
    , hidePopOver: when isVisible $ setIsVisible false
    , showPopOver: unless isVisible $ setIsVisible true
    , isVisible
    }

popOverComponent ∷ PopOver.PopOverViewProps → JSX
popOverComponent = unsafePerformEffect mkPopOverView
