module Plumage.Atom.DatePicker.View where

import Plumage.Prelude.Style
import Data.Date (Date, Day, Month(..), Weekday(..), Year)
import Data.Date as Date
import Data.Enum (enumFromTo, fromEnum)
import Data.Enum as Enum
import Data.String as String
import Data.Time.Duration (Days(..), negateDuration)
import Data.Tuple.Nested (type (/\), (/\))
import Framer.Motion as M
import Literals.Undefined (undefined)
import Plumage.Icon.Heroicons as Heroicons
import Plumage.Style (mXY, pB, pR', pT, pX, pXY)
import Plumage.Style.Border (border, borderCol, borderLeft, borderNone, borderSolid, boxSizingBorderBox, roundedFull, roundedLg, roundedMd, roundedXl)
import Plumage.Style.BoxShadow (shadowMd, shadowSm)
import Plumage.Style.Color.Background (background)
import Plumage.Style.Color.Tailwind as TW
import Plumage.Style.Color.Text (textCenter, textCol)
import Plumage.Style.Color.Util (withAlpha)
import Plumage.Style.Cursor (cursorPointer)
import Plumage.Style.Display.Flex (flexCol, flexRow, itemsCenter, justifyBetween, justifyCenter, justifyEnd)
import Plumage.Style.Display.Grid (displayGrid, templateCols, templateRows)
import Plumage.Style.Inset (bottom', right')
import Plumage.Style.Overflow (overflowXHidden)
import Plumage.Style.Position (positionAbsolute, positionRelative)
import Plumage.Style.PseudoElements (afterElement)
import Plumage.Style.Size (height, height', heightFull, width, widthAndHeight, widthFull)
import Plumage.Style.Text (fontMedium, textDefault, textSm, textXs)
import Plumage.Style.Transform (translate)
import Plumage.Style.Transition (transition)
import Plumage.Util.HTML as H
import Prelude as Bounded
import React.Basic (JSX)
import React.Basic.DOM as R
import React.Basic.Emotion (Style)
import React.Basic.Emotion as E
import React.Basic.Events (handler_)
import React.Basic.Hooks as React
import Record (disjointUnion)

type Props = { state ∷ State, dispatch ∷ Action → Effect Unit }

data Action
  = DateSelected Date
  | ShowPreviousMonth
  | ShowNextMonth
  | Open { currentDate :: Date, selectedDateʔ :: Maybe Date }
  | StartTransition TransitionDirection
  | Dismiss

data TransitionDirection = Opening | ToNextMonth | ToPreviousMonth | Closing

derive instance Eq TransitionDirection

type State = Maybe
  { selectedDateʔ ∷ Maybe Date
  , currentDate :: Date
  , showingMonth ∷ (Month /\ Year)
  , transitioningʔ :: Maybe TransitionDirection
  }

defaultState ∷ State
defaultState = Nothing

reduce ∷ State → Action → State
reduce = case _, _ of
  Just s, DateSelected d -> Just (s { selectedDateʔ = Just d })
  Just s, ShowNextMonth -> Just (s { showingMonth = nextMonth s.showingMonth, transitioningʔ = Nothing })
  Just s, ShowPreviousMonth -> Just (s { showingMonth = previousMonth s.showingMonth, transitioningʔ = Nothing })

  -- User clicking very fast. Without this they have to wait for the transition
  -- to finish on every click
  Just s@{ transitioningʔ: Just running }, StartTransition transition
    | running == transition -> case running of
        ToNextMonth -> Just s { showingMonth = nextMonth s.showingMonth }
        ToPreviousMonth -> Just s { showingMonth = previousMonth s.showingMonth }
        _ -> Just s
  Just s, StartTransition transition -> Just (s { transitioningʔ = Just transition })
  Just _, Dismiss -> Nothing
  Nothing, Open { currentDate, selectedDateʔ } -> do
    let date = fromMaybe currentDate selectedDateʔ
    Just
      { selectedDateʔ
      , currentDate
      , showingMonth: (Date.month date /\ Date.year date)
      , transitioningʔ: Nothing
      }
  s, _ → s

mkDatePickerView ∷ React.Component Props
mkDatePickerView = do
  React.component "DatePickerView" \props → React.do
    let { state, dispatch } = props
    pure case state of
      Just s → renderDate ({ dispatch } `disjointUnion` s)
      Nothing -> R.text "nope"

renderDate
  ∷ { dispatch :: Action -> Effect Unit
    , currentDate :: Date
    , selectedDateʔ :: Maybe Date
    , showingMonth :: Month /\ Year
    , transitioningʔ :: Maybe TransitionDirection
    }
  → JSX
renderDate { dispatch, currentDate, selectedDateʔ, transitioningʔ, showingMonth: showingMonth /\ showingYear } = do
  let date = Date.canonicalDate showingYear showingMonth Bounded.bottom
  let nextMonth /\ nextYear = nextMonth (showingMonth /\ showingYear)
  let nextDate = Date.canonicalDate nextYear nextMonth Bounded.bottom
  let previousMonth /\ previousYear = previousMonth (showingMonth /\ showingYear)
  let previousDate = Date.canonicalDate previousYear previousMonth Bounded.bottom
  H.div_ dateContainerStyle
    [ H.div_ titleAndControlsStyle
        [ E.element R.button'
            { className: "plm-cal-btn"
            , css: monthChangeButtonStyle
            , onClick: handler_ (dispatch (StartTransition ToPreviousMonth))
            , children: [ Heroicons.chevronLeft ]
            }
        , E.element R.button'
            { className: "monthAndYear"
            , css: monthAndYearStyle
            , children:
                [ R.div_
                    [ R.text $ monthName showingMonth <>
                        if showingYear == Date.year currentDate then ""
                        else " " <> yearString showingYear
                    ]
                , H.div_
                    ( width 20
                        <> height' (E.str "calc(100% - 6px)")
                        <> flexRow
                        <> itemsCenter
                        <> justifyEnd
                        <> border 0
                        <> borderLeft 1
                        <> borderSolid
                        <> borderCol TW.gray._200
                    )
                    [ H.div_ (widthAndHeight 16)
                        [ Heroicons.chevronDown ]
                    ]
                ]
            }
        , E.element R.button'
            { className: "plm-cal-btn"
            , css: monthChangeButtonStyle
            , onClick: handler_ (dispatch (StartTransition ToNextMonth))
            , children: [ Heroicons.chevronRight ]
            }
        ]
    , E.element R.div'
        { className: "days-container"
        , css: daysContainerStyle
        , children:
            [ H.div_ daysHeadingsStyle
                ( enumFromTo Monday Sunday <#> (weekdayName >>> String.take 3 >>> \n -> R.div_ [ R.text n ])
                )
            , E.element M.div
                { className: "the-days"
                , key: monthName showingMonth
                , css: flexRow <> width (7 * size) <> height 260
                , initial: M.initial $ R.css { x: "-100%" }
                , animate: M.animate case transitioningʔ of
                    Just ToNextMonth -> R.css { x: "-200%", transition: { duration: 0.2 } }
                    Just ToPreviousMonth -> R.css { x: "0%", transition: { duration: 0.2 } }
                    _ -> R.css { x: "-100%" }
                , onAnimationComplete: M.onAnimationComplete case transitioningʔ of
                    Just ToNextMonth → const $ dispatch ShowNextMonth
                    Just ToPreviousMonth → const $ dispatch ShowPreviousMonth
                    _ → mempty
                , children:
                    [ H.div "days" daysStyle
                        $ renderMonthNumbers
                            { date: previousDate
                            , selectedDateʔ: Nothing
                            , currentDateʔ: Nothing
                            , showingMonth: previousMonth
                            , dispatch: mempty
                            }
                    , H.div "days" daysStyle
                        $ renderMonthNumbers
                            { date
                            , selectedDateʔ
                            , currentDateʔ: Just currentDate
                            , showingMonth
                            , dispatch
                            }
                    , H.div "days" daysStyle
                        $ renderMonthNumbers
                            { date: nextDate
                            , selectedDateʔ: Nothing
                            , currentDateʔ: Nothing
                            , showingMonth: nextMonth
                            , dispatch: mempty
                            }
                    ]
                }
            ]
        }
    ]

renderMonthNumbers { date, selectedDateʔ, currentDateʔ, showingMonth, dispatch } = do
  let firstDay = firstMondayBefore $ setDay Bounded.bottom date
  let lastDay = Date.adjust (41.0 # Days) firstDay # fromMaybe Bounded.top
  ( ( enumFromTo firstDay lastDay
    -- ( firstSundayAfter
    --     $ setDay (lastDayOfMonth (Date.year date) (Date.month date)) date
    -- )
    )
      <#> \(d :: Date) ->
        E.element R.button'
          { className: "day"
          , css: dayStyle <>
              if Date.month d /= showingMonth then
                otherMonthDayStyle
              else mempty
          , children:
              [ E.element M.div
                  { css:
                      dayRoundStyle
                        <>
                          ( if selectedDateʔ == Just d then
                              selectedDayStyle
                            else mempty
                          )
                        <>
                          ( if Just d == currentDateʔ then currentDayStyle
                            else mempty
                          )
                        <> if (fromEnum $ Date.day d) == 1 then oneDayStyle else mempty
                  , initial:
                      if selectedDateʔ == Just d then
                        M.initial $ R.css { scale: 1.2 }
                      else M.initial $ undefined
                  , animate:
                      M.animate $ R.css
                        { scale: 1
                        , transition:
                            { type: "spring"
                            , delay: 0.1
                            , stiffness: 100
                            , mass: 0.5
                            , damping: 5
                            }
                        }
                  , className: "cn"
                  , children: [ R.text $ show $ fromEnum $ Date.day d ]
                  }
              ]
          , onClick: handler_
              if Date.month d < showingMonth then do
                dispatch (StartTransition ToPreviousMonth)
                dispatch (DateSelected d)
              else if Date.month d > showingMonth then do
                dispatch (StartTransition ToNextMonth)
                dispatch (DateSelected d)
              else do
                dispatch $ DateSelected d
          }
  )

nextMonth (currentMonth /\ currentYear) = do
  let monthSuccʔ = Enum.succ currentMonth
  case monthSuccʔ of
    Nothing -> Bounded.bottom /\ (Enum.succ currentYear # fromMaybe Bounded.top)
    Just monthSucc -> monthSucc /\ currentYear

previousMonth (currentMonth /\ currentYear) = do
  let monthPredʔ = Enum.pred currentMonth
  case monthPredʔ of
    Nothing -> Bounded.top /\ (Enum.pred currentYear # fromMaybe Bounded.bottom)
    Just monthPred -> monthPred /\ currentYear

setDay ∷ Day → Date → Date
setDay day date = Date.canonicalDate (Date.year date) (Date.month date) day

firstMondayBefore :: Date -> Date
firstMondayBefore date = go date
  where
  go d =
    if Date.weekday d == Monday then d
    else do
      Date.adjust (negateDuration (Days 1.0)) d # maybe d go

firstSundayAfter :: Date -> Date
firstSundayAfter date = go date
  where
  go d =
    if Date.weekday d == Sunday then d
    else Date.adjust (Days 1.0) d # maybe d go

commonDaysStyle :: Style
commonDaysStyle = displayGrid <> templateCols "repeat(7, 1fr)" <> textCenter

daysHeadingsStyle ∷ Style
daysHeadingsStyle = commonDaysStyle
  <> textCol TW.gray._500
  <> fontMedium
  <> textXs
  <> pT 10
  <> pB 8

daysStyle ∷ Style
daysStyle = commonDaysStyle <> templateRows ("repeat(7," <> show size <> "px)")

size ∷ Int
size = 42

padding ∷ Int
padding = 2

dayStyle ∷ Style
dayStyle = width size <> height size <> borderNone <> E.css { background: E.none } <> mXY 0
  <> pXY padding
  <> textCol (TW.gray._500 # darken 0.07)
  <> fontMedium
  <> textSm

dayRoundStyle ∷ Style
dayRoundStyle = roundedXl <> widthFull <> heightFull <> boxSizingBorderBox
  <> pT 6
  <> transition "all 160ms ease-out"
  <> hover
    ( background TW.coolGray._300
        <> borderCol TW.coolGray._300
        <> cursorPointer
        <> textCol TW.black
    )
  <> border 3
  <> borderCol TW.gray._50
  <> borderSolid

selectedDayStyle ∷ Style
selectedDayStyle = s <> hover s
  where
  s = background TW.violet._100
    <> borderCol TW.violet._500
    <> textCol TW.violet._800

oneDayStyle ∷ Style
oneDayStyle = pR' (E.str "1px")

currentDayStyle ∷ Style
currentDayStyle = positionRelative <> E.css { fontVariantNumeric: E.str "tabular-nums" }
  <> afterElement
    ( positionAbsolute <> bottom' (6 # E.px) <> right' (50.0 # E.percent)
        <> width 18
        <> height 3
        <> background (TW.gray._500 # withAlpha 0.5)
        <> translate "50%" "50%"
        <> roundedFull
    )

otherMonthDayStyle ∷ Style
otherMonthDayStyle = textCol TW.gray._400

dateContainerStyle ∷ Style
dateContainerStyle = roundedLg <> shadowMd <> flexCol <> justifyCenter <> itemsCenter
  <> pX 12
  <> pT 16
  <> pB 12
  <> background (TW.gray._50)
  <> textSm
  <> overflowXHidden
  <> border 1
  <> borderSolid
  <> borderCol TW.gray._200
  <> E.css { width: E.str "fit-content" }

titleAndControlsStyle ∷ Style
titleAndControlsStyle = flexRow
  <> justifyBetween
  <> itemsCenter
  <> widthFull

monthChangeButtonStyle ∷ Style
monthChangeButtonStyle =
  border 1
    <> roundedMd
    <> borderSolid
    <> textCol TW.gray._600
    <> background TW.white
    <> borderCol TW.gray._200
    <> widthAndHeight 30
    <> shadowSm
    <> pXY 6
    <> boxSizingBorderBox
    <> mXY 0
    <> hover (background TW.gray._100)

monthAndYearStyle ∷ Style
monthAndYearStyle =
  textDefault <> fontMedium <> textCol TW.gray._600
    <> background TW.white
    <> border 1
    <> borderSolid
    <> roundedMd
    <> borderCol TW.gray._200
    <> pXY 0
    <> width 180
    <> height 30
    <> itemsCenter
    <> mXY 0
    <> pX 5
    <> flexRow
    <> textSm
    <> justifyBetween
    <> shadowSm

daysContainerStyle ∷ Style
daysContainerStyle = pT 8

yearString ∷ Year → String
yearString = fromEnum >>> show

monthName ∷ Month → String
monthName = case _ of
  January -> "January"
  February -> "February"
  March -> "March"
  April -> "April"
  May -> "May"
  June -> "June"
  July -> "July"
  August -> "August"
  September -> "September"
  October -> "October"
  November -> "November"
  December -> "December"

weekdayName ∷ Weekday → String
weekdayName = case _ of
  Monday -> "Monday"
  Tuesday -> "Tuesday"
  Wednesday -> "Wednesday"
  Thursday -> "Thursday"
  Friday -> "Friday"
  Saturday -> "Saturday"
  Sunday -> "Sunday"