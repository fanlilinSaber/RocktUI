import { IPickerViewData } from './data/IPickerViewData';
import { PickerOptions, WheelComponent } from './wheel/WheelComponent'

/**
 * 列表多级联动选择器
 */
@Component
export struct RUPickerView {
  @Link pickerOptionsController: PickerOptionsController
  @Prop topHeight: number = 0
  /**私有变量**/
  @State PickerOptionsOne: PickerOptions = new PickerOptions()
  @State PickerOptionsTwo: PickerOptions = new PickerOptions()
  @State PickerOptionsThree: PickerOptions = new PickerOptions()
  @State isExpand: boolean = false
  @State isShow: boolean = false
  @State showTwoPicker: boolean = false
  @State showThreePicker: boolean = false
  /**点击事件回调**/
  clickSelected: (tag: string, index: number, item?: IPickerViewData) => void = () => {
  }
  /**结果回调**/
  backResult: (result: Array<PickerResult>) => void = () => {
  }
  /**消失监听**/
  onDismissListener: () => void = (): void => {
  }

  aboutToAppear(): void {
    this.pickerOptionsController.setMultiplePicker = (count: number) => {
      if (count == 2) {
        this.showTwoPicker = true
      }
      if (count == 3) {
        this.showTwoPicker = true
        this.showThreePicker = true
      }
    }
    this.pickerOptionsController.setPickerData =
      (pickerOptions: PickerOptions, setValue: (item: IPickerViewData, index: number) => void) => {
        pickerOptions.data.forEach((item: IPickerViewData, index: number) => {
          setValue(item, index)
        })
        this.setDataByPickerOptions(pickerOptions)
      }
    this.pickerOptionsController.showPicker = () => {
      this.isExpand ? this.isExpand = false : this.isExpand = true
    }
    this.pickerOptionsController.closePicker = () => {
      this.isExpand = false
      this.onDismissListener()
    }
    this.pickerOptionsController.setPickerCurrentIndex = (tag: string, currentIndex: number) => {
      if (tag == PickerOptionsTag.OPTIONS_ONE) {
        this.PickerOptionsOne.currentIndex = currentIndex
        this.clickSelected(tag, currentIndex, this.PickerOptionsOne.data[currentIndex])
      }
      if (tag == PickerOptionsTag.OPTIONS_TWO) {
        this.PickerOptionsTwo.currentIndex = currentIndex
        this.clickSelected(tag, currentIndex, this.PickerOptionsTwo.data[currentIndex])
      }
      if (tag == PickerOptionsTag.OPTIONS_THREE) {
        this.PickerOptionsThree.currentIndex = currentIndex
        this.clickSelected(tag, currentIndex, this.PickerOptionsThree.data[currentIndex])
      }
    }
    this.pickerOptionsController.setPickerSelectedData = (tag: string, selectedData: Array<IPickerViewData>) => {
      if (tag == PickerOptionsTag.OPTIONS_ONE) {
        if (selectedData.length == 0) {
          this.PickerOptionsOne.data[0].optionSelected = true
        } else {
          this.PickerOptionsOne.data.forEach((item1: IPickerViewData, index: number) => {
            selectedData.forEach((item2: IPickerViewData) => {
              if (item1.optionsName == item2.optionsName) {
                item1.optionSelected = true
              }
            })
          })
        }
        this.PickerOptionsOne.currentIndex = Math.ceil(Math.random() * 10000)
      }
      if (tag == PickerOptionsTag.OPTIONS_TWO) {
        if (selectedData.length == 0) {
          this.PickerOptionsTwo.data[0].optionSelected = true
        } else {
          this.PickerOptionsTwo.data.forEach((item1: IPickerViewData, index: number) => {
            selectedData.forEach((item2: IPickerViewData) => {
              if (item1.optionsName == item2.optionsName) {
                item1.optionSelected = true
              }
            })
          })
        }
        this.PickerOptionsTwo.currentIndex = Math.ceil(Math.random() * 10000)
      }
      if (tag == PickerOptionsTag.OPTIONS_THREE) {
        if (selectedData.length == 0) {
          this.PickerOptionsThree.data[0].optionSelected = true
        } else {
          this.PickerOptionsThree.data.forEach((item1: IPickerViewData, index: number) => {
            selectedData.forEach((item2: IPickerViewData) => {
              if (item1.optionsName == item2.optionsName) {
                item1.optionSelected = true
              }
            })
          })
        }
        this.PickerOptionsThree.currentIndex = Math.ceil(Math.random() * 10000)
      }
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
        Column() {
          Row() {
            WheelComponent({
              pickOptions: this.PickerOptionsOne,
              bgColor: $r('app.color.ru_color_FFFFFFFF'),
              optionsSelect: (item: IPickerViewData, index: number, tag: string) => {
                this.clickSelected(tag, index, item)
              }
            }).layoutWeight(1)
            WheelComponent({
              pickOptions: this.PickerOptionsTwo,
              bgColor: $r('app.color.ru_color_FFFAFAFA'),
              optionsSelect: (item: IPickerViewData, index: number, tag: string) => {
                this.clickSelected(tag, index, item)
              }
            }).layoutWeight(1)
              .layoutWeight(1)
              .visibility(this.showTwoPicker ? Visibility.Visible :
                this.PickerOptionsTwo.data.length > 0 ? Visibility.Visible : Visibility.None)
            WheelComponent({
              pickOptions: this.PickerOptionsThree,
              bgColor: $r('app.color.ru_color_FFF5F5F5'),
              optionsSelect: (item: IPickerViewData, index: number, tag: string) => {
                this.clickSelected(tag, index, item)
              }
            }).layoutWeight(1)
              .visibility(this.showThreePicker ? Visibility.Visible :
                this.PickerOptionsThree.data.length > 0 ? Visibility.Visible : Visibility.None)
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
                this.PickerOptionsOne.currentIndex = 0
                this.PickerOptionsTwo.data = []
                this.PickerOptionsThree.data = []
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
            this.onDismissListener()
          }).layoutWeight(1)
      }
      .height('100%')
      .backgroundColor('#66000000')
    }
    .width('100%')
    .height(this.isExpand ? '100%' : 0)
    .height('100%')
    .visibility(this.isExpand ? Visibility.Visible : this.isShow ? Visibility.Visible : Visibility.None)
  }

  /**添加或更改数据内容**/
  setDataByPickerOptions(pickerOptions: PickerOptions) {
    if (pickerOptions.tag == PickerOptionsTag.OPTIONS_ONE) {
      this.PickerOptionsOne = pickerOptions
      this.clickSelected(pickerOptions.tag, pickerOptions.currentIndex, pickerOptions.data[pickerOptions.currentIndex])
    }
    if (pickerOptions.tag == PickerOptionsTag.OPTIONS_TWO) {
      this.PickerOptionsTwo = pickerOptions
      this.clickSelected(pickerOptions.tag, pickerOptions.currentIndex, pickerOptions.data[pickerOptions.currentIndex])
    }
    if (pickerOptions.tag == PickerOptionsTag.OPTIONS_THREE) {
      this.PickerOptionsThree = pickerOptions
      this.clickSelected(pickerOptions.tag, pickerOptions.currentIndex, pickerOptions.data[pickerOptions.currentIndex])
    }
  }

  handleResult() {
    let result: Array<PickerResult> = []
    if (this.PickerOptionsOne.data.length > 0) {
      let rst = new PickerResult()
      rst.tag = this.PickerOptionsOne.tag
      rst.singleCurrentIndex = this.PickerOptionsOne.currentIndex
      rst.singleResult = this.PickerOptionsOne.data[this.PickerOptionsOne.currentIndex]
      if (this.PickerOptionsOne.isMultipleSelect) {
        let selectedData: Array<IPickerViewData> = []
        this.PickerOptionsOne.data.forEach((item: IPickerViewData) => {
          if (item.optionSelected) {
            selectedData.push(item)
          }
        })
        rst.multipleResult = selectedData
        rst.singleCurrentIndex = 0
      }
      result.push(rst)
    }
    if (this.PickerOptionsTwo.data.length > 0) {
      let rst = new PickerResult()
      rst.tag = this.PickerOptionsTwo.tag
      rst.singleCurrentIndex = this.PickerOptionsTwo.currentIndex
      rst.singleResult = this.PickerOptionsTwo.data[this.PickerOptionsTwo.currentIndex]
      if (this.PickerOptionsTwo.isMultipleSelect) {
        let selectedData: Array<IPickerViewData> = []
        this.PickerOptionsTwo.data.forEach((item: IPickerViewData) => {
          if (item.optionSelected) {
            selectedData.push(item)
          }
        })
        rst.multipleResult = selectedData
        rst.singleCurrentIndex = 0
      }
      result.push(rst)
    }
    if (this.PickerOptionsThree.data.length > 0) {
      let rst = new PickerResult()
      rst.tag = this.PickerOptionsThree.tag
      rst.singleCurrentIndex = this.PickerOptionsThree.currentIndex
      rst.singleResult = this.PickerOptionsThree.data[this.PickerOptionsThree.currentIndex]
      if (this.PickerOptionsThree.isMultipleSelect) {
        let selectedData: Array<IPickerViewData> = []
        this.PickerOptionsThree.data.forEach((item: IPickerViewData) => {
          if (item.optionSelected) {
            selectedData.push(item)
          }
        })
        rst.multipleResult = selectedData
        rst.singleCurrentIndex = 0
      }
      result.push(rst)
    }
    this.backResult(result)
  }
}

/**
 *  联动筛选标记
 */
export enum PickerOptionsTag {
  /**
   *  联动列一
   */
  OPTIONS_ONE = 'OptionsOne',
  /**
   * 联动列二
   */
  OPTIONS_TWO = 'OptionsTwo',
  /**
   * 联动列三
   */
  OPTIONS_THREE = 'OptionsThree'
}


export class PickerOptionsController {
  /**
   * 设置数据源
   */
  setPickerData: (pickerOptions: PickerOptions, setValue: (item: IPickerViewData, index: number) => void) => void =
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
  setPickerCurrentIndex: (tag: string, currentIndex: number) => void = () => {
  }
  /**
   * 设置多选已选内容
   * 当开启头内容互斥关系后则设置selectedData为new Array 后默认选中首个内容
   */
  setPickerSelectedData: (tag: string, selectedData: Array<IPickerViewData>) => void = () => {
  }
  /**
   * 关闭当前筛选界面
   */
  closePicker: () => void = () => {
  }
  /**
   * 显示多层数据背景
   */
  setMultiplePicker: (count: number) => void = () => {
  }
}

/**
 *  结果数据返回
 */
export class PickerResult {
  /**
   *  联动筛选列表标记
   */
  tag: string = ''
  /**
   *  单选数据结果
   */
  singleResult?: IPickerViewData
  /**
   *  单选数据当前位置
   */
  singleCurrentIndex: number = -1
  /**
   *  多选数据集合
   */
  multipleResult: Array<IPickerViewData> = []
}