/**
 * Author:fanlilin
 * Date:2024/1/26
 * Descrobe:
 */

import { RKTProgress, RKTProgressStyle } from "@zjos/rocketUI"
import RKTUtil from '@zjos/rocketUI/src/main/ets/utils/RKTUtil';

@Component
export default struct RKTLoadingDemo {
  @State count: number = 0;

  build() {
    Column() {
      // Text(`loading 测试：click times: ${this.count}`)
      //   .fontSize(30)
      //   .fontWeight(FontWeight.Bold)
      //   .onClick(() => {
      //   })
      //   .margin({
      //     top: 10
      //   })
      //
      // Button(`click times: ${this.count}`)
      //   .onClick(() => {
      //     this.count += 1;
      //   })
      this.test01()
    }
    .width('100%')
    .height('100%')
  }

  @Builder test01() {
    Text("转圈loding")
      .fontSize(30)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        RKTUtil.showLoading()

        setTimeout(()=>{
          RKTUtil.hideLoading()
        },3000)
      })
      .margin({
        top: 10
      })
  }

}