module Test.Hyper.Trout.Repro where

import Prelude

import Data.Maybe (Maybe(..))
import Hyper.Middleware (evalMiddleware)
import Hyper.Status (statusOK)
import Hyper.Test.TestServer (TestRequest(..), TestResponse(..), defaultRequest, testServer, testStatus)
import Hyper.Trout.Repro (siteRouter)
import Test.Spec (Spec, describe, it, pending)
import Test.Spec.Assertions (shouldEqual)

spec :: Spec Unit
spec =
  describe "Hyper.Trout.Repro" do
    it "type checks" do
      conn <-
        { request: TestRequest defaultRequest
        , response: TestResponse Nothing [] []
        , components: {}
        }
        # evalMiddleware siteRouter
        # testServer
      testStatus conn `shouldEqual` Just statusOK

    pending "Fix the type error"
