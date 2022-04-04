module Plumage.Atom.DatePicker where

import Prelude

import Data.Date (Date)
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Now (nowDate)
import Plumage.Atom.DatePicker.View (mkDatePickerView)
import Plumage.Atom.DatePicker.View as DateView
import React.Basic.Hooks (mkReducer, useEffect)
import React.Basic.Hooks as React

type Props =
  { dateʔ :: Maybe Date
  , show :: Boolean
  , onChange :: Maybe Date -> Effect Unit
  }

data Action = DateViewAction DateView.Action

type State =
  { datePickerState ∷ DateView.State
  }

defaultState ∷ State
defaultState = { datePickerState: DateView.defaultState }

reduce ∷ State → Action → State
reduce = case _, _ of
  s, DateViewAction a → s { datePickerState = DateView.reduce (s.datePickerState) a }

mkDatePicker ∷ React.Component Props
mkDatePicker = do
  dateView <- mkDatePickerView
  reducer <- mkReducer reduce
  React.component "DatePicker" \props → React.do
    state /\ dispatch <- React.useReducer defaultState reducer
    useEffect props.show do
      if props.show then do
        currentDate <- nowDate
        dispatch (DateViewAction $ DateView.Open { selectedDateʔ: props.dateʔ, currentDate })
      else
        dispatch (DateViewAction DateView.Dismiss)
      mempty

    useEffect props.dateʔ do
      case props.dateʔ of
        Nothing -> mempty
        Just date -> dispatch $ DateViewAction $ DateView.DateSelected date
      mempty
    useEffect (state.datePickerState <#> _.selectedDateʔ) do
      case state.datePickerState of
        Nothing -> mempty
        Just { selectedDateʔ } -> unless (selectedDateʔ == props.dateʔ) do
          props.onChange selectedDateʔ
      mempty
    pure
      ( dateView
          { state: state.datePickerState
          , dispatch: dispatch <<< DateViewAction
          }
      )