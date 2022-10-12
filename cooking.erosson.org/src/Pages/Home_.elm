module Pages.Home_ exposing (page)

import Gen.Params.Home_ exposing (Params)
import Gen.Route
import Html exposing (..)
import Html.Attributes exposing (..)
import Layout
import Page exposing (Page)
import Recipe
import Request
import Shared
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page
page shared req =
    Page.static
        { view = Layout.layout shared view 
        }

view : Shared.OkModel -> View msg
view model = 
    { title = "Evan's Recipes", body = viewBody model }

viewBody : Shared.OkModel -> List (Html msg)
viewBody model =
    [ text "ok", ul [] <| List.map viewRecipeLink model.recipes ]


viewRecipeLink : Recipe.File -> Html msg
viewRecipeLink recipe =
    li [] [ a [ href <| Gen.Route.toHref <| Gen.Route.Recipe__Name_ { name = recipe.name } ] [ text recipe.name ] ]
