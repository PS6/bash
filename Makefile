SHELL=/bin/bash
secrets = secrets.yml
identifier = keys-for-cloud-compute
#first = start
#second = this
pwfile=~/.ssh/remove-files-at-logout/pw22175
av=cat $(pwfile) | ansible-vault
ap=cat $(pwfile) | ansible-playbook
vs=--vault-id $(identifier)@vault-client.sh
vc=./vault-client.sh

lpwd:

init:
        @echo "type the password and use make clean before logout"
        $(vc) $(secrets) $(identifier) > $(pwfile)
        chmod 400 $(pwfile)
# $@ expands to label
create:
        $(av) $@ $(vs) $(secrets)
        chmod 400 $(secrets)
        reset

edit:
        chmod 600 $(secrets)
        $(av) $@ $(vs) $(secrets)
        chmod 400 $(secrets)
        reset

view:
        $(av) $@ $(vs) $(secrets)

plan:
        $(ap) -v --connection=local -i hosts-inventory.txt -l localhost $(vs) tf-$@.yml

build:
        $(ap) -v --connection=local -i hosts-inventory.txt -l localhost $(vs) tf-$@.yml

# make play book=update.yml target=ts
play:
        $(ap) -i hosts-inventory.txt -l $(target) $(vs) $(book)

# make random user=ubuntu seed=abc123
random:
        @cat $(pwfile) | $(vc) $(user) $(seed)

echo: lpwd
        cat $(pwfile)

hint: lpwd
        echo "r...2"

clean: lpwd
        rm $(pwfile)
