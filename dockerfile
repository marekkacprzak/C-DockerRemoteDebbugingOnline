# Use the official image as a parent image.
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
#install debugger for NET Core
RUN apt-get update
RUN apt-get install -y unzip
RUN curl -sSL https://aka.ms/getvsdbgsh | /bin/sh /dev/stdin -v latest -l ~/vsdbg
EXPOSE 5000
RUN mkdir /work/
WORKDIR /work/

COPY *.csproj /work/
RUN dotnet restore

COPY ./ /work/
RUN mkdir /out/
RUN dotnet publish -p:PublishReadyToRun=true  -o out -c Release 

CMD dotnet run learn
###########START NEW IMAGE###########################################
# Build runtime image
FROM mcr.microsoft.com/dotnet/runtime:8.0 as prod

RUN mkdir /app/
WORKDIR /app/
COPY --from=build-env /out/ /app/
RUN chmod +x /app/ 
CMD dotnet Learn.dll

# Start the app
#ENTRYPOINT ["dotnet", "Learn.dll"]
#CMD ["bash"]
