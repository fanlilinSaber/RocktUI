import { GoodsFilterBoxComponent } from '../components/GoodsFilterBoxComponent'
import { GoodsFilterBoxComponentButtonType } from '../viewModel/GoodsFilterBoxViewModel'
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
  canExpand: boolean = false
  /*是否被点击,标志着是否处于点击状态*/
  isClick: boolean = false
  /*是否被选中,选中之后就会高亮*/
  isSelected: boolean = false
  /*互斥分组id，当传入相同的id的时候，这个是显示为互斥的，只对不能展开的按钮生效*/
  mutableId?: string

  constructor(
    param: {
      index: number,
      text: string,
      type: GoodsFilterBoxComponentButtonType,
      clickCallBack: (item: GoodsFilterBoxComponentConfig) => void,
      canExpand?: boolean,
      isSelected?: boolean,
      isClick?: boolean,
      mutableId?: string,
    }) {
    this.index = param.index
    this.text = param.text
    this.isClick = param.isClick ?? false
    this.canExpand = param.canExpand ?? false
    this.type = param.type
    this.clickCallBack = param.clickCallBack
    this.isSelected = param.isSelected ?? false
    this.mutableId = param.mutableId ?? null
  }
}