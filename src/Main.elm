module Main exposing (main)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Navigation
import Html exposing (text)
import Index
import OtherPage
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, custom, fragment, map, oneOf, s, top)


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }



-- Model


type alias Model =
    { key : Navigation.Key
    , page : Page
    }


type Page
    = Index Index.Model
    | OtherPage OtherPage.Model
    | NotFound



-- Init


type alias Flags =
    ()


init : Flags -> Url -> Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    routeTo url
        { key = key
        , page = NotFound
        }



-- View


view : Model -> Browser.Document Msg
view model =
    case model.page of
        Index indexModel ->
            { title = "Index"
            , body =
                [ Index.view indexModel
                    |> Html.map IndexMsg
                ]
            }

        NotFound ->
            { title = "Not found"
            , body =
                [ text "Not found :(" ]
            }

        OtherPage otherPageModel ->
            { title = "Other page"
            , body =
                [ OtherPage.view otherPageModel
                    |> Html.map OtherPageMsg
                ]
            }



-- Update


type Msg
    = LinkClicked UrlRequest
    | UrlChanged Url
    | IndexMsg Index.Msg
    | OtherPageMsg OtherPage.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Internal url ->
                    ( model
                    , Navigation.pushUrl model.key (Url.toString url)
                    )

                External url ->
                    ( model
                    , Navigation.load url
                    )

        UrlChanged newUrl ->
            routeTo newUrl model

        IndexMsg indexMsg ->
            case model.page of
                Index indexModel ->
                    updateIndex model (Index.update indexMsg indexModel)

                _ ->
                    ( model, Cmd.none )

        OtherPageMsg otherPageMsg ->
            case model.page of
                OtherPage otherPageModel ->
                    updateOtherPage model (OtherPage.update otherPageMsg otherPageModel)

                _ ->
                    ( model, Cmd.none )


updateIndex : Model -> ( Index.Model, Cmd Index.Msg ) -> ( Model, Cmd Msg )
updateIndex model ( pageModel, pageCmd ) =
    ( { model
        | page = Index pageModel
      }
    , pageCmd
        |> Cmd.map IndexMsg
    )


updateOtherPage : Model -> ( OtherPage.Model, Cmd OtherPage.Msg ) -> ( Model, Cmd Msg )
updateOtherPage model ( pageModel, pageCmd ) =
    ( { model
        | page = OtherPage pageModel
      }
    , pageCmd
        |> Cmd.map OtherPageMsg
    )



-- Routing


routeTo : Url -> Model -> ( Model, Cmd Msg )
routeTo url model =
    let
        parser =
            oneOf
                [ route top
                    (updateIndex model (Index.init ()))
                , route (s "other-page")
                    (updateOtherPage model (OtherPage.init ()))
                ]
    in
    case Parser.parse parser url of
        Just answer ->
            answer

        Nothing ->
            ( { model
                | page = NotFound
              }
            , Cmd.none
            )


route : Parser a b -> a -> Parser (b -> c) c
route parser handler =
    Parser.map handler parser



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
