include_recipe 'apt'
include_recipe 'python'

directory '/tmp/deploy' do
  owner 'ubuntu'
  recursive true
end

directory node['app']['mimic_path'] do
  owner node['app']['user']
  recursive true
end

template '/tmp/deploy/start_mimic.sh' do
  source 'start_mimic.sh.erb'
  mode '0700'
end

package 'python-dev' do
  action :install
end

package 'libffi-dev' do
  action :install
end

package 'libssl-dev' do
  action :install
end

user node['app']['user'] do
  system true
end

directory '/home/mimic' do
  owner node['app']['user']
  mode '0755'
  action :create
end

python_virtualenv node['app']['virtualenv'] do
  owner node['app']['user']
  action :create
end

python_pip 'mimic' do
  virtualenv node['app']['virtualenv']
end

execute 'starts mimic' do
  command './tmp/deploy/start_mimic.sh'
end
