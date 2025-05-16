import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:league_better_client/api/betterClientApi.dart';
import 'dart:convert';
import 'dart:io';

extension ImageService on BetterClientApi {
  Future<Image> getProfileIcon(String iconId) async {
    if (iconId == "-1") {
      iconId = "0";
    }
    Image? localImage = await _getImageFromLocalPath(
      "/profileicon/$iconId.png",
    );
    if (localImage != null) {
      return localImage;
    }

    final client = HttpClient();
    client.badCertificateCallback = (cert, host, port) => true;

    final ddragonVersionUri = Uri.parse(
      'https://ddragon.leagueoflegends.com/api/versions.json',
    );
    //print('Requesting: $ddragonVersionUri');
    final request = await client.getUrl(ddragonVersionUri);

    final response = await request.close();

    //print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final responseBody = await response.transform(utf8.decoder).join();
      final versions = jsonDecode(responseBody);
      final ddragonVersion = versions[0];
      final iconUri = Uri.parse(
        'https://ddragon.leagueoflegends.com/cdn/$ddragonVersion/img/profileicon/$iconId.png',
      );
      //print('Requesting: $iconUri');
      final iconRequest = await client.getUrl(iconUri);
      final iconResponse = await iconRequest.close();
      //print('Icon response status: ${iconResponse.statusCode}');
      if (iconResponse.statusCode == 200) {
        final bytes = await consolidateHttpClientResponseBytes(iconResponse);
        final file = await createFileWithFolders(
          "assets/profileicon/$iconId.png",
        );
        await file.writeAsBytes(bytes);
        //print('Icon saved to: ${file.path}');
        return Image.memory(bytes);
      } else {
        print('Icon request failed with status: ${iconResponse.statusCode}.');
      }
    } else {
      print(
        'ddragon version Request failed with status: ${response.statusCode}.',
      );
    }
    return Image.asset(
      'assets/placeholder.png',
      width: 100,
      height: 100,
    ); // fallback
  }

  Future<bool> fileExists(String filePath) async {
    final file = File(filePath);
    return await file.exists();
  }

  Future<File> createFileWithFolders(String filePath) async {
    final file = File(filePath);

    await file.parent.create(recursive: true);

    return await file.create();
  }

  Future<Image?> _getImageFromLocalPath(String path) async {
    var imagePath = "assets$path";
    if (await fileExists(imagePath)) {
      var file = File(imagePath);
      return Image.file(file, width: 200, fit: BoxFit.contain);
    } else {
      print('Image not found at $imagePath');
      return null;
    }
  }

  Future<Image> getImageFromPath(String path) async {
    Image? localImage = await _getImageFromLocalPath(path);
    if (localImage != null) {
      return localImage;
    }
    final response = await makeRequest(path, RequestType.GET);

    if (response.statusCode == 200) {
      final bytes = await consolidateHttpClientResponseBytes(response);
      final file = await createFileWithFolders("assets$path");
      await file.writeAsBytes(bytes);
      return Image.memory(bytes, fit: BoxFit.contain, width: 200);
    } else {
      print('Failed with status: ${response.statusCode}');
      return Image.asset('assets/placeholder.png');
    }
  }

  Future<SvgPicture> getPositionIcon(String position) async {
    if (position == "null") {
      position = "LANE";
    }
    if (await fileExists("assets/icons/position/$position.svg")) {
      return SvgPicture.file(
        File("assets/icons/position/$position.svg"),
        width: 40,
        fit: BoxFit.contain,
      );
    } else {
      throw ('Image not found at assets/icons/position/$position.svg');
    }
  }
}
