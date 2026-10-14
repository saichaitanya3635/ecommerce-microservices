# ---------- Stage 1: Build (kitchen) ----------
FROM eclipse-temurin:21-jdk AS build
WORKDIR /build

COPY .mvn .mvn
COPY mvnw pom.xml ./
RUN ./mvnw -q dependency:go-offline

COPY src src
RUN ./mvnw -q -DskipTests package && cp target/*.jar app.jar

# ---------- Stage 2: Runtime (tiffin box) ----------
FROM eclipse-temurin:21-jre-alpine

RUN addgroup -S app && adduser -S app -G app
WORKDIR /app
COPY --from=build /build/app.jar app.jar
USER app

EXPOSE 8080
ENV JAVA_TOOL_OPTIONS="-XX:MaxRAMPercentage=75 -XX:+ExitOnOutOfMemoryError"
ENTRYPOINT ["java", "-jar", "app.jar"]