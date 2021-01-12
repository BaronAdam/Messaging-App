# Messaging-App
Engineer's degree application.

## Adding migrations
```bash
cd Messaging-App.Infrastructure
dotnet ef --startup-project ../Messaging-App.Api/ migrations add [name]
```
## Docker
```
docker-compose up -d
```
## Flutter: build runner
```bash
flutter packages pub run build_runner build
```
