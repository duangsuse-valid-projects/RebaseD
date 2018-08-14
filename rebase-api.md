# Specifications v0.7.2 | Rebase API 接口约定

This describes the resources that make up the official Rebase API by [drakeet](https://github.com/drakeet).

If you have any problems or requests please contact [drakeet](https://github.com/drakeet) or create an issue.

## Schema | 模式

All API access is over __HTTPS__, and accessed from the `https://server/rebase`. All data is sent and received as __JSON__.

```yml
Content-Type: application/json; charset=utf-8
```

All timestamps are returned in __ISO 8601__ format:

```json
YYYY-MM-DDTHH:MM:SSZ
```

## Parameters | 传递参数

Many APIs take optional parameters. For __GET__ requests, any parameters not specified as a __segment in the path__ can be passed as an __HTTP query string__ parameter:

```javascript
GET https://api.drakeet.com/rebase/categories/drakeet/fun/feeds?size=15&last_id=123
```

For __POST, PATCH, PUT, and DELETE__ requests, parameters __not included in the URL__ should be __encoded as JSON__ with a `Content-Type` of `application/json`.

## Access Token | 口令

Access token is required for all __POST, PATCH, PUT, and DELETE__ requests, except for `user register`.

Header

```yml
Authorization: token YOUR-TOKEN
```

## Client Errors | 如何处理请求错误

There is only one type of errors on API calls.

> Status __4xx__ Description

```json
{
  "error": "Not Found"
}
```

## Misc APIs | 杂项 API

### 主页

> Request

```javascript
GET /
```

> Return

`application/json`

Api openapi __v3.0.0__ index

### Markdown 渲染

> Request

```javascript
POST /markdown
```

name | type | description
:-- | :-- | :--
literal | string | Markdown

> Response

```json
{
  "rendered": "..."
}
```

Rendered HTML of given markdown

> Errors

Response __422__ if render failure

### API 版本

> Request

```javascript
GET /version
```

> Response

```json
{
  "version": "0.7.2",
  "server": "RebaseD",
  "server-version": "0.1.0"
}
```

### 全部数据

```javascript
GET /datastorage
```

> Response

`Content-Type` is `application/json`

> This is an internal, undocumented API

## Users | 用户们

By default, all the UGCs are public, but only the owner can publish or change (owned) categories and feeds.

### Register | 注册

```javascript
POST /users
```

> Input

| Name | Type | Description |
| :-- | :--| :-- |
| username | string | **Required**. username of the user. It's immutable |
| password | string | **Required**. password of the user, will be stored with __SHA__ hash |
| name | string | **Required**. name of the user |
| email | string | **Required**. email of the user to contact |
| description | string | **Required**. description of the user |

> Response

Status: __201 Created__

Location: [__https://server/rebase/users/drakeet__](https://server/rebase/users/drakeet)

```json
{
    "username": "drakeet",
    "name": "drakeet",
    "email": "drakeet.me@gmail.com",
    "description": "an Android developer.",
    "authorization": {
        "access_token": "431240f28f0637a640a051fce3632a88463dcc0o",
        "updated_at": "2017-02-02T20:40:42+0800"
    },
    "created_at": "2017-02-02T20:40:42+0800"
}
```

### Authorization | 权限验证

```javascript
GET /authorizations/:username
```

> Parameters

| Name | Type | Description |
| :-- | :-- | :-- |
| password | string | The password of the user |

> Response

Status: __200 OK__

```json
{
  "access_token": "e72e16c7e42f292c6912e7710c838347ae178b4a",
  "updated_at": "2017-02-02T20:40:42+0800"
}
```

## Categories | 分类

> One user can create up to __11__ categories.

### List categories of someone | 获取用户分类列表

```javascript
GET /categories/:owner
```

> Response

Status: __200 OK__

```json
[
    {
        "key": "a key",
        "name": "a name of the category",
        "rank": 1,
        "owner": "drakeet"
    },
    {
        "key": "a key",
        "name": "a name of the category",
        "rank": 2,
        "owner": "drakeet"
    }
]
```

### Create a category | 创建一个分类

```javascript
POST /categories/:owner
```

> Parameters

| Name | Type | Description |
| :-- | :-- | :-- |
| key | string | **Required**. The key of the category. It's the id of the category |
| name | string | **Required**. The name of the category |
| rank | number | Default: __0__. The rank of the category |

> Response

Status: __201 Created__

Location: [__https://api.drakeet.com/rebase/categories/drakeet/cat__](https://api.drakeet.com/rebase/categories/drakeet/cat)

```json
{
    "key": "a key",
    "name": "a name of the category",
    "rank": 1,
    "owner": "drakeet"
}
```

## Feeds | 订阅点（文章）

> A feed may contain anything relating to its category.

### List feeds in a category | 列出分类中的所有订阅

```javascript
GET /categories/:owner/:category/feeds
```

> Parameters

| Name | Type | Description |
| :-- | :-- | :-- |
| last_id | string | Default: __null__. The last feed id of the feeds |
| size | number | Default: __20__. The size of the feeds |

> Response

Status: __200 OK__

```json
[
    {
        "_id": "1",
        "title": "a title",
        "content": "a content",
        "url": "an url",
        "category": "a category",
        "owner": "an owner",
        "cover_url": "a cover url",
        "created_at": "2017-02-11T10:51:07+0800",
        "updated_at": "2017-02-11T11:51:07+0800",
        "published_at": "2017-02-11T20:40:42+0800"
    },
    {
        "_id": "2",
        "title": "a title",
        "content": "a content",
        "url": "an url",
        "category": "a category",
        "owner": "an owner",
        "cover_url": "a cover url",
        "created_at": "2017-02-11T10:51:07+0800",
        "updated_at": "2017-02-11T11:51:07+0800",
        "published_at": "2017-02-11T20:40:42+0800"
    }
]
```

### Create a feed | 创建订阅

```javascript
POST /categories/:owner/:category/feeds
```

Input

| Name | Type | Description |
| :-- | :-- | :-- |
| title | String | **Required**. The title of the feed |
| content | String | The content of the feed |
| url | String | The target URL of the feed |
| cover_url | String | The cover URL of the feed |

> Response

Status: __201 Created__

Location: __[https://server/rebase/categories/drakeet/fun/feeds/5883235334b352758f6617d8](https://server/rebase/categories/drakeet/fun/feeds/5883235334b352758f6617d8)__

```json
{
    "_id": "1",
    "title": "a title",
    "content": "a content",
    "url": "an url",
    "category": "a category",
    "owner": "an owner's username",
    "cover_url": "a cover url",
    "created_at": "2017-02-11T10:51:07+0800",
    "published_at": "2017-02-11T20:40:42+0800"
}
```

### Edit a feed | 编辑订阅

```javascript
PATCH /categories/:owner/:category/feeds/:_id
```

> Input

| Name | Type | Description |
| :-- | :-- | :-- |
| title | string | Optional. The title of the feed |
| content | string | Optional. The content of the feed |
| url | string | Optional. The target URL of the feed |
| cover_url | string | Optional. The cover URL of the feed |
| category | string | Optional. The category of the feed |

> Example

```json
{
    "title": "a new title"
}
```

> Response

Status: __200 OK__

```json
{
    "_id": "1",
    "title": "a new title",
    "content": "a content",
    "url": "an url",
    "category": "a category",
    "owner": "an owner's username",
    "cover_url": "a cover url",
    "created_at": "2017-02-11T10:51:07+0800",
    "published_at": "2017-02-11T20:40:42+0800",
    "updated_at": "2017-02-13T20:40:42+0800"
}
```

### Delete a feed | 删除订阅

```javascript
DELETE /categories/:owner/:category/feeds/:_id
```

> Response

Status: __204 No Content__

```text
```
