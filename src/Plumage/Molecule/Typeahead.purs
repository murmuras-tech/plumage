module Plumage.Molecule.Typeahead where

import Yoga.Prelude.View

import Data.Array ((!!))
import Data.Array as Array
import Data.Either (either)
import Data.Time.Duration (Milliseconds(..))
import Effect.Aff (Aff, attempt, delay)
import Effect.Exception (Error)
import Framer.Motion as M
import Network.RemoteData (RemoteData)
import Network.RemoteData as RemoteData
import Plumage (background', borderTop, justifyEnd, maxHeight', minHeight, overflowYHidden, pX, roundedLg, shadowLg, textCol', textXs, transition)
import Plumage (focus) as P
import Plumage.Atom.InfiniteLoadingBar (mkKittLoadingBar)
import Plumage.Atom.Input.Input.Style (plumageInputContainerStyle, plumageInputStyle)
import Plumage.Atom.PopOver.View (mkPopOverView)
import Plumage.Style (pB, pT, pX, pY)
import Plumage.Style.Border (border, borderCol, roundedDefault)
import Plumage.Style.Color.Background (background)
import Plumage.Style.Color.Tailwind as TW
import Plumage.Style.Color.Text (textCol)
import Plumage.Style.Cursor (cursorPointer)
import Plumage.Style.Display.Flex (flexCol, flexRow, gap, justifyBetween)
import Plumage.Style.Overflow (overflowScroll, overflowYScroll)
import Plumage.Style.Text (fontMedium, textSm)
import Plumage.Style.Transition (transition)
import Plumage.Util.HTML as H
import React.Aria.Interactions2 (useFocus, useFocusWithin)
import React.Aria.Utils (useId)
import React.Basic.DOM as R
import React.Basic.DOM.Events as SE
import React.Basic.Emotion (var, vh)
import React.Basic.Emotion as E
import React.Basic.Hooks as React
import React.Basic.Hooks.Aff (useAff)
import Unsafe.Reference (unsafeRefEq)
import Web.DOM.Node (childNodes)
import Web.DOM.NodeList as NodeList
import Web.HTML (window)
import Web.HTML.HTMLDocument (activeElement)
import Web.HTML.HTMLElement as HTMLElement
import Web.HTML.Window (document)
import Yoga.Block.Hook.Key (KeyCode)
import Yoga.Block.Hook.Key as Key

type Args a =
  { debounce ∷ Milliseconds
  , loadSuggestions ∷ String → Aff (Either Error (Array a))
  , renderSuggestion ∷ a → JSX
  , suggestionToText ∷ a → String
  , contextMenuLayerId :: String
  , clickAwayId :: String
  }

type Props a =
  { onSelected ∷ a → Effect Unit
  , onRemoved ∷ Effect Unit
  , onDismiss ∷ Effect Unit
  , placeholder ∷ String
  }

mkDefaultArgs
  ∷ ∀ a
  . { loadSuggestions ∷ String → Aff (Either Error (Array a))
    , renderSuggestion ∷ a → JSX
    , suggestionToText ∷ a → String
    , contextMenuLayerId :: String
    , clickAwayId :: String
    }
  → Args a
mkDefaultArgs { loadSuggestions, renderSuggestion, suggestionToText, contextMenuLayerId, clickAwayId } =
  { debounce: Milliseconds 200.0
  , loadSuggestions
  , renderSuggestion
  , suggestionToText
  , contextMenuLayerId
  , clickAwayId
  }

mkTypeahead ∷ ∀ a. Args a → Effect (ReactComponent (Props a))
mkTypeahead args = do
  view ←
    mkTypeaheadView
      { renderSuggestion: args.renderSuggestion
      , suggestionToText: args.suggestionToText
      , contextMenuLayerId: args.contextMenuLayerId
      , clickAwayId: args.clickAwayId
      }
  React.reactComponent "Typeahead" (render view)
  where
  render view props = React.do
    input /\ setInput ← React.useState' (Left "")
    suggestions /\ setSuggestions ← React.useState' (RemoteData.NotAsked)
    activeIndex /\ updateActiveIndex ← React.useState Nothing
    useAff (input # either Just (const Nothing)) do
      case input of
        Left value → do
          delay args.debounce
          setSuggestions RemoteData.Loading # liftEffect
          result ← attempt (args.loadSuggestions value)
          let rd = RemoteData.fromEither (join result)
          setSuggestions rd # liftEffect
        _ → mempty

    pure
      $ view
      </>
        { input
        , setInput
        , suggestions
        , activeIndex
        , updateActiveIndex
        , onSelected: props.onSelected
        , onRemoved: props.onRemoved
        , onDismiss: props.onDismiss
        , placeholder: props.placeholder
        }

mkTypeaheadView
  ∷ ∀ a
  . { renderSuggestion ∷ a → JSX
    , suggestionToText ∷ a → String
    , contextMenuLayerId :: String
    , clickAwayId :: String
    }
  → Effect
      ( ReactComponent
          { activeIndex ∷ Maybe Int
          , input ∷ Either String a
          , setInput ∷ Either String a → Effect Unit
          , suggestions ∷ RemoteData Error (Array a)
          , updateActiveIndex ∷ (Maybe Int → Maybe Int) → Effect Unit
          , onSelected ∷ a → Effect Unit
          , onRemoved ∷ Effect Unit
          , onDismiss ∷ Effect Unit
          , placeholder ∷ String
          }
      )
mkTypeaheadView { renderSuggestion, suggestionToText, contextMenuLayerId, clickAwayId } = do
  -- loader ← mkLoader
  loadingBar ← mkKittLoadingBar
  popOver <- mkPopOverView { clickAwayId: clickAwayId, containerId: contextMenuLayerId }
  React.reactComponent "TypeaheadView" React.do (render loadingBar popOver)
  where

  render
    loadingBar
    popOver
    props@
      { input
      , setInput
      , suggestions
      , onDismiss
      , activeIndex
      , updateActiveIndex
      , placeholder
      } = React.do
    id ← useId
    listRef ← React.useRef null
    prevSuggs /\ setPrevSuggs ← React.useState' []
    inputHasFocus /\ setInputHasFocus ← React.useState' false
    popupHasFocus /\ setPopupHasFocus ← React.useState' false
    inputRef <- React.useRef null
    let focusIsWithin = inputHasFocus || popupHasFocus
    useEffect focusIsWithin do
      unless focusIsWithin do
        updateActiveIndex (const Nothing)
      mempty
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
    React.useEffect (RemoteData.isSuccess suggestions) do
      case suggestions of
        RemoteData.Success suggs → setPrevSuggs suggs
        _ → mempty
      mempty
    focusActiveElement listRef activeIndex
    let
      focusInput ∷ Effect Unit
      focusInput = do
        maybeElem ← React.readRefMaybe inputRef
        for_ (maybeElem >>= HTMLElement.fromNode) focus

      blurCurrentItem ∷ Effect Unit
      blurCurrentItem = do
        maybeNode ← React.readRefMaybe listRef
        for_ maybeNode \node → do
          nodeArray ← node # (childNodes >=> NodeList.toArray)
          maybeActive ← window >>= document >>= activeElement
          for_ maybeActive \active →
            for_ nodeArray \n → do
              when (unsafeRefEq n (HTMLElement.toNode active))
                $ blur active
    let
      onSelected x = do
        setInput (Right x)
        blurCurrentItem
        props.onSelected x
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
      inputBox = H.div_ plumageInputContainerStyle
        [ inputElement
        , popOver
            { hide: blurCurrentItem
            , placementRef: inputRef
            , childʔ:
                if not focusIsWithin then Nothing
                else Just $ R.div'
                  </
                    { onFocus: focusWithinProps.onFocus
                    , onBlur: focusWithinProps.onBlur
                    }
                  /> [ resultsContainer ]
            }
        ]

      inputElement = case input of
        Right x → R.div'
          </*
            { css: plumageInputContainerStyle
            }
          />
            [ H.div_ flexRow
                [ H.div_
                    ( border 1 <> borderCol TW.gray._400
                        <> background TW.gray._800
                        <> textCol TW.gray._100
                        <> fontMedium
                        <> pX 4
                        <> pY 2
                        <> roundedDefault
                        <> flexRow
                        <> justifyBetween
                        <> gap 4
                        <> textSm
                    )
                    [ R.text (suggestionToText x)
                    , R.button'
                        </
                          { onClick: handler preventDefault
                              ( const do
                                  setInput (Left "")
                                  props.onRemoved
                              )
                          }
                        /> [ R.text "×" ]
                    ]
                ]
            ]
        Left value →
          R.input'
            </*>
              { css: plumageInputStyle
              , id
              , ref: inputRef
              , placeholder
              , className: "plm-input"
              , value
              , onChange: handler targetValue (traverse_ (setInput <<< Left))
              , onKeyUp:
                  handler
                    SE.key
                    \e → e >>= parseKey # traverse_ handleKeyDown

              , onFocus: focusProps.onFocus
              , onBlur: focusProps.onBlur
              }

      wrapSuggestion i suggestion =
        M.li
          </*
            { css: resultContainerStyle
            , tabIndex: -1
            , onHoverStart:
                M.onHoverStart \_ _ → do
                  updateActiveIndex (const (Just i))
            , onHoverEnd:
                M.onHoverEnd \_ _ → do
                  updateActiveIndex (const Nothing)
            , onKeyDown: handler preventDefault mempty
            -- ^ disables scrolling with arrow keys
            , onKeyUp:
                handler
                  SE.key
                  (\e → e >>= parseKey # traverse_ handleKeyDown)
            , onClick: handler_ (onSelected suggestion)
            }
          /> [ renderSuggestion suggestion ]

      resultsContainer =
        R.div'
          </* { css: resultsContainerStyle }
          />
            [ R.ul' </* { css: overflowYScroll, ref: listRef } /> suggestionElements
            , H.div_ (pX 8)
                [ loadingBar
                    { numberOfLights: 10
                    , remoteData: suggestions
                    }
                ]
            ]

      suggestionElements =
        mapWithIndex wrapSuggestion
          case suggestions of
            RemoteData.NotAsked → prevSuggs
            RemoteData.Loading → prevSuggs
            RemoteData.Failure _ → prevSuggs
            RemoteData.Success suggs → suggs
    pure inputBox

  focusActiveElement listRef activeIndex =
    useEffect activeIndex do
      maybeNode ← React.readRefMaybe listRef
      case maybeNode, activeIndex of
        Just node, Just i → do
          nodeArray ← node # (childNodes >=> NodeList.toArray)
          for_ (nodeArray !! i) \n → do
            for_ (HTMLElement.fromNode n) focus
        _, _ → mempty
      mempty

  resultsContainerStyle =
    textCol TW.gray._700
      <> background' (var ("--plm-popupBackground-colour"))
      <> pT 4
      <> minHeight 60
      <> maxHeight' (33.3 # vh)
      <> pB 6
      <> pX 0
      <> flexCol
      <> justifyEnd
      <> gap 3
      <> roundedLg
      <> border 1
      <> borderTop 0
      <> textXs
      <> shadowLg
      <> borderCol TW.gray._200

  resultContainerStyle =
    pX 8
      <> pY 2
      <> cursorPointer
      <> P.focus
        ( background' (var "--plm-inputSelectOption-colour")
            <> textCol' (var "--plm-inputSelectOptionText-colour")
            <> E.css { outline: E.none }
        )

parseKey ∷ String → Maybe KeyCode
parseKey = case _ of
  "ArrowUp" → Just Key.Up
  "ArrowDown" → Just Key.Down
  "Backspace" → Just Key.Backspace
  "Enter" → Just Key.Return
  _ → Nothing

mkHandleKeyDown
  ∷ ∀ a
  . { activeIndex ∷ Maybe Int
    , focusInput ∷ Effect Unit
    , suggestions ∷ (Array a)
    , updateActiveIndex ∷ (Maybe Int → Maybe Int) → Effect Unit
    , onSelected ∷ a → Effect Unit
    , onDismiss ∷ Effect Unit
    }
  → KeyCode
  → Effect Unit
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
