module Plumage.Hooks.UsePopOver where

import Yoga.Prelude.View

import Data.Newtype (class Newtype)
import Effect.Unsafe (unsafePerformEffect)
import Plumage.Atom.PopOver.View (mkPopOver)
import React.Basic.Hooks as React

type Options = { clickAwayId ∷ String, containerId ∷ String }

newtype UsePopOver hooks = UsePopOver
  (UseRef (Nullable Node) (UseState Boolean hooks))

derive instance Newtype (UsePopOver hooks) _

usePopOver ∷
  Options →
  Hook UsePopOver
    { hide ∷ Effect Unit
    , renderInPopOver ∷ JSX → JSX
    , targetProps ∷ { onClick ∷ Effect Unit, ref ∷ NodeRef }
    }
usePopOver options = coerceHook React.do
  isVisible /\ setIsVisible ← React.useState' false
  targetRef ← React.useRef null
  let
    renderInPopOver content = popOverComponent
      { hide: setIsVisible false
      , isVisible
      , content
      , placementRef: targetRef
      , clickAwayId: options.clickAwayId
      , containerId: options.containerId
      }
    onClick = setIsVisible (not isVisible)
  pure
    { targetProps: { onClick, ref: targetRef }
    , renderInPopOver
    , hide: setIsVisible false
    }
  where
  popOverComponent = unsafePerformEffect mkPopOver
