module Request exposing (start)

import Bytes exposing (Bytes)
import Bytes.Decode
import Bytes.Encode
import Http exposing (Response(..), header)
import Protobuf.Decode exposing (Decoder, decode)
import Protobuf.Encode exposing (Encoder, encode)


start : String -> req -> (req -> Encoder) -> Decoder res -> (Result Http.Error res -> msg) -> Cmd msg
start url request encoder decoder msg =
    let
        body =
            encode (encoder request)
                |> frameRequest
                |> Http.bytesBody "application/grpc-web+proto"
    in
    Http.request
        { method = "POST"
        , headers = [ header "x-grpc-web" "elm-grpc", header "accept" "application/grpc-web+proto" ]
        , url = url
        , body = body
        , expect =
            Http.expectBytesResponse msg <|
                \httpResponse ->
                    case httpResponse of
                        GoodStatus_ _ bytes ->
                            Bytes.Decode.decode responseDecoder bytes
                                |> Maybe.andThen (\response -> decode decoder response.message)
                                |> Result.fromMaybe Http.NetworkError

                        _ ->
                            Err Http.NetworkError
        , timeout = Nothing
        , tracker = Nothing
        }


requestEncoder : Bytes -> Bytes.Encode.Encoder
requestEncoder message =
    let
        messageLength =
            Bytes.width message
    in
    Bytes.Encode.sequence
        [ Bytes.Encode.unsignedInt8 0
        , Bytes.Encode.unsignedInt32 Bytes.BE messageLength
        , Bytes.Encode.bytes message
        ]


type alias Response =
    { message : Bytes
    }


responseDecoder : Bytes.Decode.Decoder Response
responseDecoder =
    Bytes.Decode.map2 (\_ -> Response)
        (Bytes.Decode.bytes 1)
        (Bytes.Decode.unsignedInt32 Bytes.BE
            |> Bytes.Decode.andThen Bytes.Decode.bytes
        )


frameRequest : Bytes -> Bytes
frameRequest binaryData =
    requestEncoder binaryData
        |> Bytes.Encode.encode
