
import { NativeModules } from 'react-native'

const { RNTQiniu } = NativeModules

function callback() {

}

export default {

  upload(options, onSuccess, onFailure, onProgress) {
    RNTQiniu.upload(options, onSuccess || callback, onFailure || callback, onProgress || callback)
  },

}
