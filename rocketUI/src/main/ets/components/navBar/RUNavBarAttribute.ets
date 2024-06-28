/**
 * Author:fanlilin
 * Date:2024/6/27
 * Descrobe:
 */
import RUConfig from '../../config/RUConfig'
import { CommonModifier } from "@ohos.arkui.modifier"

export class RUNavBarAttribute {
  containerModifier: RUNavBarModifier
  leftMemuBarModifier: RUNavBarModifier
  rightMemuBarModifier: RUNavBarModifier
  titleBarModifier: RUNavBarModifier
  textBarModifier: RUNavBarTextModifier

  leftMemuBarWidth?: number
  rightMemuBarWidth?: number
  titleBarWidth?: number
  textBarWidth?: number
  containerWidth?: number

  constructor(containerModifier: RUNavBarModifier, leftMemuBarModifier: RUNavBarModifier, rightMemuBarModifier: RUNavBarModifier, titleBarModifier: RUNavBarModifier, textBarModifier: RUNavBarTextModifier) {
    this.containerModifier = containerModifier
    this.leftMemuBarModifier = leftMemuBarModifier
    this.rightMemuBarModifier = rightMemuBarModifier
    this.titleBarModifier = titleBarModifier
    this.textBarModifier = textBarModifier

    containerModifier._onAreaChange = (id: string, oldValue: Area, newValue: Area): void => {
      console.info(`${id}: on area change, oldValue is ${JSON.stringify(oldValue)} value is ${JSON.stringify(newValue)}`)
      // 自适应顶部元素，模仿系统的expandSafeArea
      if (newValue.globalPosition.y as number > 0) {
        containerModifier.padding({ top: 0 })
      } else {
        containerModifier.padding({ top: `${RUConfig.statusBarHeight}px` })
      }
      this.containerWidth = newValue.width as number
      this.updateLayout()
    }

    leftMemuBarModifier._onAreaChange = (id: string, oldValue: Area, newValue: Area): void => {
      console.info(`${id}: on area change, oldValue is ${JSON.stringify(oldValue)} value is ${JSON.stringify(newValue)}`)
      this.leftMemuBarWidth = newValue.width as number
      this.updateLayout()
    }

    rightMemuBarModifier._onAreaChange = (id: string, oldValue: Area, newValue: Area): void => {
      console.info(`${id}: on area change, oldValue is ${JSON.stringify(oldValue)} value is ${JSON.stringify(newValue)}`)
      this.rightMemuBarWidth = newValue.width as number
      this.updateLayout()
    }

    titleBarModifier._onAreaChange = (id: string, oldValue: Area, newValue: Area): void => {
      console.info(`${id}: on area change, oldValue is ${JSON.stringify(oldValue)} value is ${JSON.stringify(newValue)}`)
      this.titleBarWidth = newValue.width as number
      this.updateLayout()
    }

    textBarModifier._onAreaChange = (id: string, oldValue: Area, newValue: Area): void => {
      console.info(`${id}: on area change, oldValue is ${JSON.stringify(oldValue)} value is ${JSON.stringify(newValue)}`)
      this.textBarWidth = newValue.width as number
      this.updateLayout()

    }
  }

  updateLayout() {
    if (this.leftMemuBarWidth === undefined || this.rightMemuBarWidth === undefined || this.titleBarWidth === undefined || this.containerWidth === undefined || this.textBarWidth === undefined) {
      return
    }

    // 自适应居中
    let of = this.containerWidth - this.leftMemuBarWidth - this.rightMemuBarWidth
    let x = this.leftMemuBarWidth / 2
    if (this.textBarWidth <= of) {
      this.textBarModifier.offset({ left: -x })
      // this.textBarModifier.backgroundColor(Color.Yellow)

    }
  }
}

export class RUNavBarModifier extends CommonModifier {
  _id: string = ''
  _onAreaChange?: (id: string, oldValue: Area, newValue: Area) => void

  constructor(id: string) {
    super()
    this._id = id

    this.onAreaChange((oldValue: Area, newValue: Area) => {
      this._onAreaChange && this._onAreaChange(this._id, oldValue, newValue)
    })
  }

  applyNormalAttribute(instance: ColumnAttribute): void {
    super.applyNormalAttribute?.(instance);
  }
}

export class RUNavBarTextModifier extends CommonModifier {
  _id: string = ''
  _onAreaChange?: (id: string, oldValue: Area, newValue: Area) => void

  constructor(id: string) {
    super()
    this._id = id

    // TODO: 不响应不知道为啥不响应
    // this.onAreaChange((oldValue: Area, newValue: Area) => {
    //   this._onAreaChange && this._onAreaChange(this._id, oldValue, newValue)
    // })
  }

  applyNormalAttribute(instance: CommonAttribute): void {
    super.applyNormalAttribute?.(instance);
  }
}


