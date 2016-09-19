require 'socket'

with_server(1337, [fixture('handler_call.go')]) do |expect|
  if expect.running
    begin
      File.delete('/tmp/99d_test_handler_call')
    rescue Errno::ENOENT
    end

    payload = '{"timestamp": "2006-01-02T15:04:05Z", "level": 4}'
    packet = [payload.length].pack('n') + payload
    TCPSocket.open('localhost', 1337) { |s| s.send(packet, 0) }
    sleep 0.1

    expect.expect(File.read('/tmp/99d_test_handler_call') == 'called')
  end
end
