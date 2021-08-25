module Main exposing (..)

import Browser
import Html exposing (Html, button, div, h2, input, main_, p, text)
import Html.Attributes exposing (placeholder, style, value)
import Html.Events exposing (onClick, onInput)


type alias Model =
    { tasks : List Task
    , newTask : Task
    }


type TaskStatus
    = Pending
    | Ongoing
    | Completed
    | Editing


type alias Task =
    { id : SelectedTaskId
    , name : String
    , description : String
    , status : TaskStatus
    }


type alias SelectedTaskId =
    Int


type Msg
    = UpdateTask Task
    | UpdateNewTask Task
    | CreateNewTask Task
    | DeleteTask SelectedTaskId


init : ( Model, Cmd Msg )
init =
    ( { tasks = defaultTasks, newTask = defaultNewTask }
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


defaultNewTask : Task
defaultNewTask =
    { id = List.length defaultTasks
    , name = ""
    , description = ""
    , status = Pending
    }


defaultTasks : List Task
defaultTasks =
    [ { id = 0
      , name = "Buy coffee"
      , description = "Buy coffee on monday"
      , status = Pending
      }
    , { id = 1
      , name = "Learn elm"
      , description = "Keep building this"
      , status = Pending
      }
    ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateTask selectedTask ->
            let
                updatedTasks =
                    List.map
                        (\task ->
                            if task.id == selectedTask.id then
                                selectedTask

                            else
                                task
                        )
                        model.tasks
            in
            ( { model | tasks = updatedTasks }, Cmd.none )

        UpdateNewTask task ->
            ( { model | newTask = task }, Cmd.none )

        CreateNewTask task ->
            ( { model | tasks = model.tasks ++ [ task ], newTask = defaultNewTask }, Cmd.none )

        DeleteTask selectedTaskID ->
            ( { model | tasks = List.filter (\task -> task.id /= selectedTaskID) model.tasks }
            , Cmd.none
            )


view : Model -> Html Msg
view { tasks, newTask } =
    div []
        [ div [ style "display" "flex", style "flex-direction" "column", style "align-items" "flex-start" ]
            [ input [ placeholder "New task name", onInput (\newName -> UpdateNewTask { newTask | name = newName }), value newTask.name ] []
            , input [ placeholder "New task description", onInput (\newDescription -> UpdateNewTask { newTask | description = newDescription }), value newTask.description ] []
            , if newTask.name /= "" && newTask.description /= "" then
                button [ onClick (CreateNewTask newTask) ] [ text "Create" ]

              else
                button [] [ text "Create" ]
            ]
        , div [ style "display" "flex", style "flex-direction" "column", style "align-items" "flex-start" ]
            (List.map viewTaskCard tasks)
        ]


viewTaskCard : Task -> Html Msg
viewTaskCard task =
    let
        defaultWrapper children =
            div [ style "background-color" "lightgrey", style "margin-top" "1rem", style "width" "300px" ] children

        completedWrapper children =
            div [ style "background-color" "green", style "margin-top" "1rem", style "width" "300px" ] children

        editButton =
            button [ onClick <| UpdateTask { task | status = Editing } ] [ text "Edit" ]

        stopButton =
            button [ onClick <| UpdateTask { task | status = Pending } ] [ text "Stop" ]

        completeButton =
            button [ onClick <| UpdateTask { task | status = Completed } ] [ text "Complete" ]

        uncompleteButton =
            button [ onClick <| UpdateTask { task | status = Pending } ] [ text "Uncomplete" ]

        deleteButton =
            button [ onClick <| DeleteTask task.id ] [ text "Delete" ]
    in
    case task.status of
        Editing ->
            defaultWrapper
                [ stopButton
                , completeButton
                , deleteButton
                , div
                    [ style "padding" "1rem" ]
                    [ h2 [] [ viewTaskNameInput task ]
                    , p [] [ viewTaskDescriptionInput task ]
                    ]
                ]

        Completed ->
            completedWrapper
                [ uncompleteButton
                , deleteButton
                , div
                    [ style "padding" "1rem" ]
                    [ h2 [] [ text task.name ]
                    , p [] [ text task.description ]
                    ]
                ]

        _ ->
            defaultWrapper
                [ editButton
                , completeButton
                , deleteButton
                , div
                    [ style "padding" "1rem" ]
                    [ h2 [] [ text task.name ]
                    , p [] [ text task.description ]
                    ]
                ]


viewTaskNameInput : Task -> Html Msg
viewTaskNameInput task =
    input [ placeholder "Enter name", value task.name, onInput (\newValue -> UpdateTask { task | name = newValue }) ] []


viewTaskDescriptionInput : Task -> Html Msg
viewTaskDescriptionInput task =
    input [ placeholder "Enter description", value task.description, onInput (\newValue -> UpdateTask { task | description = newValue }) ] []
