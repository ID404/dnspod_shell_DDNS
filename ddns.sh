#请先检查本机是否有安装jq
#可通过命令 yum install jq -y  或 apt-get install jq 安装


#登录dnspod
#在用户管理-密钥管理-创建密钥
#记录 ID 和 Token

ID=XXX
TOKEN=XXX
domain=baidu.com
sub_domain=www

#若为顶级域名，sub_domain填写@ 
#例: sub_domain=@

#获取域名对应的ID
domain_id=$(curl -k https://dnsapi.cn/Domain.List -d "login_token=$ID,$TOKEN" | jq -r '.domains[] | select(.punycode == "'$domain'")'  | jq .id)
echo "get domain id : $domain_id "

#获取recordid
record_id_tmp=$(curl -k https://dnsapi.cn/Record.List -d "login_token=$ID,$TOKEN&domain_id=$domain_id"  | jq -r '.records[] | select(.name == "'$sub_domain'")' | jq -r '. | select(.type == "A")' | jq .id)
#此处为查询根域名@ 且类型为A记录的域名 record id
record_id=$(echo $record_id_tmp | sed 's/\"//g')
echo "get $sub_domain domain record id : $record_id "


更新域名本机公网IP
curl -X POST https://dnsapi.cn/Record.Ddns -d "login_token=$ID,$TOKEN&domain_id=$domain_id&record_id=$record_id&record_line=默认&sub_domain=$sub_domain"


#更新域名指定IP
#curl -X POST https://dnsapi.cn/Record.Ddns -d 'login_token=$ID,$TOKEN&domain_id=$domain_id&record_id=$record_id&record_line=默认&sub_domain=$sub_domain&value=$ip
