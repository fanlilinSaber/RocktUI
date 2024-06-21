
import { RKTTabDataListType, RKTTabType, RKTTabComponent } from '@zjos/rocketUI'
import { promptAction } from '@kit.ArkUI'

const dataListDemo:RKTTabDataListType[] = [
  {name: '出租大厅', no: '1'},
  {name: '需求大厅', no: '2'},
  {name: '转让大厅', no: '3'},
  {name: '自营租赁', no: '4'},
  {name: '竞价租赁', no: '5'},
  {name: '集采租赁', no: '6'},
  {name: '企业专项', no: '7'}
]

@Component
export  struct RKTTabDemo {

  @State UnderlineTabDataList:RKTTabDataListType[] = []
  @State UnderlineTabCurrentIndex:number = 0

  @State BorderTabDataList:RKTTabDataListType[] = []
  @State BorderTabCurrentIndex:number = 2

  @State LeftLineTabDataList:RKTTabDataListType[] = []
  @State LeftLineTabCurrentIndex:number = 4

  aboutToAppear(): void {
    this.UnderlineTabDataList = dataListDemo
    this.BorderTabDataList = dataListDemo
    this.LeftLineTabDataList = dataListDemo
  }

  /*下划线UnderlineTabChange*/
  UnderlineTabChange(index:number){
    this.UnderlineTabCurrentIndex = index
    promptAction.showToast({ message: '下划线UnderlineTabChange------------>当前点击下标'+ index +'\n 点前点击数据=========》' + JSON
      .stringify(this.UnderlineTabDataList[index])})
  }
  /*边框类型BorderTabChange*/
  BorderTabChange(index:number){
    this.BorderTabCurrentIndex = index
    promptAction.showToast({ message: '边框类型BorderTabChange------------->当前点击下标'+ index })
  }
  /*左边块LeftLineTabChange*/
  LeftLineTabChange(index:number){
    this.LeftLineTabCurrentIndex = index
    promptAction.showToast({ message: '左边块LeftLineTabChange--------------->当前点击下标'+ index })
  }

  @Builder
  UnderlineTab(){
    RKTTabComponent({
      tabDataList: this.UnderlineTabDataList,
      currentIndex: this.UnderlineTabCurrentIndex,
      tabType: RKTTabType.UnderlineTab,
      onChangeTab: (index => {
        this.UnderlineTabChange(index)
      })
    })
  }
  @Builder
  BorderTab(){
    RKTTabComponent({
      tabDataList: this.BorderTabDataList,
      currentIndex: this.BorderTabCurrentIndex,
      tabType: RKTTabType.BorderTab,
      onChangeTab: (index => {
        this.BorderTabChange(index)
      })
    })
  }
  @Builder
  LeftLineTab(){
    RKTTabComponent({
      tabDataList:this.LeftLineTabDataList,
      currentIndex:this.LeftLineTabCurrentIndex,
      tabType:RKTTabType.LeftLineTab,
      place:Axis.Vertical,
      tabHeight:'100%',
      isShowBorder:false,
      onChangeTab:async (index:number)=>{
        this.LeftLineTabChange(index)
      }
    })
  }

  build() {
      Column() {
        RKTTabComponent({
          tabDataList: this.UnderlineTabDataList,
          currentIndex: this.UnderlineTabCurrentIndex,
          tabType: RKTTabType.UnderlineTab,
          onChangeTab: (index => {
            this.UnderlineTabChange(index)
          })
        })
        RKTTabComponent({
          tabDataList: this.BorderTabDataList,
          currentIndex: this.BorderTabCurrentIndex,
          tabType: RKTTabType.BorderTab,
          onChangeTab: (index => {
            this.BorderTabChange(index)
          })
        })
        Row(){
          RKTTabComponent({
            tabDataList:this.LeftLineTabDataList,
            currentIndex:this.LeftLineTabCurrentIndex,
            tabType:RKTTabType.LeftLineTab,
            place:Axis.Vertical,
            tabHeight:'100%',
            isShowBorder:false,
            onChangeTab:async (index:number)=>{
              this.LeftLineTabChange(index)
            }
          })
        }.height(300).backgroundColor($r('app.color.ru_color_FFFFFFFF'))
      }
      .width('100%')
      .height('100%')
  }
}