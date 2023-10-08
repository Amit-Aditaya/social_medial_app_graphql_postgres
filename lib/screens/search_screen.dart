import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:raftlabs_flutter/utils/appcolors.dart';

class SearchScreen extends StatefulWidget {
  final List? followlist;
  final Function(List) callBack;

  const SearchScreen(
      {super.key, required this.followlist, required this.callBack});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var mutateTagQuery = gql(r'''
                                 
mutation posts1($id: Int!, $newTag: [String!]) {
                                     update_posts1(
                                         where: { id: { _eq: $id } }
                                         _set : {tags: $newTag}
                                       ) {
                                         affected_rows
                                         returning {
                                           id
                                           tags                                         
                                        }
                                       }
                                     }
                                      ''');

  List taggedList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Mutation(
          options: MutationOptions(document: mutateTagQuery),
          builder: (insert, result) {
            return Query(
                options: QueryOptions(document: gql('''
            query{
               users{
                id
                first_name
                last_name
                email            
                follow_list
               } 
            }
              ''')),
                builder: (result,
                    {VoidCallback? refetch, FetchMore? fetchMore}) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: double.infinity,
                    width: double.infinity,
                    child: Column(children: [
                      widget.followlist == null || widget.followlist!.isEmpty
                          ? const Text(' No tags, you are not following anyone')
                          : Column(
                              children: [
                                const Text(
                                  'Pick someone to tag',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                ListView.builder(
                                    itemCount: widget.followlist!.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            taggedList
                                                .add(widget.followlist![index]);
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Colors.grey
                                                          .withOpacity(.5)))),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Author ${widget.followlist![index]}',
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                taggedList.contains(widget
                                                        .followlist![index]!)
                                                    ? 'Tagged'
                                                    : 'Tag',
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.blue,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                const SizedBox(
                                  height: 15,
                                ),
                                InkWell(
                                  onTap: () {
                                    widget.callBack(taggedList);
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color:
                                          const Color(AppColors.primaryColor),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Done',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                    ]),
                  );
                });
          }),
    );
  }
}
