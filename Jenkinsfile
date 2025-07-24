pipeline {
    agent any

    environment {
        AWS_REGION       = 'ap-south-1' 
        ECR_REPO         = 'samson/buggyapp'
        SECRET_KEY_BASE = '7bb3bd01f5fc5ad4d1d9a35c74eb27cf8d3159053100be50a38ebe2cc1e64ef6d99ca95bea1346da465a475f0d54aed5446f4f0cb9bf22850748eff33c827335'
        DB_PASSWORD = 'samson123'
        DB_USER = 'samson1'
        DB_NAME = 'myapp_production'
        DB_HOST = 'db'
        ECR_ACCOUNT_ID   = '156916773321' // Your AWS Account ID
        IMAGE_TAG        = "samson/buggyapp:${env.BUILD_NUMBER}"
        ECR_IMAGE        = "${ECR_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${IMAGE_TAG}"
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
                    echo "Building app image using local ruby-base:3.3.8"
                    sh "docker build  -f Dockerfile.app -t ${ECR_IMAGE} ."
                }
            }
        }

        stage('Login to ECR') {
    steps {
        script {
            echo "Logging in to ECR with hardcoded credentials (test only)"

            // Set your actual credentials here temporarily
            def AWS_ACCESS_KEY_ID="ASIASJCHX6HE6L62SSOL"
            def AWS_SECRET_ACCESS_KEY="SsDMMDO9LGKNdQgY+A/PTeSUXUKejAKyLM1yb3Ju"
            def AWS_SESSION_TOKEN="IQoJb3JpZ2luX2VjEAgaCmFwLXNvdXRoLTEiRjBEAiAdDf0BZFdL17puGopeYGwmJOHiSN0qW2Zi3dihO681wgIgAkbhBpo/teWRbB9cZst7g6ianC3QNOInaZMQ5m0apqIqlgMIMRAAGgwxNTY5MTY3NzMzMjEiDI2rWW0I9LvBczLaUirzAlZBoe7t3r2fnko+fP1JppB6dM4eLXNpFhwb5x4adtZYAn9QqbuJrfxwxFeBELtNzy0Xt+eVjWHb9sigzP860elgwcBEjRFs6Bj3DFb7neFC0VS2ZHVmR+tkAQah6r3VCPzL6/feORBoj/NtYVN9KzjuW238MHkrrU/jeD+qvfUHwkd7lJ+lZzrOmRrZlZyEfICE1vngDQagWrZVodsud0w6QO6MQUnj6ZEQZJAfZOkaz9v+T9qnMz6IVila/jMr23NgSBWPJJtAZ7+vrRYxOhJOQCaR/Rm2Ln0Tu2e6LduJStsNpFlA2zD0ovZ7DSzIuStKNfuGy+Uw9qFo+DE4Gm6l2vJrc2tliaUmIBcBpfXBqSxqg8Xt6avcsCa1LzVncKkPP9s7p+uUzpsfDtZEh2nmsI8Eu7Zyk9+2LYKb9QfBJ3Y5d0iFcdFDqK1tcCHR0G+buEoJ5j2MhwrCp/5xwSH9/8UTYz2rqazLFYzRyHa3ujfGMMusicQGOqcBqmWmXa9ioCwLnAHQYsaD83K+KUcL7m6NXzBfqzIikhXAKHu+yV84fN06Onr0keYG49Bf0cm8oFDHe1x5g4ZN9WPudLrQdVXWWzQg0oG95/5T0ot2LFVeBQ4ArtPGgMg3g1SpdkN4sKCqndv7gt3YUj8f+W0dEqqbw8ywwmOjtUAGF49SEoMLS6wE56LvqmKkNXSE8n3mfzIDCWzneM5yAaaDDhZ+oJ8="
            
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
        MYSQL_ROOT_PASSWORD=samson123
        MYSQL_DATABASE=myapp_production
        MYSQL_USER=samson1
        MYSQL_PASSWORD=samson123
      """.stripIndent()

      writeFile file: '.env.web.production', text: """
        RAILS_ENV=production
        DB_HOST=db
        DB_NAME=myapp_production
        DB_USER=samson1
        DB_PASSWORD=samson123
        SECRET_KEY_BASE=7bb3bd01f5fc5ad4d1d9a35c74eb27cf8d3159053100be50a38ebe2cc1e64ef6d99ca95bea1346da465a475f0d54aed5446f4f0cb9bf22850748eff33c827335
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
            //sh "docker rmi ${ECR_IMAGE}" // Uncomment if needed
        }
    }
}
