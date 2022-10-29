FROM maven as build
WORKDIR /app
COPY . .
RUN mvn install

FROM openjdk:11
WORKDIR /app
COPY --from=build /app/target/*.jar /app/app.jar
EXPOSE 9090
CMD ["java", "-jar", "app.jar"]
