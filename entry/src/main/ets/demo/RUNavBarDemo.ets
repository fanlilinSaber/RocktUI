/**
 * Author:fanlilin
 * Date:2024/2/1
 * Descrobe:
 */

import { RUNavBar, RUNavBarMenuItem, RUEventData, RUNavBarAppearanceMode } from '@zjos/rocketUI'
import promptAction from '@ohos.promptAction'
import emitter from '@ohos.events.emitter'
import hilog from '@ohos.hilog'
import RUEventBus from '@zjos/rocketUI/src/main/ets/utils/RUEventBus'

export interface DemoTabItem {
  // 名称
  title?: string
  // 描述
  desc?: string
}

@Component
export default struct RULoadingDemo {

  leftMemus: Array<RUNavBarMenuItem> = []

  rightMemus: Array<RUNavBarMenuItem> = []

  tabItems: Array<DemoTabItem> = [{title: '商品大厅', desc: '商品大厅占位内容'}]

  leftMemus04: Array<RUNavBarMenuItem> = []

  @State title: string = 'RUNavBar变化标题'
  @State count1: number = 0
  count2: number = 0
  @State keyword: string = '111111'
  scroller: Scroller = new Scroller();


  aboutToAppear() {

    this.leftMemus = [
      {icon: $r('app.media.goods_ic_btn_add_to'), action: (): void => this.addAction() },
      {title: '删除', action: (): void => this.deleteAction() },
      // {title: '更多', action: this.deleteAction.bind(this)}
      ]

    this.rightMemus = [
      {title: '刷新', action: (): void => this.refreshAction() },
      {title: '重装', action: (): void => this.reloadAction() },
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

    RUEventBus.on({
      eventName: '测试showLoading',
      target: this},
      (next: RUEventData) => {

      hilog.info(0xFFFF00 , `RocketUI`, "测试showLoading事件" + JSON.stringify(next))
    })
  }

  aboutToDisappear() {
    RUEventBus.off("测试showLoading", this)
  }

  build() {
    Scroll(this.scroller) {
      Column({space: 2}) {

        RUNavBar({ title: 'RUNavBar使用', rightMemus: this.rightMemus, appearanceMode: RUNavBarAppearanceMode.WhiteMode })

        RUNavBar({ title: 'RUNavBar使用', leftMemus: this.leftMemus })

        RUNavBar({ title: 'RUNavBar使用', leftMemus: this.leftMemus, rightMemus: this.rightMemus })

        RUNavBar({ title: 'RUNavBar使用', customLeftMemus: this.customLeftMemus01, rightMemus: this.rightMemus, barColor: Color.Gray })

        RUNavBar({ title: 'RUNavBar使用', customTitle: this.customTitle01, barColor: Color.Orange, forceCenter: true })

        RUNavBar({
          title: 'RUNavBar使用',
          customTitle: (): void => { this.customTitle02() },
          rightMemus: [{icon: $r('app.media.common_Search'), action: this.searchAction, iconSize: {width:35, height: 35}}], barColor: Color.Yellow })

        RUNavBar({ customTitle: (): void => { this.customTitle02() }, rightMemus: [{title: '搜索', action: this.searchAction}, {title: '|'}, {title: '发布', action: this.searchAction}], forceCenter: false })

        RUNavBar({ title: 'RUNavBar使用', customTitle: (): void => { this.customTitle03() } })

        RUNavBar({ title: 'RUNavBar使用', customTitle: (): void => { this.customTitle03() }, forceCenter: true })

        RUNavBar({ hideBack: true, title: 'RUNavBar使用', customTitle: (): void => { this.customTitle03() } })

        RUNavBar({ hideBack: true, customTitle: (): void => { this.customTitle04() } })

        RUNavBar({ title: this.title, rightMemus: [{title: '变化1', action: (tag?: string): void => { this.changeTitleAction(tag) }, tag: '1'}, {title: '变化2', action: (tag?: string): void => { this.changeTitleAction(tag) }, tag: '2'}] })

        Text(`变化标题测试: ${this.count1} + ${this.count2}`)
          .onClick(() => {
            this.count1 += 1
            this.count2 += 1
          })

      }
      .width('100%')
      .margin({ top: 2})
    }
    .scrollable(ScrollDirection.Vertical)
  }

  addAction() {
    // promptAction.showToast({ message: 'addAction' })
    promptAction.showToast({ message: `RUNavBar变化标题+${this.count1}` })

    let dd: DemoTabItem = { title: '11', desc: ''}
    RUEventBus.emit("测试showLoading", dd)
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

  changeTitleAction(tag?: string ) {
    if (tag === '1') {
      this.count1 -= 1;
    } else {
      this.count1 += 1;
    }
    // this.title = this.title === 'Hello ArkUI' ? 'Hello World' : 'Hello ArkUI';
    this.title = `RUNavBar变化标题${this.count1}`
    promptAction.showToast({ message: `RUNavBar变化标题+${this.count1}` })
  }

  @Builder customTitle01() {
    Column() {
      Text('我是自义定标题我是自义定标题我是自义定标题我是自义定标题我是自义定标题')
        .align(Alignment.Center)
        .fontSize(20).fontWeight(FontWeight.Medium).fontColor(Color.Red)
        .textOverflow({ overflow: TextOverflow.Ellipsis }) // 限制为一行 ellipses
        .maxLines(1)
      Text('我是副标题')
        .align(Alignment.Center)
        .fontSize(14).fontWeight(FontWeight.Medium).fontColor(Color.Gray)
    }
    .justifyContent(FlexAlign.Center)
    .backgroundColor(Color.Yellow)
  }

  @Builder customTitle02() {
    Column() {
      Row() {
        Image($r('app.media.common_Search'))
          .height(20).width(20).margin({ left: 10 })
        TextInput({ text: $$this.keyword, placeholder: '请输入搜索内容'})
          .backgroundColor(Color.Transparent)
          .layoutWeight(1)
          .placeholderFont({ size: 13 })
          .padding(0)
          .onChange((value: string) => {console.log('TextInput: ' + value)
          })
      }
      .borderRadius(8)
      .backgroundColor(Color.White)
      .height(33)
      .justifyContent(FlexAlign.Center)
      .clip(true)
    }
    .justifyContent(FlexAlign.Center)
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
      .backgroundColor('#FFEF4033')
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      // .width(320)
      .onChange((index: number) => {
        console.info(index.toString())
      })
    }
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#FFEF4033')
    .border({ width: '1vp', color: Color.Black })
  }

  @Builder customTitle04() {
    RelativeContainer() {
      // 右侧菜单栏
      Row({ space: 10 }) {
        ForEach(this.leftMemus04, (item: RUNavBarMenuItem)  => {
          if (item.title) {
            Text(item.title)
              .align(Alignment.Center)
              .fontSize(16).fontWeight(FontWeight.Regular).fontColor('#FFEF4033')
              .onClick(() => {
                item.action && item.action(item.tag)
              })
          } else if (item.icon) {
            Image(item.icon)
              .width(item.iconSize ? item.iconSize.width : 20).height(item.iconSize ? item.iconSize.height : 20)
              .objectFit(ImageFit.Auto)
              .onClick(() => {
                item.action && item.action(item.tag)
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