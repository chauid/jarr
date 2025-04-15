FROM eclipse-temurin:17-jdk-alpine
ARG JAR_FILE=./build/libs/*.jar
COPY ${JAR_FILE} ./
ENTRYPOINT [ "java", "-jar", "./*.jar" ]