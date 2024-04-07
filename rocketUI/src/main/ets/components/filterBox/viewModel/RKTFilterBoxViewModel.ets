import {
  RKTFilterBoxComponentConfig
} from '../Model/RKTFilterBoxComponentConfig'

/*
 * 条件筛选，在需要引用条件筛选的界面
 * 1.用@Provide修饰 RKTFilterBoxViewModel
 * 2.初始化dataArr,dataArr中包含GoodsFilterBoxComponentConfig数组,每一个GoodsFilterBoxComponentConfig就是一个按钮的初始化model
 * 3.GoodsFilterBoxViewModel有部分配置方法可以设置选中效果
 * 4.GoodsFilterBoxComponentConfig中的clickCallBack回调可以返回当前点击的按钮的GoodsFilterBoxComponentConfig
 * */

export enum RKTFilterBoxComponentButtonType {
  /*正常形态*/
  normal,
  /*右侧有个箭头按钮*/
  rightButton
}

export class RKTFilterBoxViewModel {
  /*数据源*/
  dataArr: RKTFilterBoxComponentConfig[] = []
  /*当前点击的下标*/
  clickGoodsFilterBoxComponentConfig: RKTFilterBoxComponentConfig
}