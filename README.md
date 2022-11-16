# Run Broker in your local (Baremetal) K8s cluster

This step-by-step demo will provision your own GitLab instance (docker) and brokers on Baremetal K8s in your local machine.

There are 5 steps in this demo.

1. Create GitLab instance with docker
1. Push some sample repo to gitlab
1. Create local K8s cluster (In this demo, Kind is used)
1. Deploy Broker
1. Deploy Ingress (so that Webhook works)

# 0. Prerequisite
* DNS masq (https://thekelleys.org.uk/dnsmasq/doc.html)
* mkcert (https://github.com/FiloSottile/mkcert)
  * To set up DNS masq and mkcert, please refer this. https://github.com/masa-snyk/broker_gitlab_local
* Kind (https://kind.sigs.k8s.io/)
* Clone this repo.
* We will use service called nip (https://nip.io) so that you don't need to modify /etc/hosts to match the hostnames in your local K8s pods.

# 1. Create GitLab instance with docker

Run following:

```
1.create_gitlab.sh
```

First time you provision GitLab, it would take 10~15 min. 
Please check the log by running:
```
docker logs -f gitlab
```

When Gitlab is created, `GITLAB_HOST` file is also created for later use.

Your Gitlab instance should be able up at `$GITLAB_HOST`. 
```
open https://$(cat GITLAB_HOST)
```

After Gitlab is ready, please login to Gitlab with following credentials.


```
Username: root
Password: Passw0rd
```

Once logged in, create `Personal access token`. (Preference -> Access Tokens)
Create a token with following scopes.
- api - For Broker integration
- read_repositoy - For Code agent to read your repo
- read_registry - For Container scan
- write_registry - For this demo only (Not necessary for scan)

Copy the token and store it in your local file `GITLAB_TOKEN`.

```
cat SL6WK2Etzkb1Txdrtpko > GITLAB_TOKEN
```

# 2. Push some sample repo to gitlab

Run following:
```
2.prep_gitlab.sh
```

Push some sample repo to Gitlab for testing.

_**Note**: You might be asked to enter credential_. Then enter followings.
```
Username: root
Password: Passw0rd
```

# 3. Create local K8s cluster (In this demo, Kind is used)

First, we need a Broker token from Snyk platform.

Log in to Snyk UI, and get Broker token from integration page.

Copy the token to your local file `BROKER_TOKEN`. 

```
cat 350a39e2-3e4a-481a-a7ff-eb51ca9e2442 > BROKER_TOKEN
```

Run following:
```
3.create_kind_cluster.sh
```

Provision local K8s cluster with Kind. 
You are welcome to use or re-use your own K8s cluster.

# 4. Deploy Broker

Make sure you have these 3 files.
`GITLAB_HOST` : Generated in Step 1.
`GITLAB_TOKEN` : Please generate one in GitLab console.
`BROKER_TOKEN` : Please generate one from Snyk UI.

Run following:
```
4.deploy_broker.sh
```

Once this step is done, you should be able to import GitLab repo from Snyk UI.


# 5. Deploy Ingress (so that Webhook works)

For baremetal K8s, this step is necessary for:
* Webhook from Gitlab
* Healthcheck/systemcheck from outside of K8s cluster
  
If you already have external loadbalancer (or using some managed K8s such as EKS, GKE, AKS, etc), this step is not necessary.

In this demo, Nginx is used for Ingress controller. You can choose any of your favorite ingress controler, like contour, kong, etc. 

Run following:
```
5.deploy_ingress.sh 
```

* _**Note**: You might need to enter your admin password for your local machine_

Now, Webhook should work. And you can run health and system check from your local machine like below:

```
curl http://broker.test/healthcheck
curl http://broker.test/systemcheck
```

# To do

* [] Container registry agent (CRA) and broker for CRA
* [] Code agent
* [] Add more instructions in README
