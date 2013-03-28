e = execute "apt-get update" do
    action :nothing
end

e.run_action(:run)

package "git"
package "python3"
package "python3-setuptools"
package "default-jre"
package "mongodb"

# clone

execute "git clone --branch #{node.ally_branch} #{node.ally_repo} ally-py" do
    cwd "/vagrant/"
    creates "/vagrant/ally-py"
end

execute "git clone --branch #{node.superdesk_branch} #{node.superdesk_repo} superdesk" do
    cwd "/vagrant/"
    creates "/vagrant/superdesk"
end

# setup

pattern = '/vagrant/{superdesk,ally-py}/**/setup.py'
paths = Dir.glob(pattern)
dirnames = paths.map { |path| File.dirname(path) }
pythonpath = '${PYTHONPATH}:' + (dirnames * ':')

app = "/vagrant/superdesk/distribution/application.py"

execute "python3 #{app} -dump" do
    cwd File.dirname(app)
    environment({
        'PYTHONPATH' => pythonpath,
    })
end

# service

service "superdesk" do
    provider Chef::Provider::Service::Upstart
    supports :restart => true, :start => true, :stop => true
end

template "/etc/init/superdesk.conf" do
    source "superdesk.conf.erb"
    notifies :restart, "service[superdesk]"
    owner "root"
    group "root"
    mode "0644"
    variables({
        :app => app,
        :pythonpath => pythonpath,
    })
end

# run

service "superdesk" do
    action [:enable, :start]
end
