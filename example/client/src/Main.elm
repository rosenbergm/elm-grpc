module Main exposing (..)

import Browser
import Html exposing (Html, button, div, h2, text)
import Html.Events exposing (onClick)
import Http
import Proto.Test exposing (PingRequest, PongResponse, decodePongResponse, encodePingRequest)
import Rpc exposing (Client(..), Rpc(..), Service(..))



-- MAIN


main : Program () Model Msg
main =
    Browser.element { init = init, update = update, view = view, subscriptions = \_ -> Sub.none }



-- MODEL


type alias Model =
    String


init : () -> ( Model, Cmd Msg )
init _ =
    ( "Nothing sent yet", Cmd.none )



-- UPDATE


type Msg
    = Send
    | Receive (Result Http.Error PongResponse)


client : Client
client =
    Client "http://localhost:9001"


pingService : Service
pingService =
    Service "PingService" client


ping : Rpc Msg PingRequest PongResponse
ping =
    Rpc pingService "Ping" Receive encodePingRequest decodePongResponse


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        Send ->
            ( "SENDING", Rpc.unary ping { name = "Michal" } )

        Receive testResult ->
            case testResult of
                Err _ ->
                    ( "", Cmd.none )

                Ok response ->
                    ( "RECEIVED: " ++ response.message, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Send ] [ text "Send gRPC message" ]
        , h2 [] [ text "Status:" ]
        , text <| model
        ]
