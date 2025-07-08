module.exports = {
  apps: [
    {
      name: 'picmory',
      script: './dist/main.js',
      instances: 2,
      exec_mode: 'cluster',
      wait_ready: true, // new_process ready
      listen_timeout: 50000, // new_process ready timeout, 1600ms -> 50000ms
      kill_timeout: 5000, // old_process 강제종료 timeout, 1600ms -> 5000ms
    },
  ],
};
