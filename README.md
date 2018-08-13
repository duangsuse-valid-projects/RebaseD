# Rebase API Server

Drakeet 闭源了 Rebase API 服务器，这是与 [SPEC v0.7.2](rebase-api.md) 兼容的替代品

## 构建

```bash
# 安装 Crystal

shards
crystal build rebased.cr

# Release mode
crystal build rebased.cr -s -p --release
```

## Rake

```bash
rake build # 构建，默认目标
rake build REL= # 发布模式
rake clean # 清除
rake cleandeps # 清除 shards
rake check # 检查 API
```

## 使用

```bash
# 直接使用
./rebased

# Systemd 部署使用
cp rebased.service /lib/systemd/system/
cp rebased /root
chmod +x /root/rebased
systemctl start rebased
```

## 文件

+ .gitignore
+ [README.md](README.md)
+ [Rakefile](Rakefile)
+ [rebase-api.md](rebased-api.md)
+ [rebased.cr](rebased.cr)
+ [rebased-unit.cr](rebased-unit.cr)
+ [rebased.service](rebased.service)
+ [shard.yml](shard.yml)

## API

```ruby
```

## 许可证

项目许可证使用 __AGPL-3.0__ 许可
