// import 'package:url_launcher/url_launcher.dart';

// class Utils {
//   static Future<void> sendEmail({
//     required String email,
//     String subject = "",
//     String body = "",
//   }) async {
//     String? encodeQueryParameters(Map<String, String> params) {
//       return params.entries
//           .map((MapEntry<String, String> e) =>
//               '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
//           .join('&');
//     }

//     final Uri mail = Uri(
//       scheme: 'mailto',
//       path: email,
//       query: encodeQueryParameters(
//         <String, String>{
//           'subject': subject,
//           'body': body,
//         },
//       ),
//     );
//     if (await canLaunchUrl(mail)) {
//       await launchUrl(mail);
//     } else {
//       throw Exception("Unable to open the email");
//     }
//   }

//   static Future<void> makePhoneCall(String phoneNumber) async {
//     final Uri url = Uri(scheme: 'tel', path: phoneNumber);
//     if (await canLaunchUrl(url)) {
//       await launchUrl(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   static Future<void> launchWhatsapp(String number, String message) async {
//     String encodedMessage =
//         Uri.encodeComponent(message).replaceAll('%0A', '\n');
//     final whatsappUrl =
//         "https://wa.me/$number/?text=${Uri.parse(encodedMessage)}";
//     final whatsappUri = Uri.parse(whatsappUrl);

//     if (await canLaunchUrl(whatsappUri)) {
//       await launchUrl(whatsappUri);
//     } else {
//       throw 'Could not launch $whatsappUrl';
//     }
//   }
// }
