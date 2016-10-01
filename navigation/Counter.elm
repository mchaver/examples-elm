import Html exposing (..)
import Html.Events exposing (..)
import Http
import Navigation
import String
import Task
import UrlParser exposing (Parser, (</>), format, int, oneOf, s, string)

main =
  Navigation.program (Navigation.makeParser hashParser)
    { init = init
    , view = view
    , update = update
    , urlUpdate = urlUpdate
    , subscriptions = subscriptions
    }

toHash : Page -> String
toHash page =
  case page of
    Count count ->
      "#count/" ++ toString count



hashParser : Navigation.Location -> Result String Page
hashParser location =
  UrlParser.parse identity pageParser (String.dropLeft 1 location.hash)

{-
type Result error value = Ok value | Err error
-}
type Page = Count Int

pageParser : Parser (Page -> a) a
pageParser =
  oneOf
    [ format Count (UrlParser.s "count" </> int)
    ]
    
toUrl : Int -> String
toUrl count = 
  "#/" ++ toString count

fromUrl : String -> Result String Int
fromUrl url =
  String.toInt (String.dropLeft 2 url)

urlParser : Navigation.Parser (Result String Int)
urlParser =
  Navigation.makeParser (fromUrl << .hash)

type alias Model = Int

init : Result String Page -> (Model, Cmd Msg)
init result =
  case result of 
    Ok (Count newCount) -> 
      urlUpdate result newCount
    Err _ ->       
      urlUpdate result 0
        
type Msg = Increment | Decrement

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  let
    newModel =
      case msg of
        Increment ->
          model + 1
        Decrement ->
          model - 1
  in  
    (newModel, Navigation.newUrl (toHash (Count newModel)))

urlUpdate : Result String Page -> Model -> (Model, Cmd Msg)
urlUpdate result model =
  case result of --  Debug.log "result" result of
    Ok (Count newCount) ->
      (newCount, Cmd.none)
    Err _ ->
      (model, Navigation.modifyUrl (toHash (Count model)))

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (toString model) ]
    , button [ onClick Increment ] [ text "+" ]
    ]    
