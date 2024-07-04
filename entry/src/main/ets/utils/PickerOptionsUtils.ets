import { FrameOptions } from '@zjos/rocketUI/src/main/ets/components/datePicker/frame/FrameComponent';
import { PickerOptions } from '@zjos/rocketUI/src/main/ets/components/datePicker/wheel/WheelComponent';
import { IPickerViewData } from '@zjos/rocketUI/src/main/ets/components/datePicker/data/IPickerViewData';
import { FrameOptionsController } from '@zjos/rocketUI/src/main/ets/components/datePicker/RUFramePickerView';
import { PickerOptionsController } from '@zjos/rocketUI/src/main/ets/components/datePicker/RUPickerView';

import { AddressEntity } from '../pages/DetailsPage04'

/**
 * 筛选组件统一数据填充管理类
 * AddressEntity类可根据自己模块的内接接收数据修改
 */
export class PickerOptionsUtils {

  /**
   * 多级联动筛选组件统一数据填充管理类
   * @param tag 标记位 标识单个筛选车轮，可根据筛选内容自定义，同一组件内不可重复
   * @param selectedStyle 筛选模块 1是筛选背景色修改  2是勾选
   * @param isMultipleSelect 多选和单选
   * @param 数据源
   */
  static setPickerOptionsData(tag: string, selectedStyle: number, isMultipleSelect: boolean, data: Array<AddressEntity>,
    pickerOptionsController: PickerOptionsController) {
    let options = new PickerOptions()
    options.tag = tag
    options.selectedStyle = selectedStyle
    options.currentIndex = 0
    options.isMultipleSelect = isMultipleSelect
    options.data = data
    pickerOptionsController.setPickerData(options, (item: IPickerViewData, index: number) => {
      item.optionsName = data[index].name
      item.optionsValue = data[index].no
      item.optionChildren = data[index].children
      item.optionSelected = false
    })
  }

  /**
   * 框体筛选组件统一数据填充管理类
   * @param currentIndex 当前默认选中的位置
   * @param isMultipleSelect 多选和单选
   * @param 数据源
   */
  static setFrameOptionsData(currentIndex: number, isMultipleSelect: boolean, data: Array<AddressEntity>,
    frameOptionsController: FrameOptionsController) {
    let options = new FrameOptions()
    options.currentIndex = currentIndex
    options.isMultipleSelect = isMultipleSelect
    options.data = data
    frameOptionsController.setPickerData(options, (item: IPickerViewData, index: number) => {
      item.optionsName = data[index].name
      item.optionsValue = data[index].no
      item.optionSelected = false
    })
  }
}