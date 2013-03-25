e = execute "apt-get update" do
    action :nothing
end

e.run_action(:run)

# clone

package "git"

execute "git clone --branch #{node.ally_branch} #{node.ally_repo} ally-py" do
    cwd "/vagrant/"
    creates "/vagrant/ally-py"
end

execute "git clone --branch #{node.superdesk_branch} #{node.superdesk_repo} superdesk" do
    cwd "/vagrant/ally-py/"
    creates "/vagrant/ally-py/superdesk"
end

# build

package "python3"
package "python3-setuptools"

execute "/vagrant/ally-py/superdesk/build-eggs" do
    cwd "/vagrant/ally-py/superdesk/"
end

# setup

app = "/vagrant/ally-py/superdesk/distribution/application.py"

execute "python3 #{app} -dump" do
    cwd File.dirname(app)
end

# service

package "default-jre"
package "mongodb"

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
    })
end

# run

service "superdesk" do
    action [:enable, :start]
end
