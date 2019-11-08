
import { NativeModules } from 'react-native'

const { RNTQiniu } = NativeModules

export default {

  upload(options) {
    return RNTQiniu.upload(options)
  },

}
