module NN.Search.UI
( State
, Query(..)
, initialState
, ui
) where

import Data.Array as Array
import Data.DateTime.Instant (instant, unInstant)
import Data.Map as Map
import Data.Time.Duration (Milliseconds(..))
import Halogen (Component, component, ComponentDSL, ComponentHTML, get, modify)
import Halogen.HTML.Indexed as H
import Halogen.HTML.Properties.Indexed as P
import NN (NN)
import NN.Event (Event, Level(..))
import NN.Filter (Filter(..), unFilter)
import NN.Prelude

type State =
  { filter :: Filter
  , events :: List Event
  }

data Query a
  = SetFilter Filter a
  | Search a

initialState :: State
initialState = {filter: Filter "", events: Nil}

ui :: Component State Query NN
ui = component {render, eval}
  where
  render :: State -> ComponentHTML Query
  render s =
    H.div [P.class_ (H.className "nn--search")]
      [ H.fieldset_ [ H.legend_ [H.text "Search"]
                    , H.textarea [P.value (unFilter s.filter)]
                    ]
      , H.table_ [H.tbody_ $ map renderEvent $ Array.fromFoldable s.events]
      ]

  renderEvent :: Event -> ComponentHTML Query
  renderEvent e =
    H.tr [P.class_ (H.className (levelClass e.level))]
      [ H.td [P.class_ (H.className "-timestamp")]
          [H.time_ [H.text (timestamp e.timestamp)]]
      , H.td [P.class_ (H.className "-host")]
          [H.text e.host]
      , H.td [P.class_ (H.className "-fields")]
          (map field $ Array.fromFoldable (Map.toList e.fields))
      ]
    where levelClass Debug    = "-debug"
          levelClass Info     = "-info"
          levelClass Notice   = "-notice"
          levelClass Warning  = "-warning"
          levelClass Error    = "-error"
          levelClass Critical = "-critical"
          levelClass Alert    = "-alert"

          timestamp ts = formatDateTime (unInstant ts)

          field (Tuple k v) =
            H.span_ [ H.span [P.class_ (H.className "-key")] [H.text k]
                    , H.span [P.class_ (H.className "-val")] [H.text v]
                    ]

  eval :: Query ~> ComponentDSL State Query NN
  eval (SetFilter filter next) = do
    modify (_ { filter = filter })
    pure next
  eval (Search next) = do
    traceA "Commencing search!"
    traceA ∘ ("query: " <> _) ∘ unFilter ∘ _.filter =<< get
    modify (_ {events = dummy})
    pure next

dummy :: List Event
dummy = {timestamp: fromMaybe bottom $ instant (Milliseconds 1000.0), host: "localhost", level: Debug, fields: Map.empty :: Map.Map String String}
      : {timestamp: fromMaybe bottom $ instant (Milliseconds 1000.0), host: "localhost", level: Info, fields: Map.singleton "msg" "boot"}
      : {timestamp: fromMaybe bottom $ instant (Milliseconds 1000.0), host: "localhost", level: Notice, fields: Map.singleton "msg" "boot"}
      : {timestamp: fromMaybe bottom $ instant (Milliseconds 1000.0), host: "localhost", level: Warning, fields: Map.singleton "msg" "boot"}
      : {timestamp: fromMaybe bottom $ instant (Milliseconds 1000.0), host: "localhost", level: Error, fields: Map.singleton "msg" "boot"}
      : {timestamp: fromMaybe bottom $ instant (Milliseconds 1000.0), host: "localhost", level: Critical, fields: Map.singleton "msg" "boot"}
      : {timestamp: fromMaybe bottom $ instant (Milliseconds 1000.0), host: "localhost", level: Alert, fields: Map.singleton "msg" "boot"}
      : {timestamp: fromMaybe bottom $ instant (Milliseconds 2000.0), host: "example.com", level: Warning, fields: Map.empty # Map.insert "msg" "high load" # Map.insert "load" "9.32"}
      : Nil

foreign import formatDateTime :: Milliseconds -> String
