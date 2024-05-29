@Component
export struct RKTCategoryTitleView {
  @Link categoryEntityArray: RKTCategoryTitleEntity[]
  @State categoryTitleArray: string[] = []
  @State showBottomLine: boolean = false
  /// 设置菜单按钮宽度
  @State menuWidth: number = 0
  /// 当前选中item
  private selectEntity: RKTCategoryTitleEntity = new RKTCategoryTitleEntity()
  /// 菜单索引从1开始
  clickAction: Function = ((index: number) => {})

  aboutToAppear() {
    if (this.categoryEntityArray.length == 0) {
      this.categoryTitleArray.forEach((value) => {
        let entity = new RKTCategoryTitleEntity()
        entity.name = value
        this.categoryEntityArray.push(entity)
      })
    }
  }

  build() {
    Column() {
      Row() {
        ForEach(this.categoryEntityArray, (entity: RKTCategoryTitleEntity, index) => {
          RKTCategoryTitleItem({
            index: index + 1,
            entity: entity,
            clickAction: this.clickAction
          })
            .width(this.menuWidth > 0 ? this.menuWidth : (100 / this.categoryEntityArray.length) + '%')
            .onClick(() => {
              if (this.selectEntity && this.selectEntity != entity) {
                this.selectEntity.isSelect = false
              }
              entity.index = index + 1
              entity.isSelect = !entity.isSelect
              this.selectEntity = entity
              this.clickAction(this.selectEntity.isSelect ? this.selectEntity.index : 0)
            })
        })
      }

      if (this.showBottomLine) {
        Divider().width('100%').height(0.5).color('#EDEDED')
      }
    }
    .backgroundColor(Color.White)
    .width('100%')
    .height(45)
    .flexShrink(0)
  }
}

/// 为了监听到嵌套图片的变化 拆分菜单栏子组件
@Component
struct RKTCategoryTitleItem {
  @State index: number = 0
  @ObjectLink entity: RKTCategoryTitleEntity
  clickAction: Function = ((index: number) => {})

  build() {
    Row({ space: 5 }) {
      Text(this.entity.name)
        .fontSize(13)
        .fontColor(this.entity.isSelect ? "#666666" : this.entity.isHighLight ? '#EF4033' : '#666666')
      Image(this.entity.isSelect ? this.entity.selectImage : this.entity.isHighLight ? this.entity.highLightImage : this.entity.image)
        .width(6)
        .height(4)
    }
    .width('100%')
    .height(44)
    .justifyContent(FlexAlign.Center)
  }
}

@Observed
export class RKTCategoryTitleEntity {
  index: number = 0
  name: string = ""
  image: string | Resource = $r("app.media.rkt_ic_arrow_down_gray")
  selectImage: string | Resource = $r("app.media.rkt_ic_arrow_up_gray")
  highLightImage: string | Resource = $r("app.media.rkt_ic_arrow_down_red")
  isSelect: boolean = false
  isHighLight: boolean = false

  constructor(name: string = "", image: string | Resource = $r("app.media.rkt_ic_arrow_down_gray"), selectImage: string | Resource = $r("app.media.rkt_ic_arrow_up_gray"), isSelect: boolean = false, isHighLight: boolean = false) {
    this.name = name;
    this.image = image;
    this.selectImage = selectImage;
    this.isSelect = isSelect;
    this.isHighLight = isHighLight;
  }
}