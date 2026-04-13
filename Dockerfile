# Stage 1: Build the application
# Use the official Maven image which comes with Temurin 17
FROM maven:3.8.5-eclipse-temurin-17 AS build
WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests

# Stage 2: Create the final lightweight image
# Use the Eclipse Temurin runtime image
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Copy the JAR from the build stage
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
