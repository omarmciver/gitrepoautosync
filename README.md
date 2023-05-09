# Docker based Git Repo Auto Sync

## Local build image

`docker build . -t git`

## Local run image

```bash
docker run -it --rm git <reponame> <branchname> https://<orgname>:<PAT_token>@dev.azure.com/<OrgName>/<projectname>/_git/<reponame> https://<otherOrgName>:<Other_PAT_Token>@dev.azure.com/<otherOrgName>/<other_projectname>/_git/<reponame>
```

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
            args: ["REPONAME2", "BRANCHNAME", "https://ORGNAME:PAT_TOKEN@dev.azure.com/ORGNAME/PROJECTNAME/_git/REPONAME", "https://ORGNAME2:PAT_TOKEN2@dev.azure.com/ORGNAME2/PROJECTNAME2/_git/REPONAME"]
          
          - name: syncrepo2
            image: omarmciver/gitrepoautosync:latest
            args: ["REPONAME2", "BRANCHNAME", "https://ORGNAME:PAT_TOKEN@dev.azure.com/ORGNAME/PROJECTNAME/_git/REPONAME2", "https://ORGNAME2:PAT_TOKEN2@dev.azure.com/ORGNAME2/PROJECTNAME2/_git/REPONAME2"]

          restartPolicy: OnFailure
```