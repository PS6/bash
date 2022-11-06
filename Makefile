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

all: copy init
        @echo $@

$(sp): lpw
        @echo $@
        [ -f $(sp) ] && created=ready

copy:
        @echo $@
        [ -f $(sp) ] && cp $(sp) $(sp).$(ds)
        [ -f $(sp) ] && touch $(sp)

create: lpw
ifndef created
        @echo $@
        $(av) create $(vs) $(sy)
        cp $(sy) $(sp).$(ds)
endif

$(sy): copy
        @echo $@
        [ -f $(sp) ] && cp $(sp) $(sy)

edit: lpw $(sy)
        @echo $@
        $(av) $@ $(vs) $(sy)
        cp $(sy) $(sp).$(ds)
        cp $(sy) $(sp)
        reset

$(vcs):
        @echo $@
        [ -f $(vcs) ] && rm $(vcs) || true
        ln -s ~/.ssh/$(vcs).sh $@

init: $(vcs)
        @echo $@
        @echo "type the password and use make clean before logout"
        [ -f $(pwfile) ] && touch $(pwfile) || $(vc) $(sy) $(identifier) > $(pwfile)
        chmod 400 $(pwfile)

lpw: init
        @echo $@
        touch lpw
        rm lpw
        [ -f $(pwfile) ] && ln -s $(pwfile) $@

view: $(sy) lpw
        @echo $@
        [ -f $(sy) ] && $(av) $@ $(vs) secrets.yml

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

clean: copy
        [ -f $(pwfile) ] && rm -f $(pwfile) || true
        [ -f $(vcs) ] && rm $(vcs) || true
        [ -f $(sy) ] && rm $(sy) || true
        chmod 600 $(sp).*
        cp $(shell ls -1 secrets.protected.* | tail -1) $(sp)
        [ -f $(sp) ] && rm $(sp).* || true
        touch lpw
        rm lpw
