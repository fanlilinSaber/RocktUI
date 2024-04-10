import { RKTFilterExpandComponentConfig } from '../model/RKTFilterExpandComponentConfig'

export enum RKTFilterExpandComponentType {
  area,
  other
}

export class RKTFilterExpandViewModel {
  /*数据源*/
  dataArr: RKTFilterExpandComponentConfig[] | RKTFilterExpandComponentConfig[][] = []
  /*当前点击的下标*/
  clickIndex: number | number[]
  /*是否单选*/
  isSingle: boolean = false
  /*确定的回调*/
  makeSureCallBack: (selected: RKTFilterExpandComponentConfig[] | RKTFilterExpandComponentConfig[]) => void
  type: RKTFilterExpandComponentType = RKTFilterExpandComponentType.other
}