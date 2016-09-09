module NN
( NN
, NNF(..)
, createLog

, runNN
) where

import NN.Prelude


type NN = Free NNF

data NNF a
  = CreateLog String a

createLog :: String -> NN Unit
createLog name = liftF $ CreateLog name unit


runNN :: forall eff. NN ~> Aff eff
runNN = foldFree go
  where go :: NNF ~> Aff eff
        go (CreateLog name next) = do
          traceA name
          pure next
