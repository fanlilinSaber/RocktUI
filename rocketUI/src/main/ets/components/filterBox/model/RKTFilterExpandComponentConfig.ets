

export class RKTFilterExpandComponentConfig {
  /*下标*/
  index?: number = 0
  /*标题*/
  text?: string = ""
  /*id*/
  id?: string =""
  /*点击事件的回调函数*/
  clickCallBack:Function =  (item: RKTFilterExpandComponentConfig) => {}
  /*是否被选中,选中之后就会高亮*/
  isSelected: boolean = false

  constructor(
    param: RKTFilterExpandComponentConfigParam) {
    this.id = param.id
    this.text = param.text
    this.isSelected = param.isSelected ?? false
  }
}


class RKTFilterExpandComponentConfigParam{
  text: string = ""
  id: string =""
  isSelected?: boolean = false
}