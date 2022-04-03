module Layout exposing (layout)

import Html exposing (..)
import Shared


layout : Shared.Model -> (Shared.OkModel -> List (Html msg)) -> List (Html msg)
layout shared viewBody =
    case shared of
        Shared.Loading ->
            [ text "loading..." ]

        Shared.Failure err ->
            [ text "Error: ", text err ]

        Shared.Success model ->
            viewBody model
