module Plumage.Style.Global where

import Prelude
import Data.Array (intercalate)
import Prim.RowList (class RowToList)
import React.Basic.Emotion (Style, StyleProperty, auto, baseline, borderBox, css, em, inherit, nested, none, percent, px, relative, solid, str)
import Type.Row.Homogeneous (class HomogeneousRowList)

nest
  ∷ ∀ r rl
  . RowToList r rl
  ⇒ HomogeneousRowList rl StyleProperty
  ⇒ Record r
  → StyleProperty
nest = nested <<< css

globalStyles ∷ Style
globalStyles =
  css
    { ":root":
        nest
          { "*, ::before, ::after":
              nest
                { boxSizing: borderBox
                , borderWidth: str "0"
                , borderStyle: solid
                , borderColor: str "currentColor"
                }
          }
    , html:
        nest
          { tabSize: str "4"
          , "MozTabSize": str "4"
          , lineHeight: str "1.5"
          , "WebkitTextSizeAdjust": str "100%"
          , fontFamily:
              str
                $ intercalate ","
                    [ "system-ui"
                    , "-apple-system"
                    , "'Segoe UI'"
                    , "Roboto"
                    , "Helvetica"
                    , "Arial"
                    , "sans-serif"
                    , "'Apple Color Emoji'"
                    , "'Segoe UI Emoji'"
                    ]
          }
    , body:
        nest
          { margin: str "0"
          , lineHeight: inherit
          , fontFamily: inherit
          }
    , hr:
        nest
          { height: str "0"
          , color: inherit
          , borderTopWidth: px 1
          }
    , "abbr[title]":
        nest
          { textDecoration: str "underline dotted"
          , "WebkitTextDecoration": str "underline dotted"
          }
    , "b,strong": nest { fontWeight: str "bolder" }
    , "code, kbd, samp, pre":
        nest
          { fontSize: em one
          , fontFamily:
              str
                $ intercalate ","
                    [ "ui-monospace"
                    , "SFMono-Regular"
                    , "Consolas"
                    , "'Liberation Mono'"
                    , "Menlo"
                    , "monospace"
                    ]
          }
    , "small": nest { fontSize: percent 80.0 }
    , "sub,sup":
        nest
          { fontSize: percent 75.0
          , lineHeight: str "0"
          , position: relative
          , verticalAlign: baseline
          }
    , sub: nest { bottom: em (-0.25) }
    , sup: nest { bottom: em (-0.5) }
    , table:
        nest
          { textIndent: str "0"
          , borderColor: inherit
          , borderCollapse: str "collapse"
          }
    , "button,input,optgroup,select,textarea":
        nest
          { fontFamily: inherit
          , fontSize: percent 100.0
          , lineHeight: str "1.15"
          , margin: str "0"
          }
    , "button, select": nest { textTransform: none }
    , "button, [type='button'], [type='reset'], [type='submit']":
        nest { "WebkitAppearance": str "button" }
    , "::MozFocusInner": nest { borderStyle: none, padding: str "0" }
    , "::MozFocusring": nest { outline: str "1px dotted ButtonText" }
    , ":MozUIInvalid": nest { boxShadow: none }
    , legend: nest { padding: str "0" }
    , progress: nest { verticalAlign: baseline }
    , "::WebkitInnerSpinButton, ::WebkitOuterSpinButton": nest { height: auto }
    , "[type='search']":
        nest
          { "WebkitAppearance": str "textfield"
          , outlineOffset: px (-2)
          }
    , "::WebkitSearchDecoration": nest { "WebkitAppearance": none }
    , "::WebkitFileUploadButton":
        nest
          { "WebkitAppearance": str "button"
          , font: inherit
          }
    , summary: nest { display: str "list-item" }
    , "blockquote, dl, dd, h1, h2, h3, h4, h5, h6, hr, figure, p, pre":
        nest
          { margin: str "0"
          }
    , button:
        nest
          { backgroundColor: str "transparent"
          , backgroundImage: none
          }
    , fieldset:
        nest
          { margin: str "0"
          , padding: str "0"
          }
    , "ol, ul":
        nest
          { listStyle: none
          , margin: str "0"
          , padding: str "0"
          }
    , img: nest { borderStyle: solid }
    , textarea: nest { resize: str "vertical" }
    , "input::placeholder, textarea::placeholder":
        nest
          { opacity: str "1"
          , color: str "#9ca3af"
          }
    , "button, [role=\"button\"]":
        nest { cursor: str "pointer" }
    , "h1,h2,h3,h4,h5,h6": nest { fontSize: inherit, fontWeight: inherit }
    , a: nest { color: inherit, textDecoration: inherit }
    , "button, input, optgroup, selecct, textarea":
        nest
          { padding: str "0"
          , lineHeight: inherit
          , color: inherit
          }
    , "img, svg, video, canvas, audio, iframe, embed, object":
        nest { display: str "block", verticalAlign: str "middle" }
    , "img, video":
        nest
          { maxWidth: str "100%"
          , height: auto
          }
    }
