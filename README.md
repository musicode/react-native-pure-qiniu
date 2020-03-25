# react-native-pure-qiniu

七牛上传文件。

不支持分片上传。

## 安装

```
npm i react-native-pure-qiniu
// 0.60 以下手动执行 link
react-native link react-native-pure-qiniu
```

## 用法

```js
import qiniu from 'react-native-pure-qiniu'
qiniu.upload(
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
  },
  // 如果需要获取上传进度
  // 传入第二个参数，progress 取值范围为 0-1
  // 如果不需要获取上传进度，最好不传此参数，避免 js/native 频繁通信
  function (progress) {

  }
)
.then(data => {
  // 成功
})
.catch(error => {
  // 失败
})
```