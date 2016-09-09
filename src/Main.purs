module Main
( main
) where

import Halogen (HalogenEffects, interpret, runUI)
import Halogen.Util (awaitBody, runHalogenAff)
import NN (NN, createLog, runNN)
import NN.Prelude

import Halogen (Component, component, ComponentDSL, liftH)
import Halogen.HTML.Indexed as H
import Halogen.HTML.Events.Indexed as E


main :: forall eff. Eff (HalogenEffects eff) Unit
main = runHalogenAff do
  body <- awaitBody
  runUI (interpret runNN ui) unit body


data Query a
  = CreateLog a

ui :: Component Unit Query NN
ui = component {render, eval}
  where render _ =
          H.button [E.onClick (E.input_ CreateLog)] []
        eval :: Query ~> ComponentDSL Unit Query NN
        eval (CreateLog next) = do
          liftH $ createLog "test"
          pure next
