import { RKTCategoryTitleEntity, RKTCategoryTitleView } from '@zjos/rocketUI'
import { RKTGridMenuPopupView } from '@zjos/rocketUI'
import { RKTDateTimePicker } from '@zjos/rocketUI'
import hilog from '@ohos.hilog'

enum CategoryPopupType {
  Default, //默认
  Menu1,
  Menu2,
  Menu3,
}

@Component
export struct RKTPopupDemo {
  @State popupType: CategoryPopupType = CategoryPopupType.Default
  @State categoryEntityArray: RKTCategoryTitleEntity[] = []
  private categoryTitleArray: string[] = ['菜单1', '菜单2', '菜单3']
  private gridMenuTitles: string[] = "菜单1,".repeat(50).split(",")

  build() {
    Stack() {
      Column() {
        RKTCategoryTitleView({
          categoryEntityArray: $categoryEntityArray,
          categoryTitleArray: this.categoryTitleArray,
          clickAction: (index:number) => {
            this.popupType = index
          }
        })
      }
      .width('100%')
      .height('100%')

      RKTGridMenuPopupView({ gridMenuTitles: this.gridMenuTitles, clickAction: () => {
        this.popupType = CategoryPopupType.Default
        this.categoryEntityArray[0].isHighLight = true
        this.categoryEntityArray[0].isSelect = false
      }, cancelAction: () => {
        this.popupType = CategoryPopupType.Default
        this.categoryEntityArray[0].isSelect = false
      } })
        .visibility(this.popupType == CategoryPopupType.Menu1 ? Visibility.Visible : Visibility.Hidden)

      RKTDateTimePicker({
        titleName: "日期选择器",
        onEnter: (date : Date) => {
          hilog.info(0x00, 'RKTDateTimePicker', `${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()}`)

          this.popupType = CategoryPopupType.Default
          this.categoryEntityArray[1].isSelect = false
        }, onCancel: () => {
          this.popupType = CategoryPopupType.Default
          this.categoryEntityArray[1].isSelect = false
        } })
        .visibility(this.popupType == CategoryPopupType.Menu2 ? Visibility.Visible : Visibility.Hidden)
    }
  }
}