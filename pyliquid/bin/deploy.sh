docker run -it --rm \
    --env-file "$(pwd)/pyliquid/aws.env" \
    -v "$(pwd)/pyliquid/dev/v072_config:/app/config" \
    -v "$(pwd)/pyliquid/output:/app/output" \
    api3/airnode-deployer:0.7.2 deploy
