require 'net/telnet'
conn = Net::Telnet.new('Host' => '192.168.1.107', 'Port' => '8899', 'Timeout' => 20, "Prompt" => /^OK$/)
conn.cmd("VERSION") { |c| print c }
conn.cmd("SCAN 1 text") { |c| print c }
