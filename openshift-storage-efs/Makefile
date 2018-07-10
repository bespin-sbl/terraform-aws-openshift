infrastructure:
	terraform init && terraform apply -auto-approve

# Installs OpenShift on the cluster.
openshift:
	ssh-add ~/.ssh/id_rsa
	ssh-keyscan -t rsa -H $$(terraform output bastion-public_dns) >> ~/.ssh/known_hosts

	scp ./inventory-efs.cfg ec2-user@$$(terraform output bastion-public_dns):~
	cat ./scripts/install-efs-from-bastion.sh | ssh -o StrictHostKeyChecking=no -A ec2-user@$$(terraform output bastion-public_dns)

output:
	terraform init && terraform output

destroy:
	terraform init && terraform destroy -auto-approve

