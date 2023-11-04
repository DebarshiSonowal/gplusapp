
class FloatingButton{
//   "float_btn": {
//             "status": "true",
//             "text": "Vote Now",
//             "color": "#7CFC00",
//             "url": "https://guwahatiplus.com/voteView"
//         }
  bool? status;
  String? text,color,url,image_url;

  FloatingButton.fromJson(json){
    status = json["status"]==null?false:(json["status"]=="true"?true:false);
    text = json["text"]??"Vote Now";
    color = json["color"]??"#7CFC00";
    url = json["url"]??"https://guwahatiplus.com/voteView";
    image_url = json["image_url"]??"";
  }

}