e = execute "apt-get update" do
    action :nothing
end
e.run_action(:run)

package "git"
package "python"
package "python-pip"
package "mongodb"

execute "git clone --branch #{node.web_branch} #{node.web_repo} web" do
    cwd "/vagrant/"
    creates "/vagrant/web"
end

execute "pip install -r requirements.txt" do
    cwd "/vagrant/web"
end

service "superdesk-web" do
    provider Chef::Provider::Service::Upstart
    supports :restart => true, :start => true, :stop => true
end

template "/etc/init/superdesk-web.conf" do
    source "superdesk-web.conf.erb"
    notifies :restart, "service[superdesk-web]"
    owner "root"
    group "root"
    mode "0644"
    variables({
        :app => "/vagrant/web/manage.py",
        :db => "mongodb",
    })
end

service "superdesk-web" do
    action [:enable, :start]
end
