# Etapas multi-stage para construir y ejecutar la aplicación ASP.NET Core (.NET 10)
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Copia sólo el proyecto para aprovechar el cache de restore
COPY ["ProyectoEjemploMVC/ProyectoEjemploMVC.csproj", "ProyectoEjemploMVC/"]
RUN dotnet restore "ProyectoEjemploMVC/ProyectoEjemploMVC.csproj"

# Copia el resto del código y publica en Release
COPY . .
WORKDIR "/src/ProyectoEjemploMVC"
RUN dotnet publish "ProyectoEjemploMVC.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Imagen runtime ligera
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app
ENV ASPNETCORE_URLS=http://+:80

COPY --from=build /app/publish .
EXPOSE 80

ENTRYPOINT ["dotnet", "ProyectoEjemploMVC.dll"]