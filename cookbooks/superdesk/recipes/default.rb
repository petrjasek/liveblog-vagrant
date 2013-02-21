apt_today = "/var/log/apt-%s" % Date.today.to_s
execute "apt-get update && touch %s" % apt_today do
    # update apt once a day
    creates apt_today
end

package "git"
package "python3"
package "default-jre"

execute "git clone git://github.com/sourcefabric/Ally-Py.git /vagrant/ally-py" do
    creates "/vagrant/ally-py"
end

execute "git clone git://github.com/sourcefabric/Superdesk.git /vagrant/superdesk" do
    creates "/vagrant/superdesk"
end

directory "/vagrant/ally-py/superdesk"

execute "cp -r /vagrant/superdesk/* /vagrant/ally-py/superdesk/" do
    creates "/vagrant/ally-py/superdesk/README"
end

execute "/vagrant/ally-py/superdesk/build-eggs" do
    cwd "/vagrant/ally-py/superdesk"
    creates "/vagrant/ally-py/superdesk/distribution/components"
end

app_path = "/vagrant/ally-py/superdesk/distribution/application.py"
cwd_path = File.dirname(app_path)

execute "python3 %s -dump" % app_path do
    cwd cwd_path
end

service "superdesk" do
    action :start
    start_command "python3 %s &" % app_path
end
