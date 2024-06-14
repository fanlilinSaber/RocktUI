import { RKTProgress } from "@zjos/rocketUI"
import Prompt from '@system.prompt'
import router from '@ohos.router'
import { DetailsPage01Builder } from './DetailsPage01';

interface Demo {
  text: string;
  value: string;
}

let demos: Demo[] = [
  { text: "加载Loading", value: "LoadingDemo" },
  { text: "使用RKTPage加载Loading", value: "RKTLoadingDemo" },
  { text: "消息提示Toast", value: "RKTToastDemo" },
  { text: "弹出窗口Popup", value: "RKTPopupDemo" },
  { text: "RKTNavBar使用", value: "RKTNavBarDemo" },
  { text: "ItemInputText", value: "RKTItemInputTextDemo" },
  { text: "下拉刷新/上拉加载更多", value: "RKTRefreshDemo" },
  { text: "其它弹窗demo", value: "RKTDialogDemo" },
  { text: "选择图片/视频demo", value: "RKTSelectPicturesDemo" },
  { text: "条件筛选框", value: "RKTConditionalFilteringDemo" }
];

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State visible: boolean = false;
  pageStack: NavPathStack = new NavPathStack()

  build() {
    // Navigation(this.pageStack) {
      Column() {
        // RKTNavBar()
        // Test001()
        this.buildContent()
      }
      .width('100%')
    // }
    // .title("测试表示")
    // .navDestination(this.pageMap)
    // .mode(NavigationMode.Stack)
  }

  @Builder pageMap(name: string) {

    if (name === 'DetailsPage01') {

      // 路由到hsp包中的登录页面

      DetailsPage01Builder()

    }
  }

  @Builder
  buildContent() {
    Text("RocketUI Demo示列")
      .height(64)
      .fontSize(25)

    List({ space: 10 }) {
      ForEach(demos, (item: Demo, index: number) => {
        ListItem() {
          Row() {
            Text(item.text);
          }
          .width('100%')
          .backgroundColor(Color.White)
          .padding({
            top: 4,
            bottom: 4,
            left: 16,
            right: 16
          })
          .margin({
            bottom: 4,
          })
          .onClick(() => {
            this.onDemoClick(item)
          })
          .animation({ duration: 50 })
        }
      }, (item: Demo, index: number) => item.value + index)
    }.margin({
      top: 10
    })
    .divider({
      strokeWidth: 1,
      startMargin: 16,
      endMargin: 10,
      color: '#ffe9f0f0'
    })
  }

  onDemoClick(item: Demo) {
    let url = 'pages/DetailsPage02'
    if (item.text == '加载Loading') {
      url = 'pages/DetailsPage01'
      // this.pageStack.pushPathByName("DetailsPage01", null, true)
      // return
    } else if (item.text == "条件筛选框") {
      url = 'pages/DetailsPage03'
    }

    router.pushUrl({
      url: url,
      params: {
        value: item.value,
        title: item.text
      }
    })

  }
}
