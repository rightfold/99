module Test.Main
( main
) where

import Control.Monad.Eff (Eff)
import NN.Prelude

main :: forall eff. Eff eff Unit
main = pure unit
