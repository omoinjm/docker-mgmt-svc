docker build -t dev-container .

docker stop devc && docker rm devc

docker run -it --name devc -v $(pwd):/workspace --entrypoint /workspace/scripts/setup-ohmyzsh.sh dev-container
