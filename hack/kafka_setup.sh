#!/usr/bin/env bash
set -e
# Turn colors in this script off by setting the NO_COLOR variable in your
# environment to any value:
#
# $ NO_COLOR=1 test.sh
# NO_COLOR=${NO_COLOR:-""}
# if [ -z "$NO_COLOR" ]; then
#   header=$'\e[1;33m'
#   reset=$'\e[0m'
# else
#   header=''
#   reset=''
# fi
# strimzi_version=`curl https://github.com/strimzi/strimzi-kafka-operator/releases/latest |  awk -F 'tag/' '{print $2}' | awk -F '"' '{print $1}' 2>/dev/null`
strimzi_version="0.16.2"
function header_text {
  echo "$header$*$reset"
}
header_text "Using Strimzi Version:                  ${strimzi_version}"
header_text "Strimzi install"
kubectl create namespace kafka
curl -L "https://github.com/strimzi/strimzi-kafka-operator/releases/download/${strimzi_version}/strimzi-cluster-operator-${strimzi_version}.yaml" \
  | sed 's/namespace: .*/namespace: kafka/' \
  | kubectl -n kafka apply -f -


header_text "Applying Strimzi Cluster file"
# kubectl -n kafka apply -f "https://raw.githubusercontent.com/strimzi/strimzi-kafka-operator/${strimzi_version}/examples/kafka/kafka-ephemeral-single.yaml"
kubectl apply --filename https://github.com/knative/eventing/releases/download/v0.16.0/mt-channel-broker.yaml
curl -L "https://github.com/knative/eventing-contrib/releases/download/v0.16.0/kafka-channel.yaml" \
 | sed 's/REPLACE_WITH_CLUSTER_URL/my-cluster-kafka-bootstrap.kafka:9092/' \
 | kubectl apply --filename -

# kubectl apply --filename https://github.com/knative/eventing/releases/download/v0.16.0/mt-channel-broker.yaml

kubectl apply --filename https://github.com/knative/eventing-contrib/releases/download/v0.16.0/kafka-source.yaml

