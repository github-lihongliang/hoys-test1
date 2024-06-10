import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import { info } from '../http/api'
// @Entry
@Component
export struct MinePage {
  @StorageProp('userObj') @Watch('watchTokenChange') userObj:string = ''
  @State userInfo:{
    avatarUrl?:string,
    nickname?: string
  }={}

  // 监听
  async watchTokenChange(){
    if (this.userObj) {
      let data = await info()
      // this.userInfo = data
    }else {
      this.userInfo = {}
    }
  }

  async aboutToAppear(){
    if (this.userObj){
      let data = await info()
      this.userInfo = {
        avatarUrl:'https://oss.aliyuncs.com/aliyun_id_photo_bucket/default_handsome.jpg',
        nickname: ''
      }
    }
  }

  build() {
    Stack(){
      Column(){
        Image(this.userObj?this.userInfo.avatarUrl:$r('app.media.app_icon'))
          .width(100)
          .height(100)
          .borderRadius(50)
          .margin({top:120})
          .onClick(()=>{
            router.pushUrl({url:'pages/loginPage'})
          })
        Text(this.userObj?this.userInfo.nickname:'暂无登录')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Black)
          .margin({top:20})
        if (!this.userObj){
          Text('请先登录')
            .fontSize(18)
            .fontColor(Color.Black)
            .fontWeight(FontWeight.Medium)
            .margin({top:0})
        }
      }.width('100%')
      .height('50%')
      .backgroundImage(this.userObj?this.userInfo.avatarUrl:$r('app.media.app_icon'))
      .backgroundImageSize({width:'100%',height:'100%'})
      .backgroundBlurStyle(BlurStyle.Regular)
      Column(){
        this.mineItemBuilder($r('app.media.app_icon'),'打开记录',()=>{
          if(this.userObj){
            router.pushUrl({url:'pages/ClicreHosyryPage'})
          }else promptAction.showToast({message:'请点击立即登录'})
        })
        Divider()
        this.mineItemBuilder($r('app.media.app_icon'),'检查更新',()=>{
          promptAction.showToast({message:'检查更新。。。。'})
        })
        Divider()
        this.mineItemBuilder($r('app.media.app_icon'),'关于',()=>{
          promptAction.showToast({message:'关于。。。。'})
        })
        Blank()

      }.width('100%')
      .height('60%')
      .offset({y:'40%'})
      .borderRadius({topLeft:50,topRight:50})
      .borderColor(Color.Black)
      .padding(50)
    }.width('100%')
    .height('100%')
    .alignContent(Alignment.Top)
  }

  @Builder
  mineItemBuilder(icon: Resource, title: string, callback?: () => void) {
    Row({space:10}){
      Image(icon)
        .width(24)
        .height(24)
      Text(title)
        .fontSize(16)
        .height(24)
        .fontWeight(FontWeight.Medium)
      Blank()
      Image($r('app.media.app_icon'))
        .width(24)
        .height(24)
    }.width('100%')
    .height(40)
    .onClick(()=> {
      callback();
    })
  }
}