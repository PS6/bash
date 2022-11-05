# use TAB not 8 spaces
SHELL=/bin/bash
identifier = keys-for-cloud-compute
vcs=vault-client
sp=secrets.protected
sy=secrets.yml
#first = start
#second = this
pwn:=$(shell pwd | sed -e 's/\//_/g')
ds:=$(shell date +%y%m%d%H%M%S)
pwfile=~/.ssh/remove-files-at-logout/pw$(pwn)
av=cat lpw | ansible-vault
ap=cat lpw | ansible-playbook
vs=--vault-id $(identifier)@$(vcs)
vc=./$(vcs)

$(sp):
        $(av) create $(vs) $(sy)
        chmod 400 $(sy)
        reset

$(sy):
        [ -f $(sp) ] && cp $(sp) $(sy)
        chmod 400 $(sy)

edit: secrets.yml lpw
        chmod 600 secrets.yml
        $(av) $@ $(vs) secrets.yml
        chmod 400 secrets.yml
        cp $(sy) $(sp).$(ds)
        reset

$(vcs):
        ln -s ../.ssh/$(vcs).sh $@

$(pwfile): $(vcs)
        @echo "type the password and use make clean before logout"
        $(vc) secrets.yml $(identifier) > $@
        chmod 400 $@
# $@ expands to label

lpw: $(pwfile)
        ln -s $(pwfile) $@

view: lpw $(sy)
        $(av) $@ $(vs) secrets.yml

plan:
        $(ap) -v --connection=local -i hosts-inventory.txt -l localhost $(vs) tf-$@.yml

build:
        $(ap) -v --connection=local -i hosts-inventory.txt -l localhost $(vs) tf-$@.yml

# make play book=update.yml target=ts
play:
        $(ap) -i hosts-inventory.txt -l $(target) $(vs) $(book)

# make random user=ubuntu seed=abc123
random: $(pwfile)
        @cat $(pwfile) | $(vc) $(user) $(seed)

keygen:
        make play book=echo-password.yml target=localhost

echo: lpw
        cat lpw

hint: lpw
        echo "S...0"

clean:
        [ -f $(pwfile) ] && rm $(pwfile) || true
        [ -f $(vcs) ] && rm $(vcs) || true
        [ -f $(sy) ] && rm $(sy) || true
        cp $(shell ls -1 secrets.protected.* | tail -1) $(sp)
        touch lpw
        rm lpw
