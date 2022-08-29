docker run -it --rm \
    --env-file "$(pwd)/aws.env" \
    -v "$(pwd)/airnodes/demo/v072/config:/app/config" \
    -v "$(pwd)/airnodes/demo/v072/output:/app/output" \
    api3/airnode-deployer:0.7.2 deploy
