module React.Aria.Utils where

import Prelude
import Data.Nullable (Nullable)
import Effect.Uncurried (EffectFn1, EffectFn2, runEffectFn2)
import Foreign (Foreign, unsafeFromForeign, unsafeToForeign)
import Prim.Row (class Lacks, class Union)
import React.Basic.DOM (Props_button)
import React.Basic.Events (EventHandler)
import React.Basic.Hooks (Hook, ReactComponent, Ref, unsafeHook)
import Untagged.Union (OneOf)
import Web.DOM (Node)
import Web.HTML (HTMLElement)

foreign import mergePropsImpl ∷ Array Foreign -> Foreign

mergeProps ∷ ∀ r1 r2 r3. Union r1 r2 r3 => { | r1 } -> { | r2 } -> { | r3 }
mergeProps r1 r2 = unsafeFromForeign (mergePropsImpl [ unsafeToForeign r1, unsafeToForeign r2 ])
