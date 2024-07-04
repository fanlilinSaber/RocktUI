import { RUProgress } from "@zjos/rocketUI"
import Prompt from '@system.prompt'
import router from '@ohos.router'
import { DetailsPage01Builder } from './DetailsPage01';
import { DetailsPage02Builder } from './DetailsPage02';
import { DetailsPage03Builder } from './DetailsPage03';
import { DetailsPage04Builder } from './DetailsPage04';
import { DetailsPage05Builder } from './DetailsPage05';

interface Demo {
  title: string;
  value: string;
}

let demos: Demo[] = [
  { title: "普通加载Loading", value: "LoadingDemo" },
  { title: "使用RUPage加载Loading", value: "RULoadingDemo" },
  { title: "使用RUPage自定义title", value: "RUPageCustomTitleDemo" },
  { title: "消息提示Toast", value: "RUToastDemo" },
  { title: "弹出窗口Popup", value: "RUPopupDemo" },
  { title: "RUNavBar使用", value: "RUNavBarDemo" },
  { title: "ItemInputText", value: "RUItemInputTextDemo" },
  { title: "下拉刷新/上拉加载更多", value: "RURefreshDemo" },
  { title: "其它弹窗demo", value: "RUDialogDemo" },
  { title: "选择图片/视频demo", value: "RUSelectPicturesDemo" },
  { title: "条件筛选框", value: "RUFilterDemo" },
  { title: "常用TabDemo", value: "RUTabDemo" },
  { title: "筛选Demo", value: "RUPickerDemo" }
];

let storage = LocalStorage.getShared();

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State visible: boolean = false;
  @LocalStorageLink("pageStack") pageStack: NavPathStack = new NavPathStack()

  build() {
    Navigation(this.pageStack) {
      this.buildContent()
    }
    .hideTitleBar(true)
    .navDestination(this.pageMap)
  }

  @Builder pageMap(name: string, param: Object) {
    // NavDestination() {
      if (name === 'pages/DetailsPage01') {
        // 路由到hsp包中的登录页面
        DetailsPage01Builder(param)
      } else if (name === 'pages/DetailsPage02') {
        DetailsPage02Builder(param)
      } else if (name === 'pages/DetailsPage03') {
        DetailsPage03Builder(param)
      } else if (name === 'pages/DetailsPage04') {
        DetailsPage04Builder(param)
      } else if (name == 'pages/DetailsPage05') {
        DetailsPage05Builder(param)
      }
    // }.hideTitleBar(true)
  }

  @Builder
  buildContent() {
    Text("RocketUI Demo示列")
      .height(64)
      .fontSize(25)
      .margin({ top: 40 })

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
    if (item.value == 'LoadingDemo') {
      url = 'pages/DetailsPage01'
    } else if (item.value == 'RUPageCustomTitleDemo') {
      url = 'pages/DetailsPage05'
    } else if (item.value == 'RUPickerDemo') {
      url = 'pages/DetailsPage04'
    }

    let params: Demo = { value: item.value, title: item.title }
    this.pageStack.pushPathByName(url, params, true)
  }
}