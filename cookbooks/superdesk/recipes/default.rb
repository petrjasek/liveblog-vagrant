execute "apt-get update" do
    action :nothing
    not_if "which git && which python3 && which java"
end

package "git"
package "python3"
package "default-jre"

execute "git clone --depth=3 --branch #{node.ally.branch} #{node.ally.repo} /vagrant/ally-py" do
    creates "/vagrant/ally-py"
end

execute "git clone --depth=3 --branch #{node.superdesk.branch} #{node.superdesk.repo} /vagrant/ally-py/superdesk" do
    creates "/vagrant/ally-py/superdesk"
end

execute "build-eggs" do
    command "./build-eggs"
    cwd "/vagrant/ally-py/superdesk"
end

app_path = "/vagrant/ally-py/superdesk/distribution/application.py"

execute "python3 #{app_path} -dump" do
    cwd File.dirname(app_path)
end

service "superdesk" do
    action :start
    start_command "python3 #{app_path} &"
end
