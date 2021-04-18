#FROM maven:3.6.3-openjdk-8-slim AS build
#RUN mkdir /project
#COPY . /project
#WORKDIR /project
#RUN mvn clean package -DskipTests

FROM openjdk:8-jdk-alpine

RUN mkdir /app
COPY /target/config-server.jar /app/config-server.jar
WORKDIR /app

ENTRYPOINT [ "java", "-jar", "/config-server.jar" ]

EXPOSE 8084