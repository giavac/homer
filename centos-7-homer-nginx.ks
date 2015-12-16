install
text
sshpw --username=root setup --plaintext
url --url=http://mirror.centos.org/centos/7/os/x86_64/
repo --name=updates --baseurl=http://mirror.centos.org/centos/7/updates/x86_64/
repo --name=extras --baseurl=http://mirror.centos.org/centos/7/extras/x86_64/
repo --name=plus --baseurl=http://mirror.centos.org/centos/7/centosplus/x86_64/
repo --name=epel --mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-7&arch=x86_64
repo --name=bintray--sipcapture-homer-yum --baseurl=http://dl.bintray.com/sipcapture/homer-yum
repo --name=mysql-connectors-community --baseurl=http://repo.mysql.com/yum/mysql-connectors-community/el/7/x86_64/
repo --name=mysql-tools-community --baseurl=http://repo.mysql.com/yum/mysql-tools-community/el/7/x86_64/
repo --name=mysql57-community --baseurl=http://repo.mysql.com/yum/mysql-5.7-community/el/7/x86_64/
repo --name=home_kamailio_v4.3.x-rpms --baseurl=http://download.opensuse.org/repositories/home:/kamailio:/v4.3.x-rpms/CentOS_7/

keyboard us
lang en_US.UTF8

timezone --utc Europe/Amsterdam

auth --enableshadow --passalgo=sha512 --enablefingerprint
rootpw --iscrypted $6$y4oi7guFydjyif96$9bm7hVh/D5DxqAF1vEAPCZKSUdF3GiLFP2lcui9uGZ6tCKYr30c20gIBtU8jO08IYmG9Frrz1d.XmMktmYoPp.

selinux --disabled
firewall --disabled

ignoredisk --only-use=sda
clearpart --drives=sda --all --initlabel
zerombr

part /boot --size=1024 --ondrive=sda --asprimary --fstype=ext4
part pv.01 --size=1    --ondrive=sda --grow

volgroup vg_main pv.01
logvol swap  --vgname=vg_main --size=1024   --name=swap --label=SWAP --fstype=swap
logvol /     --vgname=vg_main --size=2048   --name=root --label=ROOT --fstype=ext4 --fsoptions="defaults,sync,relatime"
logvol /home --vgname=vg_main --size=1024   --name=home --label=HOME --fstype=ext4 --fsoptions="defaults,nodev"
logvol /usr  --vgname=vg_main --size=4096   --name=usr  --label=USR  --fstype=ext4 --fsoptions="defaults,nodev"
logvol /var  --vgname=vg_main --size=1      --name=var  --label=VAR  --fstype=ext4 --fsoptions="defaults,nodev,nosuid,relatime" --grow
bootloader --location=mbr

%packages
@Core
epel-release
mysql-community-release
homer-nginx

%end

%post —log=/mnt/sysimage/var/log/ks-post.log

mkdir -p /mnt/sysimage/root/.ssh

systemctl enable sshd.service

curl https://bintray.com/sipcapture/homer-yum/rpm -o /etc/yum.repos.d/sipcapture.repo
curl http://download.opensuse.org/repositories/home:/kamailio:/v4.3.x-rpms/CentOS_7/home:kamailio:v4.3.x-rpms.repo -o /etc/yum.repos.d/kamailio.repo

%end

reboot
