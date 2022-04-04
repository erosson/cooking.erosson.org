module Layout exposing (layout)

import Html exposing (..)
import Shared
import View exposing (View)


layout : Shared.Model -> (Shared.OkModel -> View msg) -> View msg
layout shared view =
    case shared of
        Shared.Loading ->
            {title="Evan's Recipes", body=[ text "loading..." ]}
            

        Shared.Failure err ->
            {title="Evan's Recipes", body=[ text "Error: ", text err ]}

        Shared.Success model ->
            view model
