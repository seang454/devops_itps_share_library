# ===============================
# Stage 1: Build with Gradle
# ===============================
ARG GRADLE_VERSION=7.6
FROM gradle:${GRADLE_VERSION} AS builder

WORKDIR /app

# Copy Gradle files first (better layer caching)
COPY build.gradle settings.gradle ./

# Copy source code
COPY src ./src

# Build the application (skip tests for CI speed)
RUN gradle clean build -x test


# ===============================
# Stage 2: Runtime (Java 17)
# ===============================
FROM eclipse-temurin:17-jre-jammy

ARG PORT=8080
ENV PORT=${PORT}

WORKDIR /app

# Copy fat jar from builder stage
COPY --from=builder /app/build/libs/*.jar app.jar

# Volume for uploaded/static files
VOLUME [ "/app/filestorage/images" ]

# Expose application port
EXPOSE 8080

# Run Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar", "--server.port=${PORT}"]
