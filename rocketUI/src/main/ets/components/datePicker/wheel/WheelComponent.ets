import { IPickerViewData } from '../data/IPickerViewData'

@Component
export struct WheelComponent {
  @ObjectLink pickOptions: PickerOptions
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
            this.ItemMultipleSelectBuilder(item, index)
          } else {
            this.ItemSingleSelectBuilder(item, index)
          }
        }
      })
    }
    //List设置边缘滑动效果
    .edgeEffect(EdgeEffect.None)
    .scrollBar(BarState.Off)
    .height(280)
    .backgroundColor(Color.White)
    .nestedScroll({
      scrollForward: NestedScrollMode.PARENT_FIRST,
      scrollBackward: NestedScrollMode.SELF_FIRST
    })
  }

  @Builder
  ItemSingleSelectBuilder(item: IPickerViewData, index: number) {
    Row() {
      Text(item.optionsName)
        .fontSize(20)
        .fontColor(this.pickOptions.currentIndex == index ? $r('app.color.ru_color_FFEF4033') : $r('app.color.ru_color_FF333333'))
        //.fontWeight(this.pickOptions.currentIndex == index ? FontWeight.Bold : FontWeight.Normal)
        .height(40)
        .layoutWeight(1)
        .textAlign(TextAlign.Start)
        .maxLines(1)
        .textOverflow({
          overflow: TextOverflow.Ellipsis
        })
      Image($r('app.media.icon_picker_hook_red'))
        .width(15)
        .visibility(this.pickOptions.selectedStyle == SelectedStyle.CHANGE_BACKGROUND && index != 0 ? Visibility.Hidden : this.pickOptions.currentIndex == index ? Visibility.Visible : Visibility.Hidden)
        .margin({
          left: 10
        })
    }
    .backgroundColor(this.pickOptions.selectedStyle == SelectedStyle.CHANGE_BACKGROUND && index != 0 ? this.pickOptions.currentIndex == index ? $r('app.color.ru_color_1AEF4033') : Color.White: Color.White)
    .padding({
      left: 15,
      right: 15
    })
    .onClick(() => {
      this.pickOptions.currentIndex = index
      this.optionsSelect(item, index, this.pickOptions.tag)
    })
  }

  @Builder
  ItemMultipleSelectBuilder(item: IPickerViewData, index: number) {
    Row() {
      Text(item.optionsName)
        .fontSize(20)
        .fontColor(item.optionSelected ? $r('app.color.ru_color_FFEF4033') : $r('app.color.ru_color_FF333333'))
        //.fontWeight(item.optionSelected ? FontWeight.Bold : FontWeight.Normal)
        .height(40)
        .layoutWeight(1)
        .textAlign(TextAlign.Start)
        .maxLines(1)
        .textOverflow({
          overflow: TextOverflow.Ellipsis
        })
      Image($r('app.media.icon_picker_hook_red'))
        .width(15)
        .visibility(this.pickOptions.selectedStyle == SelectedStyle.CHANGE_BACKGROUND && index != 0 ? Visibility.Hidden : item.optionSelected ? Visibility.Visible : Visibility.Hidden)
        .margin({
          left: 10
        })
    }
    .backgroundColor(this.pickOptions.selectedStyle == SelectedStyle.CHANGE_BACKGROUND && index != 0 ? item.optionSelected ? $r('app.color.ru_color_1AEF4033') : Color.White: Color.White)
    .padding({
      left: 15,
      right: 15
    })
    .onClick(() => {
      item.optionSelected ? item.optionSelected = false : item.optionSelected = true
      if (this.pickOptions.isMultipleSelect) {
        if (this.pickOptions.isFirstMutex) {
          if (index == 0) {
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
      this.refreshUI()
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
   * 标识
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
   * 选中模式
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
