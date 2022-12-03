module Rpc exposing (Client(..), Rpc(..), Service(..), unary)

import Http exposing (Response(..))
import Protobuf.Decode exposing (Decoder)
import Protobuf.Encode exposing (Encoder)
import Request exposing (start)


{-| Defines a gRPC client with a `hostname`.

    backend : Client
    backend =
        Client.Client "http://localhost:9001"

-}
type Client
    = Client String


{-| Defines a gRPC service attached to a `Client`.

    backend : Client
    backend =
        Client.Client "http://localhost:9001"

    userService : Service
    userService =
        Client.Service "UserService" backend

-}
type Service
    = Service String Client


{-| Defines an RPC that is to be called on a `Service`

    backend : Client
    backend =
        Client.Client "http://localhost:9001"

    userService : Service
    userService =
        Client.Service "UserService" backend

    getUser : Rpc Msg UserRequest UserResponse
    getUser =
        Client.Rpc userService "GetUser" ReceiveUser encodeUserRequest decodeUserResponse

-}
type Rpc msg req res
    = Rpc Service String (Result Http.Error res -> msg) (req -> Encoder) (Decoder res)


{-| Execute a unary RPC on a gRPC-web server running on the specified host.

    backend : Client
    backend =
        Client.Client "http://localhost:9001"

    userService : Service
    userService =
        Client.Service "UserService" backend

    getUser : Rpc Msg UserRequest UserResponse
    getUser =
        Client.Rpc userService "GetUser" ReceiveUser encodeUserRequest decodeUserResponse

    unaryCall : Cmd msg
    unaryCall =
        Client.unary getUser { name = "Michal" }

-}
unary : Rpc msg req res -> req -> Cmd msg
unary (Rpc (Service serviceName (Client host)) rpcName send encoder decoder) request =
    let
        url =
            host ++ "/" ++ serviceName ++ "/" ++ rpcName
    in
    start url request encoder decoder send
