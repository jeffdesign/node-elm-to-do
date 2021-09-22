module Main exposing (..)

import Browser
import Html exposing (Html, button, div, h2, input, p, text)
import Html.Attributes exposing (disabled, placeholder, style, value)
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
    { id : UUID
    , name : String
    , description : String
    , status : TaskStatus
    }


type alias NewValue =
    String


type alias UUID =
    Int


type Msg
    = UpdateTaskName UUID NewValue
    | UpdateTaskDescription UUID NewValue
    | UpdateTaskStatus UUID TaskStatus
    | UpdateNewTaskName NewValue
    | UpdateNewTaskDescription NewValue
    | CreateNewTask
    | DeleteTask UUID


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
        UpdateTaskName selectedTaskId newTaskName ->
            let
                updatedTask task =
                    if task.id == selectedTaskId then
                        { task | name = newTaskName }

                    else
                        task
            in
            ( { model | tasks = List.map updatedTask model.tasks }, Cmd.none )

        UpdateTaskDescription selectedTaskId newDescription ->
            let
                updatedTask task =
                    if task.id == selectedTaskId then
                        { task | description = newDescription }

                    else
                        task
            in
            ( { model | tasks = List.map updatedTask model.tasks }, Cmd.none )

        UpdateTaskStatus selectedTaskId newTaskStatus ->
            let
                updatedTask task =
                    if task.id == selectedTaskId then
                        { task | status = newTaskStatus }

                    else
                        task
            in
            ( { model | tasks = List.map updatedTask model.tasks }, Cmd.none )

        UpdateNewTaskName newName ->
            let
                newTask =
                    model.newTask
            in
            ( { model | newTask = { newTask | name = newName } }, Cmd.none )

        UpdateNewTaskDescription newDescription ->
            let
                newTask =
                    model.newTask
            in
            ( { model | newTask = { newTask | description = newDescription } }, Cmd.none )

        CreateNewTask ->
            ( { model
                | tasks =
                    model.tasks
                        ++ [ { id = List.length model.tasks
                             , name = model.newTask.name
                             , description = model.newTask.description
                             , status = Pending
                             }
                           ]
                , newTask = defaultNewTask
              }
            , Cmd.none
            )

        DeleteTask selectedTaskId ->
            ( { model | tasks = List.filter (\task -> task.id /= selectedTaskId) model.tasks }
            , Cmd.none
            )


view : Model -> Html Msg
view { tasks, newTask } =
    div []
        [ div [ style "display" "flex", style "flex-direction" "column", style "align-items" "flex-start" ]
            [ input
                [ placeholder "New task name"
                , onInput (\newName -> UpdateNewTaskName newName)
                , value newTask.name
                ]
                []
            , input
                [ placeholder "New task description"
                , onInput (\newDescription -> UpdateNewTaskDescription newDescription)
                , value newTask.description
                ]
                []
            , if newTask.name /= "" && newTask.description /= "" then
                button [ onClick CreateNewTask ] [ text "Create" ]

              else
                button [ disabled True ] [ text "Create" ]
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
            button [ onClick <| UpdateTaskStatus task.id Editing ] [ text "Edit" ]

        disabledEditButton =
            button [ disabled True ] [ text "Edit" ]

        stopButton =
            button [ onClick <| UpdateTaskStatus task.id Pending ] [ text "Stop" ]

        completeButton =
            button [ onClick <| UpdateTaskStatus task.id Completed ] [ text "Complete" ]

        uncompleteButton =
            button [ onClick <| UpdateTaskStatus task.id Pending ] [ text "Uncomplete" ]

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
                [ disabledEditButton
                , uncompleteButton
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
    input
        [ placeholder "Enter name"
        , value task.name
        , onInput (\newName -> UpdateTaskName task.id newName)
        ]
        []


viewTaskDescriptionInput : Task -> Html Msg
viewTaskDescriptionInput task =
    input
        [ placeholder "Enter description"
        , value task.description
        , onInput (\newDescription -> UpdateTaskDescription task.id newDescription)
        ]
        []
