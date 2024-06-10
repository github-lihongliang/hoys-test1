@Observed
export class answerInfo{
  id: number
  postText: string
  rightcount: number
  mansweredcount: number
  timeused: number
  mcreateTime: string
  likecount: number
  nickname: string
  avatarurl: string
  misLike: boolean

  constructor(post:{
    id: number,
    postText: string,
    rightcount: number,
    mansweredcount: number,
    timeused: number,
    mcreateTime: string,
    likecount: number,
    nickname: string,
    avatarurl: string,
    misLike: boolean
  }) {
    this.id = post.id;
    this.postText = post.postText;
    this.rightcount = post.rightcount,
    this.mansweredcount = post.mansweredcount,
    this.timeused = post.timeused,
    this.mcreateTime = post.mcreateTime,
    this.likecount = post.likecount,
    this.nickname = post.nickname,
    this.avatarurl = post.avatarurl,
    this.misLike = post.misLike
  }
}
export const dataData:answerInfo[]=[
  {
    id: 0,
    postText: '既然选择远方，当不负青春，砥砺前行',
    rightcount: 3,
    mansweredcount: 4,
    timeused: 5747,
    mcreateTime: '2024-05-23',
    likecount: 1,
    nickname: '138****3456',
    avatarurl: 'https://oss.aliyuncs.com/aliyun_id_photo_bucket/default_handsome.jpg',
    misLike: false
  },
  {
    id: 1,
    postText: '既然选择远方，当不负青春，砥砺前行',
    rightcount: 3,
    mansweredcount: 4,
    timeused: 5747,
    mcreateTime: 'string',
    likecount: 1,
    nickname: '138****3456',
    avatarurl: 'https://oss.aliyuncs.com/aliyun_id_photo_bucket/default_handsome.jpg',
    misLike: false
  },
  {
    id: 2,
    postText: '既然选择远方，当不负青春，砥砺前行',
    rightcount: 3,
    mansweredcount: 4,
    timeused: 5747,
    mcreateTime: 'string',
    likecount: 1,
    nickname: '138****3456',
    avatarurl: 'https://oss.aliyuncs.com/aliyun_id_photo_bucket/default_handsome.jpg',
    misLike: false
  },
  {
    id: 3,
    postText: '既然选择远方，当不负青春，砥砺前行',
    rightcount: 3,
    mansweredcount: 4,
    timeused: 5747,
    mcreateTime: 'string',
    likecount: 1,
    nickname: '138****3456',
    avatarurl: 'https://oss.aliyuncs.com/aliyun_id_photo_bucket/default_handsome.jpg',
    misLike: false
  },
  {
    id: 4,
    postText: '既然选择远方，当不负青春，砥砺前行',
    rightcount: 3,
    mansweredcount: 4,
    timeused: 5747,
    mcreateTime: 'string',
    likecount: 1,
    nickname: '138****3456',
    avatarurl: 'https://oss.aliyuncs.com/aliyun_id_photo_bucket/default_handsome.jpg',
    misLike: false
  },
  {
    id: 5,
    postText: '既然选择远方，当不负青春，砥砺前行',
    rightcount: 3,
    mansweredcount: 4,
    timeused: 5747,
    mcreateTime: 'string',
    likecount: 1,
    nickname: '138****3456',
    avatarurl: 'https://oss.aliyuncs.com/aliyun_id_photo_bucket/default_handsome.jpg',
    misLike: false
  },
  {
    id: 6,
    postText: '既然选择远方，当不负青春，砥砺前行',
    rightcount: 3,
    mansweredcount: 4,
    timeused: 5747,
    mcreateTime: 'string',
    likecount: 1,
    nickname: '138****3456',
    avatarurl: 'https://oss.aliyuncs.com/aliyun_id_photo_bucket/default_handsome.jpg',
    misLike: false
  },
  {
    id: 7,
    postText: '既然选择远方，当不负青春，砥砺前行',
    rightcount: 2,
    mansweredcount: 6,
    timeused: 5747,
    mcreateTime: '2024-05-23',
    likecount: 3,
    nickname: '138****3456',
    avatarurl: 'https://oss.aliyuncs.com/aliyun_id_photo_bucket/default_handsome.jpg',
    misLike: false
  }
]