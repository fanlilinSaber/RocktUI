import { GET, Net, NetLoadingDialog, ReturnDataType } from '../../../../../../../../net'
import { GoodsApi } from '../../../../api/GoodsApi'
import { GoodsFilterBoxComponentConfig } from '../Model/GoodsFilterBoxComponentConfig'

/*地址数据模型*/
class AreaModel {
  id: string
  name: string
  simleName: string
  shortName: string
  areaName: string
  parentNo: string
  parentId: string
  lat: string
  lng: string
  no: string
  sort: number
  level: number
  children: AreaModel[]

  constructor(param: {
    id: string,
    name: string,
    no: string
  }) {
    this.id = param.id
    this.name = param.name
    this.no = param.no
  }
}

// Basic implementation of IDataSource to handle data listener
class BasicDataSource implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private originDataArray: AreaModel[] = [];

  public totalCount(): number {
    return 0;
  }

  public getData(index: number): AreaModel {
    return this.originDataArray[index];
  }

  // 该方法为框架侧调用，为LazyForEach组件向其数据源处添加listener监听
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      console.info('add listener');
      this.listeners.push(listener);
    }
  }

  // 该方法为框架侧调用，为对应的LazyForEach组件在数据源处去除listener监听
  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      console.info('remove listener');
      this.listeners.splice(pos, 1);
    }
  }

  // 通知LazyForEach组件需要重载所有子组件
  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  // 通知LazyForEach组件需要在index对应索引处添加子组件
  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }

  // 通知LazyForEach组件需要重载所有子组件
  notifyDataClear(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }

  // 通知LazyForEach组件在index对应索引处数据有变化，需要重建该子组件
  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    })
  }

  // 通知LazyForEach组件需要在index对应索引处删除该子组件
  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }
}

var index = 0

class MyDataSource extends BasicDataSource {
  private dataArray: AreaModel[] = [];

  public totalCount(): number {
    return this.dataArray.length;
  }

  public clear() {
    this.dataArray = []
    this.notifyDataReload()
  }

  public reload() {
    this.notifyDataReload()
  }

  public getData(index: number): AreaModel {
    return this.dataArray[index];
  }

  public indexOfName(name: string): number {
    var i = 0
    this.dataArray.forEach((item, index) => {
      if (item.name == name) {
        i = index
        return
      }
    })
    return i
  }

  public addData(index: number, data: AreaModel): void {
    this.dataArray.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public pushData(data: AreaModel): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }
}

/*
 * 地址选择弹出框
 *
 * @description TODO
 * @author 罗林轩
 * @date 2023/12/11 09:27
 **/
enum GoodsFilterBoxPopAreaComponentChoiceType {
  /*一般情况，仅区域多选*/
  normal,
  /*其余的待补充*/
}

var isFirst: boolean = true

@Component
export struct GoodsFilterBoxPopAreaComponent {
  /*config*/
  @Link item: GoodsFilterBoxComponentConfig
  /*是否展示,和上一个页面双向同步*/
  @Watch("componentAnimate") @Link expandIndex: number
  /*这个参数和expandIndex一样时，就表示可以展开了*/
  configExpandIndex: number = 0
  /*省数据*/
  provinceArray: MyDataSource = new MyDataSource()
  /*省选择下标*/
  @State provinceSelectedIndex: number = 0
  /*市数据*/
  cityArray: MyDataSource = new MyDataSource()
  /*市选择下标*/
  @State citySelectedIndex: number = 0
  /*区域数据*/
  areaArray: MyDataSource = new MyDataSource()
  /*区域选择的下标*/
  @State areaSelectedIndexs: number[] = [0]
  /*list的高度*/
  @State listHeight: number = 0
  /*按钮的高度*/
  @State buttonHeight: number = 0
  /*空白的高度*/
  @State blankHeight: string = "0%"
  private mCustomDialogController = new CustomDialogController({
    builder: NetLoadingDialog({
      loadingText: '加载中...'
    }),
    autoCancel: false,
    customStyle: true
  })

  /*获取全国的数据*/
  getNetworkData() {
    this.mCustomDialogController.open()
    this.getData().then(data => {
      this.mCustomDialogController.close()
      this.provinceArray.pushData(new AreaModel({ id: "", name: "全国", no: "" }))
      data.forEach(item => {
        this.provinceArray.pushData(item)
      });
    }).catch(err => {
      this.mCustomDialogController.close()
    })


  }

  @GET(GoodsApi.GOODS_AREATREE,{
    priority: 2,
    iscachefile: true
  })
  public getData(): Promise<Array<AreaModel>> {

    return null
  }

  /*组件动画*/
  componentAnimate() {
    if (this.expandIndex > -1 && isFirst == true) {
      this.getNetworkData()
      isFirst = false
    }
      this.expandIndex == this.configExpandIndex ? this.show() : this.hide()
  }

  /*如果有历史数据就读取*/
  reloadHistory() {
    if (this.item.selectedAreaContent.provinceNameSelected.length > 0) {
      this.provinceSelectedIndex = this.provinceArray.indexOfName(this.item.selectedAreaContent.provinceNameSelected)
    } else {
      this.provinceSelectedIndex = 0
    }
    if (this.item.selectedAreaContent.cityNameSelected.length > 0) {
      this.citySelectedIndex = this.cityArray.indexOfName(this.item.selectedAreaContent.cityNameSelected)
    } else {
      this.cityArray.clear()
    }
    if (this.item.selectedAreaContent.areaNameSelected.length > 0) {
      this.item.selectedAreaContent.areaNameSelected.forEach((name) => {
        this.areaSelectedIndexs.push(this.areaArray.indexOfName(name))
      })
    } else {
      this.areaArray.clear()
    }
  }

  show() {
    this.reloadHistory()

    animateTo({ duration: 300, curve: Curve.Linear }, () => {
      this.listHeight = 280
      this.buttonHeight = 48
      this.blankHeight = "100%"
    })
  }

  hide() {
    /*如果没有选中保存，则清空*/
    if (this.item.isSelected == false) {
      this.areaSelectedIndexs = []
      this.citySelectedIndex = 0
      this.provinceSelectedIndex = 0
      this.areaArray.clear()
      this.cityArray.clear()
    }

    animateTo({ duration: 300, curve: Curve.Linear }, () => {
      this.listHeight = 0
      this.buttonHeight = 0
      this.blankHeight = "0"
    })
  }

  build() {
    Column() {
      Flex({ direction: FlexDirection.Row }) {
        /*省*/
        List() {
          LazyForEach(this.provinceArray, (item: AreaModel, index) => {
            ListItem() {
              Row() {
                Text(item.name)
                  .fontWeight(this.provinceSelectedIndex == index ? FontWeight.Bold : FontWeight.Normal)
                  .fontColor((this.provinceSelectedIndex == index && this.provinceSelectedIndex != 0) ? $r("app.color.color_FFFF2928") : Color.Black)

                if (index == 0 && this.provinceSelectedIndex == 0) {
                  Image($r("app.media.goods_ic_selected"))
                    .size({ width: 14, height: 10 })
                }
              }
              .onClick(() => {
                this.provinceSelectedIndex = index
                this.cityArray.clear()
                this.areaArray.clear()
                this.citySelectedIndex = 0
                this.areaSelectedIndexs = [0]
                if (index != 0) {
                  this.cityArray.pushData(new AreaModel({ id: "", name: "不限", no: "" }))
                  this.provinceArray.getData(this.provinceSelectedIndex).children.forEach(item => {
                    this.cityArray.pushData(item)
                  });
                }
              })
              .justifyContent(FlexAlign.SpaceBetween)
              .width("100%")
              .height(40)
            }
            .backgroundColor((this.provinceSelectedIndex == index && this.provinceSelectedIndex != 0) ? $r("app.color.auxiliaryColor_04") : Color.White)
            .padding({ left: 14, right: 14 })
          }, (item: AreaModel) => item.name)
        }
        .height(this.listHeight)
        .alignListItem(ListItemAlign.Start)
        .flexGrow(1)
        .backgroundColor("#FFFFFF")

        /*市*/
        List() {
          LazyForEach(this.cityArray, (item: AreaModel, index) => {
            ListItem() {
              Row() {
                Text(item.name)
                  .fontWeight(this.citySelectedIndex == index ? FontWeight.Bold : FontWeight.Normal)
                  .fontColor((this.citySelectedIndex == index && this.citySelectedIndex != 0) ? $r("app.color.color_FFFF2928") : Color.Black)

                if (index == 0 && this.citySelectedIndex == 0) {
                  Image($r("app.media.goods_ic_selected"))
                    .size({ width: 14, height: 10 })
                }
              }
              .onClick(() => {
                this.citySelectedIndex = index
                this.areaSelectedIndexs = [0]
                this.areaArray.clear()
                if (index != 0) {
                  this.areaArray.pushData(new AreaModel({ id: "", name: "不限", no: "" }))
                  this.cityArray.getData(this.citySelectedIndex).children.forEach(item => {
                    this.areaArray.pushData(item)
                  });
                }
                this.areaArray.reload()
              })
              .justifyContent(FlexAlign.SpaceBetween)
              .width("100%")
            }
            .backgroundColor((this.citySelectedIndex == index && this.citySelectedIndex != 0) ? $r("app.color.auxiliaryColor_04") : Color.White)
            .padding({ left: 14, right: 14 })
            .height(40)
          }, (item: AreaModel) => item.name)
        }
        .height(this.listHeight)
        .alignListItem(ListItemAlign.Start)
        .flexGrow(1)
        .backgroundColor("#F9F9F9")

        /*区*/
        List() {
          LazyForEach(this.areaArray, (item: AreaModel, index) => {
            ListItem() {
              Row() {
                Text(item.name)
                  .fontWeight(this.areaSelectedIndexs.includes(index) == true ? FontWeight.Bold : FontWeight.Normal)
                if (this.areaSelectedIndexs.includes(index) == true) {
                  Image($r("app.media.goods_ic_selected"))
                    .size({ width: 14, height: 10 })
                }
              }
              .onClick(() => {
                if (index == 0) {
                  this.areaSelectedIndexs.splice(0, this.areaSelectedIndexs.length)
                } else if (this.areaSelectedIndexs[0] == 0) {
                  this.areaSelectedIndexs.shift()
                }

                if (this.areaSelectedIndexs.includes(index)) {
                  this.areaSelectedIndexs.splice(this.areaSelectedIndexs.indexOf(index), 1)
                } else {
                  this.areaSelectedIndexs.push(index)
                }
              })
              .justifyContent(FlexAlign.SpaceBetween)
              .width("100%")
            }
            .backgroundColor(Color.Transparent)
            .padding({ left: 14, right: 14 })
            .height(40)
          }, (item: AreaModel) => item.name)
        }
        .height(this.listHeight)
        .alignListItem(ListItemAlign.Start)
        .flexGrow(1)
        .backgroundColor("#F4F4F4")
        .width("100%")
        .onAppear(() => {

        })
      }

      Flex({ direction: FlexDirection.Row }) {
        Text("重置")
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Black)
          .backgroundColor(Color.White)
          .flexGrow(1)
          .height(this.buttonHeight)
          .onClick(() => {
            this.areaSelectedIndexs = []
            this.citySelectedIndex = null
            this.cityArray.clear()
            this.areaArray.clear()
            this.provinceSelectedIndex = 0
          })
        Text("确定")
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .backgroundColor($r("app.color.color_FFFF2928"))
          .flexGrow(1)
          .height(this.buttonHeight)
          .onClick(() => {
            /*保存数据*/
            this.item.selectedAreaContent.provinceNameSelected = this.provinceArray.getData(this.provinceSelectedIndex)
              .name
            this.item.selectedAreaContent.provinceCodeSelected = this.provinceArray.getData(this.provinceSelectedIndex)
              .no

            if (this.cityArray.totalCount() > 0) {
              this.item.selectedAreaContent.cityNameSelected = this.cityArray.getData(this.citySelectedIndex)
                .name
              this.item.selectedAreaContent.cityCodeSelected = this.cityArray.getData(this.citySelectedIndex)
                .no
            }

            if (this.areaArray.totalCount() > 0) {
              this.item.selectedAreaContent.areaNameSelected = []
              this.item.selectedAreaContent.areaCodeSelected = []

              this.areaSelectedIndexs.forEach(item => {
                this.item.selectedAreaContent.areaNameSelected.push(this.areaArray.getData(item)
                  .name)
              });
              this.areaSelectedIndexs.forEach(item => {
                this.item.selectedAreaContent.areaCodeSelected.push(this.areaArray.getData(item).no)
              });
            }

            if (this.provinceSelectedIndex == 0) {
              this.item.isSelected = false
            } else {
              this.item.isSelected = true
            }
            this.expandIndex = -1
            this.item.clickCallBack(this.item)
          })
      }
      .width("100%")

      Blank()
        .height(this.blankHeight)
        .width("100%")
        .backgroundColor(Color.Black)
        .opacity(0.3)
        .onClick(() => {
          this.expandIndex = -1
        })
    }
  }
}