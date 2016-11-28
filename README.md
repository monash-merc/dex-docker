# Dex docker container build instructions

1. Clone this repository
2. Build the image: `docker build .`
3. Run the image, mounting the directory containing `config.yaml` to `/mnt` and expose port 5556: `docker run -d --name dex -p 5556:5556 -v /path/to/config/:/mnt <image_id>`
