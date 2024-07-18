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
  textBarModifier: RUNavBarModifier

  leftMemuBarArea?: Area
  rightMemuBarArea?: Area
  titleBarArea?: Area
  textBarArea?: Area
  containerArea?: Area

  constructor(containerModifier: RUNavBarModifier, leftMemuBarModifier: RUNavBarModifier, rightMemuBarModifier: RUNavBarModifier, titleBarModifier: RUNavBarModifier, textBarModifier: RUNavBarModifier) {
    this.containerModifier = containerModifier
    this.leftMemuBarModifier = leftMemuBarModifier
    this.rightMemuBarModifier = rightMemuBarModifier
    this.titleBarModifier = titleBarModifier
    this.textBarModifier = textBarModifier

    containerModifier._onAreaChange = (oldValue: Area, newValue: Area): void => {
      console.info(`containerModifier: on area change, oldValue is ${JSON.stringify(oldValue)} value is ${JSON.stringify(newValue)}`)
      // 自适应顶部元素，模仿系统的expandSafeArea
      if (newValue.globalPosition.y as number > 0) {
        containerModifier.padding({ top: 0 })
      } else {
        containerModifier.padding({ top: `${ RUConfig.statusBarHeight}px` })
      }
      this.containerArea = newValue
      this.updateLayout()
    }

    leftMemuBarModifier._onAreaChange = (oldValue: Area, newValue: Area): void => {
      console.info(`leftMemuBarModifier: on area change, oldValue is ${JSON.stringify(oldValue)} value is ${JSON.stringify(newValue)}`)
      this.leftMemuBarArea = newValue
      this.updateLayout()
    }

    rightMemuBarModifier._onAreaChange = (oldValue: Area, newValue: Area): void => {
      console.info(`rightMemuBarModifier: on area change, oldValue is ${JSON.stringify(oldValue)} value is ${JSON.stringify(newValue)}`)
      this.rightMemuBarArea = newValue
      this.updateLayout()
    }

    titleBarModifier._onAreaChange = (oldValue: Area, newValue: Area): void => {
      console.info(`titleBarModifier: on area change, oldValue is ${JSON.stringify(oldValue)} value is ${JSON.stringify(newValue)}`)
      this.titleBarArea = newValue
      this.updateLayout()
    }

    textBarModifier._onAreaChange = (oldValue: Area, newValue: Area): void => {
      console.info(`textBarModifier: on area change, oldValue is ${JSON.stringify(oldValue)} value is ${JSON.stringify(newValue)}`)
      this.textBarArea = newValue
      this.updateLayout()
    }
  }

  updateLayout() {
    if (this.leftMemuBarArea === undefined || this.rightMemuBarArea === undefined || this.titleBarArea === undefined || this.containerArea === undefined || this.textBarArea === undefined) {
      return
    }

    let containerWidth = this.containerArea.width as number
    let leftMemuBarWidth = this.leftMemuBarArea.width as number
    let rightMemuBarWidth = this.rightMemuBarArea.width as number
    let textBarWidth = this.textBarArea.width as number
    let rightMemuBarMinX = this.rightMemuBarArea.position.x as number
    let leftMemuBarMaxX = (this.leftMemuBarArea.position.x as number) + ( this.leftMemuBarArea.width as number)

    // 自适应居中
    let maxWidth = containerWidth - leftMemuBarWidth - rightMemuBarWidth
    let centerX = containerWidth / 2
    let textHalfX = textBarWidth / 2
    let textPreMaxX = centerX + textHalfX
    let textPreMinX = centerX - textHalfX
    let offsetX = (leftMemuBarWidth - rightMemuBarWidth) / 2
    // 1.如果左边菜单区域大于右边菜单区域
    if (leftMemuBarWidth > rightMemuBarWidth) {
      // 只处理居中显示不遮挡菜单按钮的情况
      if (textPreMinX >= leftMemuBarMaxX) {
        this.textBarModifier.offset({ left: -offsetX })
      }
    }
    // 2.如果左边菜单区域小于右边菜单区域
    else if (leftMemuBarWidth < rightMemuBarWidth) {
      // 只处理居中显示不遮挡菜单按钮的情况
      if (textPreMaxX <= rightMemuBarMinX) {
        this.textBarModifier.offset({ left: -offsetX })
      }
    }
  }
}

export default class RUNavBarModifier extends CommonModifier {
  _onAreaChange?: (oldValue: Area, newValue: Area) => void

  constructor() {
    super()

    // TODO: 这里Text接收不到，需要外面实现传回来
    this.onAreaChange((oldValue: Area, newValue: Area) => {
      this._onAreaChange && this._onAreaChange(oldValue, newValue)
    })
  }

  applyNormalAttribute(instance: CommonAttribute): void {
    super.applyNormalAttribute?.(instance);
  }
}

