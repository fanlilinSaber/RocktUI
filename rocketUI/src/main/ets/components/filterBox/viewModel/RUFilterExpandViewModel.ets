import { RUFilterExpandComponentConfig } from '../model/RUFilterExpandComponentConfig'

export enum RUFilterExpandComponentType {
  area,
  other
}

export class RUFilterExpandViewModel {
  /*数据源*/
  dataArr: RUFilterExpandComponentConfig[] | RUFilterExpandComponentConfig[][] = []
  /*当前点击的下标*/
  clickIndex: number | number[] = 0
  /*是否单选*/
  isSingle: boolean = false
  /*确定的回调*/
  makeSureCallBack: Function = (selected: RUFilterExpandComponentConfig[] | RUFilterExpandComponentConfig[]) => {}
  type: RUFilterExpandComponentType = RUFilterExpandComponentType.other
}