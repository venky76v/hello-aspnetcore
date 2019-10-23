FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ["HelloAspNetCore.csproj", "./"]
RUN dotnet restore "./HelloAspNetCore.csproj"
COPY . .
RUN dotnet build "HelloAspNetCore.csproj" -c Release -o /app

FROM build as publish
RUN dotnet publish "HelloAspNetCore.csproj" -c Release -o /app

FROM base as final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT [ "dotnet", "HelloAspNetCore.dll" ]