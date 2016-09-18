with_server(3) do |pid|
  assert(Process.waitpid(pid, Process::WNOHANG) == pid)
  assert($?.exitstatus != 0)
end
