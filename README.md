# 📡 elm-grpc

elm-grpc allows you to communicate with gRPC using gRPC-web purely from Elm. That means no ports and no libraries that add _300 KB_ to your bundle size.

It uses the wonderful [`elm-protocol-buffers`](https://github.com/eriktim/elm-protocol-buffers) library and integrates with fully-generated types from [`protoc-gen-elm`](https://github.com/andreasewering/protoc-gen-elm).

> ⚠️ This library is under very heavy development and currently implements only basic features of gRPC-web.

## 📥 Installation

```bash
elm install rosenbergm/elm-grpc
# If you're not a masochist, install protoc-gen-elm as well to generate all the necessary code.
yarn global add protoc-gen-elm
```

## 📋 Usage

1. Generate Elm types, encoders and decoders from Proto files
```bash
protoc --elm_out=. api.proto
``` 
2. Go to the [example](example)! The best way to find out how this library works is to see it in action!

## 🙏 Special thanks

Thanks to [@michaljanocko](https://github.com/michaljanocko) for introducing me to Elm (and FP in general) a few years ago. It changed my whole perspective on writing code.