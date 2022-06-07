module Story.Typeahead (default, typeahead) where

import Prelude

import Data.Either (Either(..))
import Data.Time.Duration (Milliseconds(..))
import Effect (Effect)
import Effect.Aff (delay)
import Effect.Class (liftEffect)
import Effect.Class.Console as Console
import Effect.Random (randomRange)
import Fahrtwind (background, globalStyles, gray, height', widthFull)
import Plumage.Molecule.Typeahead (mkTypeahead)
import Plumage.Molecule.Typeahead as Typeahead
import Plumage.Util.HTML as H
import React.Basic (JSX, fragment)
import React.Basic.DOM as R
import React.Basic.Emotion as E
import Story.Container (inContainer)
import Yoga ((</>))

default ∷ { title ∷ String }
default = { title: "Molecule/Typeahead" }

typeahead ∷ Effect JSX
typeahead = do
  typeaheadView ∷ _ (Typeahead.Props String) ← mkTypeahead typeaheadArgs

  pure $ inContainer $ H.div_
    (height' (E.px 5000) <> widthFull <> background gray._400)
    [ typeaheadView </>
        { loadSuggestions: \s → do
            ms ← randomRange 200.0 2000.0 # liftEffect
            delay (ms # Milliseconds)
            pure $ Right
              if s == "" then
                [ "loads"
                , "and loads"
                , "loads"
                , "and loads"
                , "loads"
                , "and loads"
                , "loads"
                , "and loads"
                , "loads"
                , "and loads"
                , "loads"
                , "and loads"
                , "loads"
                , "and loads"
                , "loads"
                , "and loads"
                , "loads"
                , "and loads"
                , "loads"
                , "and loads"
                ]
              else
                [ s <> " Beer"
                , s <> " Sausage"
                , s <> " Meat"
                , "Wrong"
                ]
        , renderSuggestion: R.text
        , onSelected: Console.log
        , onDismiss: Console.log "dismissed"
        , onRemoved: const $ Console.log "removed"
        , placeholder: "Search"
        , beforeInput: R.text "hoho"
        }
    ]

typeaheadArgs = Typeahead.mkDefaultArgs
  { suggestionToText: identity
  , contextMenuLayerId: "cm"
  , clickAwayId: "clickaway"
  }