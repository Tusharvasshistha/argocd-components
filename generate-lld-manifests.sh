#!/bin/sh

# KUSTOMIZE
for project in "kustomize"/*/*/; do
	if [ -d "$project" ]; then
		for overlay in "$project"overlays/*/; do
			if [ -d "$overlay" ]; then
				echo "Running Kustomize to generate LLD manifest for: $overlay"
				target="$overlay"lld
				mkdir -p $target
				kustomize build $overlay > "$target/manifest.yaml"
				git add "$target/manifest.yaml"
			fi
		done
	fi
done

# HELM
for namespace in "helm"/*; do
	if [ -d "$namespace" ]; then
		for chart in "$namespace"/*; do
			if [ -d "$chart" ]; then
				for var in "$chart"/vars/*/; do
					if [ -d "$var" ]; then
						echo "Running Helm template to generate LLD manifest for: $var"
						trimmed_namespace="${namespace#helm/}"
						target="$var"lld
						mkdir -p $target
						helm template --namespace $trimmed_namespace $chart -f "$var/Values.yaml" > "$target/manifest.yaml"
						git add "$target/manifest.yaml"
					fi
				done
			fi
		done
	fi
done