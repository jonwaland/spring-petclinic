# Stage 1: Build the application
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app

# Copy the pom.xml and source code
COPY pom.xml .
COPY src ./src

# Build the JAR file, skipping tests to save time (since GitHub Actions runs them anyway)
RUN mvn clean package -DskipTests

# Stage 2: Create the final lightweight image
FROM openjdk:17-jdk-slim
WORKDIR /app

# Copy the JAR from the build stage
# The PetClinic JAR is usually named 'spring-petclinic-3.x.x.jar' 
# We use a wildcard to make it easier
COPY --from=build /app/target/*.jar app.jar

# Expose the port the app runs on
EXPOSE 8080

# Command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
