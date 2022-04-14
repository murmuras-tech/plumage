module Story.Typeahead (default, typeahead) where

import Prelude

import Data.Either (Either(..))
import Data.Time.Duration (Milliseconds(..))
import Effect (Effect)
import Effect.Aff (delay)
import Effect.Class (liftEffect)
import Effect.Class.Console as Console
import Effect.Random (randomRange)
import Plumage (background, globalStyles, gray, height', widthFull)
import Plumage.Molecule.Typeahead (mkTypeahead)
import Plumage.Molecule.Typeahead as Typeahead
import Plumage.Util.HTML as H
import React.Basic (JSX, fragment)
import React.Basic.DOM as R
import React.Basic.Emotion as E
import Yoga ((</>))

default ∷ { title ∷ String }
default = { title: "Molecule/Typeahead" }

typeahead ∷ Effect JSX
typeahead = do
  typeaheadView ∷ _ (Typeahead.Props String) ← mkTypeahead typeaheadArgs

  pure $ fragment
    [ E.global </> { styles: globalStyles }
    , H.div_ (height' (E.px 5000) <> widthFull <> background gray._400)
        [ typeaheadView </>
            { onSelected: Console.log
            , onDismiss: Console.log "dismissed"
            , onRemoved: Console.log "removed"
            , placeholder: "Search"
            }
        ]
    , R.div
        { id: "clickaway"
        , style: R.css
            { position: "fixed"
            , top: "0"
            , left: "0"
            , width: "100%"
            , height: "100%"
            , backgroundColor: "rgba(0, 0, 0, 0.00)"
            , pointerEvents: "none"
            }
        }
    , R.div
        { id: "cm"
        , style: R.css
            { position: "absolute"
            , top: "0"
            , left: "0"
            , width: "100%"
            , height: "100%"
            , backgroundColor: "rgba(0, 0, 0, 0.00)"
            , pointerEvents: "none"
            }
        }
    ]

typeaheadArgs = Typeahead.mkDefaultArgs
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
  , suggestionToText: identity
  , contextMenuLayerId: "cm"
  , clickAwayId: "clickaway"
  }