pipeline {
  agent any

  parameters {
    string(name: 'DOCKER_REGISTRY', defaultValue: 'nt548', description: 'Image prefix or registry namespace.')
    string(name: 'IMAGE_TAG', defaultValue: 'lab2-local', description: 'Image tag used by Docker and kind.')
    string(name: 'KUBE_CONTEXT', defaultValue: 'kind-nt548-lab2', description: 'kubectl context used for kind deployment.')
    string(name: 'TRIVY_SEVERITY', defaultValue: 'HIGH,CRITICAL', description: 'Trivy severities to report.')
    string(name: 'TRIVY_EXIT_CODE', defaultValue: '0', description: 'Set to 1 to fail Jenkins on Trivy findings.')
    string(name: 'SONAR_HOST_URL', defaultValue: '', description: 'Optional SonarQube server URL.')
    password(name: 'SONAR_TOKEN', defaultValue: '', description: 'Optional SonarQube token.')
    booleanParam(name: 'DEPLOY_TO_KIND', defaultValue: false, description: 'Deploy to the local kind cluster after image build.')
  }

  environment {
    SERVICES = 'api-gateway auth-service catalog-service order-service'
    DOCKER_REGISTRY = "${params.DOCKER_REGISTRY}"
    IMAGE_TAG = "${params.IMAGE_TAG}"
    KUBE_CONTEXT = "${params.KUBE_CONTEXT}"
    TRIVY_SEVERITY = "${params.TRIVY_SEVERITY}"
    TRIVY_EXIT_CODE = "${params.TRIVY_EXIT_CODE}"
    SONAR_HOST_URL = "${params.SONAR_HOST_URL}"
    SONAR_TOKEN = "${params.SONAR_TOKEN}"
    DEPLOY_TO_KIND = "${params.DEPLOY_TO_KIND}"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Install') {
      steps {
        sh 'npm ci'
      }
    }

    stage('Test Services') {
      steps {
        sh 'npm test --workspaces --if-present'
      }
    }

    stage('SonarQube Scan') {
      steps {
        sh '''
          if [ -z "${SONAR_HOST_URL:-}" ] || [ -z "${SONAR_TOKEN:-}" ]; then
            echo "Skipping SonarQube scan because SONAR_HOST_URL or SONAR_TOKEN is not set."
            exit 0
          fi

          for service in $SERVICES; do
            (cd "services/$service" && npx --yes sonar-scanner \
              -Dsonar.host.url="$SONAR_HOST_URL" \
              -Dsonar.token="$SONAR_TOKEN")
          done
        '''
      }
    }

    stage('Docker Build') {
      steps {
        sh 'node scripts/build-images.js'
      }
    }

    stage('Trivy Image Scan') {
      steps {
        sh '''
          if ! command -v trivy >/dev/null 2>&1; then
            echo "Skipping Trivy image scan because trivy is not installed."
            exit 0
          fi

          for service in $SERVICES; do
            trivy image \
              --severity "$TRIVY_SEVERITY" \
              --exit-code "$TRIVY_EXIT_CODE" \
              "$DOCKER_REGISTRY/$service:$IMAGE_TAG"
          done
        '''
      }
    }

    stage('Deploy to kind') {
      when {
        expression {
          return env.DEPLOY_TO_KIND == 'true'
        }
      }
      steps {
        sh '''
          kubectl config use-context "$KUBE_CONTEXT"

          if command -v kind >/dev/null 2>&1; then
            for service in $SERVICES; do
              kind load docker-image "$DOCKER_REGISTRY/$service:$IMAGE_TAG" --name nt548-lab2
            done
          fi

          kubectl apply -k deploy/k8s/overlays/dev

          for service in $SERVICES; do
            kubectl -n nt548-lab2 rollout status "deployment/$service" --timeout=120s
          done
        '''
      }
    }
  }
}
