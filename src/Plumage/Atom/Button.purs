module Plumage.Atom.Button where

import Prelude
import Data.Array (fold)
import Data.Maybe (Maybe)
import Data.Monoid (guard)
import Data.Nullable (Nullable)
import Data.Nullable as Nullable
import Data.Traversable (for, for_)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Foreign.Object as Object
import Framer.Motion as M
import Plumage.Layer as Layer
import Plumage.Style (mXY, pX, pXY, pY)
import Plumage.Style.Border (border, borderCol, borderNone, borderSolid, boxSizingBorderBox, rounded, roundedXl)
import Plumage.Style.BoxShadow (shadowDefaultCol, shadowSm)
import Plumage.Style.Color.Background (background)
import Plumage.Style.Color.Tailwind as C
import Plumage.Style.Color.Text (textCol)
import Plumage.Style.Cursor (cursorPointer)
import Plumage.Style.Display (inlineBlock)
import Plumage.Style.Opacity (opacity)
import Plumage.Style.Position (positionRelative, positionAbsolute)
import Plumage.Style.Size (height, width)
import React.Aria.Button (useButton)
import React.Aria.Focus (useFocusRing)
import React.Aria.Utils (mergeProps)
import React.Basic.DOM (css, unsafeCreateDOMComponent)
import React.Basic.DOM as R
import React.Basic.Emotion (Style)
import React.Basic.Emotion as E
import React.Basic.Hooks (Ref, component, readRefMaybe, useEffectAlways)
import React.Basic.Hooks as React
import Web.DOM (Node)
import Web.HTML.HTMLElement (DOMRect, HTMLElement, getBoundingClientRect)
import Web.HTML.HTMLElement as HTMLElement

mkButton = do
  rawButton ← unsafeCreateDOMComponent "button"
  component "Button" \props → React.do
    ref ← React.useRef Nullable.null
    containerRef ← React.useRef Nullable.null
    boundingBox /\ setBoundingBox ← React.useState' zero
    useEffectAlways do
      maybeBB ← getBoundingBoxFromRef containerRef
      for_ maybeBB \bb →
        when (bb /= boundingBox) (setBoundingBox bb)
      mempty
    { buttonProps } ← useButton props.buttonProps ref
    { isFocused, isFocusVisible, focusProps } ←
      useFocusRing { within: false, isTextInput: false, autoFocus: false }
    pure
      $ E.element R.div'
          { className: "plm-button-container"
          , css:
              positionRelative
                <> inlineBlock
                <> pXY 0
                <> mXY 0
                <> props.containerCss
          , ref: containerRef
          , children:
              [ E.element rawButton
                  ( mergeProps
                      focusProps
                      ( mergeProps
                          buttonProps
                          { className: "plm-button"
                          , css: props.css
                          , ref
                          , children: props.children
                          }
                      )
                  )
              , guard (isFocused && isFocusVisible)
                  ( E.element M.div
                      { className: "focus-outline"
                      , css: focusStyle
                      , initial:
                          M.initial
                            $ css
                                { width: boundingBox.width
                                , height: boundingBox.height
                                , left: 0
                                , top: 0
                                }
                      , animate:
                          M.animate
                            $ css
                                { width: boundingBox.width + 12.0
                                , height: boundingBox.height + 12.0
                                , left: -6.0
                                , top: -6.0
                                }
                      , layout: M.layout true
                      , layoutId: M.layoutId "focus-indicator"
                      , _aria: Object.singleton "hidden" "true"
                      }
                  )
              ]
          }

focusStyle ∷ Style
focusStyle =
  fold
    [ border 4
    , borderCol C.violet._400
    , borderSolid
    , boxSizingBorderBox
    , rounded (E.px 17)
    , positionAbsolute
    , opacity 80
    , Layer.topmost
    ]

baseButtonStyle ∷ Style
baseButtonStyle =
  fold
    [ background C.white
    , textCol C.black
    , roundedXl
    , borderSolid
    , borderCol C.gray._300
    , border 1
    , pY 11
    , pX 27
    , boxSizingBorderBox
    , shadowSm
    , cursorPointer
    , E.css
        { fontFamily: E.str "InterVariable, sans-serif"
        , fontSize: E.str "0.95em"
        , fontWeight: E.str "500"
        , letterSpacing: E.str "0.025em"
        , textAlign: E.str "center"
        , outline: E.none
        }
    ]

primaryButtonStyle ∷ Style
primaryButtonStyle =
  baseButtonStyle
    <> fold
        [ background C.violet._600
        , textCol C.white
        , borderNone
        , pY 12
        , pX 28
        , shadowDefaultCol C.violet._600
        ]

getBoundingBoxFromRef ∷ Ref (Nullable Node) → Effect (Maybe DOMRect)
getBoundingBoxFromRef itemRef = do
  htmlElem ← getHTMLElementFromRef itemRef
  for htmlElem getBoundingClientRect

getHTMLElementFromRef ∷ Ref (Nullable Node) → Effect (Maybe HTMLElement)
getHTMLElementFromRef itemRef = do
  maybeNode ← readRefMaybe itemRef
  pure $ HTMLElement.fromNode =<< maybeNode
