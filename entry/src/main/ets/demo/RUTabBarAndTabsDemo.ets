/**
 * Author:fanlilin
 * Date:2024/8/8
 * Descrobe:
 */
import RUTabBar, { RUTabBarController,
  RUTabBarIndicatorDelegate,
  RUTabBarIndicatorType,
  RUTabBarItem } from '@zjos/rocketUI/src/main/ets/components/newTab/RUTabBar'
import { RUTabsController } from '@zjos/rocketUI/src/main/ets/components/newTab/RUTabs'
import { promptAction } from '@kit.ArkUI'
import { RUTabBarIndicatorLine, RUTabBarIndicatorPosition } from '@zjos/rocketUI'
import GoodsListPage from '../pages/GoodsListPage'

const TabBarItems: RUTabBarItem[] = [
  new RUTabBarItem({ title: '商品大厅', titleColor: '#FF333333', titleSelectedColor: '#FFEF4033' }),
  new RUTabBarItem({ title: '自营商品', titleColor: '#FF333333', titleSelectedColor: '#FFEF4033' }),
  new RUTabBarItem({ title: '企业专项', titleColor: '#FF333333', titleSelectedColor: '#FFEF4033' }),
  new RUTabBarItem({ title: '集采商品', titleColor: '#FF333333', titleSelectedColor: '#FFEF4033' }),
  new RUTabBarItem({ title: '促销商品', titleColor: '#FF333333', titleSelectedColor: '#FFEF4033' }),
  new RUTabBarItem({ title: '供应商', titleColor: '#FF333333', titleSelectedColor: '#FFEF4033' }),
  new RUTabBarItem({ title: '长标题测试一下', titleColor: '#FF333333', titleSelectedColor: '#FFEF4033' }),
]

@Component
export default struct RUTabBarAndTabsDemo {
  tabsController: TabsController = new TabsController()
  tabBarController: RUTabBarController = new RUTabBarController()

  build() {
    Column() {
      RUTabBar({ items: TabBarItems, indicatorType: RUTabBarIndicatorType.Custom, indicator: this.customIndicatorLine1, tabsController: this.tabsController, tabBarController: this.tabBarController, scrollPadding: { left: 15, right: 15},
        onClickIndex: (index) => {
          promptAction.showToast({ message: `点击下标${index}` })
        }}).height(49)

      Tabs({ index: 0, controller: this.tabsController }) {
        ForEach(TabBarItems, (item: RUTabBarItem, index: number) => {
          TabContent() {
            GoodsListPage({ tabsController: this.tabsController, tabsIndex: index })
          }
        })
      }
      .barWidth(0)
      .barHeight(0)
      .onChange((index: number) => {
        this.tabBarController.scrollToIndex(index)
      })
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  customIndicatorLine1(controller: RUTabBarIndicatorDelegate) {
    RUTabBarIndicatorLine({ delegate: controller, options: { width: 20, height: 3, color: '#FFEF4033', position: RUTabBarIndicatorPosition.Bottom } })
  }
}