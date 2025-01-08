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

gcloud compute instances create xrdp-spot-jammy-minimal-zoho \
    --project=civil-hologram-441810-s4 \
    --zone=europe-west4-b \
    --machine-type=e2-standard-8 \
    --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default \
    --metadata=enable-osconfig=TRUE \
    --can-ip-forward \
    --no-restart-on-failure \
    --maintenance-policy=TERMINATE \
    --provisioning-model=SPOT \
    --instance-termination-action=STOP \
    --service-account=168809542545-compute@developer.gserviceaccount.com \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/trace.append \
    --enable-display-device \
    --tags=lb-health-check \
    --create-disk=auto-delete=yes,boot=yes,device-name=xrdp-spot-jammy-minimal-zoho,image=projects/ubuntu-os-cloud/global/images/ubuntu-minimal-2204-jammy-v20241218,mode=rw,size=20,type=pd-ssd \
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
