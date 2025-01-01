#!/bin/bash

# Check if the static IP address 'eu' already exists
if gcloud compute addresses describe eu \
    --region=europe-west4 \
    --project=civil-hologram-441810-s4 > /dev/null 2>&1; then
  echo "Static IP address 'eu' already exists. Skipping creation."
else
  echo "Creating static IP address 'eu'..."
  gcloud compute addresses create eu \
      --region=europe-west4 \
      --project=civil-hologram-441810-s4
  echo "Static IP address 'eu' created successfully."
fi

gcloud compute instances create xrdp-spot \
    --project=civil-hologram-441810-s4 \
    --zone=europe-west4-b \
    --machine-type=e2-standard-8 \
    --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default \
    --metadata=enable-osconfig=TRUE,ssh-keys=zkey:ssh-rsa\ \
AAAAB3NzaC1yc2EAAAADAQABAAABAQC7JU3RpWmUVVMPop1wVDuAsFko1h9sy4lKR8NfSfciLVr3KxIAJpTV9jIVIpQW0FX6iuEYVUiFZ5OIiGmPNuGsp7kqNaMk20llQLRP\+S7jnn3wA2fcXVtugb8oV9yL9WuxV9SLHjBwkhVF8tAvKJz37oTE2Mt/N4OMmr\+\+vzGavg3pSlEJO3lCLtGkc0vS0DOH5l2rl659iJWuKv\+AC\+a3RkIy87hiuFxJFUdzlchzBH0RnDPdYgl1ag4uv9mwGdNlTD1T3YrlYVfXoJPbphw/CHmncOrDDt1dsv6Y5d/QNXpXjEZ5vktNKmIitL7UsGapxSp5E9gU/k8Bj\+rkE5MB\ zkey \
    --can-ip-forward \
    --no-restart-on-failure \
    --maintenance-policy=TERMINATE \
    --provisioning-model=SPOT \
    --instance-termination-action=STOP \
    --max-run-duration=28800s \
    --service-account=168809542545-compute@developer.gserviceaccount.com \
    --scopes=https://www.googleapis.com/auth/cloud-platform \
    --tags=all,http-server,https-server,lb-health-check \
    --create-disk=auto-delete=yes,boot=yes,device-name=xrdp-spot,image=projects/ubuntu-os-cloud/global/images/ubuntu-minimal-2404-noble-amd64-v20241218a,mode=rw,size=32,type=pd-ssd \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --labels=goog-ops-agent-policy=v2-x86-template-1-4-0,goog-ec-src=vm_add-gcloud \
    --reservation-affinity=any \
&& \
printf 'agentsRule:\n  packageState: installed\n  version: latest\ninstanceFilter:\n  inclusionLabels:\n  - labels:\n      goog-ops-agent-policy: v2-x86-template-1-4-0\n' > config.yaml \
&& \
gcloud compute instances ops-agents policies create goog-ops-agent-v2-x86-template-1-4-0-europe-west4-b \
    --project=civil-hologram-441810-s4 \
    --zone=europe-west4-b \
    --file=config.yaml
