module Pages.Recipe.Name_ exposing (page)

import Dict exposing (Dict)
import Gen.Params.Recipe.Name_ exposing (Params)
import Gen.Route
import Html exposing (..)
import Html.Attributes as A exposing (..)
import Json.Encode as E
import Layout
import Page exposing (Page)
import Recipe
import Request
import Shared
import Url
import View exposing (View)
import Pages.NotFound


page : Shared.Model -> Request.With Params -> Page
page shared req =
    Page.static
        { view = Layout.layout shared <| view req.params
        }

view : Params -> Shared.OkModel -> View msg
view params model =
    case Url.percentDecode params.name |> Maybe.andThen (\name -> Dict.get name model.recipesByName) of
        Nothing ->
            Pages.NotFound.view

        Just ok ->
            { title = "Evan's Recipes: "++ok.name, body = viewBody ok }


viewBody : Recipe.File -> List (Html msg)
viewBody recipe =
    [ h1 [] [ a [href <| Gen.Route.toHref Gen.Route.Home_] [text "Evan's Recipes"], text " > ", text recipe.name ]
    , details [] [ summary [] [ text "ingredients" ], ul [] (recipe.model |> Recipe.ingredients |> List.map (viewIngredientEntry >> li []))]
    -- , details [ A.attribute "open" "" ] [ summary [] [ text "model" ], pre [] [ recipe.model |> Debug.toString |> text ] ]
    , details [ A.attribute "open" ""] [summary[][text "steps"], ul [] (recipe.model.steps |> List.map (viewStep >> li []))]
    , details [] [summary [] [text "text"], pre [] [ text recipe.content ]]
    , details [] [ summary [] [ text "json" ], pre [] [ recipe.json |> E.encode 2 |> text ] ]
    ]

viewIngredientEntry : Recipe.Ingredient -> List (Html msg)
viewIngredientEntry ingr =
    case renderIngredientQuantity ingr of
        "" -> [text ingr.name]
        qty -> [text ingr.name, text ": ", text qty]
renderIngredientQuantity : Recipe.Ingredient -> String
renderIngredientQuantity ingr =
    case ingr.quantity of
        Nothing -> ""
        Just qtyres ->
            let qty : String
                qty = case qtyres of
                    Ok num -> String.fromFloat num
                    Err str -> str
                units : String
                units = ingr.units |> Maybe.map ((++) " ") |> Maybe.withDefault ""
            in qty ++ units

viewStep : Recipe.Step -> List (Html msg)
viewStep = List.map viewStepNode

viewStepNode : Result E.Value Recipe.StepNode -> Html msg
viewStepNode noderes =
    case noderes of
        Err json -> text "???"
        Ok (Recipe.StepText val) -> text val
        -- Ok (Recipe.StepIngredient ingr) -> a [title <| renderIngredientQuantity ingr, href "#"] [text ingr.name]
        Ok (Recipe.StepIngredient ingr) -> 
            case renderIngredientQuantity ingr of
                "" -> u [] [text ingr.name]
                qty -> u [] [text ingr.name, text " (", text qty, text ")"]
