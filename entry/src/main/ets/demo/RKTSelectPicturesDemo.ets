import picker from '@ohos.file.picker'

/**
 * 选择图片demo
 *
 * 实现步骤：
 * 点击"选择图片"，通过photoViewPicker.select()接口,通过传入参数PhotoSaveOptions图库对象，返回的用户选择的图片并显示在页面中，
 * 从而实现手机相册并进行图片预览和选择。
 */
@Component
export struct RKTSelectPicturesDemo {
  //全局变量保存图库选择的结果uri
  @State uris: Array<string> = []
  //全局变量控制选择图片的显示
  @State photoCount: number = 0

  build() {
    Column() {

      Text("选择图片")
        .padding(10)
        .fontSize(15)
        .margin({ left: 15, top: 10, bottom: 10 })
        .backgroundColor("#1A333333")
        .borderRadius(5)
        .fontColor("#FF333333")
        .onClick(() => {
          // 知识点：通过调用getFileAssetsFromType()中的photoViewPicker.select()拉起图库界面进行图片选择。
          this.getFileAssetsFromType(picker.PhotoViewMIMETypes.IMAGE_TYPE)
        })

      Row() {
        Image(this.photoCount > 0 ? this.uris[0] : "")
          .objectFit(this.photoCount > 0 ? ImageFit.Contain : ImageFit.None)
          .width(100)
          .height(100)
          .borderColor("#333333")
          .borderWidth(1)
          .margin({ left: 15 })

        Image(this.photoCount > 1 ? this.uris[1] : "")
          .objectFit(this.photoCount > 1 ? ImageFit.Contain : ImageFit.None)
          .width(100)
          .height(100)
          .borderColor("#333333")
          .borderWidth(1)
          .margin({ left: 15 })
      }

      Text("选择视频")
        .padding(10)
        .fontSize(15)
        .margin({ left: 15, top: 20, bottom: 10 })
        .backgroundColor("#1A333333")
        .borderRadius(5)
        .fontColor("#FF333333")
        .onClick(() => {
          // 知识点：通过调用getFileAssetsFromType()中的photoViewPicker.select()拉起图库界面进行图片选择。
          this.getFileAssetsFromType(picker.PhotoViewMIMETypes.VIDEO_TYPE)
        })


      Video({
        src: this.photoCount > 0 ? this.uris[0] : "",
        previewUri: this.photoCount > 0 ? this.uris[0] : ""
      }).autoPlay(true).width("80%").height(200)

    }
    .backgroundColor("#FFF")
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .height('100%')
  }

  //接口采用promise异步返回形式，传入可选参数DocumentSelectOptions对象，返回选择文件的uri数组。
  async getFileAssetsFromType(mMIMEType: picker.PhotoViewMIMETypes) {
    //创建图片-音频类型文件-预览的图库选项实例
    const photoSelectOptions = new picker.PhotoSelectOptions()
    //选择媒体文件类型和选择媒体文件的最大数目
    //选择媒体文件类型为Image
    photoSelectOptions.MIMEType = mMIMEType //picker.PhotoViewMIMETypes.IMAGE_TYPE
    //选择媒体文件的最大数目
    photoSelectOptions.maxSelectNumber = 2
    //知识点：创建图库选择器实例，调用photoViewPicker.select()接口拉起图库界面进行文件选择，文件选择成功后，返回photoSelectResult结果集。
    const photoViewPicker = new picker.PhotoViewPicker()
    photoViewPicker.select(photoSelectOptions)
      .then((photoSelectResult) => { // select返回的uri权限是只读权限，需要将uri写入全局变量@State中即可进行读取文件数据操作。
        this.uris = photoSelectResult.photoUris
        this.photoCount = this.uris.length
      })
      .catch((err) => {
        console.log('Invoke photoViewPicker.select failed, code is ${err.code},message is ${err.message}')
      })
  }
}