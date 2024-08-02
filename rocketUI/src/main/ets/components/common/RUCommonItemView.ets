/**
 * 通用ItemView组件
 * @author shengjie
 * @time 2024.07.30
 */
@Component
export struct RUCommonItemView {
  leftPadding?: number = 15
  rightPadding?: number = 15
  //左侧图片
  leftImage?: string | PixelMap | Resource = undefined
  //左侧文案
  leftContent?: string = "-"
  leftContentFontColor?: ResourceColor = $r("app.color.ru_color_FF333333")
  leftContentMaxLines?: number = 1
  //是否显示红色星号"*"
  isShowRedStar?: boolean = true
  //右侧是否能够输入 true 能够输入 false 不能输入，只是展示文案
  isRightInput?: boolean = false
  //右侧提示文案
  rightHint?: string = "请选择"
  //右侧文案（优先显示content文案，如果没有则显示hint）
  rightContent?: string = ""
  rightContentColor?: ResourceColor = $r("app.color.ru_color_FF000000")
  //右侧底部提示文案
  rightBottomHint?: string = "请输入内容"
  //右侧底部文案（优先显示content文案，如果没有则显示hint）
  rightBottomContent?: string = ""
  //垂直间距
  leftContentPaddingVertical?: number = 15
  //是否显示右侧箭头
  isShowRightArrow?: boolean = true
  //文案的最大行数
  maxLines?: number = 1
  //显示底部的分割线
  isShowBottomLine?: boolean = true
  bottomLineMarginLeft?: number = 15
  bottomLineMarginRight?: number = 15
  bgColor?: ResourceColor = $r("app.color.ru_color_FFFFFFFF")
  rightImage?: Resource = undefined
  //保存的数据
  tag?: string = ""
  onClickItem: Function = () => {
  }
  //水平模式，右边输入框内容改变监听
  onRightContentChange: Function = () => {
  }
  //水平模式，底部输入框内容改变监听
  onRightBottomContentChange: Function = () => {
  }
  //可以通过这个尾部，自定义星号的样式
  @BuilderParam starView: () => void = this.defaultBuilder

  build() {

    Column() {
      Row() {
        Row() {
          if (this.leftImage) {
            Image(this.leftImage).width(14).height(14).margin({ right: 10 }).objectFit(ImageFit.Fill)
          }

          Text(this.leftContent)
            .fontSize(15)
            .padding({
              top: this.leftContentPaddingVertical,
              bottom: this.leftContentPaddingVertical
            })
            .fontColor(this.leftContentFontColor ?? $r("app.color.ru_color_FF333333"))
            .maxLines(this.leftContentMaxLines)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          if (this.isShowRedStar) {
            this.starView()
          }
        }.padding({ right: 15 })
        .constraintSize({ minWidth: 100 })

        if (this.isRightInput === true) {
          if (this.maxLines === 1) {
            TextInput({ placeholder: this.rightHint, text: this.rightContent })
              .textAlign(TextAlign.End)
              .fontSize(15)
              .backgroundColor(this.bgColor)
              .placeholderColor($r("app.color.ru_color_FFC0C4CC"))
              .fontColor(this.rightContentColor)
              .layoutWeight(1)
              .onChange((value: string) => {
                this.rightContent = value
                this.onRightContentChange(value)
              })
          } else {
            TextArea({ placeholder: this.rightHint, text: this.rightContent })
              .textAlign(TextAlign.End)
              .fontSize(15)
              .fontColor(this.rightContentColor)
              .placeholderColor($r("app.color.ru_color_FFC0C4CC"))
              .backgroundColor(this.bgColor)
              .layoutWeight(1)
              .onChange((value: string) => {
                this.rightContent = value
                this.onRightContentChange(value)
              })
          }
        } else {
          if (this.isEmptyString(this.rightContent ?? "")) {
            Text(this.rightHint)
              .fontColor($r("app.color.ru_color_FFC0C4CC"))
              .maxLines(this.maxLines)
              .textAlign(TextAlign.End)
              .fontSize(15)
              .layoutWeight(1)
          } else {
            Text(this.rightContent)
              .maxLines(this.maxLines)
              .fontColor(this.rightContentColor)
              .textAlign(TextAlign.End)
              .fontSize(15)
              .layoutWeight(1)
          }
        }
        if (this.isShowRightArrow) {
          if (this.rightImage === null || this.rightImage === undefined) {
            Image($r("app.media.ru_ic_right_arrow_gray")).width(7).height(14).margin({ left: 9 })
          } else {
            Image(this.rightImage).width(14).height(14).margin({ left: 9 })
          }
        }
      }
      .padding({ left: this.leftPadding, right: this.rightPadding })
      .width("100%")
      .justifyContent(FlexAlign.Start)
      .onClick(() => {
        this.onClickItem(this.leftContent)
      })

      if (this.isShowBottomLine === true) {
        Row() {
          Shape()
            .layoutWeight(1)
            .height(1)
            .backgroundColor($r("app.color.ru_color_FFEDEDED"))
        }
        .width("100%")
        .height(1)
        .padding({ left: this.bottomLineMarginLeft, right: this.bottomLineMarginRight })
      }
    }.width("100%")
    .backgroundColor(this.bgColor)

  }

  @Builder
  defaultBuilder() {
    Text("*").fontSize(15)
      .padding({ top: 15, bottom: 15, left: 5 })
      .fontColor($r("app.color.ru_main_color"))
  }

  /**
   * 是空字符串吗
   * @param str
   * @returns
   */
  isEmptyString(str: string): boolean {
    return str === undefined || str === null || str.length === 0
  }
}

export const enum RUOrientation {
  horizontal,
  vertical,
  checkBox
}
