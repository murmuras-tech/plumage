module Plumage.Icon.Heroicons where

import Prelude
import React.Basic (JSX)
import React.Basic.DOM.SVG as SVG

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

menu = outline "M4 6h16M4 12h16M4 18h16" ∷ JSX
cross = outline "M6 18L18 6M6 6l12 12" ∷ JSX
externalLink = outline "M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" ∷ JSX
shoppingCart = outline "M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z" ∷ JSX
shoppingBag = outline "M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z" ∷ JSX
chartBar = outline "M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" ∷ JSX
chartPie = outlines [ "M11 3.055A9.001 9.001 0 1020.945 13H11V3.055z", "M20.488 9H15V3.512A9.025 9.025 0 0120.488 9z" ] ∷ JSX
chartSquareBar = outline "M16 8v8m-4-5v5m-4-2v2m-2 4h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" ∷ JSX
cash = outline "M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z" ∷ JSX
ban = outline "M18.364 18.364A9 9 0 005.636 5.636m12.728 12.728A9 9 0 015.636 5.636m12.728 12.728L5.636 5.636" ∷ JSX
speakerphone = outline "M11 5.882V19.24a1.76 1.76 0 01-3.417.592l-2.147-6.15M18 13a3 3 0 100-6M5.436 13.683A4.001 4.001 0 017 6h1.832c4.1 0 7.625-1.234 9.168-3v14c-1.543-1.766-5.067-3-9.168-3H7a3.988 3.988 0 01-1.564-.317z" ∷ JSX
deviceMobile = outline "M12 18h.01M8 21h8a2 2 0 002-2V5a2 2 0 00-2-2H8a2 2 0 00-2 2v14a2 2 0 002 2z" ∷ JSX
database = outline "M4 7v10c0 2.21 3.582 4 8 4s8-1.79 8-4V7M4 7c0 2.21 3.582 4 8 4s8-1.79 8-4M4 7c0-2.21 3.582-4 8-4s8 1.79 8 4m0 5c0 2.21-3.582 4-8 4s-8-1.79-8-4" ∷ JSX
heart = outline "M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" ∷ JSX