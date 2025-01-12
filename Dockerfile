# Use a multi-stage build to minimize the final image size

# Stage 1: Build the application using Maven
FROM maven:3.9.4-eclipse-temurin-17-alpine AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn dependency:go-offline
RUN mvn package -DskipTests

# Stage 2: Create the final image with a JRE
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar #Copy the jar
EXPOSE 8080 #Expose the port
CMD ["java", "-jar", "app.jar"]