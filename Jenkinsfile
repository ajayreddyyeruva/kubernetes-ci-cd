node {

    checkout scm

    env.DOCKER_API_VERSION="1.23"
    
    sh "git rev-parse --short HEAD > commit-id"

    tag = readFile('commit-id').replace("\n", "").replace("\r", "")
    appName = "hello-kenzan"
    registryHost = "mindstreamorg/"
    imageName = "${registryHost}${appName}:${tag}"
    env.BUILDIMG=imageName

    stage "Build Image"
    
        sh "/usr/local/bin/docker build -t ${imageName} -f applications/hello-kenzan/Dockerfile applications/hello-kenzan"
    
    stage "Push Image"

        sh "/usr/local/bin/docker push ${imageName}"

    stage "Deploy Container"

        sh "sed 's#mindstreamorg/hello-kenzan:latest#'$BUILDIMG'#' applications/hello-kenzan/k8s/deployment.yaml | /usr/local/bin/kubectl apply -f -"
        sh "/usr/local/bin/kubectl rollout status deployment/hello-kenzan"
    
}
