import { IPickerViewData } from './data/IPickerViewData';
import { PickerOptions, WheelComponent } from './wheel/WheelComponent'

/**
 * 列表多级联动选择器
 */
@Component
export struct RUPickerView {
  @Link pickerOptionsController: PickerOptionsController
  /**私有变量**/
  @State ArrayOptions: PickerOptions[] = []
  @State isExpand: boolean = false
  @State isShow: boolean = false
  clickSelected: (item: IPickerViewData, index: number, tag: string) => void = () => {
  }
  onReSet: () => void = () => {
  }
  backResult: (result: Array<PickerResult>) => void = () => {
  }

  aboutToAppear(): void {
    this.pickerOptionsController.setPickerData = (pickerOptions: PickerOptions, setValue: (item: IPickerViewData, index: number) => void) => {
      pickerOptions.data.forEach((item: IPickerViewData, index: number) => {
        setValue(item, index)
      })
      this.setDataByPickerOptions(pickerOptions)
    }
    this.pickerOptionsController.showPicker = () => {
      this.isExpand ? this.isExpand = false : this.isExpand = true
    }
    this.pickerOptionsController.setPickerCurrentIndex = (tag: string, currentIndex: number) => {
      this.ArrayOptions.forEach((item: PickerOptions, index: number) => {
        if (tag == item.tag) {
          item.currentIndex = currentIndex
          this.notifyUI(item, index)
        }
      })
    }
    this.pickerOptionsController.setPickerSelectedData = (tag: string, selectedData: Array<IPickerViewData>) => {
      this.ArrayOptions.forEach((item: PickerOptions, index: number) => {
        if (tag == item.tag) {
          if (item.isMultipleSelect && item.data.length > 0) {
            if (selectedData.length == 0) {
              item.data[0].optionSelected = true
            } else {
              item.data.forEach((item1: IPickerViewData, index: number) => {
                selectedData.forEach((item2, IPickerViewData) => {
                  if (item1.optionsName = item2.optionsName) {
                    item1.optionSelected = true
                  }
                })
              })
            }
          }
          this.notifyUI(item, index)
        }
      })
    }
  }

  build() {
    Column() {
      Column() {
        Row() {
          ForEach(this.ArrayOptions, (item: PickerOptions, index: number) => {
            WheelComponent({
              pickOptions: item,
              optionsSelect: (item: IPickerViewData, index: number, tag: string) => {
                this.clickSelected(item, index, tag)
              },
              refreshUI: () => {
                this.notifyUI(item, index)
              }
            }).layoutWeight(1)
          })
        }

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
              this.onReSet()
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
              this.handleResult()
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
      }
      .height(this.isExpand ? 340 : 0)
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

      Blank()
        .onClick(() => {
          this.isExpand = false
        }).zIndex(-1)
    }
    .width('100%')
    .height(this.isExpand ? '100%' : 0)
    .height('100%')
    .backgroundColor('#66000000')
    .visibility(this.isExpand ? Visibility.Visible : this.isShow ? Visibility.Visible : Visibility.None)
  }

  /**添加或更改数据内容**/
  setDataByPickerOptions(pickerOptions: PickerOptions) {
    let currentIndex: number = -1
    this.ArrayOptions.forEach((item: PickerOptions, index: number) => {
      if (pickerOptions.tag == item.tag) {
        currentIndex = index
      }
    })
    if (currentIndex == -1) {
      this.ArrayOptions.push(pickerOptions)
    } else {
      this.ArrayOptions[currentIndex] = pickerOptions
    }
  }

  handleResult() {
    let result: Array<PickerResult> = []
    this.ArrayOptions.forEach((item: PickerOptions) => {
      let rst = new PickerResult()
      rst.tag = item.tag
      rst.singleCurrentIndex = item.currentIndex
      rst.singleResult = item.data[item.currentIndex]
      if (item.isMultipleSelect) {
        let selectedData: Array<IPickerViewData> = []
        item.data.forEach((item: IPickerViewData) => {
          if (item.optionSelected) {
            selectedData.push(item)
          }
        })
        rst.multipleResult = selectedData
      }
      result.push(rst)
    })
    this.backResult(result)
  }

  notifyUI(item: PickerOptions, index: number) {
    let pickerOptions = new PickerOptions()
    pickerOptions.tag = item.tag
    pickerOptions.data = item.data
    pickerOptions.currentIndex = item.currentIndex
    pickerOptions.selectedStyle = item.selectedStyle
    pickerOptions.isMultipleSelect = item.isMultipleSelect
    pickerOptions.isFirstMutex = item.isFirstMutex
    this.ArrayOptions[index] = pickerOptions
  }
}


export class PickerOptionsController {
  /**
   * 设置数据源
   */
  setPickerData: (pickerOptions: PickerOptions, setValue: (item: IPickerViewData, index: number) => void) => void = () => {
  }
  /**
   * 显示布局
   */
  showPicker: () => void = () => {
  }
  /**
   * 设置单选当前位置
   */
  setPickerCurrentIndex: (tag: string, currentIndex: number) => void = () => {
  }
  /**
   * 设置多选已选内容
   * 当开启头内容互斥关系后则设置selectedData为new Array 后默认选中首个内容
   */
  setPickerSelectedData: (tag: string, selectedData: Array<IPickerViewData>) => void = () => {
  }
}

export class PickerResult {
  tag: string = ''
  singleResult?: IPickerViewData
  singleCurrentIndex: number = -1
  multipleResult: Array<IPickerViewData> = []
}