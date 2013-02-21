apt_today = "/var/log/apt-%s" % Date.today.to_s
execute "apt-get update && touch %s" % apt_today do
    # update apt once a day
    creates apt_today
end

package "git"
package "python3"
package "default-jre"

execute "git clone --depth=10 git://github.com/sourcefabric/Ally-Py.git /vagrant/ally-py" do
    creates "/vagrant/ally-py"
end

execute "git clone --depth=10 git://github.com/sourcefabric/Superdesk.git /vagrant/ally-py/superdesk" do
    creates "/vagrant/ally-py/superdesk"
end

execute "update-ally" do
    command "git pull"
    cwd "/vagrant/ally-py"
end

execute "update-superdesk" do
    command "git pull"
    cwd "/vagrant/ally-py/superdesk"
end

execute "build-eggs" do
    command "./build-eggs"
    cwd "/vagrant/ally-py/superdesk"
end

app_path = "/vagrant/ally-py/superdesk/distribution/application.py"

execute "python3 %s -dump" % app_path do
    cwd File.dirname(app_path)
end

service "superdesk" do
    action :start
    start_command "python3 %s &" % app_path
end
