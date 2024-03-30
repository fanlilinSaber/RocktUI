import { GoodsFilterExpandComponentConfig } from '../model/GoodsFilterExpandComponentConfig'

export class GoodsFilterExpandViewModel {
  /*数据源*/
  dataArr: GoodsFilterExpandComponentConfig[] = []
  /*当前点击的下标*/
  clickIndex: number
  /*是否单选*/
  isSingle: boolean
  /*确定的回调*/
  makeSureCallBack: (selected: GoodsFilterExpandComponentConfig[]) => void

  constructor(p: { isSingle: boolean }) {
    this.isSingle = p.isSingle
  }
}