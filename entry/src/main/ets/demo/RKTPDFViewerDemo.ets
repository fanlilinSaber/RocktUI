import web_webview from '@ohos.web.webview'

//本地PDF文件，其中“#toolbar=0”屏蔽Web组件的工具栏
const RESOURCE_URL: string = 'resource://rawfile/sample.pdf#toolbar=0'
//网络PDF文件路径，其中“#toolbar=0”屏蔽Web组件的工具栏
const REMOTE_URL: string = 'https://gitee.com/harmonyos-cases/cases/raw/master/CommonAppDevelopment/feature/webpdfviewer/src/main/resources/rawfile/sample.pdf#toolbar=0'

//本地PDF文件，其中“#toolbar=0”屏蔽Web组件的工具栏
//const RESOURCE_URL: string = 'https://gitee.com/harmonyos-cases/cases/issues?page=2&state=open'
//网络PDF文件路径，其中“#toolbar=0”屏蔽Web组件的工具栏
//const REMOTE_URL: string = 'https://www.baidu.com'

/**
 *PDF预览器（分别是预览本地PDF文件和预览网络PDF文件。）
 *创建一个Web组件，通过 resource 协议来预览本地PDF资源并通过.onProgressChange方法监听加载进度。
 *创建一个Web组件，通过网络链接属性来加载并预览网络PDF资源并通过.onProgressChange方法监听加载进度。
 *
 *TODO 这个demo还有点问题不能正常预览，可能是模拟器的问题，等有真机了再测试一下。
 *TODO 这个demo还有点问题不能正常预览，可能是模拟器的问题，等有真机了再测试一下。
 *TODO 这个demo还有点问题不能正常预览，可能是模拟器的问题，等有真机了再测试一下。
 */
@Component
export default struct RKTPDFViewerDemo {

  // 指定当前进度值，初始化开始位置为0
  START_VALUE: number = 0
  // 指定进度总长，进度条总长度为100
  TOTAL_VALUE: number = 100

  //设置加载本地进度，进度条初始值为0
  @State localProgressValue: number = 0
  //记录加载本地进度条显隐，进入页面默认加载
  @State isHiddenLocalProgress: boolean = true
  //设置加载网络进度，进度条初始值为0
  @State remoteProgressValue: number = 0
  //记录加载网络进度条显隐，进入页面默认加载
  @State isHiddenRemoteProgress: boolean = true
  //tabs组件选中的初始位置
  @State tabsIndex: number = 0
  controller: web_webview.WebviewController = new web_webview.WebviewController()
  tabsController: TabsController = new TabsController()
  @Link @Watch("onChangeUrl") isNetPdf: boolean

  build() {
    Column() {
      if (this.isHiddenLocalProgress) {
        Progress({ value: this.START_VALUE, total: this.TOTAL_VALUE, type: ProgressType.Linear })
          .width("100%")
          .height(3)
          .value(this.localProgressValue)
          .color("#FF123123")
      }
      //需求：可以对Web的下载、打印等按钮点击事件处理。
      //知识点：加载本地PDF文件，通过resource协议加载本地资源文件。
      //知识点：加载网络PDF文件，可以直接访问网络地址的方式。
      Web({ src: this.isNetPdf ? REMOTE_URL : RESOURCE_URL, controller: this.controller })
        .onProgressChange((event) => {
          if (event) {
            this.localProgressValue = event.newProgress
            if (this.localProgressValue >= this.TOTAL_VALUE) {
              this.isHiddenLocalProgress = false
            }
          }
        })
          //设置是否开启文档对象模型存储接口（DOM Storage API）权限，默认未开启。
        .domStorageAccess(true)
    }
  }

  onChangeUrl() {
    let url = this.isNetPdf ? REMOTE_URL : RESOURCE_URL
    this.controller.loadUrl(url)
  }
}

