module Plumage.Icon.Heroicons where

import React.Basic (JSX)
import React.Basic.DOM.SVG as SVG

menu ∷ JSX
menu =
  SVG.svg
    { viewBox: "0 0 24 24"
    , xmlns: "http://www.w3.org/2000/svg"
    , xmlSpace: "preserve"
    , stroke: "currentColor"
    , children:
        [ SVG.path
            { strokeLinecap: "round"
            , strokeLinejoin: "round"
            , strokeWidth: "2"
            , d: "M4 6h16M4 12h16M4 18h16"
            }
        ]
    }

cross ∷ JSX
cross =
  SVG.svg
    { viewBox: "0 0 24 24"
    , xmlns: "http://www.w3.org/2000/svg"
    , xmlSpace: "preserve"
    , stroke: "currentColor"
    , children:
        [ SVG.path
            { strokeLinecap: "round"
            , strokeLinejoin: "round"
            , strokeWidth: "2"
            , d: "M6 18L18 6M6 6l12 12"
            }
        ]
    }

externalLink ∷ JSX
externalLink =
  SVG.svg
    { viewBox: "0 0 24 24"
    , xmlns: "http://www.w3.org/2000/svg"
    , xmlSpace: "preserve"
    , fill: "none"
    , stroke: "currentColor"
    , children:
        [ SVG.path
            { strokeLinecap: "round"
            , strokeLinejoin: "round"
            , strokeWidth: "2"
            , d: "M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"
            }
        ]
    }
