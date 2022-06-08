module Plumage.Atom.PopOver.View where

import Yoga.Prelude.View

import Control.Monad.ST.Internal as ST
import Data.Int as Int
import Data.Maybe (isNothing)
import Data.Time.Duration (Milliseconds(..))
import Debug (spy)
import Fahrtwind (acceptClicks, positionAbsolute)
import Fahrtwind.Style.BoxShadow (shadow)
import Framer.Motion as M
import Plumage.Atom.Modal.View (mkClickAway)
import Plumage.Hooks.UseRenderInPortal (useRenderInPortal)
import Plumage.Hooks.UseResize2 (useOnResize)
import Plumage.Prelude.Style (Style)
import React.Basic.DOM as R
import React.Basic.Hooks as React
import Unsafe.Reference (UnsafeRefEq, reallyUnsafeRefEq)
import Web.Event.EventTarget (addEventListener, eventListener, removeEventListener)
import Web.HTML (window)
import Web.HTML.Event.EventTypes as EventType
import Web.HTML.HTMLDocument as HTMLDocument
import Web.HTML.Window (document, innerHeight, innerWidth, requestAnimationFrame, scrollX, scrollY)
import Web.UIEvent.MouseEvent as MouseEvent

popOverShadow ∷ Style
popOverShadow =
  shadow
    "0 30px 12px 2px rgba(50,57,70,0.2), 0 24px 48px 0 rgba(0,0,0,0.4)"

type PopOverViewProps =
  { clickAwayIdʔ ∷ Maybe String
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
    visiblePlacementʔ /\ setVisiblePlacement ← React.useState' Nothing
    animationDone /\ setAnimationDone ← React.useState' false
    visibleChildʔ /\ setVisibleChild ← React.useState' Nothing
    contentRef ← React.useRef null
    motionRef ← React.useRef null
    useEffectAlways do
      if not animationDone || (props.clickAwayIdʔ # isJust) then
        mempty
      else do
        bbʔ ← getBoundingBoxFromRef motionRef
        targetBbʔ ← getBoundingBoxFromRef props.placementRef
        case bbʔ, targetBbʔ of

          Just bb, Just targetBb → do
            eventTarget ← window >>= document <#> HTMLDocument.toEventTarget
            listener ← eventListener \e → do
              for_ (MouseEvent.fromEvent e) \mouseEvent → do
                let pageX = MouseEvent.clientX mouseEvent # Int.toNumber
                let pageY = MouseEvent.clientY mouseEvent # Int.toNumber
                let _ = spy "stuff" { pageX, pageY, bb }
                let
                  outsideOfPopOver = (pageX < bb.left)
                    || (pageX > bb.right)
                    || (pageY < bb.top)
                    || (pageY > bb.bottom)
                  outsideOfTarget = (pageX < targetBb.left)
                    || (pageX > targetBb.right)
                    || (pageY < targetBb.top)
                    || (pageY > targetBb.bottom)

                props.hide # when (outsideOfPopOver && outsideOfTarget)
            addEventListener EventType.click listener true eventTarget
            pure $ removeEventListener EventType.click listener true eventTarget
          _, _ → mempty

    let
      -- measureStyle = R.css { visibility: "hidden" }
      measureStyle = R.css
        { visibility: "hidden"
        , outline: "pink"
        , border: "solid 10px red"
        }
      style = visiblePlacementʔ # foldMap \placement → R.css
        { transformOrigin: toTransformOrigin placement
        }
      initial = M.initial $ R.css
        { scale: 0.25
        , opacity: 0
        }
      animate = M.animate $ R.css
        { scale: 1
        , opacity: 1
        , y: 0
        , transition: { type: "spring", bounce: 0.16, duration: 0.3 }
        }
      exit =
        M.exit $ R.css
          { scale: 0.25
          , opacity: 0
          , transition:
              { type: "spring", bounce: 0.2, duration: 0.3 }
          }
      onAnimationComplete = M.onAnimationComplete \fgn → do
        if (reallyUnsafeRefEq fgn exit) then
          setVisiblePlacement Nothing
        else if (reallyUnsafeRefEq fgn animate) then do
          bbʔ ← getBoundingBoxFromRef contentRef
          let _ = spy "bbʔ" bbʔ
          setAnimationDone true
        else mempty

      onAnimationStart = M.onAnimationStart do
        setAnimationDone false

      getBBWidthAndHeight = ado
        bbʔ ← getBoundingBoxFromRef contentRef
        w ← window >>= innerWidth <#> Int.toNumber
        h ← window >>= innerHeight <#> Int.toNumber
        in { bbʔ, w, h }

      calculatePlacement { bbʔ, w, h } oldPlacement = do

        -- [FIXME] I need to take the placement ref into account, it'll be the
        -- longest if else in the world
        let (Placement _ secondary) = oldPlacement
        bbʔ <#> \bb → do
          if (bb.height > h) || (bb.width > w) then
            oldPlacement
          else if bb.right > w then
            (Placement Left secondary)
          else if bb.left < zero then
            (Placement Right secondary)
          else if bb.top < zero then
            (Placement Bottom secondary)
          else if bb.bottom > h then
            (Placement Top secondary)
          else do
            oldPlacement

      getBestPlacement ∷
        { bbʔ ∷ Maybe DOMRect, w ∷ Number, h ∷ Number } → Placement → Placement
      getBestPlacement bbWidthAndHeight oldPlacement = ST.run do
        pRef ← ST.new oldPlacement
        let
          getNewPlacement = do
            currentPlacement ← ST.read pRef
            let
              newPlacement = calculatePlacement bbWidthAndHeight
                currentPlacement
            for_ newPlacement (_ `ST.write` pRef)
        getNewPlacement
        placementBefore ← ST.read pRef
        ST.while (ST.read pRef <#> (_ /= placementBefore)) do
          getNewPlacement
        result ← ST.read pRef
        pure result

    let

      recalculatePlacement =
        case props.childʔ of
          Just child →
            -- I don't know why we need three frames, sorry
            void $ window >>= requestAnimationFrame do
              void $ window >>= requestAnimationFrame do
                void $ window >>= requestAnimationFrame do
                  bbWidthAndHeight ← getBBWidthAndHeight
                  for_ bbWidthAndHeight.bbʔ $ \bb → do
                    let
                      newPlacement = getBestPlacement bbWidthAndHeight
                        props.placement
                    setVisiblePlacement (Just newPlacement)
                    setVisibleChild (Just child)
          Nothing →
            setVisibleChild Nothing

    useLayoutEffectAlways do
      recalculatePlacement
      mempty

    useOnResize (200.0 # Milliseconds) \_ → do
      setVisibleChild Nothing

    pure $ popOver
      { isVisible: props.childʔ # isJust
      , clickAwayIdʔ: props.clickAwayIdʔ
      , containerId: props.containerId
      , hide: props.hide
      , placement: visiblePlacementʔ # fromMaybe props.placement
      , placementRef: props.placementRef
      , content:
          fragment
            [ guard (visibleChildʔ # isNothing) $ props.childʔ # foldMap
                \child → R.div'
                  </
                    { ref: contentRef
                    , style: measureStyle
                    }
                  /> [ child ]
            , M.animatePresence </ {} />
                [ visibleChildʔ # foldMap \child →
                    M.div
                      </
                        { key: "popOver"
                        , style
                        , initial
                        , animate
                        , exit
                        , onAnimationComplete
                        , onAnimationStart
                        , ref: motionRef
                        }
                      />
                        [ child ]
                ]
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
  , clickAwayIdʔ ∷ Maybe String
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

cyclePlacement ∷ Placement → Placement
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
    let { hide, isVisible, content, clickAwayIdʔ, containerId } = props
    refBB /\ setRefBB ← React.useState' (zero ∷ DOMRect)
    let
      recalc = when isVisible do
        bbʔ ← getBoundingBoxFromRef props.placementRef
        fromTop ← window >>= scrollY
        fromLeft ← window >>= scrollX
        let
          adjustedBbʔ = bbʔ <#> \bb → bb
            { top = bb.top + fromTop
            , left = bb.left + fromLeft
            , right = bb.right + fromLeft
            , bottom = bb.bottom + fromTop
            }
        for_ adjustedBbʔ \newBb →
          unless (refBB == newBb) do
            setRefBB newBb

    useEffectAlways do
      recalc
      mempty

    renderInPortal ← useRenderInPortal containerId
    pure $ fragment
      [ clickAwayIdʔ
          # foldMap \clickAwayId → clickAway
              { css: mempty, hide, isVisible, clickAwayId }
      , renderInPortal
          ( R.div'
              </*
                { className: "popOver"
                , css: popOverStyle
                , style: toAbsoluteCSS refBB props.placement
                }
              />
                [ content ]
          )
      ]

toAbsoluteCSS ∷ DOMRect → Placement → R.CSS
toAbsoluteCSS bb (Placement primary secondary) =
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
