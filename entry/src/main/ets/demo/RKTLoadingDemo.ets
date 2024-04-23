/**
 * Author:fanlilin
 * Date:2024/1/26
 * Descrobe:
 */

import { RKTProgressUtil, RKTProgressStyle, RKTProgressItem } from "@zjos/rocketUI"
import util from '@ohos.util'
import common from '@ohos.app.ability.common'
import promptAction from '@ohos.promptAction'
import { RKTProgressElement } from '@zjos/rocketUI/src/main/ets/components/progress/RKTProgress'

@Component
export default struct RKTLoadingDemo {
  @State count: number = 0;
  @State progressStr: string = '下载进度0%'
  @State progressValue: number = 0
  private intervalID: number

  progressElement01: RKTProgressElement = { animateSize: { width: 200, height: 200 }, boxBorderSize: { width: 220, height: 220 }, boxBorderRadius: 10, boxBackgroundColor: Color.Red}
  progressElement02: RKTProgressElement = { animateSize: { width: 300, height: 300 }, boxBorderSize: { width: 300, height: 300 }, boxBorderRadius: 0, boxBackgroundColor: Color.Transparent }

  async aboutToAppear() {
    this.loadJSONFile01()
    this.loadJSONFile02()
  }

  async loadJSONFile01() {
    let animatePath = 'loading_6.json'

    let resStr = util.TextDecoder.create('utf-8', { ignoreBOM: true })
    let context = getContext(this) as common.UIAbilityContext
    // 这里是一个异步方法，可能在build - Canvas - onReady之后执行
    let buffer = await context.resourceManager.getRawFileContent(animatePath)
    if(buffer === null || buffer === undefined){ return }

    let lottieStr = resStr.decodeWithStream(new Uint8Array(buffer))

    this.progressElement01.lottieData = JSON.parse(lottieStr)

    promptAction.showToast({ message: 'json动画1资源加载完成' })
  }

  async loadJSONFile02() {
    let animatePath = 'animation_woniu.json'

    let resStr = util.TextDecoder.create('utf-8', { ignoreBOM: true })
    let context = getContext(this) as common.UIAbilityContext
    // 这里是一个异步方法，可能在build - Canvas - onReady之后执行
    let buffer = await context.resourceManager.getRawFileContent(animatePath)
    if(buffer === null || buffer === undefined){ return }

    let lottieStr = resStr.decodeWithStream(new Uint8Array(buffer))

    this.progressElement02.lottieData = JSON.parse(lottieStr)

    promptAction.showToast({ message: 'json动画2资源加载完成' })
  }

  build() {
    Column() {
      this.test01()
      this.test02()
      this.test03()
      this.test04()
      this.test05()
      this.test06()
      this.test07()
    }
    .width('100%')
    .height('100%')
  }

  @Builder test01() {
    Text("转圈loding")
      .fontSize(30)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        RKTProgressUtil.showLoading()
        setTimeout(()=>{
          RKTProgressUtil.hideLoading()
        },3000)
      })
      .margin({
        top: 10
      })
  }

  @Builder test02() {
    Text("沙漏动画loding")
      .fontSize(30)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        RKTProgressUtil.showLoading({ style: RKTProgressStyle.sandClock, message: '正在抓取数据请稍后...'})
        setTimeout(()=>{
          RKTProgressUtil.hideLoading()
        },3000)
      })
      .margin({
        top: 10
      })
  }

  @Builder test03() {
    Text("'经营帮'字跳舞loding")
      .fontSize(30)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        RKTProgressUtil.showLoading(RKTProgressStyle.wordDance)
        setTimeout(()=>{
          RKTProgressUtil.hideLoading()
        },3000)
      })
      .margin({
        top: 10
      })
  }

  @Builder test04() {
    Text("全屏loding")
      .fontSize(30)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        RKTProgressUtil.showWindowLoading()
        setTimeout(()=>{
          RKTProgressUtil.hideLoading()
        },3000)
      })
      .margin({
        top: 10
      })
  }

  @Builder test05() {
    Text("自定义loding动画")
      .fontSize(30)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        RKTProgressUtil.showLoading(this.progressElement01)
        setTimeout(()=>{
          RKTProgressUtil.hideLoading()
        },3000)
      })
      .margin({
        top: 10
      })
  }

  @Builder test06() {
    Text("任务进度")
      .fontSize(30)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {

        RKTProgressUtil.showProgress(this.progressValue, { message: this.progressStr })

        // 模拟网络下载进度
        this.intervalID = setInterval(() => {
          if (this.progressValue > 1) {
            clearInterval(this.intervalID)
            this.progressValue = 0
            RKTProgressUtil.hideProgress()
            return
          }
          this.progressValue += 0.02
          this.progressStr = `下载进度` + (this.progressValue * 100).toFixed(0) + `%`

          RKTProgressUtil.showProgress(this.progressValue, { message: this.progressStr })
        }, 200)

        // if (this.progressValue > 1) {
        //   clearInterval(this.intervalID)
        //   this.progressValue = 0
        //   RKTProgressUtil.hideLoading()
        // }
        // this.progressValue += 0.05
        // this.progressStr = `下载进度` + (this.progressValue * 100).toFixed(0) + `%`
        //
        // RKTProgressUtil.showProgress(this.progressValue, { message: this.progressStr })
      })
      .margin({
        top: 10
      })
  }

  @Builder test07() {
    Text("自定义任务进度")
      .fontSize(30)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {

        RKTProgressUtil.showProgress(this.progressValue, this.progressElement02)

        // 模拟网络下载进度
        this.intervalID = setInterval(() => {
          if (this.progressValue > 1) {
            clearInterval(this.intervalID)
            this.progressValue = 0
            RKTProgressUtil.hideProgress()
            return
          }
          this.progressValue += 0.02
          this.progressStr = `下载进度` + (this.progressValue * 100).toFixed(0) + `%`
          this.progressElement02.text = this.progressStr

          RKTProgressUtil.showProgress(this.progressValue, this.progressElement02)
        }, 200)
      })
      .margin({
        top: 10
      })
  }
}