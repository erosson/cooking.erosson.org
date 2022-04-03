module Pages.Home_ exposing (page)

import Gen.Params.Home_ exposing (Params)
import Gen.Route
import Html exposing (..)
import Html.Attributes exposing (..)
import Layout
import Page exposing (Page)
import Request
import Shared


page : Shared.Model -> Request.With Params -> Page
page shared req =
    Page.static
        { view = { title = "Evan's Recipes", body = Layout.layout shared viewBody }
        }


viewBody : Shared.OkModel -> List (Html msg)
viewBody model =
    [ text "ok", ul [] <| List.map viewRecipeLink model.recipes ]


viewRecipeLink : Shared.Recipe -> Html msg
viewRecipeLink recipe =
    li [] [ a [ href <| Gen.Route.toHref <| Gen.Route.Recipe__Name_ { name = recipe.file } ] [ text recipe.file ] ]
