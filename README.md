# Docker based Git Repo Auto Sync

## Local build image

`docker build . -t git`

## Local run image

```bash
docker run -it --rm git <reponame> <branchname> https://<orgname>:<PAT_token>@dev.azure.com/<OrgName>/<projectname>/_git/<reponame> https://<otherOrgName>:<Other_PAT_Token>@dev.azure.com/<otherOrgName>/<other_projectname>/_git/<reponame>
```
