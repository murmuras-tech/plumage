module Story.DatePicker (default, datePicker) where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Plumage.Atom.DatePicker as P
import Plumage.Style (pXY)
import Plumage.Util.HTML as H
import React.Basic (JSX)
import React.Basic.Hooks as React

default ∷ { title ∷ String }
default = { title: "Atom/Date Picker" }

datePicker ∷ Effect JSX
datePicker = do
  sc <- mkStoryComponent
  pure
    $ H.div_ (pXY 30)
        [ sc unit
        ]

  where
  mkStoryComponent = do
    datePickerView ← P.mkDatePicker
    React.component "DatePickerStory" \_ -> React.do
      dateʔ /\ setDate <- React.useState' Nothing
      show /\ setShow <- React.useState' true
      pure $ datePickerView
        { dateʔ
        , show
        , onChange: setDate >=> (const (setShow false))
        }
