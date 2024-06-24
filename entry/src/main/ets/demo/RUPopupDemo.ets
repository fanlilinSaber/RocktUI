import { RUCategoryTitleEntity, RUCategoryTitleView } from '@zjos/rocketUI'
import { RUGridMenuPopupView } from '@zjos/rocketUI'
import { RUDateTimePicker } from '@zjos/rocketUI'
import hilog from '@ohos.hilog'

enum CategoryPopupType {
  Default, //默认
  Menu1,
  Menu2,
  Menu3,
}

@Component
export struct RUPopupDemo {
  @State popupType: CategoryPopupType = CategoryPopupType.Default
  @State categoryEntityArray: RUCategoryTitleEntity[] = []
  private categoryTitleArray: string[] = ['菜单1', '菜单2', '菜单3']
  private gridMenuTitles: string[] = "菜单1,".repeat(50).split(",")

  build() {
    Stack() {
      Column() {
        RUCategoryTitleView({
          categoryEntityArray: $categoryEntityArray,
          categoryTitleArray: this.categoryTitleArray,
          clickAction: (index:number) => {
            this.popupType = index
          }
        })
      }
      .width('100%')
      .height('100%')

      RUGridMenuPopupView({ gridMenuTitles: this.gridMenuTitles, clickAction: () => {
        this.popupType = CategoryPopupType.Default
        this.categoryEntityArray[0].isHighLight = true
        this.categoryEntityArray[0].isSelect = false
      }, cancelAction: () => {
        this.popupType = CategoryPopupType.Default
        this.categoryEntityArray[0].isSelect = false
      } })
        .visibility(this.popupType == CategoryPopupType.Menu1 ? Visibility.Visible : Visibility.Hidden)

      RUDateTimePicker({
        titleName: "日期选择器",
        onEnter: (date : Date) => {
          hilog.info(0x00, 'RUDateTimePicker', `${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()}`)

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