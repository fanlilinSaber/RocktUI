import { GoodsFilterBoxComponentButtonType } from '../Components/GoodsFilterBoxComponent'
import {
  GoodsFilterBoxComponentAreaSelectedModel
} from './GoodsFilterBoxComponentAreaSelectedModel'

@Observed
export class GoodsFilterBoxComponentConfig {
  /*下标*/
  index: number
  /*标题*/
  text: string
  /*按钮type*/
  type: GoodsFilterBoxComponentButtonType
  /*点击事件的回调函数*/
  clickCallBack: (item: GoodsFilterBoxComponentConfig) => void
  /*是否能展开*/
  canExpand: boolean
  /*是否被点击*/
  isClick: boolean
  /*是否被选中*/
  isSelected: boolean
  /*互斥分组id，当传入相同的id的时候，这个是显示为互斥的*/
  mutableId?: string
  /*选中的区域内容*/
  selectedAreaContent?: GoodsFilterBoxComponentAreaSelectedModel

  constructor(
    param: {
      index: number,
      text: string,
      type: GoodsFilterBoxComponentButtonType,
      clickCallBack: (item: GoodsFilterBoxComponentConfig) => void,
      isSelected: boolean,
      canExpand: boolean,
      isClick?: boolean,
      mutableId?: string,
      selectedAreaContent?: GoodsFilterBoxComponentAreaSelectedModel
    }) {
    this.index = param.index
    this.text = param.text
    this.isClick = param.isClick
    this.canExpand = param.canExpand
    this.type = param.type
    this.clickCallBack = param.clickCallBack
    this.isSelected = param.isSelected
    this.mutableId = param.mutableId
    this.selectedAreaContent = param.selectedAreaContent
  }
}