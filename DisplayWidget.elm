module DisplayWidget exposing (..)

import Html exposing (Html, button, div, h2, text)
import Html.Events exposing (onClick)

type alias Model = { count : Int }

initialModel : Model 
initialModel = { count = 0 }

type Msg = SetValue Int

view : Model -> Html Msg
view model =
  div []
      [ h2  [] [ text "This is the Display Widget"]
      , div [] [ text ("This is value is from Counter Widget passed to me by my parent widget: " ++ (toString model.count)) ]
      ]

update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
  case message of
    SetValue v -> 
      ( { model | count = v}, Cmd.none )
