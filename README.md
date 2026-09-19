# online-boutique-gitops

GitOps repository for the [Online Boutique DevSecOps pipeline](https://github.com/abhinayyalla1997/microservices-demo-devsecops). Argo CD watches this repo; the application repo never touches it directly.

## Current scope (2026-09-19)

Only `frontend` is enabled in `helm/online-boutique/values.yaml`. This validates the full pipeline — CI → ECR → Argo CD Image Updater → this repo → Argo CD → cluster — for one service before the other 11 are turned on. See the app repo's `CLAUDE.md` for the full architecture and decision log.

## Structure

- `helm/online-boutique/` — Helm chart (adapted from an existing chart built for a different project), covers all 12 services; only `frontend.enabled: true` today.
- `argocd/application.yaml` — the Argo CD `Application` for this chart, including the Argo CD Image Updater annotations that watch ECR for new `frontend-<sha>` tags and write them back here via Git.

## How an image update reaches the cluster

1. App repo's `cd.yml` pushes a new `frontend-<sha>` image to the shared `online-boutique` ECR repository.
2. Argo CD Image Updater (in-cluster) notices the new tag and commits an update to `frontend.image.tag` in this repo's `values.yaml`, using Argo CD's own Git credentials.
3. Argo CD detects the commit and syncs the change to the cluster.

No long-lived Git credential exists in the app repo for this — see CLAUDE.md's "GitOps repo update mechanism" decision.
