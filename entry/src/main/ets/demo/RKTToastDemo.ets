/**
 * Author:fanlilin
 * Date:2024/3/28
 * Descrobe:
 */

import { RKTToast } from '@zjos/rocketUI'

@Component
export default struct RKTToastDemo {

  @State isToast: boolean = false;

  build() {
    Column() {
      this.test01()
    }
    .width('100%')
    .height('100%')
  }

  @Builder test01() {
    Text("使用Toast")
      .fontSize(30)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        this.isToast = true
      })
      .margin({
        top: 10
      })

    if (this.isToast) {
      RKTToast({ message: "输入内容有误", show: $isToast })
    }
  }
}