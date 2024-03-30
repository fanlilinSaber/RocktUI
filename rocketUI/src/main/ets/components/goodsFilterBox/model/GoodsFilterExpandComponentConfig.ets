export class GoodsFilterExpandComponentConfig {
  /*下标*/
  index: number
  /*标题*/
  text: string
  /*id*/
  id: string
  /*点击事件的回调函数*/
  clickCallBack: (item: GoodsFilterExpandComponentConfig) => void
  /*是否被选中,选中之后就会高亮*/
  isSelected: boolean = false

  constructor(
    param: {
      text: string,
      id:string,
      isSelected?: boolean,
    }) {
    this.id = param.id
    this.text = param.text
    this.isSelected = param.isSelected ?? false
  }
}