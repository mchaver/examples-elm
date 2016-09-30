module CounterWidget exposing (..)

import Html exposing (Html, button, div, h2, text)
import Html.Events exposing (onClick)

type alias Model = { count : Int }

initialModel : Model 
initialModel = { count = 0 }

type Msg = Increase

view : Model -> Html Msg
view model =
  div []
      [ h2  [] [ text "This is the Counter Widget"]
      , div [] [ text ("It has no knowledge of its parent widget. Current value is: " ++ (toString model.count))]
      , button [ onClick Increase ] [ text "Click to increase value" ]
      ]

update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
  case message of
    Increase -> 
      ( { model | count = model.count + 1}, Cmd.none )
