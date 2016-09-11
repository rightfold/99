module NN.StatusBar.UI
( State
, Query
, initialState
, ui
) where

import Halogen (action, Component, ComponentDSL, ComponentHTML, lifecycleComponent, liftH, set)
import Halogen.HTML.Indexed as H
import Halogen.HTML.Properties.Indexed as P
import NN (NN, fetchStats)
import NN.Prelude
import NN.Stats (Stats)


type State = Stats

data Query a =
  Initialize a

initialState :: State
initialState =
  { eventsPerSecond: 0.0
  , debugRate:    0
  , infoRate:     0
  , noticeRate:   0
  , warningRate:  0
  , errorRate:    0
  , criticalRate: 0
  , alertRate:    0
  }

ui :: Component State Query NN
ui = lifecycleComponent {render, eval, initializer: Just (action Initialize), finalizer: Nothing}
  where
  render :: State -> ComponentHTML Query
  render s =
    H.div [P.class_ (H.className "nn--status-bar")]
      [ H.span [P.class_ (H.className "-events-per-second")] [H.text (show s.eventsPerSecond <> " e/s")]
      , H.span [P.class_ (H.className "-info-rate")]     [H.text (show s.infoRate)]
      , H.span [P.class_ (H.className "-notice-rate")]   [H.text (show s.noticeRate)]
      , H.span [P.class_ (H.className "-warning-rate")]  [H.text (show s.warningRate)]
      , H.span [P.class_ (H.className "-error-rate")]    [H.text (show s.errorRate)]
      , H.span [P.class_ (H.className "-critical-rate")] [H.text (show s.criticalRate)]
      , H.span [P.class_ (H.className "-alert-rate")]    [H.text (show s.alertRate)]
      , H.span [P.class_ (H.className "-overall-emergency")] [H.text "EMERGENCY"]
      ]

  eval :: Query ~> ComponentDSL State Query NN
  eval (Initialize next) = do
    stats <- liftH fetchStats
    pure next
