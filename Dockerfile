#FROM maven:3.6.3-openjdk-8-slim AS build
#RUN mkdir /project
#COPY . /project
#WORKDIR /project
#RUN mvn clean package -DskipTests

FROM openjdk:8-jdk-alpine

RUN mkdir /app
WORKDIR /app

COPY /target/config-server.jar /app/config-server.jar
COPY /.docker/entrypoint.sh /app/entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

EXPOSE 8084