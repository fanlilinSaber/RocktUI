/**
 * Author:fanlilin
 * Date:2024/1/26
 * Descrobe:
 */

import { RKTProgressUtil, RKTProgressStyle, RKTProgressItem } from "@zjos/rocketUI"
import util from '@ohos.util'
import common from '@ohos.app.ability.common'
import promptAction from '@ohos.promptAction'

@Component
export default struct RKTLoadingDemo {
  @State count: number = 0;
  progressItem: RKTProgressItem = new RKTProgressItem({ animateSize: { width: 200, height: 200 }, boxBorderSize: { width: 220, height: 220 }, boxBorderRadius: 10, boxBackgroundColor: Color.Red})


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
    Text("全局loding")
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

  @Builder test05() {
    Text("自定义loding动画")
      .fontSize(30)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        RKTProgressUtil.showLoading(this.progressItem)
        setTimeout(()=>{
          RKTProgressUtil.hideLoading()
        },3000)
      })
      .margin({
        top: 10
      })
  }

}