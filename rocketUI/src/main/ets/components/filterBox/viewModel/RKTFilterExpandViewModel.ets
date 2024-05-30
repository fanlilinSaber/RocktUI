import { RKTFilterExpandComponentConfig } from '../model/RKTFilterExpandComponentConfig'

export enum RKTFilterExpandComponentType {
  area,
  other
}

export class RKTFilterExpandViewModel {
  /*数据源*/
  dataArr: RKTFilterExpandComponentConfig[] | RKTFilterExpandComponentConfig[][] = []
  /*当前点击的下标*/
  clickIndex: number | number[] = 0
  /*是否单选*/
  isSingle: boolean = false
  /*确定的回调*/
  makeSureCallBack: Function = (selected: RKTFilterExpandComponentConfig[] | RKTFilterExpandComponentConfig[]) => {}
  type: RKTFilterExpandComponentType = RKTFilterExpandComponentType.other
}