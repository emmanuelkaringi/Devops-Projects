# Basic Dockerfile
This project demonstrates how to create a basic Docker image that outputs a personalized greeting message. The goal is to provide a simple introduction to working with Dockerfiles, including how to pass arguments during the build process and utilize environment variables within a Docker container.

## Prerequisites
1. **Docker** - Make sure docker is installed on your system. You can use this [guide](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04) for Ubuntu.
2. **Basic Knowledge of Docker** - Familiarity with Docker concepts like images, containers, Dockerfiles, and basic Docker commands. Use this [official guide](https://docker-curriculum.com/).

## Step 1 - Create a `Dockerfile`
1. Create a new file named `Dockerfile` in your project root directory:

    `nano Dockerfile`
2. Add the following content:
    ```
    FROM alpine:latest

    ARG NAME=World

    ENV NAME=$NAME

    CMD echo "Hello, $NAME!"
    ```
**Explanation:**

- `FROM alpine:latest` Specifies that the base image should be the latest version of Alpine linux.
- `ARG NAME=World` Defines a build-time argument `NAME` with a default value `world`. This allows you to pass a custom name when building the image. You can read more about `ARGs` [here](https://kodekloud.com/blog/docker-build-args/#:~:text=Understanding%20the%20ARG%20instruction,-In%20a%20Dockerfile&text=Here%2C%20is%20the,variables%20during%20the%20build%20process.).
- `ENV NAME=$NAME` Sets the environment variable `NAME` using the build-time argument `ARG`.
- `CMD echo "Hello, $NAME!"` Sets the command that will be run when the docker starts.

## Step 2 - Build & Run the Docker container
1. Build the Docker image, providing a custom name as an argument:

    `docker build --build-arg NAME=yourname -t hello-docker .`

**Explanation:**

- `--build-arg NAME=yourname` Passes the value "yourname" as the `NAME` argument.
- `-t hello-docker .` Tags the image with the name `hello-docker` and specifies that the Dockerfile is in the current directory.

2. Run the docker container:

    `docker run hello-docker`

## Step 3 - Clean Up
1. Remove the docker image when you are done:

    `docker rmi hello-docker` use `docker rmi -f hello-docker` if the first command fails.