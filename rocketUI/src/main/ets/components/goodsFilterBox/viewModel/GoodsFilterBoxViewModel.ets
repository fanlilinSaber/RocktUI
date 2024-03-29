import {
  GoodsFilterBoxComponentConfig
} from '../../goodsFilterBox/Model/GoodsFilterBoxComponentConfig'

export enum GoodsFilterBoxComponentButtonType {
  /*正常形态*/
  normal,
  /*右侧有个箭头按钮*/
  rightButton
}

export class GoodsFilterBoxViewModel {
  /*数据源*/
  dataArr: GoodsFilterBoxComponentConfig[] = []
}