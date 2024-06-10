import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import { cancellike, getposInfo, like } from '../http/api'
import { answerInfo,dataData } from '../model/answerInfo'
import { convertMillisecondsToTime } from '../utils/dateUtils'
import { stateItem } from './PracticPage'
import emitter from '@ohos.events.emitter'
// @Entry
@Component
export struct ClicrePage {
  @StorageProp('userObj') @Watch('watchTokenChange') userObj:string = ''
  @State posInfoList:answerInfo[]=[]
  page:number=1
  total:number=0
  @State loadFlag:boolean=false
  scroller: Scroller=new Scroller()

  // 获取数据
  async getposInfoData(){
    // let data = await getposInfo(this.page,this.total)
    // data.data.forEach(item=>this.posInfoList.push(item))
    // this.total = data.data.total
    // this.page++
    this.posInfoList = dataData
  }

  async refresh (){
    this.loadFlag=true
    this.page=1
    this.total=0
    await this.getposInfoData()
    this.loadFlag=false
  }

  // 页面展示-判断时候登录
  aboutToAppear(){
    if (this.userObj||true) {
      this.getposInfoData()
    }
    emitter.on({eventId:1},()=>{
      this.refresh()
    })
  }

  // 监听
  watchTokenChange(){
    if (this.userObj) {
      this.getposInfoData()
    }else {
      this.posInfoList=[]
      this.page=1
      this.total=0
    }
  }

  build() {
    Column(){
      Text('英语打卡圈')
        .fontSize(18)
        .margin({top:45})
        .fontWeight(FontWeight.Bold)
      Divider()
        .color(Color.Black)
        .margin({left:20,right:20,top:10})
      if(this.userObj||true){
        //打卡列表
        if (this.loadFlag){
          this.listBuilder()
        } else this.listBuilder()
      }else{
        //未登录
        this.unLoginBuilder()
      }
    }
    .height('100%')
    .width('100%')
  }

  @Builder
  unLoginBuilder(){
    Column({space:30}){
      Image($r("app.media.app_icon"))
        .width(177)
        .height(177)
      Text('未登录暂无数据')
        .fontSize(14)
        .fontColor('#999999')
      Button('去登录')
        .fontColor(Color.White)
        .fontSize(14)
        .width(100)
        .height(34)
        .backgroundColor('#43C6A0')
        .onClick(()=> {
          router.pushUrl({ url: 'pages/loginPage' })
        })
    }
      .width('100%')
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
  }

  @Builder
  listBuilder(){
  Stack(){
    List({scroller:this.scroller}){
      ForEach(this.posInfoList,(post)=> {
        ListItem() {
          PostItem({ post: post })
        }
      })
    }.width('100%')
    .height('100%')
    .alignListItem(ListItemAlign.Center)

    .onReachEnd(() =>{
      //   触底刷新
      if(this.posInfoList.length<this.total){
        this.getposInfoData()
      }else {
        promptAction.showToast({message:'没有更多数据了'})
      }
    })
    Column({space:20}) {
      Button({ type: ButtonType.Circle }) {
        Image($r('app.media.app_icon'))
          .height(14)
          .width(14)
      }
      .height(40)
      .width(40)
      .backgroundColor(Color.Black)
      .opacity(0.5)
      .onClick(() => {
        //返回顶部
        this.scroller.scrollToIndex(0)
      })

      Button({ type: ButtonType.Circle }) {
        Image($r('app.media.app_icon'))
          .height(14)
          .width(14)
      }
      .height(40)
      .width(40)
      .backgroundColor(Color.Black)
      .opacity(0.5)
      .onClick(() => {
        //刷新
        this.refresh()
      })
    }
        .offset({x:-20,y:-50})
    }
      .width('100%')
      .layoutWeight(1)
      .alignContent(Alignment.BottomEnd)
  }

  @Builder
  loadingBuilder(){
    Column({space:15}){
      Image($r('app.media.app_icon'))
        .width(30)
        .height(30)
      Text('加载中')
      .fontSize(16)
      .fontWeight(FontWeight.Medium)
      .fontColor('#7e8892')
      }.width('100%')
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
  }
}

@Component
struct PostItem{
  @ObjectLink post:answerInfo
  build(){
    Column({space:10}){
      Row({space:10}){
        Image(this.post.avatarurl)
          .height(40)
          .width(40)
          .borderRadius(20)
        Text(this.post.nickname)
          .height(40)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
        Blank()
        Text(this.post.mcreateTime)
          .height(40)
          .fontSize(14)
          .fontColor('#999999')
          .fontWeight(FontWeight.Medium)
      }.width('100%')
      Text(this.post.postText)
        .width('100%')
      Row(){
        Column() {
          stateItem({
            icon: $r('app.media.app_icon'),
            name: '用时',
            fontColor: Color.Black }) {
            Text(convertMillisecondsToTime(this.post.timeused))
              .statTextStyle()
          }

          stateItem({
            icon: $r('app.media.app_icon'),
            name: '准确率',
            fontColor: Color.Black
          }) {
            Text((this.post.mansweredcount === 0 ? 0 : this.post.rightcount).toFixed()+'%')
              .statTextStyle()
          }

          stateItem({
            icon: $r('app.media.app_icon'),
            name: '个数',
            fontColor: Color.Black
          }) {
            Text(this.post.mansweredcount.toString())
              .statTextStyle()
          }
        }
          .padding(10)
          .borderRadius(10)
          .layoutWeight(1)
          .backgroundImage($r('app.media.login_top'))
          .backgroundImageSize(ImageSize.Cover)
          Column(){
            Text(this.post.rightcount.toString())
              .fontSize(12)
              .fontWeight(FontWeight.Medium)
              .fontColor(this.post.misLike?'#3ECBAI':'#oooaee')
            Image(this.post.misLike?$r('app.media.app_icon'):$r('app.media.app_icon'))
              .width(26)
              .height(26)
              .onClick(()=> {
                //点赞/取消点赞
                if (this.post.misLike){
                  this.post.misLike = false
                  this.post.likecount--
                  cancellike(this.post.id)
                } else {
                  this.post.misLike = true
                  this.post.likecount++
                  like(this.post.id)
                }
              })
          }.width(50)
      }.width('100%')
       .alignItems(VerticalAlign.Bottom)
    }
      .padding(10)
      .width('90%')
      .margin({top:10})
      .borderRadius(10)
      .shadow({radius:20})
  }
}

@Extend(Text) function statTextStyle() {
  .width(100)
  .fontSize(16)
  .textAlign(TextAlign.End)
  .fontWeight(FontWeight.Medium)
  .fontColor(Color.Black)
}