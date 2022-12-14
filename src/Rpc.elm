module Rpc exposing
    ( Client(..), Rpc(..), Service(..)
    , unary
    )

{-| The `Rpc` module allows you to communicate with a gRPC-web server.


# Defining a communication channel

@docs Client, Rpc, Service


# Executing requests

@docs unary

-}

import Http exposing (Response(..))
import Protobuf.Decode exposing (Decoder)
import Protobuf.Encode exposing (Encoder)
import Request exposing (start)


{-| Defines a gRPC client with a `hostname`.

    backend : Client
    backend =
        Client "http://localhost:9001"

-}
type Client
    = Client String


{-| Defines a gRPC service attached to a `Client`.

    backend : Client
    backend =
        Client "http://localhost:9001"

    userService : Service
    userService =
        Service "UserService" backend

-}
type Service
    = Service String Client


{-| Defines an RPC which will be called on a `Service`.

    backend : Client
    backend =
        Client "http://localhost:9001"

    userService : Service
    userService =
        Service "UserService" backend

    getUser : Rpc Msg UserRequest UserResponse
    getUser =
        Rpc userService "GetUser" ReceiveUser encodeUserRequest decodeUserResponse

-}
type Rpc msg req res
    = Rpc Service String (Result Http.Error res -> msg) (req -> Encoder) (Decoder res)


{-| Execute a unary RPC on a gRPC-web server running on the specified host.

    backend : Client
    backend =
        Client "http://localhost:9001"

    userService : Service
    userService =
        Service "UserService" backend

    getUser : Rpc Msg UserRequest UserResponse
    getUser =
        Rpc userService "GetUser" ReceiveUser encodeUserRequest decodeUserResponse

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
