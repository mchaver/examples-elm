import CounterWidget as CW
import DisplayWidget as DW
import Html exposing (Html, text)
import Html.App
import Task

type alias AppModel =
  { counterWidgetModel : CW.Model 
  , displayWidgetModel : DW.Model 
  }
  
initialModel : AppModel 
initialModel = 
  { counterWidgetModel = CW.initialModel 
  , displayWidgetModel = DW.initialModel 
  }

init : ( AppModel, Cmd Msg )
init = ( initialModel, Cmd.none )

type Msg = CWMsg CW.Msg | DWMsg DW.Msg

view : AppModel -> Html Msg
view model =
  Html.div []
           [ Html.h2  [] [ text "This is the parent widget"]
           , Html.div [] [ text ("This value from my child counter widget component: " ++ (toString model.counterWidgetModel.count )) ]
           , Html.App.map CWMsg (CW.view model.counterWidgetModel ) 
           , Html.App.map DWMsg (DW.view model.displayWidgetModel )]

update : Msg -> AppModel -> ( AppModel, Cmd Msg )
update message model =
    case message of
        CWMsg subMsg ->
            let
                ( updatedCounterWidgetModel, widgetCmd ) =
                    CW.update subMsg model.counterWidgetModel  
            in
                ( { model | counterWidgetModel = updatedCounterWidgetModel }, Cmd.batch [ Cmd.map CWMsg widgetCmd, callMsg (DWMsg (DW.SetValue updatedCounterWidgetModel.count))] )
        DWMsg subMsg ->
            let      
                ( updatedDisplayWidgetModel, widgetCmd ) =
                    DW.update subMsg model.displayWidgetModel
            in
                ( { model | displayWidgetModel = updatedDisplayWidgetModel }, Cmd.map DWMsg widgetCmd )

-- Task.perform converts a message into a Cmd msg
callMsg msg =
  Task.perform (always msg) (always msg) (Task.succeed ())


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
