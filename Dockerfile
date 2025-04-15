FROM eclipse-temurin:17-jdk-alpine
ARG JAR_FILE=./build/libs/*SNAPSHOT.jar
COPY ${JAR_FILE} ./
ENTRYPOINT [ "java", "-jar", "./*SNAPSHOT.jar" ]