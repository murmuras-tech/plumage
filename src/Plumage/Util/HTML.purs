module Plumage.Util.HTML where

import React.Basic (JSX)
import React.Basic.DOM as R
import React.Basic.Emotion as E

div ∷ String → E.Style → Array JSX → JSX
div className css children = E.element R.div' { className, css, children }

div_ ∷ E.Style → Array JSX → JSX
div_ css children = E.element R.div' { className: "", css, children }

span ∷ String → E.Style → Array JSX → JSX
span className css children = E.element R.span' { className, css, children }

span_ ∷ E.Style → Array JSX → JSX
span_ css children = E.element R.span' { className: "", css, children }
