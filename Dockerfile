FROM openjdk:8-jdk-alpine

ADD target/config-server.jar .
ENTRYPOINT [ "java", "-jar", "/config-server.jar" ]

EXPOSE 8084