import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:raftlabs_flutter/screens/account_screen.dart';
import 'package:raftlabs_flutter/screens/post_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextStyle _textStyle = const TextStyle(
      fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500);

  List _currentUserFollowList = [];
  final List _currentUserFollowListNames = [];

  var getUersQuery = gql('''
           query{
                users{
                  id
                  first_name,
                  last_name,
                  email,
                  follow_list
                }
              }
              ''');

  var getPostsQuery = gql('''
            query{
               posts1{
                id
                title
                author
                content            
                image
                tags
               } 
            }
              ''');

  var mutateFollowQuery = gql(r'''
                                     mutation users($id: Int!, $newFollowItem: [Int!]) {
                                     update_users(
                                         where: { id: { _eq: $id } }
                                         _set : {follow_list: $newFollowItem}
                                       ) {
                                         affected_rows
                                         returning {
                                           id
                                           follow_list                                          
                                        }
                                       }
                                     }
                                      ''');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff212121),
        //
      ),
      body: SafeArea(
        child: Query(
            options: QueryOptions(document: getUersQuery),
            builder: (QueryResult userresult,
                {VoidCallback? refetch, FetchMore? fetchMore}) {
              if (userresult.isNotLoading) {
                _currentUserFollowList =
                    userresult.data!['users'][0]['follow_list'];
              }

              return Query(
                  options: QueryOptions(document: getPostsQuery),
                  builder: (QueryResult result,
                      {VoidCallback? refetch, FetchMore? fetchMore}) {
                    if (result.hasException) {
                      print(result.exception.toString());
                      return Text(result.exception.toString());
                    }

                    if (result.isLoading) {
                      return const Text('Loading');
                    }
                    // else if (result.isNull) {
                    //   return const Text('No repositories');
                    // }

                    else {
                      return ListView.builder(
                          itemCount: result.data!['posts1'].length,
                          itemBuilder: (context, index) {
                            return Container(
                              // color: Colors.green,
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              //  height: MediaQuery.of(context).size.height * .5,
                              // color: Colors.red,
                              child: Column(children: [
                                Container(
                                  //      color: Colors.teal,
                                  child: Row(
                                    children: [
                                      result.data!['posts1'][index]['image'] ==
                                                  null ||
                                              result.data!['posts1'][index]
                                                      ['image'] ==
                                                  ""
                                          ? const Center(
                                              child: Icon(
                                                Icons.account_circle_outlined,
                                                size: 50,
                                              ),
                                            )
                                          : Container(
                                              decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle),
                                              child: ClipOval(
                                                child: Image(
                                                    fit: BoxFit.fitWidth,
                                                    height: 50,
                                                    width: 50,
                                                    image: NetworkImage(
                                                        result.data!['posts1']
                                                            [index]['image'])),
                                              ),
                                            ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      result.data!['posts1'][index]['tags'] ==
                                                  null ||
                                              result
                                                  .data!['posts1'][index]
                                                      ['tags']
                                                  .isEmpty
                                          ? Text(
                                              result.data!['posts1'][index]
                                                  ['author'],
                                              style: _textStyle,
                                            )
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  result.data!['posts1'][index]
                                                      ['author'],
                                                  style: _textStyle,
                                                ),
                                                Wrap(
                                                  children: List.generate(
                                                      result
                                                          .data!['posts1']
                                                              [index]['tags']
                                                          .length, (i) {
                                                    return Container(
                                                      margin: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 2.5),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        color: Colors
                                                            .blue.shade100,
                                                      ),
                                                      child: Text(
                                                        '@' +
                                                            result.data![
                                                                        'posts1']
                                                                    [index]
                                                                ['tags'][i],
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    );
                                                  }),
                                                )
                                              ],
                                            ),
                                      const Spacer(),
                                      Mutation(
                                          options: MutationOptions(
                                            document: mutateFollowQuery,
                                            onCompleted: (rs) {
                                              //   setState(() {});
                                            },
                                          ),
                                          builder: (insert, followResult) {
                                            return InkWell(
                                              onTap: () {
                                                _currentUserFollowList.add(
                                                    result.data!['posts1']
                                                        [index]['id']);

                                                insert({
                                                  'id': 31,
                                                  'newFollowItem':
                                                      _currentUserFollowList
                                                });
                                              },
                                              child: Text(
                                                _currentUserFollowList.contains(
                                                        result.data!['posts1']
                                                            [index]['id'])
                                                    ? 'Following'
                                                    : 'Follow',
                                                style: _textStyle.copyWith(
                                                    color: Colors.blue),
                                              ),
                                            );
                                          }),
                                    ],
                                  ),
                                ),
                                if (result.data!['posts1'][index]['image'] !=
                                        null &&
                                    result.data!['posts1'][index]['image'] !=
                                        "")
                                  Container(
                                    height: 300,
                                    margin: const EdgeInsets.only(top: 5),
                                    width: double.infinity,
                                    //color: Colors.yellow,
                                    child: Image(
                                        fit: BoxFit.fitWidth,
                                        image: NetworkImage(result
                                            .data!['posts1'][index]['image'])),
                                  ),
                                Container(
                                  // color: Colors.red,
                                  padding: const EdgeInsets.only(
                                      top: 5, left: 2.5, right: 2.5),
                                  width: double.infinity,
                                  //  color: Colors.green,
                                  child: Text(
                                    result.data!['posts1'][index]['id'] > 25
                                        ? result.data!['posts1'][index]
                                            ['content']
                                        : 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In pulvinar orci et odio pellentesque, in mollis augue gravida. Mauris tristique nisi a efficitur molestie.',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 4,
                                    style: _textStyle.copyWith(
                                        fontWeight: FontWeight.w400),
                                  ),
                                )
                              ]),
                            );
                            //     return Text(result.data!['posts1'][index]['author']);
                          });
                    }
                  });
            }),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xff212121),
        //  selectedLabelStyle: const TextStyle(color: Colors.white),
        unselectedItemColor: Colors.grey,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box_rounded),
            label: 'Account',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return PostScreen(
                followList: _currentUserFollowList,
              );
            }));
          } else if (index == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const AccountScreen();
            }));
          }
        },
        currentIndex: 0,
        selectedItemColor: Colors.white,
        //  onTap: _onItemTapped,
      ),
    );
  }
}
