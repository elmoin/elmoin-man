module App exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)


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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StartGame ->
            ( model, Cmd.none )

        NewGame ->
            ( model, Cmd.none )

        EnterWord word ->
            ( model, Cmd.none )

        EnterGuess guess ->
            ( model, Cmd.none )

        Guess ->
            ( model, Cmd.none )

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
    div [ class "flex-auto p2 bg-gray" ]
        [ input
            [ class "col-2 h2 px1 py1 "
            , type' "password"
            , value model.word
            , autofocus True
            , maxlength maxChar
            , minlength minChar
            , placeholder "Enter word"
            ]
            []
        , button
            [ class "h3 regular p2 ml2 btn btn-primary bg-orange"
            ]
            [ text "Start Game" ]
        ]


guessInput : Model -> Html Msg
guessInput model =
    div [ class "flex-auto p2 bg-silver" ]
        [ input
            [ class "col-2 h2 px1 py1"
            , type' "text"
            , value model.guess
            , maxlength maxChar
            , minlength minChar
            , placeholder "Your guess"
            ]
            []
        , button
            [ class "h3 regular p2 ml2 btn btn-primary bg-teal"
            ]
            [ text "My guess" ]
        ]


guessList : Model -> Html Msg
guessList model =
    ul [ class "list-reset m0" ]
        (List.map guessItem model.guessList)


guessItem : Word -> Html Msg
guessItem word =
    li [ class "h1 px2 py1 regular border-bottom gray" ]
        [ text word
        ]


finishView : Model -> Html Msg
finishView model =
    div [ class "col-12 p2 bg-fuchsia" ]
        [ h1 [ class "white regular mt0" ] [ text <| "Yeah, you got it !!!" ]
        , h1 [ class "white regular mt0 italic" ] [ text <| "\"" ++ model.word ++ "\"" ]
        , button
            [ class "h3 regular p2 btn btn-primary fuchsia bg-white"
            ]
            [ text "New Game" ]
        ]
