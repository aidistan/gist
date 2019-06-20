desc 'setup ISATAP for IPv6 over IPv4 tunnel on Fedora in Tsinghua'
task 'ipv6' do
  remote_ip = `host isatap.tsinghua.edu.cn`.split(' ')[-1]
  local_ip  = `hostname -i`.split(' ').select { |ip| ip =~ /^166\.111\.130/ }.first
  system("
    sudo ip tunnel del sit1
    sudo ip tunnel add sit1 mode sit remote #{remote_ip} local #{local_ip}
    sudo ifconfig sit1 up
    sudo ifconfig sit1 add 2402:f000:1:1501:200:5efe:#{local_ip}/64
    sudo ip route add ::/0 via 2402:f000:1:1501::1 metric 1
  ")
end
