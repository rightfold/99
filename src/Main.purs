module Main
( main
) where

import Halogen (HalogenEffects, interpret, runUI)
import Halogen.Util (awaitBody, runHalogenAff)
import NN (runNN)
import NN.Prelude
import NN.Workspace.UI as Workspace.UI


main :: forall eff. Eff (HalogenEffects eff) Unit
main = runHalogenAff do
  body <- awaitBody
  runUI (interpret runNN Workspace.UI.ui) Workspace.UI.initialState body
