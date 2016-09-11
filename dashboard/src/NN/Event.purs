module NN.Event
( Event
, Level(..)
) where

import Data.DateTime.Instant (Instant)
import Data.Map (Map)


type Event =
  { timestamp :: Instant
  , host      :: String
  , level     :: Level
  , fields    :: Map String String
  }

data Level
  = Debug
  | Info
  | Notice
  | Warning
  | Error
  | Critical
  | Alert
