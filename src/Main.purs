module Main where

import Prelude

import Effect (Effect)
import Hyper.Node.Server (defaultOptionsWithLogging, runServer)
import Hyper.Trout.Repro (siteRouter)

main :: Effect Unit
main = runServer defaultOptionsWithLogging {} siteRouter
