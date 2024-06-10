import { PracticPage } from './PracticPage'
import { ClicrePage } from './ClichPage'
import { MinePage } from './MinePage'
@Entry
@Component
struct Index {
  @StorageLink('crurrentTabIndex') crurrentTabIndex: number = 0

  build() {
    Tabs({ index: this.crurrentTabIndex }){
      TabContent(){
        PracticPage()
      }
      .tabBar(this.barBuilder(0,'答题',$r('app.media.app_icon'),$r('app.media.icon')))
      TabContent(){
        ClicrePage()
      }
      .tabBar(this.barBuilder(1,'答题',$r('app.media.app_icon'),$r('app.media.app_icon')))
      TabContent(){
        MinePage()
      }
      .tabBar(this.barBuilder(2,'答题',$r('app.media.app_icon'),$r('app.media.app_icon')))
    }
    .barPosition(BarPosition.End)
    .onChange((i)=>{
      this.crurrentTabIndex=i
    })
  }

  @Builder barBuilder(index:number,title:string,icon:Resource,iconSelected){
    Column(){
      Image(this.crurrentTabIndex===index?iconSelected:icon)
        .width(25)
        .height(25)
      Text(title)
        .tabTitleStyle(this.crurrentTabIndex===index?Color.Black:'#959595')
    }
  }
}
@Extend(Text) function tabTitleStyle(color:ResourceColor){
  .fontSize(16)
  .fontWeight(700)
  .fontColor(color)
  .margin({bottom:2})
}
