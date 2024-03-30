/**
 * Author:fanlilin
 * Date:2024/3/28
 * Descrobe:
 */
import Prompt from '@system.prompt'

@Component
export struct RKTToast {
  // 消息文本
  message: string
  // 延时消失时间
  duration?: number = 2000
  // 文本字体颜色
  fontColor: ResourceColor = `#FFFFFFFF`
  // 文本字体大小
  fontSize: number | string = 16

  // 是否显示
  @Link show: boolean
  // 当前页面路径, 只有当前页面中的loading才会响应,其他页面的事件不响应
  private currentPagePath: string = ""

  aboutToDisappear(){


  }

  build() {
    Column() {
      Column() {
        Text(this.message)
          .fontColor(this.fontColor).fontSize(this.fontSize).fontWeight(FontWeight.Regular)
          .textAlign(TextAlign.Center)
      }.align(Alignment.Center).alignItems(HorizontalAlign.Center).alignSelf(ItemAlign.Center)
      .constraintSize({maxWidth:345, minHeight:45})
      .padding({left:20, right:20, top:12, bottom:12})
      .borderRadius(7)
      .backgroundColor(`#99000000`)
    }
    .width('100%').height('100%')
    .position({ x: 0, y: '50%' })
    .zIndex(9999)
    .visibility(this.show ? Visibility.Visible : Visibility.None)
    .animation({ duration: 10 })
  }
}