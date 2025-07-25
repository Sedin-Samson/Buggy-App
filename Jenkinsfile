pipeline {
    agent any

    environment {
        AWS_REGION         = credentials('AWS_REGION')
        ECR_REPO           = credentials('ECR_REPO')
        SECRET_KEY_BASE    = credentials('SECRET_KEY_BASE')
        DB_PASSWORD        = credentials('DB_PASSWORD')
        DB_USER            = credentials('DB_USER')
        DB_NAME            = credentials('DB_NAME')
        DB_HOST            = credentials('DB_HOST')
        ECR_ACCOUNT_ID     = credentials('ECR_ACCOUNT_ID')
        AWS_ACCESS_KEY_ID  = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_SESSION_TOKEN  = credentials('AWS_SESSION_TOKEN')
        RAILS_ENV          = credentials('RAILS_ENV')
        IMAGE_TAG          = "samson/buggyapp:${env.BUILD_NUMBER}"
        ECR_IMAGE          = "${ECR_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${IMAGE_TAG}"
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo "Cloning source code from GitHub with credentials"
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/master']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/Sedin-Samson/Buggy-App.git',
                        credentialsId: 'acf2c1bd-dad9-44bf-8012-a65d773edc07'
                    ]]
                ])
            }
        }

        stage('Build App Image') {
            steps {
                script {
                    echo "Building app image using Dockerfile.app"
                    sh "docker build -f Dockerfile.app -t ${ECR_IMAGE} ."
                }
            }
        }

        stage('Login to ECR') {
            steps {
                script {
                    echo "Logging in to ECR securely using credentials"
                    sh """
                        export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
                        export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
                        export AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN}
                        aws ecr get-login-password --region ${AWS_REGION} | \
                        docker login --username AWS --password-stdin ${ECR_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                    """
                }
            }
        }

        stage('Push Image to ECR') {
            steps {
                script {
                    sh "docker push ${ECR_IMAGE}"
                }
            }
        }

        stage('Generate .env Files') {
            steps {
                script {
                    writeFile file: '.env', text: "ECR_IMAGE=${ECR_IMAGE}\n"
                    writeFile file: '.env.db.production', text: """
                        MYSQL_ROOT_PASSWORD=${DB_PASSWORD}
                        MYSQL_DATABASE=${DB_NAME}
                        MYSQL_USER=${DB_USER}
                        MYSQL_PASSWORD=${DB_PASSWORD}
                    """.stripIndent()

                    writeFile file: '.env.web.production', text: """
                        RAILS_ENV=${RAILS_ENV}
                        DB_HOST=${DB_HOST}
                        DB_NAME=${DB_NAME}
                        DB_USER=${DB_USER}
                        DB_PASSWORD=${DB_PASSWORD}
                        SECRET_KEY_BASE=${SECRET_KEY_BASE}
                    """.stripIndent()
                }
            }
        }

        stage('Restart Docker Compose Services') {
            steps {
                script {
                    sh """
                        docker compose down
                        docker compose up -d --build
                    """
                }
            }
        }
    }

    post {
        always {
            echo 'Clean up local image (optional)'
            // sh "docker rmi ${ECR_IMAGE}" // Uncomment if needed
        }
    }
}
