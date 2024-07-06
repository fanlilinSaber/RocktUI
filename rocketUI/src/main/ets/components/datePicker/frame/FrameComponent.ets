import { IPickerViewData } from '../data/IPickerViewData'

/**
 * 框架选择器
 */
@Component
export struct FrameComponent {
  //可配置变量
  @ObjectLink frameOptions: FrameOptions
  @Link isExpand: boolean
  @Link isShow: boolean
  backResult: (index: number, result: IPickerViewData) => void = (): void => {
  }

  build() {
    Column() {
      Column() {
        Grid() {
          ForEach(this.frameOptions.data, (item: IPickerViewData, index: number) => {
            GridItem() {
              if (this.frameOptions.isMultipleSelect) {
                ItemMultipleSelectBuilder({
                  data: item,
                  frameOptions: this.frameOptions,
                  index: index
                })
              } else {
                ItemSingleSelectBuilder({
                  data: item,
                  frameOptions: this.frameOptions,
                  index: index,
                  backResult: (index: number, result: IPickerViewData) => {
                    this.isExpand = false
                    this.backResult(index, result)
                  }
                })
              }
            }
          })
        }
        .padding({
          top: 10,
          left: 10,
          right: 10
        })
        .columnsGap(10)
        .rowsGap(10)
        .columnsTemplate('1fr 1fr 1fr 1fr')
        .edgeEffect(EdgeEffect.None)
        .scrollBar(BarState.Off)
        .height(this.isExpand ?
          this.frameOptions.data.length > 20 ? 280 : this.getViewHeight(this.frameOptions.data.length) : 0)
        .nestedScroll({
          scrollForward: NestedScrollMode.PARENT_FIRST,
          scrollBackward: NestedScrollMode.SELF_FIRST
        })
        .backgroundColor(Color.White)
        .borderRadius({
          bottomLeft: this.frameOptions.isMultipleSelect ? 0 : 15,
          bottomRight: this.frameOptions.isMultipleSelect ? 0 : 15
        })
        .animation({
          duration: 120,
          tempo: 1,
          curve: Curve.FastOutSlowIn,
          iterations: 1,
          playMode: PlayMode.Normal,
          onFinish: () => {
            if (this.isExpand) {
              this.isShow = true
            } else {
              this.isShow = false
            }
          }
        })
      }
    }
  }

  getViewHeight(length: number) {
    let num = Math.ceil(length / 4)
    return num * 40 + (num - 1) * 10 + 20
  }
}

@Component
struct ItemMultipleSelectBuilder {
  @ObjectLink data: IPickerViewData
  @Link frameOptions: FrameOptions
  @State index: number = -1

  build() {
    Text(this.data.optionsName)
      .fontSize(14)
      .fontColor(this.data.optionSelected ? $r('app.color.ru_color_FFEF4033') : $r('app.color.ru_color_FF333333'))
      .height(40)
      .textAlign(TextAlign.Center)
      .maxLines(1)
      .textOverflow({
        overflow: TextOverflow.Ellipsis
      })
      .border({
        radius: 5,
        width: 1,
        color: this.data.optionSelected ? $r('app.color.ru_color_FFEF4033') : Color.Transparent
      })
      .backgroundColor(this.data.optionSelected ? $r('app.color.ru_color_1AEF4033') : $r('app.color.ru_color_FFF5F5F5'))
      .width('100%')
      .onClick(() => {
        this.data.optionSelected ? this.data.optionSelected = false : this.data.optionSelected = true
        if (this.frameOptions.isFirstMutex) {
          if (this.index == 0) {
            this.frameOptions.data.forEach((item: IPickerViewData) => {
              item.optionSelected = false
            })
            this.frameOptions.data[0].optionSelected = true
          } else {
            let flag: boolean = false
            this.frameOptions.data.forEach((item: IPickerViewData) => {
              if (item.optionSelected) {
                flag = true
              }
            })
            this.frameOptions.data[0].optionSelected = !flag
          }
        }
        this.frameOptions.currentIndex = Math.ceil(Math.random() * 10000)
      })
  }
}

@Component
struct ItemSingleSelectBuilder {
  @ObjectLink data: IPickerViewData
  @Link frameOptions: FrameOptions
  @State index: number = -1
  backResult: (index: number, result: IPickerViewData) => void = (): void => {
  }

  build() {
    Text(this.data.optionsName)
      .fontSize(14)
      .fontColor(this.frameOptions.currentIndex == this.index ? $r('app.color.ru_color_FFEF4033') :
      $r('app.color.ru_color_FF333333'))
      .height(40)
      .textAlign(TextAlign.Center)
      .maxLines(1)
      .textOverflow({
        overflow: TextOverflow.Ellipsis
      })
      .border({
        radius: 5,
        width: 1,
        color: this.frameOptions.currentIndex == this.index ? $r('app.color.ru_color_FFEF4033') : Color.Transparent
      })
      .backgroundColor(this.frameOptions.currentIndex == this.index ? $r('app.color.ru_color_1AEF4033') :
      $r('app.color.ru_color_FFF5F5F5'))
      .width('100%')
      .onClick(() => {
        this.frameOptions.currentIndex = this.index
        this.backResult(this.index, this.frameOptions.data[this.index])
      })
  }
}

@Observed
export class FrameOptions {
  /**
   * 数据源
   */
  data: Array<IPickerViewData> = []
  /**
   * 设置当前位置(单选)
   */
  currentIndex: number = -1
  /**
   * 是否支持多选
   */
  isMultipleSelect: boolean = false
  /**
   * 多选后是否支持头内容互斥
   */
  isFirstMutex: boolean = true
}