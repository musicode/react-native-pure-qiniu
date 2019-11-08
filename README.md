# react-native-pure-qiniu

七牛上传文件。

不支持分片上传和获取上传进度。

## 安装

```
npm i react-native-pure-qiniu
// link below 0.60
react-native link react-native-pure-qiniu
```

## 用法

```js
import Qiniu from 'react-native-pure-qiniu'
Qiniu.upload(
  {
    // 上传到云端的文件名
    key: 'key',
    // 本地文件路径
    path: '/xx/xx/1.png',
    // 上传凭证
    token: '',
    // huabei huanan huadong beimei 四个枚举值
    zone: 'huabei',
    // 上传文件的 mime type
    mimeType: 'image/png',
  }
)
.then(
  data => {
    // 成功
  },
  error => {
    // 失败
  }
)
```