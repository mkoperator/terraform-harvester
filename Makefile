init:
	cd infra/ && terraform init

apply:
	cd infra/ && terraform apply

destroy:
	cd infra/ && terraform destroy