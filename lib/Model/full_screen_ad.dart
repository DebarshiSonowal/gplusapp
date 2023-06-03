
class FullScreenAdResponse{
  bool? success;
  String? data,link,message;

  FullScreenAdResponse.fromJson(json){
    success = json["success"]??true;
    data = json["data"]??"";
    link = json["link"]??"";
    message = json["message"]??"";
  }
  FullScreenAdResponse.withError(error){
    success = false;
    message = error;
  }

}
class FullScreenAd{
  String data,link;

  FullScreenAd(this.data, this.link);
}