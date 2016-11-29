default[:nginx] = {
  worker_processes: node[:cpu][:total],
  worker_rlimit_nofile: 1024 * 3,
  worker_connections: 1024,
}
