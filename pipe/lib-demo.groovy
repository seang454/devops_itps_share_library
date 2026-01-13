@Library('devop_itp_share_library@master') _
pipeline {
    agent any

    environment {
        TELEGRAM_BOT_TOKEN = '8575107181:AAFjRvEXC77DFm5BuBKTZVBlQ9QZppFSq1k'
        TELEGRAM_CHAT_ID  = '1707535552'
    }

    stages {
        stage('Demo Stage') {
            steps {
                echo 'This is a demo pipeline using shared library.'
            }
        }

        stage('Send Telegram Notification') {
            steps {
                script {
                    def message = "Demo Pipeline executed successfully\\!"
                    sendTelegramMessage("${message}", "${TELEGRAM_BOT_TOKEN}", "${TELEGRAM_CHAT_ID}")
                }
            }
        }
    }
}
