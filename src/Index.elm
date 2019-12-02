module Index exposing (Model, Msg, init, main, subscriptions, update, view)

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
    { buttonClickedCount : Int }



-- Init


init : () -> ( Model, Cmd Msg )
init flags =
    ( { buttonClickedCount = 0 }
    , Cmd.none
    )



-- View


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ h1 [] [ text "Index" ]
        , a
            [ class "link-button"
            , href "other-page"
            ]
            [ text "Link"
            , span
                [ style "float" "right"
                ]
                [ text "Clicking here goes to link too! 👍" ]
            , div []
                [ button
                    [ class ""
                    , onClickPreventDefault PreventDefaultButtonClicked
                    ]
                    [ text "Changes page, does *not* prevent default: "
                    , text "😢"
                    ]
                ]
            ]
        , div []
            [ h2 [] [ text "Button click count" ]
            , text <|
                String.fromInt model.buttonClickedCount
            ]
        ]


onClickPreventDefault : msg -> Html.Attribute msg
onClickPreventDefault tagger =
    Html.Events.preventDefaultOn "click" <|
        Json.Decode.map alwaysStop
            (Json.Decode.succeed tagger)


alwaysStop : a -> ( a, Bool )
alwaysStop x =
    ( x, True )



-- Update


type Msg
    = PreventDefaultButtonClicked


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PreventDefaultButtonClicked ->
            ( { model
                | buttonClickedCount = model.buttonClickedCount + 1
              }
            , Cmd.none
            )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
