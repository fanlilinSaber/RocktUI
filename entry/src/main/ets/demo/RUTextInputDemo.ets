/**
 * Author:fanlilin
 * Date:2024/7/12
 * Descrobe:
 */
import { RUTextInput, RUTextInputLeftIconType } from '@zjos/rocketUI'

@Component
export default struct RUTextInputDemo {

  @State @Watch('keyword1Change') keyword1: string = ''
  @State @Watch('keyword2Change') keyword2: string = ''
  @State @Watch('keyword3Change') keyword3: string = ''

  keyword1Change() {
    console.log("keyword1 发生变化了：" + this.keyword1)
  }

  keyword2Change() {
    console.log("keyword2 发生变化了：" + this.keyword2)
  }

  keyword3Change() {
    console.log("keyword3 发生变化了：" + this.keyword3)
  }

  build() {
    Column({space: 2}) {
      RUTextInput({ text: $keyword1, xpadding: { left: 10 }, xheight: 50 }).width(300)

      RUTextInput({ text: $keyword1, xheight: 50, type: InputType.Password }).width(300)

      RUTextInput({ text: $keyword1, xheight: 50, style: TextInputStyle.Inline }).width(300)

      RUTextInput({ text: $keyword2, leftIcon: RUTextInputLeftIconType.Search })

      RUTextInput({ text: $keyword2, leftIcon: { iconSrc: $r('app.media.common_Search') }})
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFF5F5F5')
  }
}