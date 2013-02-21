Live Blog via Vagrant
=====================

This is automatic install for Liveblog via [Vagrant](http://vagrantup.com).

You will need to have `git` installed and [virtualbox with vagrant](http://docs.vagrantup.com/v1/docs/getting-started/index.html).

### Run Live Blog

    git clone git://github.com/petrjasek/superdesk-vagrant.git live-blog
    cd live-blog
    vagrant up

It will take some time at first - it downloads virtual box for ubuntu precise
and fetches live blog code from github. Once it finishes you will be able to access
Live Blog via web browser on `http://localhost:8080/content/lib/core/start.html`
