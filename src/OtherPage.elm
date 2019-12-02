module OtherPage exposing (Model, Msg, init, main, subscriptions, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- Model


type alias Model =
    {}



-- Init


init : () -> ( Model, Cmd Msg )
init flags =
    ( {}
    , Cmd.none
    )



-- View


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ h1 [] [ text "Another page clicked!" ]
        , a
            [ class "link-button"
            , href "/"
            ]
            [ text "Go back" ]
        ]



-- Update


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
