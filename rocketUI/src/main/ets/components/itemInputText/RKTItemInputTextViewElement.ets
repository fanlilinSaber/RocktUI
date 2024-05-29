import { RKTOrientation } from './RKTItemInputTextView'

export class HorizontalElement {
  //组件的布局方向（默认水平方向）
  //水平方向时只展示左侧和右侧的布局，不展示底部的布局
  //垂直方式时只展示左侧和底部的布局，不展示右侧的布局
  orientation?: RKTOrientation
  leftPadding?: number
  rightPadding?: number
  //左侧图片
  leftImage?: string | PixelMap | Resource
  //左侧文案
  leftContent?: string
  leftContentFontColor?: ResourceColor
  leftContentMaxLines?: number
  //是否显示红色星号"*"
  isShowRedStar?: boolean
  //右侧是否能够输入 true 能够输入 false 不能输入，只是展示文案
  isRightInput?: boolean
  //右侧提示文案
  rightHint?: string
  //右侧文案（优先显示content文案，如果没有则显示hint）
  rightContent?: string
  rightContentColor?: ResourceColor
  //水平模式是否显示下方输入框
  isRightBottomInput?: boolean
  //右侧底部提示文案
  rightBottomHint?: string
  //右侧底部文案（优先显示content文案，如果没有则显示hint）
  rightBottomContent?: string
  //垂直间距
  leftContentPaddingVertical?: number
  //是否显示右侧箭头
  isShowRightArrow?: boolean
  //文案的最大行数
  maxLines?: number
  //显示底部的分割线
  isShowBottomLine?: boolean
  bottomLineMarginLeft?: number
  bottomLineMarginRight?: number
  bgColor?: ResourceColor
  //保存的数据
  tag?: string
}

export class VerticalElement {
  //组件的布局方向
  orientation?: RKTOrientation
  leftPadding?: number
  rightPadding?: number
  //左侧文案
  leftContent?: string
  leftContentFontColor?: ResourceColor
  leftContentMaxLines?: number
  //是否显示红色星号"*"
  isShowRedStar?: boolean
  //是否显示右侧箭头
  isShowRightArrow?: boolean
  //底部是否能够输入 true 能够输入 false 不能输入，只是展示文案
  isBottomInput?: boolean
  //底部提示文案
  bottomHint?: string
  //底部文案（优先显示content文案，如果没有则显示hint）
  bottomContent?: string
  //文案的最大行数
  maxLines?: number
  //显示底部的分割线
  isShowBottomLine?: boolean
  bottomLineMarginLeft?: number
  bottomLineMarginRight?: number
  bgColor?: ResourceColor
  //垂直间距
  leftContentPaddingVertical?: number
  //保存的数据
  tag?: string
}

export class CheckBoxElement {
  //组件的布局方向
  orientation?: RKTOrientation
  leftPadding?: number
  rightPadding?: number
  //左侧文案
  leftContent?: string
  leftContentFontColor?: ResourceColor
  leftContentMaxLines?: number
  //是否显示红色星号"*"
  isShowRedStar?: boolean
  //右侧是否能够输入 true 能够输入 false 不能输入，只是展示文案
  isRightInput?: boolean
  //右侧提示文案
  rightHint?: string
  //右侧文案（优先显示content文案，如果没有则显示hint）
  rightContent?: string
  rightContentUnit?: string
  isCheckBoxChecked?: boolean
  checkBoxContent?: string
  //显示底部的分割线
  isShowBottomLine?: boolean
  bottomLineMarginLeft?: number
  bottomLineMarginRight?: number
  //垂直间距
  leftContentPaddingVertical?: number
  //保存的数据
  tag?: string
  //文案的最大行数
  maxLines?: number
  bgColor?: ResourceColor
}
