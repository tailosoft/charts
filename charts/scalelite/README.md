this is a a very simple helm chart that allows for a very basic install scalelite.

once all pods are a running you need to add you servers and enable them:
1. list existing servers:
```
kubectl exec -it scalelite-*** -- /srv/scalelite/bin/rake servers
```
2. add your servers to the list
```
kubectl exec -it scalelite-*** -- /srv/scalelite/bin/rake servers:add[https://bbb1.example.com/bigbluebutton/api,secret]
```
3. enable them (server is can be found by listing as above)
```
kubectl exec -it scalelite-*** -- /srv/scalelite/bin/rake servers:enable[server_id]
```
4. poll the servers to have them available now:
```
kubectl exec -it scalelite-*** -- /srv/scalelite/bin/rake poll:all
```

## retrieve the path to mount:

echo /export/$(kubectl get pvc recordings-pvc | awk 'FNR > 1 { print $3 }')
