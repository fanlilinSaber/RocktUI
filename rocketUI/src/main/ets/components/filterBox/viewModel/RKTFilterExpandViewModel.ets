import { RKTFilterExpandComponentConfig } from '../model/RKTFilterExpandComponentConfig'

export class RKTFilterExpandViewModel {
  /*数据源*/
  dataArr: RKTFilterExpandComponentConfig[] = []
  /*当前点击的下标*/
  clickIndex: number
  /*是否单选*/
  isSingle: boolean = false
  /*确定的回调*/
  makeSureCallBack: (selected: RKTFilterExpandComponentConfig[]) => void
}