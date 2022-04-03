module Shared exposing
    ( Flags
    , Model
    , Msg
    , OkModel
    , Recipe
    , Remote(..)
    , init
    , subscriptions
    , update
    )

import Dict exposing (Dict)
import Json.Decode as D
import Ports
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
    { recipes : List Recipe
    , recipesByFile : Dict String Recipe
    }


type alias Recipe =
    { file : String
    , content : String
    }


type Msg
    = OnRecipesLoaded D.Value


decodeRecipes : D.Decoder (List Recipe)
decodeRecipes =
    D.andThen
        (\status ->
            case status of
                "success" ->
                    D.field "data" (D.list decodeRecipe)

                "error" ->
                    D.field "error" D.string |> D.andThen D.fail

                _ ->
                    D.fail <| "no such status: " ++ status
        )
        (D.field "status" D.string)


decodeRecipe : D.Decoder Recipe
decodeRecipe =
    D.map2 Recipe
        (D.field "file" D.string)
        (D.field "content" D.string)


init : Request -> Flags -> ( Model, Cmd Msg )
init _ _ =
    ( Loading, Cmd.none )


update : Request -> Msg -> Model -> ( Model, Cmd Msg )
update _ msg _ =
    case msg of
        OnRecipesLoaded json ->
            case D.decodeValue decodeRecipes json of
                Err err ->
                    ( err |> D.errorToString |> Failure, Cmd.none )

                Ok recipes ->
                    ( Success
                        { recipes = recipes
                        , recipesByFile = recipes |> List.map (\r -> ( r.file, r )) |> Dict.fromList
                        }
                    , Cmd.none
                    )


subscriptions : Request -> Model -> Sub Msg
subscriptions _ _ =
    Ports.recipes OnRecipesLoaded
