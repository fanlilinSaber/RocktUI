import { IPickerViewData } from '../data/IPickerViewData'
import { FrameComponent, FrameOptions } from './FrameComponent'

/**
 * 框架选择器
 */
@Component
export struct RUFramePickerView {
  /**筛选控制器**/
  @Link frameOptionsController: FrameOptionsController
  /**单选结果回调**/
  backSingleResult: (index: number, result: IPickerViewData) => void = (): void => {
  }
  /**多选结果回调**/
  backMultipleResult: (result: Array<IPickerViewData>) => void = (): void => {
  }
  /**私有变量**/
  @State frameOptions: FrameOptions = new FrameOptions()
  @State isExpand: boolean = false
  @State isShow: boolean = false

  aboutToAppear(): void {
    this.frameOptionsController.setFrameOptions = (frameOptions: FrameOptions) => {
      this.frameOptions = frameOptions
    }
    this.frameOptionsController.showPicker = () => {
      this.isExpand ? this.isExpand = false : this.isExpand = true
    }
    this.frameOptionsController.setPickerCurrentIndex = (index: number) => {
      this.frameOptions.currentIndex = index
      this.notifyUI()
    }
    this.frameOptionsController.setPickerSelectedData = (selectedData: Array<IPickerViewData>) => {
      if (this.frameOptions.isMultipleSelect && this.frameOptions.data.length > 0) {
        if (selectedData.length == 0 && this.frameOptions.isMultipleSelect) {
          this.frameOptions.data[0].optionSelected = true
        } else {
          this.frameOptions.data.forEach((item1: IPickerViewData, index: number) => {
            selectedData.forEach((item2, IPickerViewData) => {
              if (item1.optionsName = item2.optionsName) {
                item1.optionSelected = true
              }
            })
          })
        }
      }
      this.notifyUI()
    }
  }

  build() {
    Column() {
      Column() {
        FrameComponent({
          isExpand: this.isExpand,
          isShow: this.isShow,
          frameOptions: this.frameOptions,
          backResult: this.backSingleResult,
          refreshUI: (index: number) => {
            if (this.frameOptions.isMultipleSelect) {
              if (this.frameOptions.isFirstMutex) {
                if (index == 0) {
                  this.frameOptions.data.forEach((item: IPickerViewData) => {
                    item.optionSelected = false
                  })
                  this.frameOptions.data[0].optionSelected = true
                } else {
                  this.frameOptions.data[0].optionSelected = false
                }
              }
              this.notifyUI()
            }
          }
        })
        Row() {
          Text('重置')
            .fontColor($r('app.color.ru_color_FF333333'))
            .fontSize(15)
            .textAlign(TextAlign.Center)
            .layoutWeight(1)
            .width('100%')
            .height(40)
            .backgroundColor($r('app.color.ru_color_FFF5F5F5'))
            .borderRadius(5)
            .margin({
              right: 10
            })
            .onClick(() => {
              this.frameOptions.data.forEach((item: IPickerViewData) => {
                item.optionSelected = false
              })
              if (this.frameOptions.isFirstMutex) {
                this.frameOptions.data[0].optionSelected = true
              }
              this.notifyUI()
            })
          Text('确定')
            .fontColor(Color.White)
            .fontSize(15)
            .textAlign(TextAlign.Center)
            .layoutWeight(1)
            .width('100%')
            .height(40)
            .backgroundColor($r('app.color.ru_color_FFEF4033'))
            .borderRadius(5)
            .onClick(() => {
              let result: Array<IPickerViewData> = []
              this.frameOptions.data.forEach((item: IPickerViewData) => {
                if (item.optionSelected) {
                  result.push(item)
                }
              })
              this.backMultipleResult(result)
              this.isExpand = false
            })
        }
        .padding({
          left: 15,
          right: 15
        })
        .backgroundColor(Color.White)
        .height(56)
        .borderRadius({
          bottomLeft: 15,
          bottomRight: 15
        })
        .visibility(this.frameOptions.isMultipleSelect ? Visibility.Visible : Visibility.None)
      }

      Blank()
        .onClick(() => {
          this.isExpand = false
        })
    }
    .width('100%')
    .height(this.isExpand ? '100%' : 0)
    .height('100%')
    .backgroundColor('#66000000')
    .visibility(this.isExpand ? Visibility.Visible : this.isShow ? Visibility.Visible : Visibility.None)
  }

  /**刷新UI布局(替换原始数据内容被观察者发生变化后促使UI刷新)**/
  notifyUI() {
    let refreshData = new FrameOptions()
    refreshData.data = this.frameOptions.data
    refreshData.isMultipleSelect = true
    this.frameOptions = refreshData
  }
}

export class FrameOptionsController {
  /**
   * 设置数据源(不支持调用)
   */
  setFrameOptions?: (frameOptions: FrameOptions) => void
  /**
   * 设置数据源实现方法
   */
  setPickerData(frameOptions: FrameOptions, setValue: (item: IPickerViewData, index: number) => void) {
    frameOptions.data.forEach((item: IPickerViewData, index: number) => {
      setValue(item, index)
    })
    if (this.setFrameOptions) {
      this.setFrameOptions(frameOptions);
    }
  }
  /**
   * 显示布局
   */
  showPicker: () => void = () => {
  }
  /**
   * 设置单选当前位置
   */
  setPickerCurrentIndex: (index: number) => void = () => {
  }
  /**
   * 设置多选已选内容
   * 当开启头内容互斥关系后则设置selectedData为new Array 后默认选中首个内容
   */
  setPickerSelectedData: (selectedData: Array<IPickerViewData>) => void = () => {}
}

