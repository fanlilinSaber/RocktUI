/**
 * Author:fanlilin
 * Date:2024/2/1
 * Descrobe:
 */

import { RKTNavBar, RKTNavBarMenuItem, RKTEventData } from '@zjos/rocketUI'
import promptAction from '@ohos.promptAction'
import emitter from '@ohos.events.emitter'
import hilog from '@ohos.hilog'
import RKTEventBus from '@zjos/rocketUI/src/main/ets/utils/RKTEventBus'

export interface DemoTabItem {
  // 名称
  title?: string
  // 描述
  desc?: string
}

@Component
export default struct RKTLoadingDemo {

  leftMemus: Array<RKTNavBarMenuItem> = []

  rightMemus: Array<RKTNavBarMenuItem> = []

  tabItems: Array<DemoTabItem> = [{title: '商品大厅', desc: '商品大厅占位内容'}]

  leftMemus04: Array<RKTNavBarMenuItem> = []

  @State title: string = 'RKTNavBar变化标题'
  @State count1: number = 0
  count2: number = 0


  aboutToAppear() {

    this.leftMemus = [
      {icon: $r('app.media.goods_ic_btn_add_to'), action: (): void => this.addAction() },
      {title: '删除', action: (): void => this.deleteAction() },
      // {title: '更多', action: this.deleteAction.bind(this)}
      ]

    this.rightMemus = [
      {title: '刷新', action: (): void => this.refreshAction() },
      {title: '重装', action: (): void => this.reloadAction() }
    ]
    
    this.tabItems = [
      {title: '商品大厅', desc: '商品大厅占位内容'},
      {title: '自营商品', desc: '自营商品占位内容'},
      {title: '企业专项', desc: '企业专项占位内容'},
      {title: '集采商品', desc: '集采商品占位内容'},
      {title: '促销商品', desc: '促销商品占位内容'},
      {title: '供应商', desc: '供应商占位内容'}
    ]

    this.leftMemus04 = [
      {icon: $r('app.media.common_Search'), action: (): void => this.searchAction()},
      {title: '发布', action: (): void => this.publishAction()},
      {title: '询价', action: (): void => this.enquiryAction()},
      {icon: $r('app.media.btn_more'), action: (): void => this.addAction() },
    ]

    emitter.on({ eventId: 110 }, (data: emitter.EventData) => {

      hilog.info(0xFFFF00 , `RocketUI`, "测试110事件1" + JSON.stringify(data))
    })

    // emitter.on({ eventId: 110 }, (data: emitter.EventData) => {
    //
    //   hilog.info(0xFFFF00 , `RocketUI`, "测试110事件2")
    //
    //   // emitter.off(110)
    // })

    // emitter.off(110)

    RKTEventBus.on({
      eventName: '测试showLoading',
      target: this},
      (next: RKTEventData) => {

      hilog.info(0xFFFF00 , `RocketUI`, "测试showLoading事件" + JSON.stringify(next))
    })
  }

  aboutToDisappear() {
    RKTEventBus.off("测试showLoading", this)
  }

  build() {
    Column({space: 2}) {

      RKTNavBar({ title: 'RKTNavBar使用', rightMemus: this.rightMemus })

      RKTNavBar({ title: 'RKTNavBar使用', leftMemus: this.leftMemus })

      RKTNavBar({ title: 'RKTNavBar使用', leftMemus: this.leftMemus, rightMemus: this.rightMemus })

      RKTNavBar({ title: 'RKTNavBar使用', customLeftMemus: this.customLeftMemus01, rightMemus: this.rightMemus, barColor: Color.Gray })

      RKTNavBar({ title: 'RKTNavBar使用', customTitle: this.customTitle01, barColor: Color.Orange })

      RKTNavBar({
        title: 'RKTNavBar使用',
        customTitle: this.customTitle02,
        rightMemus: [{icon: $r('app.media.common_Search'), action: this.searchAction, iconSize: {width:35, height: 35}}], barColor: Color.Yellow})

      RKTNavBar({ title: 'RKTNavBar使用', customTitle: this.customTitle02, rightMemus: [{title: '搜索', action: this.searchAction}] })

      RKTNavBar({ title: 'RKTNavBar使用', customTitle: (): void => { this.customTitle03() }})

      RKTNavBar({ hideBack: true, customTitle: (): void => { this.customTitle04() } })

      RKTNavBar({ title: this.title, rightMemus: [{title: '变化1', action: (): void => this.changeTitleAction(), tag: 1}, {title: '变化2', action: (): void => this.changeTitleAction(), tag: 2}] })

      Text(`变化标题测试: ${this.count1} + ${this.count2}`)
        .onClick(() => {
          this.count1 += 1
          this.count2 += 1
        })
    }
    .width('100%')
    .margin({ top: 2})
  }

  addAction() {
    // promptAction.showToast({ message: 'addAction' })
    promptAction.showToast({ message: `RKTNavBar变化标题+${this.count1}` })

    let dd: DemoTabItem = { title: '11', desc: ''}
    RKTEventBus.emit("测试showLoading", "aaa")
  }

  deleteAction() {
    promptAction.showToast({ message: 'deleteAction' })
    // let eventData = {
    //   data: {
    //     "content": "c",
    //     "id": 1,
    //     "info": { "name": "lisi"}
    //   }};
    // emitter.emit({ eventId: 110 }, eventData)
  }

  refreshAction() {
    promptAction.showToast({ message: 'refreshAction' })
  }

  reloadAction() {
    promptAction.showToast({ message: 'reloadAction' })
  }

  searchAction() {
    promptAction.showToast({ message: 'searchAction' })
  }

  publishAction() {
    promptAction.showToast({ message: 'publishAction' })
  }

  enquiryAction() {
    promptAction.showToast({ message: 'enquiryAction' })
  }

  changeTitleAction(tag?: number) {
    if (tag == 1) {
      this.count1 -= 1;
    } else {
      this.count1 += 1;
    }
    // this.title = this.title === 'Hello ArkUI' ? 'Hello World' : 'Hello ArkUI';
    this.title = `RKTNavBar变化标题${this.count1}`
    promptAction.showToast({ message: `RKTNavBar变化标题+${this.count1}` })
  }

  @Builder customTitle01() {
    Column() {
      Text('我是自义定标题')
        .align(Alignment.Center)
        .fontSize(20).fontWeight(FontWeight.Medium).fontColor(Color.Red)
      Text('我是副标题')
        .align(Alignment.Center)
        .fontSize(14).fontWeight(FontWeight.Medium).fontColor(Color.Gray)
    }
    .justifyContent(FlexAlign.Center)
    .backgroundColor(Color.Yellow)
  }

  @Builder customTitle02() {
    Column() {
      TextInput({placeholder: '请输入搜索内容'})
        .width('280')
        .backgroundColor(Color.Pink)
    }
    .justifyContent(FlexAlign.Center)
    .backgroundColor(Color.Yellow)
  }

  @Builder customTitle03() {
    Column() {
      Tabs({ barPosition: BarPosition.Start }) {
        ForEach(this.tabItems, (item: DemoTabItem)  => {
          TabContent() {
            Column().width('100%').height('100%').backgroundColor(Color.Yellow).borderRadius('12vp')
          }
          .tabBar(new SubTabBarStyle(item.title))
        })
      }
      .backgroundColor(Color.White)
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .width(320)
      .onChange((index: number) => {
        console.info(index.toString())
      })
    }
    .justifyContent(FlexAlign.Center)
    .backgroundColor(Color.Yellow)
  }

  @Builder customTitle04() {
    RelativeContainer() {
      // 右侧菜单栏
      Row({ space: 10 }) {
        ForEach(this.leftMemus04, (item: RKTNavBarMenuItem)  => {
          if (item.title) {
            Text(item.title)
              .align(Alignment.Center)
              .fontSize(16).fontWeight(FontWeight.Regular).fontColor('#FFEF4033')
              .onClick(() => {
                item.action(item.tag)
              })
          } else if (item.icon) {
            Image(item.icon)
              .width(item.iconSize ? item.iconSize.width : 20).height(item.iconSize ? item.iconSize.height : 20)
              .objectFit(ImageFit.Auto)
              .onClick(() => {
                item.action(item.tag)
              })
          }
        })
      }
      .padding({right: 10})
      .height('100%')
      .alignRules({
        top: {anchor: "__container__", align: VerticalAlign.Top},
        right: {anchor: "__container__", align: HorizontalAlign.End}
      })
      .id("rightMemus04")

      // 左侧菜单栏
      Row() {
        Image($r('app.media.address'))
          .width(19).height(23)
          .objectFit(ImageFit.Auto)
        Text('新疆')
          .align(Alignment.Center)
          .fontSize(16).fontWeight(FontWeight.Regular).fontColor('#FFEF4033')
          .margin({left: 5})
      }
      .alignItems(VerticalAlign.Center)
      .padding({left: 10})
      .height('100%')
      .alignRules({
        top: {anchor: "__container__", align: VerticalAlign.Top},
        left: {anchor: "__container__", align: HorizontalAlign.Start}
      })
      .id("leftMemus04")
      .onClick(() => {
        promptAction.showToast({ message: '切换地区' })
      })
    }
    .height('100%').width('100%')
    .backgroundColor('#FFFFE4E4')
  }

  @Builder customLeftMemus01() {
    Row() {
      Image($r('app.media.address'))
        .width(19).height(23)
        .objectFit(ImageFit.Auto)
      Text('新疆')
        .align(Alignment.Center)
        .fontSize(16).fontWeight(FontWeight.Regular).fontColor('#FFEF4033')
        .margin({left: 5})
    }
    .alignItems(VerticalAlign.Center)
    .padding({left: 10})
    .onClick(() => {
      promptAction.showToast({ message: '切换地区' })
    })
  }
}