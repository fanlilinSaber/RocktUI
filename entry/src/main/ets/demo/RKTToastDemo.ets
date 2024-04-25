/**
 * Author:fanlilin
 * Date:2024/3/28
 * Descrobe:
 */

import { RKTToast, RKTToastUtil, RKTToastPosition } from '@zjos/rocketUI'

@Component
export default struct RKTToastDemo {

  @State isToast: boolean = false
  private timeID: number
  private index: number = 0
  private testTexts: Array<string> = ["请输入输入内容", "测试很多内容测试很多内容测试很多内容测试很多内容", "测试提示内容1", "测试超多多内容测试超多多内容测试超多多内容测试超多多内容测试超多多内容测试超多多内容测试超多多内容测试超多多内容测试超多多内容测试超多多内容"]

  build() {
    Column() {
      this.test01()
      this.test02()
      this.test03()
      this.test04()
    }
    .width('100%')
    .height('100%')
  }

  @Builder test01() {
    Text("普通使用Toast")
      .fontSize(30)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        this.isToast = true

        if (this.timeID) {
          clearTimeout(this.timeID)
          this.timeID = 0
        }

        this.timeID = setTimeout(()=>{
          this.isToast = false
          this.timeID = 0
        }, 2000)

      })
      .margin({
        top: 10
      })

    if (this.isToast) {
      RKTToast({ message: "请输入内容" })
    }
  }

  @Builder test02() {
    Text("快捷使用Toast")
      .fontSize(30)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        if (this.index >= this.testTexts.length) {
          this.index = 0
        }
        let text = this.testTexts[this.index]
        RKTToastUtil.show(text)
        this.index ++
      })
      .margin({
        top: 10
      })
  }

  @Builder test03() {
    Text("快捷使用Toast顶部弹出")
      .fontSize(30)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        if (this.index >= this.testTexts.length) {
          this.index = 0
        }
        let text = this.testTexts[this.index]
        RKTToastUtil.show({ message: text, position: RKTToastPosition.top} )
        this.index ++
      })
      .margin({
        top: 10
      })
  }

  @Builder test04() {
    Text("快捷使用Toast底部弹出")
      .fontSize(30)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        if (this.index >= this.testTexts.length) {
          this.index = 0
        }
        let text = this.testTexts[this.index]
        RKTToastUtil.show({ message: text, position: RKTToastPosition.bottom} )
        this.index ++
      })
      .margin({
        top: 10
      })
  }
}