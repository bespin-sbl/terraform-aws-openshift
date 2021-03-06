infrastructure:
	terraform init && terraform apply -auto-approve

# Installs OpenShift on the cluster.
openshift:
	# Add our identity for ssh, add the host key to avoid having to accept the
	# the host key manually. Also add the identity of each node to the bastion.
	ssh-add ~/.ssh/id_rsa
	ssh-keyscan -t rsa -H $$(terraform output bastion-public_dns) >> ~/.ssh/known_hosts
	ssh -A ec2-user@$$(terraform output bastion-public_dns) "ssh-keyscan -t rsa -H master.openshift.local >> ~/.ssh/known_hosts"
	ssh -A ec2-user@$$(terraform output bastion-public_dns) "ssh-keyscan -t rsa -H node1.openshift.local >> ~/.ssh/known_hosts"
	ssh -A ec2-user@$$(terraform output bastion-public_dns) "ssh-keyscan -t rsa -H node2.openshift.local >> ~/.ssh/known_hosts"

	# Copy our inventory to the master and run the install script.
	scp ./inventory.cfg ec2-user@$$(terraform output bastion-public_dns):~
	cat ./scripts/install-from-bastion.sh | ssh -o StrictHostKeyChecking=no -A ec2-user@$$(terraform output bastion-public_dns)

	# Now the installer is done, run the post-install steps on each host.
	cat ./scripts/post-install-master.sh | ssh -A ec2-user@$$(terraform output bastion-public_dns) ssh master.openshift.local
	cat ./scripts/post-install-node.sh | ssh -A ec2-user@$$(terraform output bastion-public_dns) ssh node1.openshift.local
	cat ./scripts/post-install-node.sh | ssh -A ec2-user@$$(terraform output bastion-public_dns) ssh node2.openshift.local

output:
	terraform init && terraform output

destroy:
	terraform init && terraform destroy -auto-approve

# Open the console.
browse-openshift:
	open $$(terraform output master-url)

# SSH onto the master.
ssh-bastion:
	ssh-add ~/.ssh/id_rsa
	ssh -t -A ec2-user@$$(terraform output bastion-public_dns)
ssh-master:
	ssh-add ~/.ssh/id_rsa
	ssh -t -A ec2-user@$$(terraform output bastion-public_dns) ssh master.openshift.local
ssh-node1:
	ssh-add ~/.ssh/id_rsa
	ssh -t -A ec2-user@$$(terraform output bastion-public_dns) ssh node1.openshift.local
ssh-node2:
	ssh-add ~/.ssh/id_rsa
	ssh -t -A ec2-user@$$(terraform output bastion-public_dns) ssh node2.openshift.local

# Create sample services.
sample:
	oc login $$(terraform output master-url) --insecure-skip-tls-verify=true -u=admin -p=password#123
	oc new-project sample
	oc process -f ./sample/counter-service.yml | oc create -f -

# Lint the terraform files. Don't forget to provide the 'region' var, as it is
# not provided by default. Error on issues, suitable for CI.
lint:
	terraform get
	TF_VAR_region="us-east-1" tflint --error-with-issues

# Run the tests.
test:
	echo "Simulating tests..."

# Run the CircleCI build locally.
circleci:
	circleci config validate -c .circleci/config.yml
	circleci build --job lint

.PHONY: sample
