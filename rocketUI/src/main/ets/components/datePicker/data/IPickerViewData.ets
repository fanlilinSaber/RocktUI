/**
 * 数据回调接口
 */
@Observed
export class IPickerViewData {
  /**
   * 显示的item内容
   */
  optionsName: string = ''
  /**
   * 对应的item的数据
   */
  optionsValue?: string | number
  /**
   * 对应的item的选中状态
   */
  optionSelected?: boolean
  /**
   * 对应的item的泛型数据
   */
  optionChildren?: IPickerViewData[]
}