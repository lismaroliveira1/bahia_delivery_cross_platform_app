import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/screens/welcome_store_screen.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

class ListStories extends StatefulWidget {
  @override
  _ListStoriesState createState() => _ListStoriesState();
}

class _ListStoriesState extends State<ListStories> {
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      bool isFavorite = false;
      if (model.isLoading) {
        return SliverToBoxAdapter(
          child: Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      } else {
        if (model.storeDataList.length == 0) {
          return SliverToBoxAdapter(
            child: Container(
              child: Center(
                child: Text("Sem Parceiros Cadastrados"),
              ),
            ),
          );
        } else {
          return SliverToBoxAdapter(
            child: Container(
              child: Stack(
                children: [
                  Column(
                      children: model.storeDataList.map((doc) {
                    print(doc.isStoreOpen);
                    return doc.ishourSeted
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: FlatButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              WelcomeStoreScreenn(
                                                  doc.storeSnapshot),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Container(
                                            height: 75,
                                            width: 75,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Stack(
                                                children: [
                                                  FadeInImage.memoryNetwork(
                                                    placeholder:
                                                        kTransparentImage,
                                                    image: doc.image,
                                                    width: 75,
                                                    height: 75,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  !doc.isStoreOpen
                                                      ? Center(
                                                          child: Image.asset(
                                                            'images/fechado.png',
                                                            width: 50 * 1.2,
                                                            height: 35 * 1.2,
                                                            fit: BoxFit.fill,
                                                          ),
                                                        )
                                                      : Container(
                                                          height: 0.0,
                                                          width: 0.0,
                                                        ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 4, 4, 4),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                doc.name,
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Container(
                                                child: Text(
                                                  doc.description,
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 12),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 3.0,
                                  right: 3.0,
                                  child: IconButton(
                                    onPressed: () {
                                      model.addFavoriteStore(doc);
                                    },
                                    icon: Icon(
                                      Icons.favorite,
                                      color:
                                          isFavorite ? Colors.red : Colors.grey,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            height: 0,
                            width: 0,
                          );
                  }).toList()),
                ],
              ),
            ),
          );
        }
      }
    });
  }
}
