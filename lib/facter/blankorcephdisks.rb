Facter.add('blankorcephdisks') do
  setcode do
    Facter.value(:blockdevices).split(/,/).select { |disk| Facter::Util::Resolution.exec("sudo parted -s /dev/#{disk} print | grep -A100 'Number.*Start.*End' | grep -P '^[\\s\\t]*[0-9]'| grep -vP '^[\\s\\t]+[0-9]+.*ceph'").empty? }.join(',')
  end
end
