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
            def AWS_ACCESS_KEY_ID="ASIASJCHX6HEX7N5WMR7"
            def AWS_SECRET_ACCESS_KEY="a/ZqWw2OK4QFwqsW4qDmKLJnDKFJnjBJSPlska9L"
            def AWS_SESSION_TOKEN="IQoJb3JpZ2luX2VjEBcaCmFwLXNvdXRoLTEiRzBFAiAfNRVPa7OMEm5r6ZvBYE2r8/ALmc0T8XCu5VhxN/nJsQIhAJpjENQae3iruxMqB3LncCMuHtAHJYQ0UJSBbmZvqmgYKpYDCEAQABoMMTU2OTE2NzczMzIxIgyKIjDbf6X+5JpBVREq8wKissKaxkWofmqZOw21YRS7UdqJQ1vn7/Re99vj19RBvPSLggHacQDsqg0GDuv8Q4eFUkRuGdUQJydfF9FJopwUQBr6VgLh2HR1oAtgk1RqChmQvUOOod/A3myWQUsekeVmDZBl19qFJnQCWmoF0PCDfkRBALW8e/SYnn2W0NN4RSKWTZVIak+Ti44M3XkYwlBCueBtzW78wZxDuJct4WCP8IRklhAcM1MTodYA6/DkxUwjbRxUKq4nVrwKYEo+1ytD9M0iSQ/NWx0i03YQ1r2q9NJ1kanYlKJx2v5MXqfbQ1uG6Qk9tTnPEnZ/Vk10udsDTaRyX11hub4PdaPfgy67ndTHh8BfDtTxWSLx3FnsCL2UNt7f8dUokx2JNvfTnb4HSELD6osD4Jx4a/6FB/HnLj5TKIlVM0VxMgH2jZNsxrdF/NTAlBaEEbv/yOYUtAShrkMv/p5bUgIOBhXHoufr/YGi4VteH72/DNTRXcEvMfm5LDD31ozEBjqmAdytnAyvnhlCG8+fNpulcz80iupRNVNvYb6bJ1Elc/z3gOQo+KHUVUA9gF+qS8uZyelLIvygxZyaFVpD3I5nFi0l2ql4O4bfWKcHnVl3rEYcVS0my4RfxioIbqgr6sfWtQd4hz5myTHewQjmRxbu9WSwtWqjuswmQpThYg30CVxZFl4zMw8qRwduluAFiAqmlmTBQmjkoWxMgxaDe+E3wJ3c3AQKWw0="
            
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
