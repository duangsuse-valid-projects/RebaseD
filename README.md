# Rebase API Server [![crystal](https://img.shields.io/badge/language-Crystal-black.svg?longCache=true&style=flat-square)](https://crystal-lang.org) ![opensource](https://img.shields.io/badge/truly-opensource-yellow.svg?longCache=true&style=flat-square) ![router.cr](https://img.shields.io/badge/http-crystal+router.cr-green.svg?longCache=true&style=flat-square)

Drakeet 闭源了 Rebase API 服务器，这是与 [SPEC v0.7.2](rebase-api.md) 兼容的替代品

## 为啥又不写了 | Why archived

这个 API 实在是太奇葩了，你们去 [Swagger UI](https://app.swaggerhub.com/apis/duangsuse/RebaseApi/0.7.2) 测试一下

为什么 ID 都是字符串、为什么日期一定非得是某个特殊格式，我自己再写一个得了

后端的服务器实在是太智障了，居然自己不处理部分验证错误，而且有些 API 没法用，API 文档不更新，和 Telegram 不更新客户端源码一个德行，果断差评

后端是 Express 这单线程处理的玩意，操作系统居然用 Ubuntu Server... 等等等等

懒得给这闭源蹩脚的 API 写服务器了，差评差评差评，浪费我一天实现给写 OpenAPI

## 构建 | Building

```bash
# 安装 Crystal

shards
crystal build rebased.cr

# Release mode
crystal build rebased.cr -s -p --release

# Or shards build
shards build

# Or crystal run
chmod +x rebased.cr rebased-unit.cr
./rebased.cr
./rebased-unit.cr

# Package RPM
cd dist
make rpm
```

## Rake 使用

```bash
rake build # 构建，默认目标
rake build REL= # 发布模式
rake clean # 清除
rake cleandeps # 清除 shards
rake check # 检查 API
```

## 使用 Rebased

```bash
# 直接使用
./rebased

# Systemd 部署使用
cp rebased.service /lib/systemd/system/
cp rebased /root
chmod +x /root/rebased
systemctl start rebased
```

## 文件列表

+ .gitignore
+ .editorconfig
+ [LICENSE](LICENSE) 本项目以 __AGPL-3.0__ 真正开源，欢迎随时 fork
+ [README.md](README.md)
+ [Rakefile](Rakefile) Rake 构建脚本
+ [rebase-api.md](rebase-api.md) API 文档，已经重新格式化
+ [rebased.cr](rebased.cr) 服务程序源代码，真正开源
+ [rebased-unit.cr](rebased-unit.cr) 服务程序测试源代码，也一样开源
+ [rebased.service](rebased.service) 开源默认 Systemd 服务配置
+ [shard.yml](shard.yml) 包管理器配置
+ [openapi.yml](openapi.yml) OpenAPI 3.0.0 标准配置
+ [dist/](dist/) RPM 打包配置

## API | 网络接口

```ruby
```

## License | 许可证

Rebased 项目使用 __AGPL-3.0__ 许可 ❤️🎉

```plain
*Real* open source Rebase API server
Copyright (C) 2018  duangsuse

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
```
