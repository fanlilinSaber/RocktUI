/**
 * Author:fanlilin
 * Date:2024/1/16
 * Descrobe:
 */

import { RKTProgress, RKTProgressStyle, RKTProgressItem } from "@zjos/rocketUI"
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

  progressItem: RKTProgressItem = new RKTProgressItem({ animateSize: { width: 200, height: 200 }, boxBorderSize: { width: 220, height: 220 }, boxBorderRadius: 10, boxBackgroundColor: Color.Red})

  loading: CustomDialogController = new CustomDialogController({
    builder: RKTProgress({}),
    customStyle: true
  })

  async aboutToAppear() {

    let animatePath = 'loading_6.json';

    let resStr = util.TextDecoder.create('utf-8', { ignoreBOM: true })
    let context = getContext(this) as common.UIAbilityContext
    // 这里是一个异步方法，可能在build - Canvas - onReady之后执行
    let buffer = await context.resourceManager.getRawFileContent(animatePath)
    if(buffer === null || buffer === undefined){ return }

    let lottieStr = resStr.decodeWithStream(new Uint8Array(buffer))

    this.progressItem.lottieData = JSON.parse(lottieStr);
    promptAction.showToast({ message: 'json动画资源加载完成' })
  }


  build() {
    Column() {
      this.test01()
      this.test02()
      this.test03()
      this.test04()
      this.test05()
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
      RKTProgress()
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
      RKTProgress({ style: RKTProgressStyle.sandClock, message: '正在抓取数据请稍后...' })
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
      RKTProgress({ style: RKTProgressStyle.wordDance })
    }
  }

  @Builder test04() {
    Text("全局loding")
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
      RKTProgress({ style: RKTProgressStyle.custom, progressItem: this.progressItem })
    }
  }

}