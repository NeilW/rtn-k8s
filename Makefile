IMAGEPATH=cr.brightbox.com/acc-tqs4c/docker/rtn-k8s
JOBSPEC=k8s/deployments.yaml

login:
	docker login cr.brightbox.com

build: 
	docker build . -t $(IMAGEPATH)

push: build login
	docker push $(IMAGEPATH)

apply: push
	kubectl apply -f $(JOBSPEC)

delete: 
	kubectl delete -f $(JOBSPEC)

credentials: login
	kubectl delete --ignore-not-found=true secret/brightbox-cr
	kubectl create secret generic brightbox-cr \
		--from-file=.dockerconfigjson=$(HOME)/.docker/config.json \
		--type=kubernetes.io/dockerconfigjson

.PHONY: delete apply push build login credentials
