# ekosystem
A sane AWS EKS configuration for a useful Operations & Development experience. The substrate of any recorded EKS cluster is an independent repository holding
the recorded AWS VPC and an independet repository holding the recorded AWS IAM policies.

This repository aims to add several redundant, highly available and secure features:
* Private subnets served by NAT Gateways
* Different classes of EC2 Instances in separate ASGs
* Spot pricing

Second, this repository aims to offer useful extenions:
* pod auto-scaling
* cluster auto-scaling
* gracefully draining nodes via _AWS Node Termination Handler_
* dynamic DNS for K8S services via _ExternalDNS_
* pod security policies via _Gatekeeper_
* pod preferences via _Gatekeeper_
* isolated pods via _Calico_
* easier Secrets management via _Kubernetes External Secrets_
* scripting operator via _Shell Operator_
* metrics via _Prometheus_
* service mesh via _LinkerD2_
* centralized authorization for microservices via _OPA_

Desired traits will be verified by _Terratest_.
