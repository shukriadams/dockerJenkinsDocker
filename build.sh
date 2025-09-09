set -e

DOCKERPUSH=0
while [ -n "$1" ]; do 
    case "$1" in
    --dockerpush) 
        DOCKERPUSH=1 ;; 
    esac 
    shift
done

docker build -t shukriadams/dockerjenkinsdocker .
echo "container built"

if [ $DOCKERPUSH -eq 1 ]; then
    echo "starting docker push"
    TAG=$(git describe --tags --abbrev=0) 
    echo "Tag ${TAG} detected"

    docker tag shukriadams/dockerjenkinsdocker:latest shukriadams/dockerjenkinsdocker:"${TAG}"
    docker push shukriadams/dockerjenkinsdocker:$TAG
fi

echo "build complete"