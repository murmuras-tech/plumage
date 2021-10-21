module Plumage.Icon.BrandIcon where

import React.Basic (JSX)
import React.Basic.DOM.SVG as SVG

facebook ∷ JSX
facebook =
  SVG.svg
    { viewBox: "0 0 24 24"
    , xmlns: "http://www.w3.org/2000/svg"
    , xmlSpace: "preserve"
    , stroke: "currentColor"
    , children:
        [ SVG.path { fill: "currentColor", stroke: "none", d: "M15.011 7.777h1.726V4.858c-.835-.087-1.675-.13-2.515-.128-2.497 0-4.205 1.524-4.205 4.314v2.406H7.199v3.268h2.818v8.372h3.379v-8.372h2.809l.422-3.268h-3.231V9.366c0-.964.257-1.589 1.615-1.589Z" }
        , SVG.path
            { strokeLinecap: "round"
            , strokeLinejoin: "round"
            , strokeWidth: "2"
            , d: "M22.984 5.017c0-2.195-1.782-3.976-3.976-3.976H4.966C2.772 1.041.99 2.822.99 5.017v14.097c0 2.194 1.782 3.976 3.976 3.976h14.042c2.194 0 3.976-1.782 3.976-3.976V5.017Z"
            }
        ]
    }
