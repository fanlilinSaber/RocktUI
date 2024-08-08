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
import { RUTabBarIndicatorLine } from '@zjos/rocketUI/src/main/ets/components/newTab/RUTabBarIndicatorLine'
import { RUTabBarIndicatorPosition, RUTabBarAutomaticDimension } from '@zjos/rocketUI/src/main/ets/components/newTab/RUTabBarIndicator'
import { RUTabBarIndicatorBackground, RUTabBarIndicatorBackgroundBuilder } from '@zjos/rocketUI/src/main/ets/components/newTab/RUTabBarIndicatorBackground'
import { RUTabBarIndicatorImageBuilder } from '@zjos/rocketUI'

const TabBarItems: RUTabBarItem[] = [
  new RUTabBarItem({ title: '商品大厅', titleColor: '#FF333333', titleSelectedColor: '#FFEF4033' }),
  new RUTabBarItem({ title: '自营商品', titleColor: '#FF333333', titleSelectedColor: '#FFEF4033' }),
  new RUTabBarItem({ title: '企业专项', titleColor: '#FF333333', titleSelectedColor: '#FFEF4033' }),
  new RUTabBarItem({ title: '集采商品', titleColor: '#FF333333', titleSelectedColor: '#FFEF4033' }),
  new RUTabBarItem({ title: '促销商品', titleColor: '#FF333333', titleSelectedColor: '#FFEF4033' }),
  new RUTabBarItem({ title: '供应商', titleColor: '#FF333333', titleSelectedColor: '#FFEF4033' }),
  new RUTabBarItem({ title: '长标题测试一下', titleColor: '#FF333333', titleSelectedColor: '#FFEF4033' }),
]

const selectedBorder: BorderOptions = { width: 1,
  color: `#FFEF4033`,
  style: { top: BorderStyle.Solid }  }

const border: BorderOptions = { width: 1,
  color: $r('app.color.ru_color_FFEDEDED'),
  style: { top: BorderStyle.Solid }  }

const TabBarItems2: RUTabBarItem[] = [
  new RUTabBarItem({ title: '商品大厅', titleColor: '#FF333333', titleSelectedColor: '#FFEF4033', border: border, selectedBorder: selectedBorder, borderRadius: 5, padding: { left: 5, right: 5} }),
  new RUTabBarItem({ title: '自营商品', titleColor: '#FF333333', titleSelectedColor: '#FFEF4033', border: border, selectedBorder: selectedBorder, borderRadius: 5, padding: { left: 5, right: 5} }),
  new RUTabBarItem({ title: '企业专项', titleColor: '#FF333333', titleSelectedColor: '#FFEF4033', border: border, selectedBorder: selectedBorder, borderRadius: 5, padding: { left: 5, right: 5} }),
  new RUTabBarItem({ title: '集采商品', titleColor: '#FF333333', titleSelectedColor: '#FFEF4033', border: border, selectedBorder: selectedBorder, borderRadius: 5, padding: { left: 5, right: 5} }),
  new RUTabBarItem({ title: '促销商品', titleColor: '#FF333333', titleSelectedColor: '#FFEF4033', border: border, selectedBorder: selectedBorder, borderRadius: 5, padding: { left: 5, right: 5} }),
  new RUTabBarItem({ title: '供应商', titleColor: '#FF333333', titleSelectedColor: '#FFEF4033', border: border, selectedBorder: selectedBorder, borderRadius: 5, padding: { left: 5, right: 5} }),
  new RUTabBarItem({ title: '长标题测试一下', titleColor: '#FF333333', titleSelectedColor: '#FFEF4033', border: border, selectedBorder: selectedBorder, borderRadius: 5, padding: { left: 5, right: 5} }),
]

@Component
export default struct RUTabBarDemo {
  tabsController: RUTabsController = new RUTabsController()
  tabBarController: RUTabBarController = new RUTabBarController()

  build() {
    Column() {
      RUTabBar({ items: TabBarItems, indicatorType: RUTabBarIndicatorType.Custom, indicator: this.customIndicatorLine1, tabsController: this.tabsController, tabBarController: this.tabBarController, scrollPadding: { left: 15, right: 15},
      onClickIndex: (index) => {
        promptAction.showToast({ message: `点击下标${index}` })
      }}).height(49)
      Divider()

      RUTabBar({ items: TabBarItems, indicatorType: RUTabBarIndicatorType.Custom, indicator: this.customIndicatorLine2, tabsController: this.tabsController, tabBarController: this.tabBarController, scrollPadding: { left: 15, right: 15},
        onClickIndex: (index) => {
          promptAction.showToast({ message: `点击下标${index}` })
        }, selectedIndex: 3 }).height(49)
      Divider()

      RUTabBar({ items: TabBarItems, indicatorType: RUTabBarIndicatorType.Custom, indicator: this.customIndicatorLine3, tabsController: this.tabsController, tabBarController: this.tabBarController, scrollPadding: { left: 15, right: 15},
        onClickIndex: (index) => {
          promptAction.showToast({ message: `点击下标${index}` })
        }}).height(49)
      Divider()

      RUTabBar({ items: TabBarItems, indicatorType: RUTabBarIndicatorType.Custom, indicator: this.customIndicatorLine4, tabsController: this.tabsController, tabBarController: this.tabBarController, scrollPadding: { left: 15, right: 15},
        onClickIndex: (index) => {
          promptAction.showToast({ message: `点击下标${index}` })
        }}).height(49)
      Divider()

      RUTabBar({ items: TabBarItems, indicatorType: RUTabBarIndicatorType.Custom, indicator: RUTabBarIndicatorBackgroundBuilder, tabsController: this.tabsController, tabBarController: this.tabBarController, scrollPadding: { left: 15, right: 15},
        onClickIndex: (index) => {
          promptAction.showToast({ message: `点击下标${index}` })
        }}).height(49)
      Divider()

      RUTabBar({ items: TabBarItems, indicatorType: RUTabBarIndicatorType.Custom, indicator: RUTabBarIndicatorImageBuilder, tabsController: this.tabsController, tabBarController: this.tabBarController, scrollPadding: { left: 15, right: 15},
        onClickIndex: (index) => {
          promptAction.showToast({ message: `点击下标${index}` })
        }}).height(60)
      Divider()

      RUTabBar({ items: TabBarItems2, indicatorType: RUTabBarIndicatorType.None, tabsController: this.tabsController, tabBarController: this.tabBarController, scrollPadding: { left: 15, right: 15},
        onClickIndex: (index) => {
          promptAction.showToast({ message: `点击下标${index}` })
        }}).height(49)
      Divider()
    }
    .width('100%')
    .height('100%')
  }


  @Builder
  customIndicatorLine1(controller: RUTabBarIndicatorDelegate) {
    RUTabBarIndicatorLine({ delegate: controller, options: { width: 20, height: 3, color: '#FFEF4033', position: RUTabBarIndicatorPosition.Bottom } })
  }

  @Builder
  customIndicatorLine2(controller: RUTabBarIndicatorDelegate) {
    RUTabBarIndicatorLine({ delegate: controller, options: { width: RUTabBarAutomaticDimension, height: 3, color: '#FFEF4033', position: RUTabBarIndicatorPosition.Bottom } })
  }

  @Builder
  customIndicatorLine3(controller: RUTabBarIndicatorDelegate) {
    RUTabBarIndicatorLine({ delegate: controller, options: { width: 30, height: 3, color: '#FFEF4033', position: RUTabBarIndicatorPosition.Top } })
  }

  @Builder
  customIndicatorLine4(controller: RUTabBarIndicatorDelegate) {
    RUTabBarIndicatorLine({ delegate: controller, options: { width: RUTabBarAutomaticDimension, height: 3, color: '#FFEF4033', position: RUTabBarIndicatorPosition.Top } })
  }
}