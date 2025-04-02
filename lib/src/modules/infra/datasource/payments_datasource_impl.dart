// // data/datasources/payments_remote_datasource.dart
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../../../core/core.dart';
// import '../../data/data.dart';
// import '../../domain/domain.dart';

// class PaymentsRemoteDataSource implements PaymentsDataSource {
//   final http.Client client;
//   final String baseUrl = 'https://travels.free.beeceptor.com';

//   PaymentsRemoteDataSource({required this.client});

//   @override
//   Future<PaymentsInfoEntity> getPaymentsInfo() async {
//     try {
//       final response = await client.get(
//         Uri.parse('$baseUrl/payments'),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         return PaymentsInfoModel.fromJson(json.decode(response.body));
//       } else {
//         throw ServerException(
//           message: 'Failed to load payments',
//           statusCode: response.statusCode,
//         );
//       }
//     } catch (e) {
//       if (e is ServerException) rethrow;
//       throw const ConnectionException(message: 'No internet connection');
//     }
//   }
// }
