import { common } from '@kit.AbilityKit';
import { util } from '@kit.ArkTS';
import {
  RUFramePickerView,
  FrameOptionsController
} from '@zjos/rocketUI/src/main/ets/components/datePicker/RUFramePickerView';
import { PickerOptionsController } from '@zjos/rocketUI/src/main/ets/components/datePicker/RUPickerView';
import { PickerResult } from '@zjos/rocketUI/src/main/ets/components/datePicker/RUPickerView';
import { RUPickerView } from '@zjos/rocketUI/src/main/ets/components/datePicker/RUPickerView';
import { PickerOptionsUtils } from '../utils/PickerOptionsUtils';
import { IPickerViewData } from '@zjos/rocketUI/src/main/ets/components/datePicker/data/IPickerViewData';

@Builder
export function DetailsPage04Builder(param: Object) {
  NavDestination() {
    DetailsPage04()
  }.hideTitleBar(true)
}

@Entry
@Component
export struct DetailsPage04 {
  @State message: string = 'Hello World';
  @State frameOptionsController: FrameOptionsController = new FrameOptionsController()
  @State data: Array<AddressEntity> = new Array
  @State pickerOptionsController: PickerOptionsController = new PickerOptionsController()

  @State topHeight: number = 0;

  aboutToAppear(): void {
    let context = getContext(this) as common.UIAbilityContext;
    let resManager = context.resourceManager;
    resManager.getRawFileContent("address.json", (err, value) => {
      if (!!err) {
        console.info('TAG: =================' + JSON.stringify(err));
        return
      }
      let rawFile = value;
      let textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true })
      let retStr = textDecoder.decodeWithStream(rawFile, { stream: false });
      console.info('TAG: =================' + retStr);
      this.data = JSON.parse(retStr) as Array<AddressEntity>
      // PickerOptionsUtils.setFrameOptionsData(0, true, this.data, this.frameOptionsController)
      // this.setPickerOptionsData("省", 1, false, this.data)
      PickerOptionsUtils.setPickerOptionsData("省", 1, false, this.data, this.pickerOptionsController)
      this.pickerOptionsController.setPickerCurrentIndex('省', 3)
    })
  }

  build() {
    Column() {

      Stack({alignContent: Alignment.TopStart}) {

        Text('点击弹出筛选框')
          .fontColor(Color.Brown)
          .fontSize(15)
          .align(Alignment.Center)
          .border({
            color: Color.Brown,
            width: 1,
            radius: 10
          })
          .margin({
            top: 156
          })
          .width('100%')
          .height(50)
          .onClick(() => {
            // this.frameOptionsController.setPickerSelectedData(new Array)
            //this.frameOptionsController.showPicker()
            this.pickerOptionsController.showPicker()
          })
          .onAreaChange((oldValue: Area, newValue: Area) => {
           this.topHeight = Math.ceil(newValue.position.y as number + (newValue.height as number))
          })
          .zIndex(-1)

        RUPickerView({
          pickerOptionsController: this.pickerOptionsController,
          topHeight: this.topHeight,
          clickSelected: (tag: string, index: number, item?: IPickerViewData) => {
            switch (tag) {
              case "省":
                PickerOptionsUtils.setPickerOptionsData("市", 2, true, item?.optionChildren as Array<AddressEntity>,
                  this.pickerOptionsController)
              //this.setOptionsData("市", [])
                this.pickerOptionsController.setPickerSelectedData('市', new Array)
                break
              case "市":
                break
            }
          },
          onReSet: () => {
            PickerOptionsUtils.setPickerOptionsData("省", 1, false, this.data, this.pickerOptionsController)
            PickerOptionsUtils.setPickerOptionsData("市", 2, true, [], this.pickerOptionsController)
          },
          backResult: (result: Array<PickerResult>) => {
            result.forEach((item: PickerResult) => {
              switch (item.tag) {
                case "省":
                  console.log("===========", "result=============" + item.singleResult?.optionsName)
                  break
                case "市":
                  console.log("===========", "result=============" + JSON.stringify(item.multipleResult))
                  break
              }
            })
          }
        })
        // RUFramePickerView({
        //   frameOptionsController: this.frameOptionsController,
        //   topHeight: this.topHeight,
        //   backSingleResult: (index: number, result: IPickerViewData) => {
        //     let optionsValue = result.optionsValue as string
        //     console.log("=============", "result=================" + optionsValue)
        //   },
        //   backMultipleResult: (result: Array<IPickerViewData>) => {
        //     console.error("=============", "result=================" + JSON.stringify(result))
        //   }
        // })
      }
    }
    .width('100%')
    .height('100%')
  }
}

export class AddressEntity extends IPickerViewData {
  name: string = ''
  no: string = ''
  children: AddressEntity[] = []
}