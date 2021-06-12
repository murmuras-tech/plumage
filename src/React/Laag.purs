module React.Laag where

import Prelude
import Data.Nullable (Nullable)
import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1)
import Prim.Row (class Union)
import React.Basic (JSX, ReactComponent, Ref)
import React.Basic.DOM (CSS)
import React.Basic.Hooks (Hook, unsafeHook)
import Web.DOM (Node)
import Web.HTML (HTMLElement, Window)
import Web.HTML.HTMLElement (DOMRect)

foreign import arrowImpl ∷ ∀ props. ReactComponent { | props }

foreign import useLayerImpl ∷ ∀ options. EffectFn1 { | options } UseLayerProps

foreign import data UseLayer ∷ Type -> Type

type UseLayerProps =
  { triggerProps ∷ { ref ∷ Effect (Ref (Nullable Node)) }
  , layerProps ∷ { ref ∷ Effect (Ref (Nullable Node)), style ∷ CSS }
  , arrowProps ∷ { layerSide ∷ String, ref ∷ Effect (Ref (Nullable Node)), style ∷ CSS }
  , renderLayer ∷ JSX -> JSX
  , layerSide ∷ String
  , triggerBounds ∷ Nullable DOMRect
  }

type UseLayerOptions =
  ( isOpen ∷ Boolean
  , overflowContainer ∷ Boolean
  , placement ∷ String
  , possiblePlacements ∷ Array String
  , preferX ∷ String
  , preferY ∷ String
  , auto ∷ Boolean
  , snap ∷ Boolean
  , triggerOffset ∷ Int
  , containerOffset ∷ Int
  , arrowOffset ∷ Int
  , layerDimensions ∷ { width ∷ Int, height ∷ Int }
  , onDisappear ∷ EffectFn1 { type ∷ String } Unit
  , onOutsideClick ∷ Effect Unit
  , onParentClose ∷ Effect Unit
  , container ∷ HTMLElement
  , trigger ∷ ∀ r. { | r }
  , getBounds ∷ Effect DOMRect
  , getParent ∷ Effect HTMLElement
  , environment ∷ Window
  )

useLayer ∷
  ∀ props props_.
  Union
    props
    props_
    UseLayerOptions =>
  { isOpen ∷ Boolean | props } -> Hook UseLayer UseLayerProps
useLayer = unsafeHook <<< runEffectFn1 useLayerImpl
