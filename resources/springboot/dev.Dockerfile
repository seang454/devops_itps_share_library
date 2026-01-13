# Stage 1: Build with Gradle
ARG GRADLE_VERSION=7.6
FROM gradle:${GRADLE_VERSION} AS builder
WORKDIR /app

# Copy only necessary files for build
COPY build.gradle ./build.gradle
COPY settings.gradle ./settings.gradle
COPY src ./src

# Build the project (skip tests)
RUN gradle build -x test

# Stage 2: Runtime with Eclipse Temurin (modern Java)
FROM eclipse-temurin:17-jdk-slim
ARG PORT=8080
ENV PORT=${PORT}

WORKDIR /app

# Copy built jar from builder
COPY --from=builder /app/build/libs/*.jar app.jar

# Volume for file storage
VOLUME [ "/app/filestorage/images" ]

# Expose port
EXPOSE 8080

# Run Spring Boot 
ENTRYPOINT ["java", "-jar", "app.jar", "--server.port=${PORT}"]