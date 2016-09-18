with_server(1337, [fixture('bad_handler.go')]) do |expect|
  expect.not_running
end
