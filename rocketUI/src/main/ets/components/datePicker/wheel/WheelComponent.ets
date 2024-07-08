import { IPickerViewData } from '../data/IPickerViewData'

@Component
export struct WheelComponent {
  @ObjectLink pickOptions: PickerOptions
  @Prop bgColor: ResourceColor
  optionsSelect: (item: IPickerViewData, index: number, tag: string) => void = () => {
  }
  /**私有变量**/
  listScroller: Scroller = new Scroller()
  refreshUI: () => void = () => {
  }

  build() {
    List({ scroller: this.listScroller }) {
      ForEach(this.pickOptions.data, (item: IPickerViewData, index: number) => {
        ListItem() {
          if (this.pickOptions.isMultipleSelect) {
            ItemMultipleSelectBuilder({
              data: item,
              index: index,
              pickOptions: this.pickOptions,
            })
          } else {
            ItemSingleSelectBuilder({
              data: item,
              index: index,
              pickOptions: this.pickOptions,
              optionsSelect: (item: IPickerViewData, index: number, tag: string) => {
                this.optionsSelect(item, index, tag)
              }
            })
          }
        }
      })
    }
    //List设置边缘滑动效果
    .edgeEffect(EdgeEffect.None)
    .scrollBar(BarState.Off)
    .height(280)
    .backgroundColor(this.bgColor)
    .nestedScroll({
      scrollForward: NestedScrollMode.PARENT_FIRST,
      scrollBackward: NestedScrollMode.SELF_FIRST
    })
  }

  @Builder
  ItemMultipleSelectBuilder(item: IPickerViewData, index: number) {

  }
}

@Component
struct ItemMultipleSelectBuilder {
  @ObjectLink data: IPickerViewData
  @Link pickOptions: PickerOptions
  @State index: number = -1

  build() {
    Row() {
      Text(this.data.optionsName)
        .fontSize(14)
        .fontColor(this.data.optionSelected ? $r('app.color.ru_color_FFEF4033') :
        $r('app.color.ru_color_FF333333'))
        .fontWeight(this.data.optionSelected ? FontWeight.Bold : FontWeight.Normal)
        .height(40)
        .layoutWeight(1)
        .textAlign(TextAlign.Start)
        .maxLines(1)
        .textOverflow({
          overflow: TextOverflow.Ellipsis
        })
      Image($r('app.media.icon_picker_hook_red'))
        .width(15)
        .visibility(this.pickOptions.selectedStyle == SelectedStyle.CHANGE_BACKGROUND && this.index != 0 ?
        Visibility.Hidden : this.data.optionSelected ? Visibility.Visible : Visibility.Hidden)
        .margin({
          left: 10
        })
    }
    .backgroundColor(this.pickOptions.selectedStyle == SelectedStyle.CHANGE_BACKGROUND && this.index != 0 ?
      this.data.optionSelected ? $r('app.color.ru_color_1AEF4033') : Color.Transparent : Color.Transparent)
    .padding({
      left: 15,
      right: 15
    })
    .onClick(() => {
      this.data.optionSelected ? this.data.optionSelected = false : this.data.optionSelected = true
      if (this.pickOptions.isMultipleSelect) {
        if (this.pickOptions.isFirstMutex) {
          if (this.index == 0) {
            this.pickOptions.data.forEach((item: IPickerViewData) => {
              item.optionSelected = false
            })
            this.pickOptions.data[0].optionSelected = true
          } else {
            let flag: boolean = false
            this.pickOptions.data.forEach((item: IPickerViewData) => {
              if (item.optionSelected) {
                flag = true
              }
            })
            this.pickOptions.data[0].optionSelected = !flag
          }
        }
      }
      this.pickOptions.currentIndex = Math.ceil(Math.random() * 10000)
    })
  }
}

@Component
struct ItemSingleSelectBuilder {
  @ObjectLink data: IPickerViewData
  @Link pickOptions: PickerOptions
  @State index: number = -1
  optionsSelect: (item: IPickerViewData, index: number, tag: string) => void = () => {
  }

  build() {
    Row() {
      Text(this.data.optionsName)
        .fontSize(14)
        .fontColor(this.pickOptions.currentIndex == this.index ? $r('app.color.ru_color_FFEF4033') :
        $r('app.color.ru_color_FF333333'))
        .fontWeight(this.pickOptions.currentIndex == this.index ? FontWeight.Bold : FontWeight.Normal)
        .height(40)
        .layoutWeight(1)
        .textAlign(TextAlign.Start)
        .maxLines(1)
        .textOverflow({
          overflow: TextOverflow.Ellipsis
        })
      Image($r('app.media.icon_picker_hook_red'))
        .width(15)
        .visibility(this.pickOptions.selectedStyle == SelectedStyle.CHANGE_BACKGROUND && this.index != 0 ?
        Visibility.Hidden : this.pickOptions.currentIndex == this.index ? Visibility.Visible : Visibility.Hidden)
        .margin({
          left: 10
        })
    }
    .backgroundColor(this.pickOptions.selectedStyle == SelectedStyle.CHANGE_BACKGROUND && this.index != 0 ?
      this.pickOptions.currentIndex == this.index ? $r('app.color.ru_color_1AEF4033') : Color.Transparent : Color.Transparent)
    .padding({
      left: 15,
      right: 15
    })
    .onClick(() => {
      this.pickOptions.currentIndex = this.index
      this.optionsSelect(this.data, this.index, this.pickOptions.tag)
    })
  }
}

/**
 * 已选项选中样式
 */
export enum SelectedStyle {
  /**
   * 背景修改
   */
  CHANGE_BACKGROUND = 1,
  /**
   * 显示勾选
   */
  SHOW_HOOK = 2
}

@Observed
export class PickerOptions {
  /**
   * 标识  PickerOptionsTag
   *      OPTIONS_ONE 联动列表一
   *      OPTIONS_TWO 联动列表二
   *      OPTIONS_THREE 联动列表三
   */
  tag: string = ''
  /**
   * 数据源
   */
  data: Array<IPickerViewData> = []
  /**
   * 设置当前位置(单选)
   */
  currentIndex: number = -1
  /**
   * 选中模式  SelectedStyle
   *       SHOW_HOOK  勾选模式
   *       CHANGE_BACKGROUND  背景修改
   */
  selectedStyle: number = SelectedStyle.SHOW_HOOK
  /**
   * 是否支持多选
   */
  isMultipleSelect: boolean = false
  /**
   * 多选后是否支持头内容互斥
   */
  isFirstMutex: boolean = true
}
