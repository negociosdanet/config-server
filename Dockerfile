#FROM maven:3.6.3-openjdk-8-slim AS build
#RUN mkdir /project
#COPY . /project
#WORKDIR /project
#RUN mvn clean package -DskipTests

FROM openjdk:8-jdk-alpine

RUN mkdir /app
WORKDIR /app

RUN addgroup --system javauser && adduser -S -s /bin/false -G javauser javauser
RUN chown -R javauser:javauser /app
USER javauser

COPY /target/config-server.jar /app
COPY /.docker/entrypoint.sh /app

ENTRYPOINT [ "sh", "/app/entrypoint.sh" ]
CMD [ "/bin/bash" ]

EXPOSE 8080