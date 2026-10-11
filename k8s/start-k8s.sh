#!/usr/bin/env bash

# .start-k8s.sh destroy   // to destroy everything
set -euo pipefail

case "${1:-start}" in
	start)
		kubectl apply -f k8s/namespace.yaml
		kubectl apply -f k8s/
		;;
	destroy)
		kubectl delete -f k8s/namespace.yaml --ignore-not-found=true
		;;
	*)
		echo "Usage: $0 [start|destroy]" >&2
		exit 2
		;;
esac
# 