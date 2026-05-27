# Estágio 1: Compilação com Maven e JDK 17
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
# Baixar dependências em cache
RUN mvn dependency:go-offline -B
COPY src ./src
# Compilar projeto pulando testes para agilizar o deploy
RUN mvn package -DskipTests -B

# Estágio 2: Imagem final de execução com JRE 17 (Temurin)
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
# Porta exposta padrão, mas o Render escuta dinamicamente no $PORT
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
