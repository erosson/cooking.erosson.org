module Pages.Recipe.Name_ exposing (page)

import Dict exposing (Dict)
import Gen.Params.Recipe.Name_ exposing (Params)
import Html exposing (..)
import Layout
import Page exposing (Page)
import Request
import Shared
import Url


page : Shared.Model -> Request.With Params -> Page
page shared req =
    Page.static
        { view = { title = "Evan's Recipes", body = Layout.layout shared (viewBody req.params) }
        }


viewBody : Params -> Shared.OkModel -> List (Html msg)
viewBody params model =
    case Url.percentDecode params.name |> Maybe.andThen (\name -> Dict.get name model.recipesByFile) of
        Nothing ->
            [ text "not found" ]

        Just ok ->
            viewRecipe ok


viewRecipe : Shared.Recipe -> List (Html msg)
viewRecipe recipe =
    [ h1 [] [ text recipe.file ], pre [] [ text recipe.content ] ]
