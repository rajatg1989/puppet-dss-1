#
# fact that determines the role based on hostname
#
Facter.add(:jiocloud_role) do
  setcode do
    Facter.value(:hostname).gsub(/^([a-z]+)\d+(-.*)?/, '\1')
  end
end
