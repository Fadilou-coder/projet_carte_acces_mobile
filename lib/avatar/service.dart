import 'package:dio/dio.dart';

class ImageService {
  static Future<dynamic> uploadFile(filePath) async {
    //jwt authentication token
    var authToken =
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjYmFnQGdtYWlsLmNvbSIsInJvbGVzIjpbIlNVUEVSX0FETUlOIl0sImlzcyI6IlRodSBNYXkgMTIgMTA6MTQ6MDcgVVRDIDIwMjIiLCJleHAiOjE2NTIzNzkyNDd9.-YxdqdakZTWKNEFzPgFtfsPpAwDa5hGnQF3alaAy8ZY';
    //user im use to upload image
    //Note: this authToken and user id parameter will depend on my backend api structure
    //in your case it can be only auth token
    var userId = '12';

    try {
      FormData formData = FormData.fromMap(
          {"file": await MultipartFile.fromFile(filePath, filename: "dp")});

      Response response = await Dio().put(
          "https://projet-carte.herokuapp.com/api/apprenants/image/$userId",
          data: formData,
          options: Options(headers: <String, String>{
            'Authorization': 'Bearer $authToken',
          }));
      return response;
    } on DioError catch (e) {
      return e.response;
    }
  }
}
