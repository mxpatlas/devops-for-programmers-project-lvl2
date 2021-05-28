ANSIBLE_ENVIRONMENT = PYTHONUNBUFFERED=1 ANSIBLE_FORCE_COLOR=true \
	ANSIBLE_SSH_ARGS="$(ANSIBLE_SSH_ARGS)"

ANSIBLE_SSH_ARGS = -o IdentitiesOnly=yes -o ControlMaster=auto \
	-o ControlPersist=60s

override ANSIBLE_PLAYBOOK_FLAGS += --connection=ssh --timeout=5 --limit="$(ANSIBLE_LIMIT)" \
  --vault-id "$(VAULT_ID)@$(VAULT_PASS_FILE)"

ANSIBLE_INVENTORY_FILE = ./inventory
ANSIBLE_LIMIT ::= all

VAULT_ID::=do_mxpatlas
VAULT_PASS_FILE::=~/.secret/vault.do_mxpatlas

VAULT_STDIN_NAME::=redmine_pg_password

all:
	@echo Usage: make ansible

.PHONY: ansible
ansible:
	$(ANSIBLE_ENVIRONMENT) ansible-playbook $(ANSIBLE_PLAYBOOK_FLAGS) \
		--inventory-file="$(ANSIBLE_INVENTORY_FILE)" playbook.yml

vault:
	ansible-vault encrypt_string --vault-id  "$(VAULT_ID)@$(VAULT_PASS_FILE)" --stdin-name "$(VAULT_STDIN_NAME)"

install-galaxy:
	ansible-galaxy install -v -r requirements.yml
	ansible-galaxy collection install -v -r requirements.yml
