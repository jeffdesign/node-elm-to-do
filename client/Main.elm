module Main exposing (..)

import Browser
import Html exposing (Html, button, div, h2, input, p, text)
import Html.Attributes exposing (placeholder, style)
import Html.Events exposing (onClick)


type alias Model =
    { tasks : List Task
    , currentId : Int
    , newTaskName : Maybe String
    }


type TaskStatus
    = Pending
    | Ongoing
    | Completed


type alias Task =
    { id : Int
    , name : String
    , description : String
    , status : TaskStatus
    }


type Msg
    = UpdateTask Int TaskStatus
    | DeleteTask Int


init : ( Model, Cmd Msg )
init =
    ( { tasks = defaultTasks
      , currentId = List.length defaultTasks
      , newTaskName = Nothing
      }
    , Cmd.none
    )


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> init
        , update = update
        , view = view
        , subscriptions = always Sub.none
        }


defaultTasks : List Task
defaultTasks =
    [ { id = 1
      , name = "Buy coffee"
      , description = "Buy coffee on monday"
      , status = Pending
      }
    , { id = 2
      , name = "Learn elm"
      , description = "Keep building this"
      , status = Pending
      }
    ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateTask id status ->
            ( model, Cmd.none )

        DeleteTask id ->
            ( { model
                | tasks =
                    List.filter (\task -> task.id /= id) model.tasks
              }
            , Cmd.none
            )


viewTaskCard : Task -> Html Msg
viewTaskCard task =
    div [ style "background-color" "lightgrey", style "margin-top" "1rem", style "width" "300px" ]
        [ button [ onClick (UpdateTask task.id Pending) ] [ text "Edit" ]
        , button [ onClick (DeleteTask task.id) ] [ text "X" ]
        , div
            [ style "padding" "1rem" ]
            [ h2 [] [ text task.name ]
            , p [] [ text task.description ]
            ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ input [ placeholder "Enter new task" ] []
        , div [ style "display" "flex", style "flex-direction" "column", style "align-items" "flex-start" ]
            (List.map (\task -> viewTaskCard task) model.tasks)
        ]
