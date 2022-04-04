module Recipe exposing (..)

import Dict exposing (Dict)
import Json.Decode as D


type alias File =
    { name : String

    -- , file: String,
    , content : String
    , json : D.Value
    , model : Model
    }


type alias Model =
    { metadata : Metadata
    , steps : List Step
    }


type alias Metadata =
    Dict String String


type alias Step =
    List (Result D.Value StepNode)


type StepNode
    = StepText String
    | StepIngredient Ingredient


type alias Ingredient =
    { name : String
    , quantity : Maybe (Result String Float)
    , units : Maybe String
    }


ingredients : Model -> List Ingredient
ingredients model =
    List.concatMap
        (List.filterMap
            (\node ->
                case node of
                    Ok (StepIngredient ingr) ->
                        Just ingr

                    _ ->
                        Nothing
            )
        )
        model.steps


decodePayload : D.Decoder (List File)
decodePayload =
    D.andThen
        (\status ->
            case status of
                "success" ->
                    D.field "data" (D.list decodeFile)

                "error" ->
                    D.field "error" D.string |> D.andThen D.fail

                _ ->
                    D.fail <| "no such status: " ++ status
        )
        (D.field "status" D.string)


decodeFile : D.Decoder File
decodeFile =
    D.map4 File
        (D.field "name" D.string)
        (D.field "content" D.string)
        (D.field "json" D.value)
        (D.field "json" decodeModel)


decodeModel : D.Decoder Model
decodeModel =
    D.map2 Model
        (D.field "metadata" decodeMetadata)
        (D.field "steps" <| D.list decodeStep)


decodeMetadata : D.Decoder Metadata
decodeMetadata =
    D.dict D.string


decodeStep : D.Decoder Step
decodeStep =
    D.list decodeStepNode


decodeStepNode : D.Decoder (Result D.Value StepNode)
decodeStepNode =
    D.field "type" D.string
        |> D.andThen
            (\t ->
                D.oneOf
                    [ -- https://github.com/cooklang/cooklang-ts/blob/main/src/Parser.ts
                      D.map Ok <|
                        case t of
                            "text" ->
                                D.map StepText
                                    (D.field "value" D.string)

                            "ingredient" ->
                                D.map StepIngredient decodeIngredient

                            _ ->
                                D.fail "invalid stepnode.type"
                    , D.value |> D.map Err
                    ]
            )


decodeIngredient : D.Decoder Ingredient
decodeIngredient =
    D.map3 Ingredient
        (D.field "name" D.string)
        (D.field "quantity" <|
            D.maybe <|
                D.oneOf
                    [ D.float |> D.map Ok
                    , D.string |> D.map Err
                    ]
        )
        (D.field "units" <| D.maybe D.string)
