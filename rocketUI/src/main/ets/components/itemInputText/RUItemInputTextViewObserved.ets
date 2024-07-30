import { RUOrientation } from './RUItemInputTextView'
import { CheckBoxElement, HorizontalElement, VerticalElement } from './RUItemInputTextViewElement'

@Observed
export class RUItemInputTextViewObserved {
  constructor(t?: HorizontalElement | VerticalElement | CheckBoxElement) {
    if (t != undefined && t != null)
      if (t.orientation === RUOrientation.vertical) {
        this.getVerticalElement(t as VerticalElement)
      } else if (t.orientation === RUOrientation.checkBox) {
        this.getCheckBoxElement(t as CheckBoxElement)
      } else {
        if (t.orientation === undefined) {
          this.orientation = RUOrientation.horizontal
        }
        this.getHorizontalElement(t as HorizontalElement)
      }
  }

  //组件的布局方向（默认水平方向）
  //水平方向时只展示左侧和右侧的布局，不展示底部的布局
  //垂直方式时只展示左侧和底部的布局，不展示右侧的布局
  orientation: RUOrientation = RUOrientation.horizontal
  //三种模式的第一行的左右padding
  leftPadding: number = 15
  rightPadding: number = 15

  //左侧图片
  leftImage: string | PixelMap | Resource | null | undefined = null
  //左侧文案
  leftContent: string| undefined = "-"
  leftContentFontColor: ResourceColor| undefined = $r("app.color.ru_color_FF333333")
  leftContentMaxLines: number = 1

  //是否显示红色星号"*"
  isShowRedStar: boolean = true

  //右侧是否能够输入 true 能够输入 false 不能输入，只是展示文案
  isRightInput: boolean| undefined = false
  //右侧提示文案
  rightHint: string = "请选择"
  //右侧文案（优先显示content文案，如果没有则显示hint）
  rightContent: string | undefined = ""
  rightContentColor: ResourceColor = $r("app.color.ru_color_FF000000")
  //水平模式是否显示下方输入框
  isRightBottomInput: boolean = false
  //右侧底部提示文案
  rightBottomHint: string = "请输入内容"
  //右侧底部文案（优先显示content文案，如果没有则显示hint）
  rightBottomContent: string | undefined  = ""
  leftContentPaddingVertical: number = 15

  //是否显示右侧箭头
  isShowRightArrow: boolean = true
  //自定义右侧图标
  rightImage: Resource | null = null

  //底部是否能够输入 true 能够输入 false 不能输入，只是展示文案
  isBottomInput: boolean = false
  //底部提示文案
  bottomHint: string = "请选择"
  //底部文案（优先显示content文案，如果没有则显示hint）
  bottomContent: string | undefined = ""

  //文案的最大行数
  maxLines: number = 1
  //显示底部的分割线
  isShowBottomLine: boolean = true
  bottomLineMarginLeft: number = 15
  bottomLineMarginRight: number = 15
  bgColor: ResourceColor = $r("app.color.ru_color_FFFFFFFF")
  rightContentUnit: string | undefined = ""
  isCheckBoxChecked: boolean| undefined = false
  checkBoxContent: string| undefined = ""

  //保存的数据
  tag: string| undefined = ""

  //horizontal
  getHorizontal(leftContent: string, rightHint?: string, rightContent?: string, isRightInput?: boolean, isShowRedStar?: boolean, isShowRightArrow?: boolean, isShowBottomLine?: boolean, bgColor?: ResourceColor, maxLines?: number, rightBottomHint?: string, rightBottomContent?: string, isRightBottomInput?: boolean) {
    this.orientation = RUOrientation.horizontal
    this.leftContent = leftContent
    this.rightHint = rightHint??"请选择"
    this.rightContent = rightContent
    this.isRightInput = isRightInput??false
    this.isShowRedStar = isShowRedStar??true
    this.isShowRightArrow = isShowRightArrow??true
    this.isShowBottomLine = isShowBottomLine??true
    this.isRightBottomInput = isRightBottomInput??false
    this.rightBottomHint = rightBottomHint??"请输入内容"
    this.rightBottomContent = rightBottomContent
    this.bgColor = bgColor?? $r("app.color.ru_color_FFFFFFFF")
    this.maxLines = maxLines??1
    return this
  }

  //vertical
  getVertical(leftContent: string, bottomHint?: string, bottomContent?: string, isBottomInput?: boolean, isShowRedStar?: boolean, isShowBottomLine?: boolean, bgColor?: ResourceColor, maxLines?: number) {
    this.orientation = RUOrientation.vertical
    this.leftContent = leftContent
    this.bottomHint = bottomHint??"请选择"
    this.bottomContent = bottomContent
    this.isBottomInput = isBottomInput??false
    this.isShowRedStar = isShowRedStar??true
    this.isShowBottomLine = isShowBottomLine??true
    this.bgColor = bgColor?? $r("app.color.ru_color_FFFFFFFF")
    this.maxLines = maxLines??1
    return this
  }

  getCheckBox(leftContent: string, rightHint?: string, rightContent?: string, rightContentUnit?: string, isShowRedStar?: boolean, isShowBottomLine?: boolean, isRightInput?: boolean, isCheckBoxChecked ?: boolean, checkBoxContent ?: string) {
    this.orientation = RUOrientation.checkBox
    this.leftContent = leftContent
    this.rightHint = rightHint??"请输入"
    this.rightContent = rightContent
    this.rightContentUnit = rightContentUnit
    this.isShowRedStar = isShowRedStar??true
    this.isShowBottomLine = isShowBottomLine??true
    this.isRightInput = isRightInput
    this.isCheckBoxChecked = isCheckBoxChecked
    this.checkBoxContent = checkBoxContent
    return this
  }

  private getHorizontalElement(e: HorizontalElement) {
    this.orientation = RUOrientation.horizontal
    this.leftPadding = e.leftPadding??15
    this.rightPadding = e.rightPadding??15
    this.leftContent = e.leftContent
    this.leftContentFontColor = e.leftContentFontColor
    this.leftContentMaxLines = e.leftContentMaxLines??1
    this.leftImage = e.leftImage
    this.rightHint = e.rightHint??"请选择"
    this.rightContent = e.rightContent
    this.rightContentColor = e.rightContentColor?? $r("app.color.ru_color_FF000000")
    this.isRightInput = e.isRightInput??false
    this.isShowRedStar = e.isShowRedStar??true
    this.isShowRightArrow = e.isShowRightArrow??true
    this.isShowBottomLine = e.isShowBottomLine??true
    this.bottomLineMarginLeft = e.bottomLineMarginLeft??15
    this.bottomLineMarginRight = e.bottomLineMarginRight??15
    this.isRightBottomInput = e.isRightBottomInput??false
    this.rightBottomHint = e.rightBottomHint??"请输入内容"
    this.rightBottomContent = e.rightBottomContent
    this.bgColor = e.bgColor?? $r("app.color.ru_color_FFFFFFFF")
    this.maxLines = e.maxLines??1
    this.leftContentPaddingVertical = e.leftContentPaddingVertical?? 15
    this.tag = e.tag
    return this
  }

  private getVerticalElement(e: VerticalElement) {
    this.orientation = RUOrientation.vertical
    this.leftPadding = e.leftPadding??15
    this.rightPadding = e.rightPadding??15
    this.leftContent = e.leftContent
    this.leftContentFontColor = e.leftContentFontColor
    this.leftContentMaxLines = e.leftContentMaxLines??1
    this.bottomHint = e.bottomHint??"请选择"
    this.bottomContent = e.bottomContent
    this.isBottomInput = e.isBottomInput??false
    this.isShowRedStar = e.isShowRedStar??true
    this.isShowBottomLine = e.isShowBottomLine??true
    this.bottomLineMarginLeft = e.bottomLineMarginLeft??15
    this.bottomLineMarginRight = e.bottomLineMarginRight??15
    this.bgColor = e.bgColor?? $r("app.color.ru_color_FFFFFFFF")
    this.maxLines = e.maxLines??1
    this.leftContentPaddingVertical = e.leftContentPaddingVertical?? 15
    this.tag = e.tag
    return this
  }

  private getCheckBoxElement(e: CheckBoxElement) {
    this.orientation = RUOrientation.checkBox
    this.leftPadding = e.leftPadding??15
    this.rightPadding = e.rightPadding??15
    this.leftContent = e.leftContent
    this.leftContentFontColor = e.leftContentFontColor
    this.leftContentMaxLines = e.leftContentMaxLines??1
    this.rightHint = e.rightHint??"请输入"
    this.rightContent = e.rightContent
    this.rightContentUnit = e.rightContentUnit
    this.isShowRedStar = e.isShowRedStar??true
    this.isShowBottomLine = e.isShowBottomLine??true
    this.bottomLineMarginLeft = e.bottomLineMarginLeft??15
    this.bottomLineMarginRight = e.bottomLineMarginRight??15
    this.isRightInput = e.isRightInput
    this.isCheckBoxChecked = e.isCheckBoxChecked
    this.checkBoxContent = e.checkBoxContent
    this.leftContentPaddingVertical = e.leftContentPaddingVertical?? 15
    this.bgColor = e.bgColor?? $r("app.color.ru_color_FFFFFFFF")
    this.maxLines = e.maxLines??1
    this.tag = e.tag
    return this
  }

  getTag(tag: string) {
    this.tag = tag
    return this
  }
}

