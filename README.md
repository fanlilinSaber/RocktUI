# RocketUI

## 简介
鸿蒙快速开发UI组件库，适用于内部项目UI样式快速调用组装。目前还在不断完善中，希望多多参与。

## 注意
此库是静态库har，被动态库依赖会被打进包里，被多个动态库依赖会造成重复依赖。
```
RKTUIConfig.moduleName = "xx"
```

## 下载安装

```
 1.通过npm安装源代码，安装在根目录（存放目录：./node_modules/rocket-ui/RocketUI）
 
 https:
 npm install 'git+https://codehub.devcloud.cn-east-3.huaweicloud.com/HarmonyOS00001/RocketUI.git#release'
 ssh:
 npm install 'git+ssh://git@codehub.devcloud.cn-east-3.huaweicloud.com:HarmonyOS00001/RocketUI.git#release'
 
 2.在工程级下build-profile.json5文件下配置手动新增module

 "modules": [
    {
      "name": "rocketUI",
      "srcPath": "./node_modules/rocket-ui/rocketUI"
    }
  ]

 3.然后通过ohpm安装本地文件
 "dependencies": {
    "@zjos/rocketUI": 'file:../node_modules/rocket-ui/rocketUI'
  },
```

## 使用说明

1.在相应的类中引入组件：
```
import lottie from '@zjos/rocketUI'
```

2.使用RKTPage
```
build() {
    Column() {
      RKTPage({ title: this.title, titleColor: Color.Black }) {
        ...
      }
    }
    .width('100%')
    .height('100%')
  }
}
```
3.使用RKTProgress
```
1.配合RKTPage使用
显示loding
RKTProgressUtil.showLoading()
隐藏loading
RKTProgressUtil.hideLoading()

2.单独使用
结合arkUI语法，用条件语句控制是否加载
if(this.isloding) {
   RKTProgress()
}
```