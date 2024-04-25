module.exports = {
  /* apps 항목은 우리가 pm2에 사용할 옵션을 기재 */
  apps: [
    {
      name: 'picmory_fastify', // app이름
      script: './src/server.js', // 실행할 스크립트 파일
      instances: 1,
      exec_mode: 'cluster',
      wait_ready: true,
      listen_timeout: 50000,
      kill_timeout: 5000,
      env: {
        NODE_ENV: 'production',
      },
    },
  ],
};
