require 'chef'
require 'CSV'

Chef::Config.from_file('/Users/kevinreedy/.chef/knife.rb')
chef = Chef::ServerAPI.new(Chef::Config[:chef_server_url])

query = Chef::Search::Query.new

return_fields = {
  fqdn: ['fqdn'],
  ip_address: ['ipaddress'],
  mac_address: ['macaddress'],
  # chef_env
  cpu_cores: ['cpu', 'total'],
  memory: ['memory', 'total'],
  chef_version: ['chef_packages', 'chef', 'version']
}

# TODO: paginate?
results = query.search(:node, '*:*', filter_result: return_fields).first

output = CSV.generate(headers: true) do |csv|
  # Get Headers
  csv << return_fields.keys

  results.each do |r|
    csv << r.values
  end
end

puts output
# require 'pry'
# binding.pry
