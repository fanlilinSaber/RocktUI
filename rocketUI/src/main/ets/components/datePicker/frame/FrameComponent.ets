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
  refreshUI: () => void = () => {
  }

  build() {
    Column() {
      Column() {
        Grid() {
          ForEach(this.frameOptions.data, (item: IPickerViewData, index: number) => {
            GridItem() {
              if (this.frameOptions.isMultipleSelect) {
                this.ItemMultipleSelectBuilder(item, index)
              } else {
                this.ItemSingleSelectBuilder(item, index)
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
        .height(this.isExpand ? this.frameOptions.data.length > 20 ? 280 : this.getViewHeight(this.frameOptions.data.length) : 0)
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

  @Builder
  ItemSingleSelectBuilder(item: IPickerViewData, index: number) {
    Text(item.optionsName)
      .fontSize(14)
      .fontColor(this.frameOptions.currentIndex == index ? $r('app.color.ru_color_FFEF4033') : $r('app.color.ru_color_FF333333'))
      .height(40)
      .textAlign(TextAlign.Center)
      .maxLines(1)
      .textOverflow({
        overflow: TextOverflow.Ellipsis
      })
      .border({
        radius: 5,
        width: 1,
        color: this.frameOptions.currentIndex == index ? $r('app.color.ru_color_FFEF4033') : Color.Transparent
      })
      .backgroundColor(this.frameOptions.currentIndex == index ? $r('app.color.ru_color_1AEF4033') : $r('app.color.ru_color_FFF5F5F5'))
      .width('100%')
      .onClick(() => {
        this.frameOptions.currentIndex = index
        this.backResult(index, this.frameOptions.data[index])
        this.isExpand = false
      })
  }

  @Builder
  ItemMultipleSelectBuilder(item: IPickerViewData, index: number) {
    Text(item.optionsName)
      .fontSize(14)
      .fontColor(item.optionSelected ? $r('app.color.ru_color_FFEF4033') : $r('app.color.ru_color_FF333333'))
      .height(40)
      .textAlign(TextAlign.Center)
      .maxLines(1)
      .textOverflow({
        overflow: TextOverflow.Ellipsis
      })
      .border({
        radius: 5,
        width: 1,
        color: item.optionSelected ? $r('app.color.ru_color_FFEF4033') : Color.Transparent
      })
      .backgroundColor(item.optionSelected ? $r('app.color.ru_color_1AEF4033') : $r('app.color.ru_color_FFF5F5F5'))
      .width('100%')
      .onClick(() => {
        item.optionSelected ? item.optionSelected = false : item.optionSelected = true
        if (this.frameOptions.isMultipleSelect) {
          if (this.frameOptions.isFirstMutex) {
            if (index == 0) {
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
        }
        this.refreshUI()
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