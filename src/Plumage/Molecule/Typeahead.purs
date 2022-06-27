module Plumage.Molecule.Typeahead where

import Yoga.Prelude.View

import Data.Array ((!!))
import Data.Array as Array
import Data.Function.Uncurried (mkFn3)
import Data.Time.Duration (Milliseconds(..))
import Debug (spy)
import Effect.Aff (Aff, attempt, delay)
import Effect.Class.Console as Console
import Effect.Exception (Error)
import Effect.Uncurried (mkEffectFn1)
import Fahrtwind (background, background', borderTop, focusWithin, gray, itemsStart, justifyEnd, outlineNone, overflowXHidden, roundedLg, shadowLg, textXs, widthFull)
import Fahrtwind as F
import Fahrtwind.Style (pB, pT, pX, pY)
import Fahrtwind.Style.Border (border, borderCol)
import Fahrtwind.Style.Color.Tailwind as TW
import Fahrtwind.Style.Color.Text (textCol)
import Fahrtwind.Style.Cursor (cursorPointer)
import Fahrtwind.Style.Display.Flex (flexCol, gap)
import Fahrtwind.Style.ScollBar (scrollBar)
import Framer.Motion as M
import MotionValue (isAnimating)
import Network.RemoteData (RemoteData)
import Network.RemoteData as RemoteData
import Plumage.Atom.InfiniteLoadingBar (mkKittLoadingBar)
import Plumage.Atom.Input.Input.Style (plumageInputContainerFocusWithinStyle, plumageInputContainerStyle, plumageInputStyle)
import Plumage.Atom.PopOver.Types (Placement(..), PrimaryPlacement(..), SecondaryPlacement(..))
import Plumage.Atom.PopOver.View (mkPopOverView)
import Plumage.Util.HTML as H
import Prim.Row (class Lacks, class Nub)
import React.Aria.Interactions2 (useFocus, useFocusWithin)
import React.Basic.DOM as R
import React.Basic.DOM.Events (capture_)
import React.Basic.DOM.Events as SE
import React.Basic.Emotion (var)
import React.Basic.Emotion as E
import React.Basic.Hooks as React
import React.Basic.Hooks.Aff (useAff)
import React.Virtuoso (virtuosoImpl)
import Record as Record
import Type.Proxy (Proxy(..))
import Unsafe.Coerce (unsafeCoerce)
import Unsafe.Reference (UnsafeRefEq)
import Untagged.Union (maybeToUor, uorToMaybe)
import Web.DOM.Document (toNonElementParentNode)
import Web.DOM.NonElementParentNode (getElementById)
import Web.HTML (window)
import Web.HTML.HTMLDocument (activeElement)
import Web.HTML.HTMLDocument as HTMLDocument
import Web.HTML.HTMLElement (spellcheck)
import Web.HTML.HTMLElement as HTMLElement
import Web.HTML.Window (document)
import Yoga.Block.Hook.Key (KeyCode)
import Yoga.Block.Hook.Key as Key

type Overscan = { main ∷ Int, reverse ∷ Int }
type ScrollSeekPlaceholder = ReactComponent { height ∷ Number, index ∷ Int }
type ScrollSeekConfiguration =
  { enter ∷ Number → Boolean, exit ∷ Number → Boolean }

type Args a =
  { debounce ∷ Milliseconds
  , suggestionToText ∷ a → String
  , contextMenuLayerId ∷ String
  , scrollSeekPlaceholderʔ ∷ Maybe ScrollSeekPlaceholder
  , scrollSeekConfigurationʔ ∷ Maybe ScrollSeekConfiguration
  , overscan ∷ Overscan
  , containerStyle ∷ E.Style
  }

type Props a =
  { onSelected ∷ a → Effect { inputValue ∷ String, dismiss ∷ Boolean }
  , onRemoved ∷ a → Effect Unit
  , renderSuggestion ∷ a → JSX
  , loadSuggestions ∷ String → Aff (Either Error (Array a))
  , onDismiss ∷ Effect Unit
  , placeholder ∷ String
  , beforeInput ∷ JSX
  }

mkDefaultArgs ∷
  ∀ a.
  { suggestionToText ∷ a → String
  , contextMenuLayerId ∷ String
  } →
  Args a
mkDefaultArgs
  { suggestionToText
  , contextMenuLayerId
  } =
  { debounce: Milliseconds 200.0
  , suggestionToText
  , contextMenuLayerId
  , scrollSeekPlaceholderʔ: Nothing
  , scrollSeekConfigurationʔ: Nothing
  , overscan: { main: 100, reverse: 100 }
  , containerStyle: resultsContainerStyle
  }

mkTypeahead ∷ ∀ a. Eq a ⇒ Args a → Effect (ReactComponent (Props a))
mkTypeahead args = do
  typeaheadView ← mkTypeaheadView
    { contextMenuLayerId: args.contextMenuLayerId
    , overscan: args.overscan
    , scrollSeekPlaceholderʔ: args.scrollSeekPlaceholderʔ
    , scrollSeekConfigurationʔ: args.scrollSeekConfigurationʔ
    , containerStyle: args.containerStyle
    }
  React.reactComponent "Typeahead" \props → React.do
    input /\ setInput ← React.useState' ""
    suggestions /\ setSuggestions ← React.useState' RemoteData.NotAsked
    activeIndex /\ updateActiveIndex ← React.useState Nothing
    useAff input do
      setSuggestions RemoteData.Loading # liftEffect
      delay args.debounce
      result ← attempt (props.loadSuggestions input)
      let rd = RemoteData.fromEither (join result)
      setSuggestions rd # liftEffect

    pure
      $ typeaheadView
      </>
        { input
        , setInput
        , suggestions
        , activeIndex
        , updateActiveIndex
        , onSelected: props.onSelected
        , onRemoved: props.onRemoved
        , onDismiss: setSuggestions RemoteData.NotAsked *> props.onDismiss
        , placeholder: props.placeholder
        , beforeInput: props.beforeInput
        , renderSuggestion: props.renderSuggestion
        }

type ViewProps a =
  { activeIndex ∷ Maybe Int
  , input ∷ String
  , setInput ∷ String → Effect Unit
  , suggestions ∷ RemoteData Error (Array a)
  , renderSuggestion ∷ a → JSX
  , updateActiveIndex ∷ (Maybe Int → Maybe Int) → Effect Unit
  , onSelected ∷ a → Effect { inputValue ∷ String, dismiss ∷ Boolean }
  , onRemoved ∷ a → Effect Unit
  , onDismiss ∷ Effect Unit
  , placeholder ∷ String
  , beforeInput ∷ JSX
  }

mkTypeaheadView ∷
  ∀ a.
  Eq a ⇒
  { contextMenuLayerId ∷ String
  , scrollSeekPlaceholderʔ ∷ Maybe ScrollSeekPlaceholder
  , scrollSeekConfigurationʔ ∷ Maybe ScrollSeekConfiguration
  , overscan ∷ Overscan
  , containerStyle ∷ E.Style
  } →
  Effect (ReactComponent (ViewProps a))
mkTypeaheadView
  args@{ contextMenuLayerId } = do
  -- loader ← mkLoader
  loadingBar ← mkKittLoadingBar
  popOver ← mkPopOverView
  itemCompo ∷ ReactComponent {} ← mkForwardRefComponentWithStyle "TypeaheadItem"
    resultContainerStyle
    M.li
  listCompo ∷ ReactComponent {} ← mkForwardRefComponentWithStyle "TypeaheadList"
    ( scrollBar
        { background: F.green._200
        , col: F.green._400
        , width: 8
        , borderRadius: 2
        , borderWidth: 4
        }
    )
    R.ul'

  React.reactComponent "TypeaheadView" \(props ∷ ViewProps a) → React.do
    let
      { renderSuggestion
      , input
      , setInput
      , suggestions
      , onDismiss
      , activeIndex
      , updateActiveIndex
      , placeholder

      } = props
    id ← React.useId
    -- The previous suggestions so we have something to display while loading
    prevSuggs /\ setPrevSuggs ← React.useState' []
    inputHasFocus /\ setInputHasFocus ← React.useState' false
    popupHasFocus /\ setPopupHasFocus ← React.useState' false
    isScrolling /\ setIsScrolling ← React.useState' false
    isAnimating /\ setIsAnimating ← React.useState' false
    inputContainerRef ← React.useRef null
    inputRef ← React.useRef null

    let focusIsWithin = inputHasFocus || popupHasFocus

    { focusWithinProps } ←
      useFocusWithin
        { onFocusWithin: handler_ (setPopupHasFocus true)
        , onBlurWithin: handler_ (setPopupHasFocus false)
        }

    { focusProps } ←
      useFocus
        { onFocus: handler_ (setInputHasFocus true)
        , onBlur: handler_ (setInputHasFocus false)
        }

    -- We store the result whenever we have successful suggestions
    React.useEffect (RemoteData.isSuccess suggestions) do
      case suggestions of
        RemoteData.Success suggs | suggs /= prevSuggs → setPrevSuggs suggs
        _ → mempty
      mempty

    let
      focusInput ∷ Effect Unit
      focusInput = do
        maybeElem ← React.readRefMaybe inputRef
        for_ (maybeElem >>= HTMLElement.fromNode) focus

      blurCurrentItem ∷ Effect Unit
      blurCurrentItem = do
        maybeActive ← window >>= document >>= activeElement
        for_ maybeActive \active → blur active

    focusActiveElement id { isAnimating, isScrolling } blurCurrentItem
      activeIndex
    let
      onSelected i = do
        { inputValue, dismiss } ← props.onSelected i
        when (props.input /= inputValue) do
          props.setInput inputValue
        when dismiss do
          updateActiveIndex (const Nothing)
          blurCurrentItem

    -- Keyboard events
    let
      handleKeyDown =
        mkHandleKeyDown
          { activeIndex
          , updateActiveIndex
          , focusInput
          , suggestions: suggestions # RemoteData.toMaybe # fromMaybe prevSuggs
          , onSelected
          , onDismiss
          }
    let
      inputBox = fragment
        [ inputElement
        , popOver
            { hide: blurCurrentItem
            , placement: Placement Below Start
            , placementRef: inputContainerRef
            , dismissBehaviourʔ: Nothing
            , onAnimationStateChange: setIsAnimating
            , containerId: contextMenuLayerId
            , childʔ:
                if focusIsWithin then Just $ R.div'
                  </
                    { onFocus: focusWithinProps.onFocus
                    , onBlur: focusWithinProps.onBlur
                    }
                  /> [ resultsContainer ]
                else Nothing
            }
        ]

      inputElement = R.div'
        </*
          { css: plumageInputContainerStyle <>
              if focusIsWithin then plumageInputContainerFocusWithinStyle
              else mempty
          , ref: inputContainerRef
          }
        />
          [ props.beforeInput
          , R.input'
              </*>
                { css: plumageInputStyle
                , id
                , ref: inputRef
                , spellCheck: false
                , autoComplete: "off"
                , placeholder
                , className: "plm-input"
                , value: input
                , onChange: handler targetValue (traverse_ setInput)
                , onMouseEnter: handler_ (when focusIsWithin focusInput)
                , onKeyUp:
                    handler
                      SE.key
                      \e → e >>= parseKey # traverse_ handleKeyDown

                , onFocus: focusProps.onFocus
                , onBlur: focusProps.onBlur
                }
          ]

      wrapSuggestion i suggestion _ =
        R.div'
          </*
            { tabIndex: -1
            , id: id <> "-suggestion-" <> show i
            , css: F.focus (background gray._100 <> outlineNone)
            , onMouseMove:
                handler syntheticEvent \det → unless (activeIndex == Just i) do
                  let
                    movementX = (unsafeCoerce det).movementX # uorToMaybe #
                      fromMaybe 0.0
                  let
                    movementY = (unsafeCoerce det).movementY # uorToMaybe #
                      fromMaybe 0.0
                  unless ((movementX == zero && movementY == zero))
                    do updateActiveIndex (const (Just i))
            , onKeyDown: handler preventDefault mempty
            -- ^ disables scrolling with arrow keys
            , onKeyUp:
                handler SE.key
                  (traverse_ handleKeyDown <<< (parseKey =<< _))
            , onClick: capture_ do
                onSelected suggestion
            }
          /> [ renderSuggestion suggestion ]

      resultsContainer =
        R.div'
          </*
            { css: args.containerStyle
            , style: R.css { overscrollBehavior: "auto" }
            }
          />
            [ suggestionElements
            , H.div_ (pX 8)
                [ loadingBar
                    { numberOfLights: 10
                    , remoteData: suggestions
                    }
                ]
            ]

      suggestionElements =
        virtuosoImpl </>
          { overscan: args.overscan
          , scrollSeekConfiguration: args.scrollSeekConfigurationʔ # maybeToUor
          , components: case args.scrollSeekPlaceholderʔ of
              Nothing → { "Item": itemCompo, "List": listCompo }
              Just scrollSeekPlaceholder → unsafeCoerce
                { "Item": itemCompo
                , "List": listCompo
                , "ScrollSeekPlaceholder": scrollSeekPlaceholder
                }
          , isScrolling: mkEffectFn1 setIsScrolling
          , style: R.css
              { height: 230, width: "100%" }
          , data: case suggestions of
              RemoteData.NotAsked → prevSuggs
              RemoteData.Loading → prevSuggs
              RemoteData.Failure _ → prevSuggs
              RemoteData.Success suggs → suggs
          , itemContent: mkFn3 wrapSuggestion
          }

    useEffect focusIsWithin do
      unless focusIsWithin do
        updateActiveIndex (const Nothing)
      mempty

    pure inputBox

  where
  focusActiveElement
    id
    { isAnimating, isScrolling }
    blurCurrentItem
    activeIndex =
    useEffect activeIndex do
      unless (isAnimating || isScrolling) do
        -- scroll into view
        case activeIndex of
          Nothing → blurCurrentItem
          Just i → do
            suggʔ ← window >>= document >>=
              ( HTMLDocument.toDocument >>> toNonElementParentNode >>>
                  getElementById (id <> "-suggestion-" <> show i)
              )
            for_ (suggʔ >>= HTMLElement.fromElement) focus
      mempty

resultsContainerStyle ∷ E.Style
resultsContainerStyle =
  textCol TW.gray._700
    <> background' (var ("--plm-popupBackground-colour"))
    <> pT 0
    <> pB 6
    <> pX 0
    <> flexCol
    <> justifyEnd
    <> itemsStart
    <> gap 3
    <> roundedLg
    <> border 1
    <> borderTop 0
    <> textXs
    <> shadowLg
    <> borderCol TW.gray._200

resultContainerStyle ∷ E.Style
resultContainerStyle = pY 2 <> cursorPointer

parseKey ∷ String → Maybe KeyCode
parseKey = case _ of
  "ArrowUp" → Just Key.Up
  "ArrowDown" → Just Key.Down
  "Backspace" → Just Key.Backspace
  "Enter" → Just Key.Return
  _ → Nothing

mkHandleKeyDown ∷
  ∀ a.
  { activeIndex ∷ Maybe Int
  , focusInput ∷ Effect Unit
  , suggestions ∷ (Array a)
  , updateActiveIndex ∷ (Maybe Int → Maybe Int) → Effect Unit
  , onSelected ∷ a → Effect Unit
  , onDismiss ∷ Effect Unit
  } →
  KeyCode →
  Effect Unit
mkHandleKeyDown
  { activeIndex
  , suggestions
  , updateActiveIndex
  , focusInput
  , onSelected
  , onDismiss
  }
  key = do
  let maxIndex = Array.length suggestions - 1
  case key of
    Key.Up → do
      when (activeIndex == Just 0) focusInput
      updateActiveIndex case _ of
        Just 0 → Nothing
        Nothing → Just maxIndex
        Just i → Just (i - 1)
    Key.Down → do
      when (activeIndex == Just maxIndex) focusInput
      updateActiveIndex case _ of
        Just i | i == maxIndex → Nothing
        Nothing → Just 0
        Just i → Just (i + 1)
    -- [TODO] End and Home keys
    Key.Return → do
      for_ activeIndex \i → do
        for_ (suggestions !! i) onSelected
    Key.Backspace → do
      focusInput
    Key.Escape → do
      onDismiss
    _ → mempty

mkForwardRefComponent ∷
  ∀ ref props.
  Lacks "ref" props ⇒
  String →
  ReactComponent { ref ∷ React.Ref ref | props } →
  Effect (ReactComponent { | props })
mkForwardRefComponent name component = mkForwardRefComponentEffect name
  \(props ∷ { | props }) ref → React.do
    pure $ React.element component (Record.insert (Proxy ∷ _ "ref") ref props)

mkForwardRefEmotionComponent ∷
  ∀ ref props.
  Lacks "ref" props ⇒
  String →
  ReactComponent { className ∷ String, ref ∷ React.Ref ref | props } →
  Effect (ReactComponent { className ∷ String, css ∷ E.Style | props })
mkForwardRefEmotionComponent name component =
  mkForwardRefComponentEffect name
    \(props ∷ { className ∷ String, css ∷ E.Style | props }) ref → React.do
      pure $ E.element component
        ( Record.insert (Proxy ∷ _ "ref") ref props
        )

mkForwardRefComponentWithStyle ∷
  ∀ ref props.
  Lacks "ref" props ⇒
  Lacks "className" props ⇒
  Union props
    (className ∷ String, css ∷ E.Style)
    (className ∷ String, css ∷ E.Style | props) ⇒
  Nub (className ∷ String, css ∷ E.Style | props)
    (className ∷ String, css ∷ E.Style | props) ⇒
  String →
  E.Style →
  ReactComponent { className ∷ String, ref ∷ React.Ref ref | props } →
  Effect (ReactComponent { | props })
mkForwardRefComponentWithStyle name css component = mkForwardRefComponentEffect
  name
  \(props ∷ { | props }) ref → React.do
    pure $ E.element component
      ( Record.insert (Proxy ∷ _ "ref") ref
          ( (props `Record.disjointUnion` { className: name, css }) ∷
              { className ∷ String, css ∷ E.Style | props }
          )
      )