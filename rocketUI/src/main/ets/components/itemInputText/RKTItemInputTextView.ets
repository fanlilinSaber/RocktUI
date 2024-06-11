
import { RKTItemInputTextViewObserved } from './RKTItemInputTextViewObserved'
/**
 * 自定义文字输入类型组件
 * RKTOrientation.horizontal
 * @author shengjie
 * @time 2023.12.20 09:40
 */
@Component
export struct RKTItemInputTextView {
  @ObjectLink mObserved: RKTItemInputTextViewObserved
  onClickItem: Function = (result: string) => {
  }
  onClickCheckBox: Function = (isCheckBoxChecked: boolean) => {
  }
  //水平模式，右边输入框内容改变监听
  onRightContentChange: Function = (result: string) => {
  }
  //水平模式，底部输入框内容改变监听
  onRightBottomContentChange: Function = (result: string) => {
  }
  //垂直模式，底部输入框内容改变监听
  onBottomContentChange: Function = (result: string) => {
  }
  //CheckBox模式输入框内容改变监听
  onCheckBoxContentChange: Function = (result: string) => {
  }
  //可以通过这个尾部，自定义星号的样式
  @BuilderParam starView: () => void = this.defaultBuilder

  build() {

    Column() {
      if (this.mObserved.orientation === RKTOrientation.horizontal) {
        Row() {

          Row() {
            if (this.mObserved.leftImage) {
              Image(this.mObserved.leftImage).width(14).height(14).margin({ right: 10 }).objectFit(ImageFit.Fill)
            }

            Text(this.mObserved.leftContent)
              .fontSize(15)
              .padding({
                top: this.mObserved.leftContentPaddingVertical,
                bottom: this.mObserved.leftContentPaddingVertical
              })
              .fontColor(this.mObserved.leftContentFontColor??$r("app.color.ru_color_FF333333"))
              .maxLines(this.mObserved.leftContentMaxLines)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
            if (this.mObserved.isShowRedStar) {
              this.starView()
            }
          }.padding({ right: 15 })
          .constraintSize({ minWidth: 100 })

          if (this.mObserved.isRightInput === true) {
            if (this.mObserved.maxLines === 1) {
              TextInput({ placeholder: this.mObserved.rightHint, text: this.mObserved.rightContent })
                .textAlign(TextAlign.End)
                .fontSize(15)
                .backgroundColor(this.mObserved.bgColor)
                .placeholderColor($r("app.color.ru_color_FFC0C4CC"))
                .fontColor(this.mObserved.rightContentColor)
                .layoutWeight(1)
                .onChange((value: string) => {
                  this.mObserved.rightContent = value
                  this.onRightContentChange(value)
                })
            } else {
              TextArea({ placeholder: this.mObserved.rightHint, text: this.mObserved.rightContent })
                .textAlign(TextAlign.End)
                .fontSize(15)
                .fontColor(this.mObserved.rightContentColor)
                .placeholderColor($r("app.color.ru_color_FFC0C4CC"))
                .backgroundColor(this.mObserved.bgColor)
                .layoutWeight(1)
                .onChange((value: string) => {
                  this.mObserved.rightContent = value
                  this.onRightContentChange(value)
                })
            }
          } else {
            if (this.isEmptyString(this.mObserved.rightContent??"")) {
              Text(this.mObserved.rightHint)
                .fontColor($r("app.color.ru_color_FFC0C4CC"))
                .maxLines(this.mObserved.maxLines)
                .textAlign(TextAlign.End)
                .fontSize(15)
                .layoutWeight(1)
            } else {
              Text(this.mObserved.rightContent)
                .maxLines(this.mObserved.maxLines)
                .fontColor(this.mObserved.rightContentColor)
                .textAlign(TextAlign.End)
                .fontSize(15)
                .layoutWeight(1)
            }
          }
          if (this.mObserved.isShowRightArrow) {
            if (this.mObserved.rightImage === null || this.mObserved.rightImage === undefined) {
              Image($r("app.media.ru_ic_right_arrow_gray")).width(7).height(14).margin({ left: 9 })
            } else {
              Image(this.mObserved.rightImage).width(14).height(14).margin({ left: 9 })
            }
          }
        }
        .padding({ left: this.mObserved.leftPadding, right: this.mObserved.rightPadding })
        .width("100%")
        .justifyContent(FlexAlign.Start)
        .onClick(() => {
          this.onClickItem(this.mObserved.leftContent)
        })

        if (this.mObserved.isRightBottomInput === true) {
          TextArea({ placeholder: this.mObserved.rightBottomHint, text: this.mObserved.rightBottomContent })
            .textAlign(TextAlign.End)
            .fontSize(15)
            .fontColor($r("app.color.ru_color_FF000000"))
            .placeholderColor($r("app.color.ru_color_FFC0C4CC"))
            .backgroundColor(this.mObserved.bgColor)
            .onChange((value: string) => {
              this.mObserved.rightBottomContent = value
              this.onRightBottomContentChange(value)
            })
        }

      } else if (this.mObserved.orientation === RKTOrientation.vertical) {
        Row() {
          Text(this.mObserved.leftContent)
            .fontSize(15)
            .padding({
              top: this.mObserved.leftContentPaddingVertical,
              bottom: this.mObserved.leftContentPaddingVertical
            })
            .fontColor(this.mObserved.leftContentFontColor??$r("app.color.ru_color_FF333333"))
            .maxLines(this.mObserved.leftContentMaxLines)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          if (this.mObserved.isShowRedStar) {
            this.starView()
          }
        }
        .padding({ left: this.mObserved.leftPadding, right: this.mObserved.rightPadding })
        .width("100%")
        .justifyContent(FlexAlign.Start)
        .onClick(() => {
          this.onClickItem(this.mObserved.leftContent)
        })

        if (this.mObserved.isBottomInput === true) {
          if (this.mObserved.maxLines === 1) {
            TextInput({ placeholder: this.mObserved.bottomHint, text: this.mObserved.bottomContent })
              .width("100%")
              .fontSize(15)
              .fontColor($r("app.color.ru_color_FF000000"))
              .placeholderColor($r("app.color.ru_color_FFC0C4CC"))
              .backgroundColor(this.mObserved.bgColor)
              .onChange((value: string) => {
                this.mObserved.bottomContent = value
                this.onBottomContentChange(value)
              })

          } else {
            TextArea({ placeholder: this.mObserved.bottomHint, text: this.mObserved.bottomContent })
              .width("100%")
              .fontSize(15)
              .fontColor($r("app.color.ru_color_FF000000"))
              .placeholderColor($r("app.color.ru_color_FFC0C4CC"))
              .backgroundColor(this.mObserved.bgColor)
              .onChange((value: string) => {
                this.mObserved.bottomContent = value
                this.onBottomContentChange(value)
              })
          }
        } else {
          if (this.isEmptyString(this.mObserved.bottomContent??"")) {
            Text(this.mObserved.bottomHint).maxLines(this.mObserved.maxLines).width("100%")
              .padding({ left: 15, right: 15, bottom: 10 })
              .fontColor($r("app.color.ru_color_FFC0C4CC"))
          } else {
            Text(this.mObserved.bottomContent).maxLines(this.mObserved.maxLines).width("100%")
              .padding({ left: 15, right: 15, bottom: 10 })
              .fontColor($r("app.color.ru_color_FF000000"))
          }
        }
      } else {

        Row() {
          Text(this.mObserved.leftContent)
            .fontSize(15)
            .padding({
              top: this.mObserved.leftContentPaddingVertical,
              bottom: this.mObserved.leftContentPaddingVertical
            })
            .fontColor(this.mObserved.leftContentFontColor??$r("app.color.ru_color_FF333333"))
            .maxLines(this.mObserved.leftContentMaxLines)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          if (this.mObserved.isShowRedStar) {
            Text("*").fontSize(15)
              .padding({ top: 15, bottom: 15, left: 5 })
              .fontColor($r("app.color.ru_main_color"))
          }

          Blank()

          if (this.mObserved.isRightInput === true) {
            TextInput({ placeholder: this.mObserved.rightHint, text: this.mObserved.rightContent })
              .textAlign(TextAlign.End)
              .fontSize(15)
              .width(100)
              .backgroundColor(this.mObserved.bgColor)
              .placeholderColor($r("app.color.ru_color_FFC0C4CC"))
              .fontColor($r("app.color.ru_color_FF000000"))
              .onChange((value: string) => {
                this.mObserved.rightContent = value
                this.onCheckBoxContentChange(value)
              })
            Text(this.mObserved.rightContentUnit??"").fontColor($r("app.color.ru_color_FF333333"))
              .fontSize(14)
              .padding({ left: 5 })
          }

          Image(this.mObserved.isCheckBoxChecked === true ? $r("app.media.ru_ic_check_blue") : $r("app.media.ru_ic_check_gray"))
            .width(15)
            .margin({ left: 20 })
            .height(15)
            .onClick(() => {
              this.mObserved.isCheckBoxChecked = !this.mObserved.isCheckBoxChecked
              this.mObserved.isRightInput = !this.mObserved.isCheckBoxChecked
              this.onClickCheckBox(this.mObserved.isCheckBoxChecked)
            })
          Text(this.mObserved.checkBoxContent??"不限").fontColor($r("app.color.ru_color_FF333333"))
            .fontSize(14)
            .padding({ left: 5 })
            .onClick(() => {
              this.mObserved.isCheckBoxChecked = !this.mObserved.isCheckBoxChecked
              this.mObserved.isRightInput = !this.mObserved.isCheckBoxChecked
              this.onClickCheckBox(this.mObserved.isCheckBoxChecked)
            })
        }
        .padding({ left: this.mObserved.leftPadding, right: this.mObserved.rightPadding })
        .width("100%")
        .justifyContent(FlexAlign.Start)
      }

      if (this.mObserved.isShowBottomLine === true) {
        Row() {
          Shape()
            .layoutWeight(1)
            .height(1)
            .backgroundColor($r("app.color.ru_color_FFEDEDED"))
        }
        .width("100%")
        .height(1)
        .padding({ left: this.mObserved.bottomLineMarginLeft, right: this.mObserved.bottomLineMarginRight })
      }
    }.width("100%")
    .backgroundColor(this.mObserved.bgColor)

  }

  @Builder defaultBuilder() {
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

export const enum RKTOrientation {
  horizontal,
  vertical,
  checkBox
}
