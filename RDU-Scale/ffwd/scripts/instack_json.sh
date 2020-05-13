curl http://quads.scalelab.redhat.com/cloud/cloud21_instackenv.json > ~/instackenv.json
#Undercloud
jq 'del(.nodes[]|select(.pm_addr == "mgmt-....."))' ~/instackenv.json > ~/new
mv ~/new ~/instackenv.json

sed -i -e 's/"cpu": "2",/"cpu": "20",/g' ~/instackenv.json
sed -i -e 's/"disk": "20",/"disk": "200",/g' ~/instackenv.json
sed -i -e 's/"memory": "1024",/"memory": "10240",/g' ~/instackenv.json

sed -i -e 's/mgmt-\(.*\).rdu.openstack.engineering.redhat.com/mgmt-\1.rdu.openstack.engineering.redhat.com",\n      "name": "\1.rdu.openstack.engineering.redhat.com",\n      "capabilities": "node:\1,boot_option:local,cpu_vt:true,cpu_hugepages:true,cpu_txt:true,cpu_aes:true,cpu_hugepages_1g:true/g' ~/instackenv.json
let x=0 ; grep node ~/instackenv.json | grep capabilities | grep -v controller | grep -v compute | grep -v cephstorage | head -n 3 | cut -d ':' -f3 | cut -d ',' -f1 | while read node; do sed -i -e "s/node:${node}/node:controller-${x}/g" ~/instackenv.json ; let x=x+1; done
let x=0 ; grep node ~/instackenv.json | grep capabilities | grep -v controller | grep -v compute | grep -v cephstorage | head -n 3 | cut -d ':' -f3 | cut -d ',' -f1 | while read node; do sed -i -e "s/node:${node}/node:cephstorage-${x}/g" ~/instackenv.json ; let x=x+1; done
grep node ~/instackenv.json | grep capabilities | grep -v controller | grep -v compute | grep -v cephstorage | cut -d ':' -f3 | cut -d ',' -f1 | cut -d '-' -f3 | sort | uniq |while read TYPE; do let x=0 ; grep node ~/instackenv.json | grep capabilities | grep -v controller | grep -v compute | grep -v cephstorage | grep "${TYPE}" | cut -d ':' -f3 | cut -d ',' -f1 | while read node; do TYPE="$(echo ${node}|cut -d '-' -f3)" ; sed -i -e "s/node:${node}/node:${TYPE,,}-compute-${x}/g" ~/instackenv.json ; let x=x+1; done; done
