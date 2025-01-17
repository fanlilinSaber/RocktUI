/**
 * Author:fanlilin
 * Date:2024/1/16
 * Descrobe:
 */

import { RUProgress, RUProgressStyle, RUProgressItem } from "@zjos/rocketUI"
import promptAction from '@ohos.promptAction'
import util from '@ohos.util'
import common from '@ohos.app.ability.common'

@Component
export default struct LoadingDemo {

  @State isloding01: boolean = false;
  @State isloding02: boolean = false;
  @State isloding03: boolean = false;
  @State isloding04: boolean = false;
  @State isloding05: boolean = false;
  @State isProgress01: boolean = false;
  @State progressValue: number = 0
  @State progressStr: string = '下载进度0%'
  @State isProgress02: boolean = false;

  private intervalID: number = 0

  progressItem01: RUProgressItem = new RUProgressItem({ animateSize: { width: 200, height: 200 }, boxBorderSize: { width: 220, height: 220 }, boxBorderRadius: 10, boxBackgroundColor: Color.Red })

  progressItem02: RUProgressItem = new RUProgressItem({ animateSize: { width: 300, height: 300 }, boxBorderSize: { width: 300, height: 300 }, boxBorderRadius: 0, boxBackgroundColor: Color.Transparent })

  loading: CustomDialogController = new CustomDialogController({
    builder: RUProgress({}),
    customStyle: true
  })

  async aboutToAppear() {
    this.loadJSONFile01()
    this.loadJSONFile02()
  }

  async loadJSONFile01() {
    let animatePath = 'loading_6.json';

    let resStr = util.TextDecoder.create('utf-8', { ignoreBOM: true })
    let context = getContext(this) as common.UIAbilityContext
    // 这里是一个异步方法，可能在build - Canvas - onReady之后执行
    let buffer = await context.resourceManager.getRawFileContent(animatePath)
    if(buffer === null || buffer === undefined){ return }

    let lottieStr = resStr.decodeWithStream(new Uint8Array(buffer))

    this.progressItem01.lottieData = JSON.parse(lottieStr);

    promptAction.showToast({ message: 'json动画1资源加载完成' })
  }

  async loadJSONFile02() {
    let animatePath = 'animation_woniu.json';

    let resStr = util.TextDecoder.create('utf-8', { ignoreBOM: true })
    let context = getContext(this) as common.UIAbilityContext
    // 这里是一个异步方法，可能在build - Canvas - onReady之后执行
    let buffer = await context.resourceManager.getRawFileContent(animatePath)
    if(buffer === null || buffer === undefined){ return }

    let lottieStr = resStr.decodeWithStream(new Uint8Array(buffer))

    this.progressItem02.lottieData = JSON.parse(lottieStr);

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
  }

  @Builder test01() {
    Text("转圈loding")
      .fontSize(30)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        this.isloding01 = true;
        setTimeout(()=>{
          this.isloding01 = false;
        },3000)
      })
      .margin({
        top: 10
      })

    if(this.isloding01) {
      RUProgress()
    }
  }

  @Builder test02() {
    Text("沙漏动画loding")
      .fontSize(30)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        this.isloding02 = true;
        setTimeout(()=>{
          this.isloding02 = false;
        },3000)
      })
      .margin({
        top: 10
      })

    if(this.isloding02) {
      RUProgress({ style: RUProgressStyle.SandClock, message: '正在抓取数据请稍后...' })
    }
  }

  @Builder test03() {
    Text("'经营帮'字跳舞loding")
      .fontSize(30)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        this.isloding03 = true;
        setTimeout(()=>{
          this.isloding03 = false;
        },3000)
      })
      .margin({
        top: 10
      })

    if(this.isloding03) {
      RUProgress({ style: RUProgressStyle.WordDance })
    }
  }

  @Builder test04() {
    Text("全屏loding")
      .fontSize(30)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        this.loading.open()
        setTimeout(()=>{
          this.loading.close()
        },3000)
      })
      .margin({
        top: 10
      })
  }

  @Builder test05() {
    Text("自定义loding")
      .fontSize(30)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        this.isloding05 = true;
        setTimeout(()=>{
          this.isloding05 = false;
        },3000)
      })
      .margin({
        top: 10
      })

    if(this.isloding05) {
      RUProgress({ style: RUProgressStyle.Custom, progressItem: this.progressItem01 })
    }
  }

  @Builder test06() {
    Text("任务进度")
      .fontSize(30)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        this.isProgress01 = true

        this.intervalID = setInterval(() => {
          if (this.progressValue > 1) {
            clearInterval(this.intervalID)
            this.progressValue = 0
            this.isProgress01 = false
            return
          }
          this.progressValue += 0.02
          this.progressStr = `下载进度` + (this.progressValue * 100).toFixed(0) + `%`
        }, 200)

      })
      .margin({
        top: 10
      })

    if(this.isProgress01) {
      RUProgress({ autoplay: false, progress: this.progressValue, message: this.progressStr, style: RUProgressStyle.Forward})
    }
  }

  @Builder test07() {
    Text("自定义任务进度")
      .fontSize(30)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        this.isProgress02 = true

        this.intervalID = setInterval(() => {
          if (this.progressValue > 1) {
            clearInterval(this.intervalID)
            this.progressValue = 0
            this.isProgress02 = false
            return
          }
          this.progressValue += 0.02
          this.progressStr = `下载进度` + (this.progressValue * 100).toFixed(0) + `%`
        }, 200)
      })
      .margin({
        top: 10
      })

    if(this.isProgress02) {
      RUProgress({ autoplay: false, progress: this.progressValue, message: this.progressStr, style: RUProgressStyle.Custom, progressItem: this.progressItem02 })
    }
  }

}