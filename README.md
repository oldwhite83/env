## CentOS7 Nginx PHP 环境 

### 1.更换为 163 yum 源(加速安装,可选)
```
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
curl http://mirrors.163.com/.help/CentOS7-Base-163.repo -o /etc/yum.repos.d/CentOS-Base.repo
yum clean all
yum makecache
```

### 2.升级系统
```
yum install git
yum update
```
**升级后请重启系统**

### 3.克隆代码
```
git clone xxx
cd environment
git submodule update --init --recursive --remote
```

### 4.安装
```
./nginx_php.sh
```
