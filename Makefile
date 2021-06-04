ANSIBLE_ENVIRONMENT = 

override ANSIBLE_PLAYBOOK_FLAGS += --timeout=5 --limit="$(ANSIBLE_LIMIT)" \
  --vault-id "$(VAULT_ID)@$(VAULT_PASS_FILE)"

ANSIBLE_INVENTORY_FILE = ./inventory
ANSIBLE_LIMIT ::= all

VAULT_ID::=do_mxpatlas
VAULT_PASS_FILE::=~/.secret/vault.do_mxpatlas


VAR_NAME::=redmine_pg_password

help:
	@echo Usage: make ansible

deploy:
	$(ANSIBLE_ENVIRONMENT) ansible-playbook $(ANSIBLE_PLAYBOOK_FLAGS) \
		--inventory-file="$(ANSIBLE_INVENTORY_FILE)" playbook.yml

encrypt-var:
	ansible-vault encrypt_string --vault-id  "$(VAULT_ID)@$(VAULT_PASS_FILE)" --stdin-name "$(VAR_NAME)"

vendor-galaxy:
	ansible-galaxy install -v -r requirements.yml
	ansible-galaxy collection install -v -r requirements.yml
