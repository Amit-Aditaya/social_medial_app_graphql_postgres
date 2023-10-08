import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:raftlabs_flutter/screens/home_screen.dart';
import 'package:raftlabs_flutter/screens/search_screen.dart';
import 'package:raftlabs_flutter/utils/appcolors.dart';
import 'package:raftlabs_flutter/utils/snackbar.dart';

class PostScreen extends StatefulWidget {
  //const PostScreen({super.key});
  final List followList;

  const PostScreen({super.key, required this.followList});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final ImagePicker _picker = ImagePicker();

  String? imageurl;

  final TextStyle _textStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Color(AppColors.primaryColor));

  final TextEditingController _textEditingController = TextEditingController();

  List slectedTags = [];

  var query = gql(r'''
       mutation insert_post1($id: Int!, $author: String!,  $title:String!, $content: String!, $image: String, $tags: [String!]){
          insert_posts1(objects:[{id: $id, author: $author,  title: $title, content: $content, image:$image, tags:$tags }]){
             returning {
                id
                author,
                title,
                content,
                image,
                tags      
             }    
          } 
        }
        ''');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Mutation(
            options: MutationOptions(
                document: query,
                onCompleted: (result) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const HomeScreen();
                  }));
                  SnackbarHelper.showCommonSnackbar(
                      context, 'Posted Successfully');
                }),
            builder: (insert, result) {
              return Container(
                height: double.infinity,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // Container(
                          //   height: 50,
                          //   width: 50,
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(5),
                          //     color: Colors.red,
                          //   ),
                          // ),
                          const Icon(
                            Icons.account_circle_outlined,
                            size: 50,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            'What\'s on your mind ?',
                            style: _textStyle.copyWith(
                                fontWeight: FontWeight.w500),
                          ),
                          const Spacer(),
                          InkWell(
                              onTap: () {
                                _selectPhoto(context);
                              },
                              child: const Icon(Icons.add_a_photo_outlined)),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return SearchScreen(
                                  followlist: widget.followList,
                                  callBack: (list) {
                                    setState(() {
                                      slectedTags = list;
                                    });
                                  },
                                );
                              }));
                            },
                            child: const Text(
                              '@',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.blue),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      imageurl == null
                          ? const SizedBox()
                          : Image(image: NetworkImage(imageurl!)),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        //  height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: TextField(
                          controller: _textEditingController,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          maxLines: 8,
                        ),
                      ),
                      const SizedBox(height: 15),
                      slectedTags.isEmpty
                          ? const SizedBox()
                          : Align(
                              alignment: Alignment.centerLeft,
                              child: Wrap(
                                children:
                                    List.generate(slectedTags.length, (i) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 2.5),
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.blue.shade100,
                                    ),
                                    child: Text(
                                      'Author ${slectedTags[i]}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  );
                                }),
                              ),
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          List list = [];

                          for (var i in slectedTags) {
                            list.add("Author $i");
                          }

                          insert({
                            "id": _getrandomNumber(),
                            "author": "Current User",
                            "title": "",
                            "content": _textEditingController.text,
                            "image": imageurl ?? "",
                            'tags': list,
                          });
                        },
                        child: Container(
                          height: 40,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color(AppColors.primaryColor),
                          ),
                          child: const Center(
                            child: Text(
                              'Post',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }));
  }

  Future _selectPhoto(BuildContext context) async {
    await showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        context: context,
        builder: (context) {
          return SizedBox(
            height: 170,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                  child: const Text(
                    'Upload Photo',
                    style: TextStyle(
                        color: Color(AppColors.primaryColor), fontSize: 20),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                        color: Color(AppColors.primaryColor),
                        fontSize: 17,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future _pickImage(ImageSource source) async {
    final pickedFile =
        await _picker.pickImage(source: source, imageQuality: 50);
    if (pickedFile == null) {
      return;
    }
    dynamic file = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1));

    if (file == null) {
      return;
    }
    file = await compressImage(file.path, 35);

    await _uploadFile(file!.path);
  }

  Future compressImage(String path, int quality) async {
    final newPath = p.join((await getTemporaryDirectory()).path,
        '${DateTime.now()}.${p.extension(path)}');

    final result = await FlutterImageCompress.compressAndGetFile(path, newPath,
        quality: quality);

    return result;
  }

  Future _uploadFile(String path) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('images')
        .child('${_getrandomNumber()}-image}');

    final result = await ref.putFile(File(path));
    final fileUrl = await result.ref.getDownloadURL();
    setState(() {
      imageurl = fileUrl;
    });

    // widget.onFileChanged(fileUrl);
  }

  int _getrandomNumber() {
    int range = 4000000;
    final random = Random();
    int randomNumber = random.nextInt(range);

    return randomNumber;
  }
}
