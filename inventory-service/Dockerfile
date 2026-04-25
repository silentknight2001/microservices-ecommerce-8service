# Stage 1: Build
FROM eclipse-temurin:21-jdk-jammy AS build

WORKDIR /app

# Install necessary tools
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Copy Maven wrapper & config first (for caching)
COPY .mvn/ .mvn
COPY mvnw pom.xml ./

# Give execute permission
RUN chmod +x mvnw

# Download dependencies (cache layer)
RUN ./mvnw dependency:go-offline -B

# Copy source code
COPY src ./src

# Build application
RUN ./mvnw clean package -DskipTests


# Stage 2: Runtime
FROM eclipse-temurin:21-jre-jammy

WORKDIR /app

# Security updates
RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN useradd -m springuser
USER springuser

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-XX:MaxRAMPercentage=75.0", "-XX:+UseContainerSupport", "-jar", "app.jar"]