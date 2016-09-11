module NN
( NN
, NNF(..)
, io
, fetchStats

, runNN
) where

import Control.Monad.Aff.Free (class Affable)
import Data.Argonaut.Core (Json)
import Network.HTTP.Affjax as Affjax
import NN.Prelude
import NN.Stats (Stats)


type NN = Free NNF

data NNF a
  = IO (IO a)
  | FetchStats (Stats -> a)

io :: forall a. IO a -> NN a
io action = liftF $ IO action

fetchStats :: NN Stats
fetchStats = liftF $ FetchStats id

instance affableNNF :: Affable eff NNF where
  fromAff = IO ∘ liftAff


runNN :: NN ~> IO
runNN = foldFree go
  where go :: NNF ~> IO
        go (IO action) = action
        go (FetchStats next) = do
          res <- liftAff $ Affjax.get "/stats"
          -- FIXME
          pure (next ((unsafeCoerce :: Json -> Stats) res.response))
