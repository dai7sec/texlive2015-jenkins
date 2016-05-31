# texlive2015-jenkins

## install software

- TeX Live 2015
- Sphinx 1.3.6
- Jenkins 1.6

## dockerhub

- https://hub.docker.com/r/tboffice/texlive2015-jenkins/

# build 

## prepare

```
yum install -y docker git vim-enhanced
systemctl start docker
# wget http://download.nus.edu.sg/mirror/ctan/systems/texlive/Images/texlive2015-20150523.iso # singapore
wget http://ftp.riken.jp/tex-archive/systems/texlive/Images/texlive2015-20150523.iso # Japan
mount -o loop -t iso9660 texlive2015-20150523.iso /mnt;cd /mnt ;python -m SimpleHTTPServer &
```

## docker build

```
# docker build -t texlive2015-jenkins .
```
