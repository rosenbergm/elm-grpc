# ✍️ elm-grpc example implementation

This is an example app that shows the usage of the `elm-grpc` library. It comprises of a few components:
- [gRPC server](server) written in Go
- [Envoy proxy](server/envoy.yaml) that allows us to access gRPC services through web
- [The app](client/src/Main.elm) itself

## 🍲 How to create a similar app

1. Install necessary utilities - [`protoc`](https://grpc.io/docs/protoc-installation/) and [`protoc-gen-elm`](https://github.com/andreasewering/protoc-gen-elm#installation)

2. Install `elm-grpc` and `elm-protocol-buffers`
```bash
elm install rosenbergm/elm-grpc
elm install eriktim/elm-protocol-buffers
```

3. [Generate types](https://github.com/andreasewering/protoc-gen-elm#installation) with `protoc-gen-elm`

4. Take a look at [`Main.elm`](client/src/Main.elm) to see how to write the necessary code for interacting with a gRPC server! You'll better grasp it from a short example!
