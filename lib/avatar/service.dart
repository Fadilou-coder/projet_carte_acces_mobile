import 'package:dio/dio.dart';

class ImageService {
  static Future<dynamic> uploadFile(filePath, id, token) async {
    try {
      FormData formData = FormData.fromMap(
          {"file": await MultipartFile.fromFile(filePath, filename: "dp")});

      Response response = await Dio()
          .put("https://projet-carte.herokuapp.com/api/apprenants/image/$id",
              data: formData,
              options: Options(headers: <String, String>{
                'Authorization': 'Bearer $token',
              }));
      return response;
    } on DioError catch (e) {
      return e.response;
    }
  }
}
