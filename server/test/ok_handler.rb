with_server(1337, [fixture('ok_handler.go')]) do |expect|
  expect.running
end
