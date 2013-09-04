hard-way-install-goagent
========================

笨办法安装 `goagent`

## Usage

1. 登录 [GAE](http://appengine.google.com) 创建 APP，记下 `appid` 和 `app-specific-password` 备用;

2. `$ git clone https://github.com/twlz0ne/hard-way-install-goagent.git && cd ./hard-way-install-goagent`

3. `$ ./hard-way-install-goagent.sh`

首次运行该脚本会提示创建参数模板，把 `gmail` 帐号以及前面创建的 `appid` 和`app-specific-password` 填进去再执行一遍即可。

还可以选择单独安装客户端或服务端：

```bash
$ ./hard-way-install-goagent.sh -h
Usage: hard-way-install-goagent.sh -[h|s|c|a]
Options:
      -h      print help
      -s      install server only
      -c      install client only
      -a      install both server and client. default
```
