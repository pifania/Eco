# Estágio 1: Compilação com Maven e JDK 17
FROM maven:3.8.5-openjdk-17-slim AS build
WORKDIR /app
COPY pom.xml .
# Baixar dependências em cache
RUN mvn dependency:go-offline -B
COPY src ./src
# Compilar projeto pulando testes para agilizar o deploy
RUN mvn package -DskipTests -B

# Estágio 2: Imagem final de execução mais leve com JRE 17
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
# Porta exposta padrão, mas o Render escuta dinamicamente no $PORT
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
