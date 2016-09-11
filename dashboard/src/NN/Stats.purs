module NN.Stats
( Stats
) where

type Stats =
  { eventsPerSecond :: Number
  , debugRate    :: Int
  , infoRate     :: Int
  , noticeRate   :: Int
  , warningRate  :: Int
  , errorRate    :: Int
  , criticalRate :: Int
  , alertRate    :: Int
  }
