/**
 * Author:fanlilin
 * Date:2024/1/16
 * Descrobe:
 */

import { RKTProgress, RKTProgressStyle } from "@zjos/rocketUI"
import Prompt from '@system.prompt'
// import { RKTProgressStyle } from '@zjos/rocketUI/src/main/ets/components/RKTProgress';

@Component
export default struct LoadingDemo {

  @State isloding01: boolean = false;
  @State isloding02: boolean = false;
  @State isloding03: boolean = false;
  @State isloding04: boolean = false;

  loading: CustomDialogController = new CustomDialogController({
    builder: RKTProgress({}),
    customStyle: true
  })

  build() {
    Column() {
      this.test01()
      this.test02()
      this.test03()
      this.test04()
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

}