module Main
( main
) where

import Halogen (interpret, runUI)
import Halogen.Util (awaitBody, runHalogenAff)
import NN (runNN)
import NN.Prelude
import NN.Workspace.UI as Workspace.UI


main = runHalogenAff do
  body <- awaitBody
  runUI (interpret (unsafeCoerce $ runIO ∘ runNN) Workspace.UI.ui)
        Workspace.UI.initialState
        body
