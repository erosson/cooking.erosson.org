port module Ports exposing (..)

import Json.Decode as Json

port recipeReq : {file: String} -> Cmd msg

port recipeRes : (Json.Value -> msg) -> Sub msg