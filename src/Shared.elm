module Shared exposing
    ( Flags
    , Model
    , Msg
    , OkModel
    , Remote(..)
    , init
    , subscriptions
    , update
    )

import Dict exposing (Dict)
import Json.Decode as D
import Ports
import Recipe
import Request exposing (Request)


type alias Flags =
    {}


type Remote err ok
    = Loading
    | Failure err
    | Success ok


type alias Model =
    Remote String OkModel


type alias OkModel =
    { recipes : List Recipe.File
    , recipesByName : Dict String Recipe.File
    }


type Msg
    = OnRecipesLoaded D.Value


init : Request -> Flags -> ( Model, Cmd Msg )
init _ _ =
    ( Loading, Cmd.none )


update : Request -> Msg -> Model -> ( Model, Cmd Msg )
update _ msg _ =
    case msg of
        OnRecipesLoaded json ->
            case D.decodeValue Recipe.decodePayload json of
                Err err ->
                    ( err |> D.errorToString |> Failure, Cmd.none )

                Ok recipes ->
                    ( Success
                        { recipes = recipes
                        , recipesByName = recipes |> List.map (\r -> ( r.name, r )) |> Dict.fromList
                        }
                    , Cmd.none
                    )


subscriptions : Request -> Model -> Sub Msg
subscriptions _ _ =
    Ports.recipes OnRecipesLoaded
