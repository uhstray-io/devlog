# devlog
Uhstray.io Devlog Updates


# Install Go!
You can download Go from the [official Go website](https://go.dev/dl/).

# Install Hugo!
```bash
go install github.com/gohugoio/hugo@latest
```

# Install Risotto Theme
```bash
hugo mod get github.com/joeroe/risotto
```

# Run it 
## Production

Download the static-web-server
```bash
./get_sws.sh
```

It is recommended running the build and serve scripts separately after each git pull.
```bash
./build.sh
./serve.sh
```

## Development
```bash
hugo server -D
```


## Deploy with docker
```bash
docker compose up -d --build
```

## Docker Compose Down
```bash
docker compose down
```