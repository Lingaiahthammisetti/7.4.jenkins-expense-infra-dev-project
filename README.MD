# Infrastructure creation and deletion

```
for i in  00-vpc/ 10-sg/ 20-db/ 40-vpn/ ; do cd $i; terraform init -reconfigure; cd .. ; done 
```

```
for i in  00-vpc/ 10-sg/ 20-db/ 40-vpn/ ; do cd $i; terraform plan; cd .. ; done 
```

```
for i in  00-vpc/ 10-sg/ 20-db/ 40-vpn/ ; do cd $i; terraform apply -auto-approve; cd .. ; done 
```


ssh -i ~/.ssh/openvpn  openvpnas@vpn-ip



```
for i in  50-app-alb/ 70-acm/ 80-web-alb/ 100-cdn/ ; do cd $i; terraform init -reconfigure; cd .. ; done 
```

```
for i in  50-app-alb/ 70-acm/ 80-web-alb/ 100-cdn/ ; do cd $i; terraform plan; cd .. ; done 
```

```
for i in  50-app-alb/ 70-acm/ 80-web-alb/ 100-cdn/ ; do cd $i; terraform apply -auto-approve; cd .. ; done 
```


```
for i in 100-cdn/ 80-web-alb/ 70-acm/ 50-app-alb/   ; do cd $i; terraform destroy auto-approve; cd .. ; done 
```

```
for i in 40-vpn/ 20-db/ 10-sg/ 00-vpc/  ; do cd $i; terraform destroy auto-approve; cd .. ; done 
```



# Expense Architecture

![alt text](expense-infra-dev.drawio.svg)