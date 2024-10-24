FROM alpine:latest

ARG NAME=World

ENV NAME=$NAME

CMD echo "Hello, $NAME!"