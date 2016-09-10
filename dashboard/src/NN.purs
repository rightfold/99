module NN
( NNEffects
, NN
, NNF(..)
, fetchStats

, runNN
) where

import Data.Argonaut.Core (Json)
import Network.HTTP.Affjax (AJAX)
import Network.HTTP.Affjax as Affjax
import NN.Prelude
import NN.Stats (Stats)


type NNEffects eff = (ajax :: AJAX | eff)

type NN = Free NNF

data NNF a
  = FetchStats (Stats -> a)

fetchStats :: NN Stats
fetchStats = liftF $ FetchStats id


runNN :: forall eff. NN ~> Aff (NNEffects eff)
runNN = foldFree go
  where go :: NNF ~> Aff (NNEffects eff)
        go (FetchStats next) = do
          res <- Affjax.get "/stats"
          -- FIXME
          pure (next ((unsafeCoerce :: Json -> Stats) res.response))
