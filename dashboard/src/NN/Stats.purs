module NN.Stats
( Stats
) where

type Stats =
  { eventsPerSecond :: Number
  , infoRate     :: Int
  , noticeRate   :: Int
  , warningRate  :: Int
  , errorRate    :: Int
  , criticalRate :: Int
  , alertRate    :: Int
  }
