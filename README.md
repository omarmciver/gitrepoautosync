# Docker based Git Repo Auto Sync

## Local build image

`docker build . -t git`

## Local run image

```bash

```

## Helm commands

Local dry run
`helm template --debug --dry-run reposync ./gitautoreposync-chart > dryrun.yml`

Local source install
`helm upgrade --install --values ./values.yml reposync ./gitautoreposync-chart --set privateSshKeyBase64=xxxxxxx`

Remote source install
`helm upgrade --install --values ./values.yml reposync oci://usdaoars.azurecr.io/helm/oars --version 1.0.0 --set privateSshKeyBase64=xxxxxxx`

## Example Cron

```yml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: reposync
spec:
  schedule: "0/2 * * * *"
  successfulJobsHistoryLimit: 1
  failedJobsHistoryLimit: 10
  jobTemplate:
    spec:
      template:
        metadata:
          name: reposync
        spec:
          containers:
            - name: syncrepo1
              image: omarmciver/gitrepoautosync:latest
              args:
                [
                  "reponame=REPONAME",
                  "branchname=BRANCHNAME",
                  "origin1=https://ORGNAME:PAT_TOKEN@dev.azure.com/ORGNAME/PROJECTNAME/_git/REPONAME",
                  "origin2=https://ORGNAME2:PAT_TOKEN2@dev.azure.com/ORGNAME2/PROJECTNAME2/_git/REPONAME"
                ]

            - name: syncrepo2
              image: omarmciver/gitrepoautosync:latest
              args:
                [
                 "reponame=REPONAME",
                  "branchname=BRANCHNAME",
                  "origin1=git@ssh.dev.azure.com:v3/ORGNAME/PROJECTNAME/REPONAME2",
                  "origin2=https://ORGNAME2:PAT_TOKEN2@dev.azure.com/ORGNAME2/PROJECTNAME2/_git/REPONAME"
                  "sshkeybase64=<sshPrivateKeyBase64Encoded>",
                  "sshhost=ssh.dev.azure.com"
                ]

          restartPolicy: Never
```
