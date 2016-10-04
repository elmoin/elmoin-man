module App exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String


main : Program Never
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type GameStatus
    = Start
    | Run
    | Finish


type alias Word =
    String


type alias Model =
    { gameStatus : GameStatus
    , word : Word
    , guess : Word
    , guessDisplay : Word
    , guessList : List Word
    }


initialModel : Model
initialModel =
    { gameStatus = Start
    , word = ""
    , guess = ""
    , guessDisplay = ""
    , guessList = []
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )



-- UPDATE


type Msg
    = EnterWord String
    | EnterGuess String
    | Guess
    | StartGame
    | NewGame
    | NoOp


minChar : Int
minChar =
    3


maxChar : Int
maxChar =
    10


displayGuess : Word -> Word -> String
displayGuess word guess =
    let
        displayChar char =
            if String.contains (String.fromChar char) guess then
                char
            else
                '*'
    in
        String.map displayChar word


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StartGame ->
            let
                guessDisplay =
                    displayGuess model.word " "
            in
                ( { model
                    | gameStatus = Run
                    , guessDisplay = guessDisplay
                  }
                , Cmd.none
                )

        NewGame ->
            ( initialModel, Cmd.none )

        EnterWord word ->
            ( { model | word = word }, Cmd.none )

        EnterGuess guess ->
            ( { model | guess = guess }, Cmd.none )

        Guess ->
            let
                guessDisplay =
                    displayGuess model.word model.guess
            in
                ( { model
                    | guessList = guessDisplay :: model.guessList
                    , guessDisplay = guessDisplay
                    , guess = ""
                    , gameStatus =
                        if guessDisplay == model.word then
                            Finish
                        else
                            Run
                  }
                , Cmd.none
                )

        NoOp ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "col-12" ]
        [ header
        , wordInput model
        , guessInput model
        , finishView model
        , guessList model
        ]


header : Html Msg
header =
    div [ class "p2 bg-black" ]
        [ h1
            [ class "m0 caps white"
            ]
            [ text "Elmoin-Man" ]
        ]


wordInput : Model -> Html Msg
wordInput model =
    let
        show =
            if model.gameStatus == Start then
                ""
            else
                " hide"
    in
        div [ class <| "flex-auto p2 bg-gray" ++ show ]
            [ input
                [ class "col-2 h2 px1 py1 "
                , type' "password"
                , value model.word
                , autofocus True
                , maxlength maxChar
                , minlength minChar
                , onInput EnterWord
                , placeholder "Enter word"
                , disabled <| model.gameStatus /= Start
                ]
                []
            , button
                [ class "h3 regular p2 ml2 btn btn-primary bg-orange"
                , onClick StartGame
                , disabled <| model.gameStatus /= Start || String.length model.word < minChar
                ]
                [ text "Start Game" ]
            ]


guessInput : Model -> Html Msg
guessInput model =
    let
        show =
            if model.gameStatus == Run then
                ""
            else
                " hide"
    in
        div [ class <| "flex-auto p2 bg-silver" ++ show ]
            [ input
                [ class "col-2 h2 px1 py1"
                , type' "text"
                , value model.guess
                , maxlength maxChar
                , minlength minChar
                , onInput EnterGuess
                , placeholder "Your guess"
                , disabled <| model.gameStatus /= Run
                ]
                []
            , button
                [ class "h3 regular p2 ml2 btn btn-primary bg-teal"
                , onClick Guess
                , disabled <| model.gameStatus /= Run || String.length model.guess < minChar
                ]
                [ text "My guess" ]
            ]


guessList : Model -> Html Msg
guessList model =
    let
        show =
            if model.gameStatus == Run then
                ""
            else
                " hide"
    in
        ul [ class <| "list-reset m0" ++ show ]
            (List.map guessItem model.guessList)


guessItem : Word -> Html Msg
guessItem word =
    li [ class "h1 px2 py1 regular border-bottom gray" ]
        [ text word
        ]


finishView : Model -> Html Msg
finishView model =
    let
        show =
            if model.gameStatus == Finish then
                ""
            else
                " hide"
    in
        div [ class <| "col-12 p2 bg-fuchsia" ++ show ]
            [ h1 [ class "white regular mt0" ] [ text <| "Yeah, you got it !!!" ]
            , h1 [ class "white regular mt0 italic" ] [ text <| "\"" ++ model.word ++ "\"" ]
            , button
                [ class "h3 regular p2 btn btn-primary fuchsia bg-white"
                , onClick NewGame
                ]
                [ text "New Game" ]
            ]
