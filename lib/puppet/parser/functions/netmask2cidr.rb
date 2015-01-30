##
## netmask2cidr
##
module Puppet::Parser::Functions
  newfunction(:netmask2cidr, :type => :rvalue, :doc => <<-EOS
This function Returns cidr value of netmask provided.
    EOS
  ) do |args|

    require 'ipaddr'

    raise(Puppet::ParseError, "netmask2cidr(): Wrong number of arguments " +
          "given (#{args.size} for 1)") if args.size != 1

	IPAddr.new(args[0]).to_i.to_s(2).count("1")
  end
end

# vim:sts=2 sw=2

