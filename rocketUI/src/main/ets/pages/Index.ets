@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Row() {
      Column() {
        Text("加载loding")
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {

          })
      }
      .width('100%')
    }
    .height('100%')
  }
}