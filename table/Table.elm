import Html exposing (Html, div, table, tbody, thead, tr, td, th, text)
import Html.App
import Html.Events exposing (onClick)
import List as L
import Task



type alias Person =
  { name : String
  , age  : Int
  }

type alias AppModel =
  { people : List Person }
  
initialModel : AppModel 
initialModel = 
  { people = [Person "Alice" 12, Person "Bob" 25, Person "Tim" 30] 
  }

init : ( AppModel, Cmd Msg )
init = ( initialModel, Cmd.none )

type Msg = AddPerson

view : AppModel -> Html Msg
view model =
  let
    tableHeader = 
      Html.thead [] 
        [ Html.tr [] 
           [ Html.th [] [text "Person"]
           , Html.th [] [text "Age"]
           ]
        ]  
  in 
    Html.div [] 
      [ Html.table [] 
          [ tableHeader
          , Html.tbody [] (L.map personToTableRow model.people)
          ]
      , Html.button [onClick AddPerson] [ text "Add a Person"]           
    ]
-- personToTableRow : Person -> Html Msg
personToTableRow person =
  Html.tr []
    [ Html.td [] [ text person.name ]
    , Html.td [] [ text (toString person.age) ]
    ]

update : Msg -> AppModel -> ( AppModel, Cmd Msg )
update message model =
  case message of
    AddPerson ->
      ( { model | people = (L.append model.people [Person "Not named" 0])} , Cmd.none )

subscriptions : AppModel -> Sub Msg
subscriptions model =
    Sub.none

main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
