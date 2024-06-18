import { RKTProgress } from "@zjos/rocketUI"
import Prompt from '@system.prompt'
import router from '@ohos.router'
import { DetailsPage01Builder } from './DetailsPage01';
import { DetailsPage02Builder } from './DetailsPage02';
import { DetailsPage03Builder } from './DetailsPage03';

interface Demo {
  title: string;
  value: string;
}

let demos: Demo[] = [
  { title: "加载Loading", value: "LoadingDemo" },
  { title: "使用RKTPage加载Loading", value: "RKTLoadingDemo" },
  { title: "消息提示Toast", value: "RKTToastDemo" },
  { title: "弹出窗口Popup", value: "RKTPopupDemo" },
  { title: "RKTNavBar使用", value: "RKTNavBarDemo" },
  { title: "ItemInputText", value: "RKTItemInputTextDemo" },
  { title: "下拉刷新/上拉加载更多", value: "RKTRefreshDemo" },
  { title: "其它弹窗demo", value: "RKTDialogDemo" },
  { title: "选择图片/视频demo", value: "RKTSelectPicturesDemo" },
  { title: "条件筛选框", value: "RKTConditionalFilteringDemo" }
];

let storage = LocalStorage.getShared();

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State visible: boolean = false;
  // pageStack: NavPathStack = new NavPathStack()
  @LocalStorageLink("pageStack") pageStack: NavPathStack = new NavPathStack()

  build() {
    Navigation(this.pageStack) {
      this.buildContent()
    }
    .hideTitleBar(true)
    .navDestination(this.pageMap)
  }

  @Builder pageMap(name: string, param: Object) {
    NavDestination() {
      if (name === 'pages/DetailsPage01') {
        // 路由到hsp包中的登录页面
        DetailsPage01Builder(param)
      } else if (name === 'pages/DetailsPage02') {
        DetailsPage02Builder(param, this.pageStack)
      } else if (name === 'pages/DetailsPage03') {
        DetailsPage03Builder(param)
      }
    }.hideTitleBar(true)
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
            Text(item.title);
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
    if (item.title == '加载Loading') {
      url = 'pages/DetailsPage01'
    } else if (item.title == "条件筛选框") {
      url = 'pages/DetailsPage03'
    }

    let params: Demo = { value: item.value, title: item.title }
    this.pageStack.pushPathByName(url, params, true)
  }
}
