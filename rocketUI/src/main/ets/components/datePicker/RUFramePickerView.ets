import { IPickerViewData } from './data/IPickerViewData'
import { FrameComponent, FrameOptions } from './frame/FrameComponent'

/**
 * 框架选择器
 */
@Component
export struct RUFramePickerView {
  /**筛选控制器**/
  @Link frameOptionsController: FrameOptionsController
  @Prop topHeight: number = 0
  /**单选结果回调**/
  backSingleResult: (index: number, result: IPickerViewData) => void = (): void => {
  }
  /**多选结果回调**/
  backMultipleResult: (result: Array<IPickerViewData>) => void = (): void => {
  }
  /**消失监听**/
  onDismissListener: () => void = (): void => {
  }
  /**私有变量**/
  @State frameOptions: FrameOptions = new FrameOptions()
  @State isExpand: boolean = false
  @State isShow: boolean = false

  aboutToAppear(): void {
    this.frameOptionsController.setPickerData =
      (frameOptions: FrameOptions, setValue: (item: IPickerViewData, index: number) => void) => {
        frameOptions.data.forEach((item: IPickerViewData, index: number) => {
          setValue(item, index)
        })
        this.frameOptions = frameOptions
      }
    this.frameOptionsController.showPicker = () => {
      this.isExpand ? this.isExpand = false : this.isExpand = true
    }
    this.frameOptionsController.closePicker = () => {
      if (this.isExpand) {
        this.isExpand = false
        this.onDismissListener()
      }
    }
    this.frameOptionsController.setPickerCurrentIndex = (index: number) => {
      this.frameOptions.currentIndex = index
    }
    this.frameOptionsController.setPickerSelectedData = (selectedData: Array<IPickerViewData>) => {
      if (this.frameOptions.isMultipleSelect && this.frameOptions.data.length > 0) {
        if (selectedData.length == 0 && this.frameOptions.isMultipleSelect) {
          this.frameOptions.data[0].optionSelected = true
        } else {
          this.frameOptions.data.forEach((item1: IPickerViewData, index: number) => {
            selectedData.forEach((item2: IPickerViewData) => {
              if (item1.optionsName == item2.optionsName) {
                item1.optionSelected = true
              }
            })
          })
        }
      }
      this.frameOptions.currentIndex = Math.ceil(Math.random() * 10000)
    }
  }

  build() {
    Column() {

      Blank()
        .onClick(() => {
          this.isExpand = false
          this.onDismissListener()
        })
        .height(this.topHeight)

      Column() {
        FrameComponent({
          isExpand: this.isExpand,
          isShow: this.isShow,
          frameOptions: this.frameOptions,
          backResult: (index: number, result: IPickerViewData) => {
            this.onDismissListener()
            this.backSingleResult(index, result)
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
              this.frameOptions.currentIndex = Math.ceil(Math.random() * 10000)
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
              this.onDismissListener()
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

        Blank()
          .onClick(() => {
            this.isExpand = false
            this.onDismissListener()
          })
      }
      .height('100%')
      .backgroundColor('#66000000')
    }
    .width('100%')
    .height(this.isExpand ? '100%' : 0)
    .height('100%')
    .visibility(this.isExpand ? Visibility.Visible : this.isShow ? Visibility.Visible : Visibility.None)
  }

}

export class FrameOptionsController {
  /**
   * 设置数据源(不支持调用)
   */
  setPickerData: (frameOptions: FrameOptions, setValue: (item: IPickerViewData, index: number) => void) => void =
    () => {
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
  setPickerSelectedData: (selectedData: Array<IPickerViewData>) => void = () => {
  }
  /**
   * 关闭当前筛选界面
   */
  closePicker: () => void = () => {
  }
}

