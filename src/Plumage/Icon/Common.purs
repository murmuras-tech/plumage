module Plumage.Icon.Common where

import Prelude
import React.Basic (JSX)
import React.Basic.DOM.SVG as SVG

outlines ∷ Array String → JSX
outlines ds =
  SVG.svg
    { viewBox: "0 0 24 24"
    , xmlns: "http://www.w3.org/2000/svg"
    , xmlSpace: "preserve"
    , stroke: "currentColor"
    , children:
        ds
          <#> \d →
              SVG.path
                { strokeLinecap: "round"
                , strokeLinejoin: "round"
                , strokeWidth: "2"
                , d
                }
    }

outline ∷ String → JSX
outline d = outlines [ d ]
