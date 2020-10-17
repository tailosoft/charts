This repo contains a list of charts use by us and our customers

#push images

create a folder called `ignore` at the root of your project, and add the script that looks like this:
```bash
#!/usr/bin/bash
if [ $# -ne 1 ]; then
  echo "wrong params, retry with one param: folderName";
  exit 1;
fi
cd "$(dirname $0)" || exit;
VERSION=$(grep -oP '^version: \K.*' ../charts/$1/Chart.yaml)
NAME=$(grep -oP '^name: \K.*' ../charts/$1/Chart.yaml)
HELM_REPO_URL=https://CAHNGE_IT/charts/
HELM_REPO_USERNAME=CHANGE_IT
HELM_REPO_PASSWORD=CHANGE_IT
# next line can be commented if project already built
helm dependency build ../charts/$1
helm package ../charts/$1
curl -O $HELM_REPO_URL/index.yaml
helm repo index . --url $HELM_REPO_URL --merge ./index.yaml
curl -X PUT -u $HELM_REPO_USERNAME:$HELM_REPO_PASSWORD --data-binary "@index.yaml" $HELM_REPO_URL/index.yaml
curl -X PUT -u $HELM_REPO_USERNAME:$HELM_REPO_PASSWORD --data-binary "@$NAME-$VERSION.tgz" $HELM_REPO_URL/$NAME-$VERSION.tgz
echo "uploaded $NAME-$VERSION.tgz successfully"
rm -rf $NAME*.tgz
```


