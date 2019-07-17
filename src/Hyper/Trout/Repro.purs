module Hyper.Trout.Repro where

import Prelude

import Control.Bind.Indexed ((:*>))
import Data.Argonaut (class EncodeJson, jsonEmptyObject, (:=), (~>))
import Data.Maybe (maybe)
import Data.MediaType.Common (applicationJSON)
import Hyper.Conn (Conn)
import Hyper.Middleware (Middleware)
import Hyper.Request (class Request)
import Hyper.Response (class Response, class ResponseWritable, ResponseEnded, StatusLineOpen, closeHeaders, contentType, respond, writeStatus)
import Hyper.Trout.Router (router)
import Type.Proxy (Proxy(..))
import Type.Trout (Resource)
import Type.Trout.ContentType.JSON (JSON)
import Type.Trout.Method (Get)

data Status = Status

instance encodeJsonStatus :: EncodeJson Status where
  encodeJson _ = "status" := "OK" ~> jsonEmptyObject

type Site = Resource (Get Status JSON)

siteStatus :: forall m. Monad m => { "GET" :: m Status }
siteStatus = { "GET": pure Status }

site :: Proxy Site
site = Proxy

siteRouter
  :: forall m req res c r
   . Monad m
  => Request req m
  => Response res m r
  => ResponseWritable r m String
  => Middleware
       m
       (Conn req (res StatusLineOpen) c)
       (Conn req (res ResponseEnded) c)
       Unit
siteRouter = do
  router site routes onRoutingError
  where
  routes = siteStatus

  onRoutingError status msg = do
    writeStatus status
      :*> contentType applicationJSON
      :*> closeHeaders
      :*> respond (maybe "" identity msg)
