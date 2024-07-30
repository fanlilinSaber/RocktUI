/**
 * Author:fanlilin
 * Date:2024/7/10
 * Descrobe:
 */

/**
 * RUTextInput 控制中心扩展
 */
export class RUTextInputControl extends TextInputController {

}

/**
 * 自定义左边图标
 */
export interface RUTextInputleftIcon {
  iconSrc?: ResourceStr
  size?: Size
  margin?: Margin | Length | LocalizedMargin
}

/**
 * 左边图标类型
 */
export enum RUTextInputLeftIconType {
  // 无样式
  None,
  // 左边带搜索🔍
  Search
}

@Component
export struct RUTextInput {
  // 文本（必须外部初始化或使用`$`绑定）
  @Link text: ResourceStr
  // 占位符
  @Prop placeholder?: ResourceStr
  // 文本字体
  font: Font = { size: 13 }
  // 文本字体颜色
  color: ResourceColor = $r('app.color.ru_color_FF333333')
  // 占位符字体
  placeholderFont: Font = { size: 13 }
  // 占位符颜色
  placeholderColor: ResourceColor = $r('app.color.ru_color_FFC0C4CC')
  // 最大行数
  maxLines?: number
  // 输入类型
  type: InputType = InputType.Normal
  // 内置样式
  style: TextInputStyle = TextInputStyle.Default
  // 左边图标
  leftIcon?: RUTextInputleftIcon | RUTextInputLeftIconType
  // 背景色
  bgColor: ResourceColor = $r('app.color.ru_color_FFFFFFFF')
  // 圆角
  xborderRadius: Length | BorderRadiuses | LocalizedBorderRadiuses = 5
  // 高度
  xheight: Length = 33
  // 内边距控制
  xpadding?: Padding | Length | LocalizedPadding
  // 是否带清除按钮
  showClearIcon: boolean = true
  // 在type = 密码模式下，是否显示右边眼睛👁图标
  showPasswordIcon: boolean = true
  // 眼睛图标自定义
  passwordIcon?: PasswordIcon
  // 输入字符最大长度限制
  maxLength?: number
  // 插入光标符颜色
  caretColor: ResourceColor = $r('app.color.ru_main_color')
  // 文本输入回调
  onChange?: (value: string) => void
  // 按下输入法回车键触发该回调
  onSubmit?: (enterKey: EnterKeyType, event: SubmitEvent) => void
  // 控制器
  control?: RUTextInputControl

  build() {
    Row() {
      this.leftArea()

      TextInput({ text: $$this.text, placeholder: this.placeholder, controller: this.control })
        .fontSize(this.font.size)
        .fontWeight(this.font.weight)
        .fontColor(this.color)
        .placeholderColor(this.placeholderColor)
        .placeholderFont(this.placeholderFont)
        .borderRadius(0)
        .style(this.style)
        .maxLines(this.maxLines)
        .showPasswordIcon(this.showPasswordIcon)
        .passwordIcon(this.passwordIcon)
        .backgroundColor(Color.Transparent)
        .type(this.type)
        .caretColor(this.caretColor)
        .padding(0)
        .maxLength(this.maxLength)
        .layoutWeight(1)
        .onChange(this.onChange)
        .onSubmit(this.onSubmit)

      if (this.showClearIcon) {
        Image($r('app.media.ru_ic_clear'))
          .width(13).height(13).margin({ left: 10, right: 10 })
          .visibility(!!this.text ? Visibility.Visible : Visibility.None)
          .onClick(() => {
            this.text = ''
          })
      }
    }
    .height(this.xheight)
    .borderRadius(this.xborderRadius)
    .backgroundColor(this.bgColor)
    .padding(this.xpadding)
  }

  @Builder
  leftArea() {
    if (typeof this.leftIcon === 'number' && this.leftIcon === RUTextInputLeftIconType.Search) {
      Image($r('app.media.ru_ic_search'))
        .width(15).height(15).margin({ left: 10, right: 10 })
    } else if (typeof this.leftIcon === 'object') {
      Image(this.leftIcon.iconSrc)
        .size(this.leftIcon.size ?? { width: 15, height: 15})
        .margin(this.leftIcon.margin ?? { left: 10, right: 10 })
    }
  }
}