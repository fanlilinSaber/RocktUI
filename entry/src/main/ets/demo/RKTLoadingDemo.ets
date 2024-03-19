/**
 * Author:fanlilin
 * Date:2024/1/26
 * Descrobe:
 */

import { RKTProgressUtil, RKTProgressStyle } from "@zjos/rocketUI"
import RKTUtil from '@zjos/rocketUI/src/main/ets/utils/RKTUtil';

@Entry
@Component
export default struct RKTLoadingDemo {
  @State count: number = 0;

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

        RKTProgressUtil.showLoading(RKTProgressStyle.sandClock, '正在抓取数据请稍后...')

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

}